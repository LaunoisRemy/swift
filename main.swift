//je crée la partie :
var p : TPartie = TPartie()

//affectation du joueur courant
p.joueurCourant = p.commence
print("Joueur " + p.joueurCourant.couleur + " à toi de jouer ! \n ")

while (!p.finPartie()) {
    
    print("les pions en vie de ton adversaire sont les suivants: \n")
    for pion in p.joueurAdverse.getPionsEnVie(){ //affiche les pions en vie de l'adversaire
       print(pion.descriptionPion())
    }
		
 	if(p.joueurCourant.existeDeplacement()){ //vérifie si un déplacement est possible avec les cartes qu'il possède

		//variable pour déterminer si le tour est terminé (un pion a été bougé ou non)
		var finTour : Bool = false

		repeat {
            
            print("Tes pions en vie sont les suivant: \n")
            for pion in p.joueurCourant.getPionsEnVie(){ //affiche les pions en vie du joueur
                print(pion.descriptionPion())
            }
            
            print("Tes deux cartes sont les suivantes: \n")
            for carte in p.joueurCourant.getCartes(){ //affiche les cartes de la main du joueur
                print(carte.descriptionCarte())
            }
            
            //Le joueur choisis un de ses pions toujours en vie
			var x1 : Int
            var y1 : Int

            repeat {
                print("Il faut choisir la position d'un des pions parmis ceux proposés : \n")
                
                //Demande la coordonée x au joueur : permet de demander tant la saisie n'est pas un entier
                var v : Int? = nil
                while v == nil {
                    print("il faut une valeur entière pour x")
                    v = Int( readLine() ?? "" )
                }
                x1 = v! // v != nil

                //Demande la coordonée y au joueur : permet de demander tant la saisie n'est pas un entier
                var w : Int? = nil
                while w == nil {
                    print("il faut une valeur entière pour y")
                    w = Int( readLine() ?? "" )
                }
                y1 = w! // w != nil

            } while !(p.joueurCourant.existePion(x : x1, y : y1)) //redemande un pion tant qu'il ne saisie pas la position d'un de ses pions en vie
			let pionChoisi : TPion = p.joueurCourant.getPion(x : x1, y : y1) //récupérer le pion choisi

	        //Le joueur choisis maintenant une carte 
			var nomCarteChoisie : String
            repeat {
				print("Il faut saisir le nom d'une des cartes parmis celles proposées : \n")

                var w : String? = nil
                while w == nil || w == "" {
                    print("il faut une valeur entière pour y")
                    w = readLine() ?? ""
                }
                // w != nil
                nomCarteChoisie = w!

            } while !(p.joueurCourant.existeCarte(nom : nomCarteChoisie)) //redemande une carte tant qu'il ne saisie pas le nom d'une de ses cartes
            let carteChoisie : TCarte = p.joueurCourant.getCarte(nom : nomCarteChoisie) //récupérer la carte choisie
			
			//le joueur choisi le déplacement qu'il veut faire.
            var x2 : Int
            var y2 : Int
            
            repeat {
				print("Il faut choisir le déplacement que tu veux réaliser: x puis y : \n")

                var v : Int? = nil
                while v == nil {
                    print("il faut une valeur entière pour x")
                    v = Int( readLine() ?? "" )
                }
                // v != nil
                x2 = v!
                
                var w : Int? = nil
                while w == nil {
                    print("il faut une valeur entière pour y")
                    w = Int( readLine() ?? "" )
                }
                // w != nil
                y2 = w!
            } while !( carteChoisie.deplacementAppartientMotif(x : x2, y : y2) ) //vérifier que le déplacement appartient à la carte que le joueur à choisi
            			
            //vérifier que le mouvement que le mouvement choisit est possible avec sa carte et son pion qu'il a choisi
	    	if (pionChoisi.peutBouger(x : x2, y : y2)){
                pionChoisi.bougerPion(x : x2, y : y2) //je tue le pion adverse si besoin lorsque je bouge

	        	//Une fois que le joueur a bougé son pion: la carte utilisée est échangée avec celle du milieu 
	        	p.joueurCourant.echangerCarte(carte : carteChoisie, plateau : p.plateau)
			  
			    //le tour est fini
			    finTour = true
	    	} else {
            	print("Le mouvement choisi pour ce pion n'est pas possible avec cette carte, il faut choisir une autre carte ou un autre pion \n ")
            }
		} while(!finTour)
	} else {
        print("Aucun déplacement n'est possible avec les cartes que tu possèdes. Quelle carte veut tu échanger avec celle du plateau ? \n")
        print("Voici les cartes que tu possèdes")
        for carte in p.joueurCourant.getCartes(){ //affiche les pions en vie du joueur
            print(carte.descriptionCarte())
        }

        var nomCarteChoisie : String
		repeat {
			print("Il faut saisir le nom de la carte à échanger : \n")
			
            var w : String? = nil
            while w == nil || w == "" {
                print("Il faut saisir un String pour le nom de la carte")
                w = readLine() ?? ""   //Le joueur saisi en console le nom de la carte qu'il veut
            }
            nomCarteChoisie = w! // w != nil
            
		} while !(p.joueurCourant.existeCarte(nom : nomCarteChoisie) )//redemande une carte tant qu'il ne saisie pas le nom d'une de ses cartes
		let carteChoisie : TCarte = p.joueurCourant.getCarte(nom : nomCarteChoisie ) //récupérer la carte choisie

    	//echanger les cartes 
		p.joueurCourant.echangerCarte(carte : carteChoisie, plateau : p.plateau)
	}
        
	//changement du joueur courant
	p.changerJoueur()
}
print("La partie est terminée, le gagnant est le joueur de couleur" + (p.aGagne ?? "nil") )


