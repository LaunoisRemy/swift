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
    var aGagne:String? {get set}

    //commence : TPartie -> TJoueur
    //Résultat: retoune le joueur qui a la même couleur que la carteMilieu
    //Pré: la partie est créée
    var commence:TJoueur! {get}

    //joueurCourant : TPartie -> TJoueur
    //Résultat: renvoie le joueur qui est en train de jouer
    //Pré : pour le set, il faut envoyer un TJoueur
    var joueurCourant:TJoueur! {get set}

    //joueurAdverse : TPartie -> TJoueur
    //Résultat: renvoie le joueur adverse du joueur courant
    //Pré : Envoi le joueur courant en paramètre
    var joueurAdverse:TJoueur! {get set}

    //carteMilieu : TPartie -> TCarte
    //Pré: les carte ont déjà été distribuées 
    //Résultat: retourne la carte du milieu du plateau
    var carteMilieu:TCarte! {get set}

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
class Partie : TPartie{
    
    private var grille:[[TPosition]]=[]
    var carteMilieu:TCarte!
    private var deck:[TCarte]=[]
    private var _commence:TJoueur!
    var joueurCourant:TJoueur!
    var joueurAdverse:TJoueur!
    var aGagne:String?
    var commence:TJoueur!
    
    
    //{return self._commence}
    
    private let j1:TJoueur
    private let j2:TJoueur

    required init(){
        // Initialisation des Cartes
        self.deck.reserveCapacity(6)
        self.deck.append(Carte(nom:"lapin",couleur:"rouge",motif:[(1,1),(2,0),(-1,-1)]))
        self.deck.append(Carte(nom:"boeuf",couleur:"rouge",motif:[(1,0),(0,1),(0,-1)]))
        self.deck.append(Carte(nom:"cobra",couleur:"rouge",motif:[(-1,0),(1,1),(1,-1)]))
        self.deck.append(Carte(nom:"elephant",couleur:"bleu",motif:[(-1,0),(-1,1),(1,0),(1,1)]))
        self.deck.append(Carte(nom:"dragon",couleur:"bleu",motif:[(2,1),(-2,1),(-1,-1),(1,-1)]))
        self.deck.append(Carte(nom:"tigre",couleur:"bleu",motif:[(0,2),(0,-1)]))
        
        //Création de la Grille. la position (0,0) correspont au coin en haut a gauche du plateau
        for y in 0..<5{
            var ligne:[Position]=[]
            for x in 0..<5{
                ligne.append(Position(x:x,y:y))
                self.grille.append(ligne)
                
            }
        }
        
        //Attribution de la carte situé au Milieu
        let milieu:Int=Int.random(in: 0..<6)
        self.carteMilieu=self.deck[milieu]
        self.deck.remove(at:milieu)
        
        
        //Création des joueurs
        self.j1=Joueur(couleur:"bleu",posMaitre:self.grille[0][2])
        self.j2=Joueur(couleur:"rouge",posMaitre:self.grille[4][2])
        
        
        //Attribution premier joueur
        if self.carteMilieu.couleur==self.j1.couleur{
            self._commence=self.j1
            self.joueurCourant=self.j1
            self.joueurAdverse=self.j2
        }
        else{
            
            self._commence=self.j2
            self.joueurCourant=self.j2
            self.joueurAdverse=self.j1
        }
        
        
        //Positionnement des Pions du joueur
        // n'étant pas précisé, on a décidé de placer le joueur bleu sur la ligne 0 et le joueur Rouge sur la ligne 4
        //Joueur courant
        initPosPions(j:&self.joueurCourant)
        //Joueur Adverse
        initPosPions(j:&self.joueurAdverse)
        
        //Initialisation de la variable aGagne
        self.aGagne=nil
    }
    
    
    
    private func initPosPions(j: inout TJoueur){
        //var i:Int=0
        var pionsJc : [TPion] = joueurCourant.getPionsEnVie()
        if j.couleur=="bleu"{
            positionPourJoueur(pionsJc :&pionsJc, ligne : 4)
        }else{
            positionPourJoueur(pionsJc :&pionsJc, ligne : 0)      
        }       
    }
    private func positionPourJoueur(pionsJc : inout [TPion], ligne : Int) {
        let poseleve:[Int]=[0,1,3,4]
        let posmaitre:Int=2
        for i in 0...pionsJc.count {
            if pionsJc[i].type=="eleve"{
                pionsJc[i].position=self.grille[ligne][poseleve[i]]
                 //i+=1
            }
            else{
                pionsJc[i].position=self.grille[ligne][posmaitre]
            }
        }
    }
    
    
    
    func finPartie() -> Bool{
        var indice_adv:Int=0
        var indice_cour:Int=0
        
        //Trouve le pions maitre dans la liste des pions du joueur adverse
        while self.joueurAdverse.getPionsEnVie()[indice_adv].type != "maitre"{
            indice_adv+=1
        }
        //Trouve le pions maitre dans la liste des pions du joueur courant
        while self.joueurCourant.getPionsEnVie()[indice_cour].type != "maitre"{
            indice_cour+=1
        }
        //Le pion maitre adverse est vivant ou Le pion maitre courant est sur la case maitre adversaire
        let maitreAdverse : Bool = self.joueurAdverse.getPionsEnVie()[indice_adv].estVivant
        
        let jcPion:TPion=self.joueurCourant.getPionsEnVie()[indice_cour]
        let posMaitreJc : TPosition = jcPion.position!
        return  maitreAdverse != true ||  posMaitreJc.coordonnees == self.joueurAdverse.caseMaitre.coordonnees
        
    }
    
    
    func changerJoueur(){
        /* facon plus rapide mais ne sais pas si fonctionnelle
         let tmp:Joueur=self.joueurCourant
         self.joueurCourant=self.joueurAdverse
         self.joueurAdverse=tmp
         */
        
        if self.joueurCourant.couleur==self.j1.couleur{
            self.joueurCourant=self.j2
            self.joueurAdverse=self.j1
        }
        else{
            self.joueurCourant=self.j1
            self.joueurAdverse=self.j2
        }
    }
    
    
}