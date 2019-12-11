protocol TPartie{
    //init: -> TPartie
    //Résultat : RESPECTERE L'ORDRE : 
    //  création des 16 cartes
    //  création du plateuu qui est une grille de TPositions de taille 5x5
    //  attribution de la carteMilieu (TCarte)
    //  création des 10 pions (5 rouges dont 4 élèves et un maître, et 5 bleus dont 4 élèves et un maître)
    //  création des 2 joueurs (un Rouge et un Bleu)
    //  placement des pions tel que le maître soit au milieu de la première ligne devant le joueur de sa couleur et les élèves autour de celu-ci, ces cases seront donc occupée.
    //Pré : RESPECTER L'ORDRE: créer cartes avant la grille, le plateau avant les pions, et les pions avant les joueurs.
    //Post: finDePartie(init()) == false et aGagne == nil
    init()

    
    //aGagne : TPartie -> String
    //Résultat: retourne la couleur du joueur qui a gagné. (celui qui a tué le maitre de l'autre ou qui a positionné son maitre est sur l'arche de l'autre (la case de départ de son maitre))
    //Pré: finDePartie == true
    var aGagne : String? {get set}

    //commence : TPartie -> TJoueur
    //Résultat: retoune le joueur qui a la même couleur que la carteMilieu
    //Pré: la partie est créée
    var commence : TJoueur!{get}

    //joueurCourant : TPartie -> TJoueur
    //Résultat: renvoie le joueur qui est en train de jouer
    //Pré : pour le set, il faut envoyer un TJoueur
    var joueurCourant : TJoueur! {get set}

    //joueurAdverse : TPartie -> TJoueur
    //Résultat: renvoie le joueur adverse du joueur courant
    //Pré : Envoi le joueur courant en paramètre
    var joueurAdverse : TJoueur! {get set}

    //carteMilieu : TPartie -> TCarte
    //Pré: les carte ont déjà été distribuées 
    //Résultat: retourne la carte du milieu du plateau
    var carteMilieu : TCarte! {get set}

    //finPartie : TPartie -> Bool
    //Résultat: retourne True si le joueurCourant capture le maître de joueurAdverse “Voie de la Pierre” ou si le maître de joueurCourant va sur la case arche de joueurAdverse (la case de départ du Maitre) “Voie du Ruisseau
    func finPartie() -> Bool
    
    //changerJoueur : TPartie
    //Résulat: le joueurCourant devient le joueurAdverse et inversement
    func changerJoueur()


}


//Class bidon pour éviter l'erreur : use of unresolved identifier 'Partie'; did you mean 'TPartie'?
// var p : TPartie = Partie()
/*
class Partie : TPartie {

	required init(){}
	var plateau : TPlateau 
	var aGagne : String?
	var commence : TJoueur!
	var joueurCourant : TJoueur!
	var joueurAdverse : TJoueur!

	func finPartie() -> Bool {
		return true
	}

	func changerJoueur() {}
}
*/
// x sens horizontale a partir de la case noir et y vertical 
class Partie:TPartie{
    var grille:[[Position]]=[]
    var carteMilieu:Carte!
    var deck:[Carte]=[]
    private var _commence:TJoueur!
    var joueurCourant:Joueur!
    var joueurAdverse:Joueur!
    init(){
        // Initialisation des Cartes
        self.deck.append(Carte("lapin","rouge",["(1,1)","(2,0)","(-1,-1)"]))
        self.deck.append(Carte("boeuf","rouge",["(1,0)","(0,1)","(0,-1)"]))
        self.deck.append(Carte("cobra","rouge",["(-1,0)","(1,1)","(1,-1)"]))
        self.deck.append(Carte("elephant","bleu",["(-1,0)","(-1,1)","(1,0)","(1,1)"]))
        self.deck.append(Carte("dragon","bleu",["(2,1)","(-2,1)","(-1,-1)","(1,-1)"]))
        self.deck.append(Carte("tigre","bleu",["(0,2)","(0,-1)"]))

        //Création de la Grille. la position (0,0) correspont au coin en haut a gauche du plateau
        for y in 0..<5{
            var ligne:[Position]=[]
            for x in 0..<5{
                ligne.append(Position(x,y))
            self.grille.append(ligne)

            }
        }

        //Attribution de la carte situé au Milieu 
        let milieu:Int= Int.random(in: 0..<6)
        self.carteMilieu=deck[milieu]
        self.deck.remove(at:milieu)


        //Création des joueurs 
        self.joueurCourant=Joueur("bleu",Position(2,0))
        self.joueurAdverse=Joueur("rouge",Position(2,4))

        //Attribution premier joueur
        if carteMilieu.couleur==joueurCourant.couleur{
            self._commence=joueurCourant
        }
        else{
            joueurSuiv(jc:joueurCourant,ja:joueurAdverse)
            self._commence=joueurCourant
        }


        //Positionnement des Pions




    }

    private mutating func joueurSuiv(jc:Joueur,ja:Joueur){
        var tmp:Joueur=jc
        self.joueurCourant=ja
        self.joueurAdverse=tmp

    }

}