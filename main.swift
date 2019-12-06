
// ============================ Fonctions utilitaires =================================================
// Fonction qui permet de lire un entier 
// Post condition : l'entier est entre 0 et 3
func lireNombre() -> Int {
	var entierOk = false
	var i : Int = -1
	while (!entierOk){
		if let input = readLine() {
		    if let int = Int(input) {
		    	if( int >= 0 && int <= 3 ) {
		    		entierOk=true
		    		i = int
		    	} 
		    }else {
		    		print(" La coordonnée doit être en 0 et 3 inclut, veuillez retaper : ")
		    }
		}
	}
	return i

}

// jeuToString : Jeu -> [[String]] 
// Fonction qui permet de créer un tableau de string de l'état du jeu
// PostCondition : tab tableau de string contenant ou - si la case et vide ou la forme colorée du joueur 
func jeuToString(j : Jeu) -> [[String]]{
	var tab : [[String]] = [["-","-","-","-"],["-","-","-","-"],["-","-","-","-"],["-","-","-","-"]]
	for x in 0...3{
		for y in 0...3 {
			let pTmp : Piece? = j.getPiece(x : x ,y : y)
			if let piece = pTmp {
				let couleur : String = piece.couleur
				if piece.nom == "tr"{
					tab[x][y] = "\u{1B}["+couleur+"m\u{1403}\u{1B}[0m"
				}
				
				else if piece.nom == "ca" {
					tab[x][y] = "\u{1B}["+couleur+"m\u{25A0}\u{1B}[0m"
				}
				else if piece.nom == "ce" {
					tab[x][y] = "\u{1B}["+couleur+"m\u{2B24}\u{1B}[0m"
				}
				else {
					tab[x][y] = "\u{1B}["+couleur+"m\u{26C1}\u{1B}[0m"
				}
			}
		}
	}
	return tab
}

// afficher : [[String]] 
// fonction qui affiche les lignes du tableau
// Precondition : tab :tableau de string contenant  "-" si la case est vide ou la forme colorée du joueur 
func afficher( tab : [[String]])  {
	var message : String = ""
	for i in 0..<4{
		for j in 0..<4{
			message += tab[i][j] + " " 
		}
			message += "\n"
		}
		print(message)
}

// ============================ Programme principal =================================================
// Déroulement du programe principal 

// Initialisation de la partie 
var jeu : Jeu = Jeu()
var estFini : Bool = false

print(" le ",jeu.jCourant, " commence")

while !estFini {
	// Affichage du jeu chaque tour
	afficher(tab : jeuToString( j : jeu))
	var aJoue = false

	// Boucle pour réaliser un tour de jeu 
	while (!aJoue){
		// Affichage du joueur courant et de ses pièces restantes
		print("Le joueur : " , jeu.jCourant.couleur ," place sa pièce " )
		for p in jeu.jCourant.PieceRestantes {
			print (" Les pièces disponibles sont : ", p.nom)
		}
		


		// Choix de la pièce
		print("Quel pièce voulez-vous choisir ? (ce : Cercle - ca : Carre - cy : Cylindre - tr : Triangle")
		var pieceOk : Bool = false


		var pieceString : String = ""
		var piece : Piece
		//Boucle qui vérifie si le string en entrée (readLine) est correct 
		while(!pieceOk){
			if let _piece = readLine() {
				
				let _piece = _piece.lowercased()
				if( _piece == "ca" || _piece == "ce" || _piece == "cy" || _piece == "tr"){
					//pieceOk = true
					pieceString  = _piece

					if jeu.jCourant.PieceDispo(nom : pieceString) { // SI la piece appartient au joueur
						 piece = jeu.jCourant.stringToPiece(nom : pieceString )
						 pieceOk = true
					}
				}			
			}else { 
	    		print(" Le nom de la piece doit être ca,ce,cy ou tr. veuillez retaper : ")
	    	}
		}
		

		

		// Choix de la coordonnée x
		print("Coordonnées x : ")
		let x = lireNombre()

		// Choix de la coordonnée y
		print("Coordonnées y : ")
		let y = lireNombre()

		// Vérifie si le joueur peut placer sa piece 
		let peutPlacer : Bool  = jeu.PeutPlacer(j : jeu.jCourant, p : piece, x : x, y : y)

		// Place la piece si c'est possible et s'il confirme
		if(peutPlacer) {
			print ("Confirmer le placement : ", piece , " ,x : " , x , " ,y : " , y , " ? ( oui/o ou autre pour non")
			if let ok = readLine() {
				let ok = ok.lowercased()

				if( ok == "oui" || ok == "o" ){
					jeu.Placer(j : jeu.jCourant, p : piece, x : x, y : y)
					aJoue = true 

					// Vérification si la partie est finie
					if (jeu.estFini(x : x, y : y) ) {
						print(jeu.jCourant , " a gagné !!!!!!")
						estFini = true
					}
					// Change de joueur si le jeu n'est pas fini 
					else { 
						let jprec : Joueur = jeu.jCourant
						jeu.joueurSuivant()
						// Vérifie que le nouveau joueur peut jouer sinon le jeu est fini 
						if( !jeu.jCourant.peutJouer(jeu : jeu)) {
							print(jprec , " a gagné !!!!!!")
						}
					}
				}	
			}
		}
		// Si le joueur n'a pas pu placer sa pièce retour en boucle aJoue
		else {
			print("Parametre incorrect ")
		}

	}// Fin de boucle aJoue

}// Fin de boucle estFini  



