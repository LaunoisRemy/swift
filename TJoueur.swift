protocol TJoueur{
    //init: -> TJoueur
    //Résultat: cette fonction crée un joueur avec une couleur, 4 pions élèves et un pion maître (tous en vie) , avec deux cartes vides
    //Post: les pions auront la même couleur que le joueur
    init(couleur:String,posMaitre : TPosition)
    
    //couleur : TJoueur -> String
    //Résultat : retourne la couleur du joueur, soit "bleu", soit "rouge"
    //Pré: le pion a été crée auparavant
    var couleur : String {get}


    //caseMaitre : TJoueur -> TPosition
    //Résultat : retourne la TPosition de la case maitre du joueur (c'est la case située au centre de la première ligne devant le joueur)
    //Pré : la grille a été créée auparavant
    var caseMaitre : TPosition {get}

    //getCartes : TJoueur
    //Resultat: retourne les deux cartes du joueur
    //Pré: les cartes ont été distribuées
    func getCartes() -> [TCarte]

    //getPionsEnVie : TJoueur -> [TPion]
    //Résultat : retourne les pions en vie du joueur
    //Pré : le joueur à été créé
    func getPionsEnVie() -> [TPion]

    //echangerCarte : TJoueur x TCarte x TPartie-> TJoueur
    //Résultat: echange la carte du joueur passée en paramètre avec la carteMilieu du plateau
    //Pré: la carte doit appartenir au joueur, et s'il a pu déplacer son pion, ça doit être la carte qu'il a utilisé. Si il n'a pas pu déplacer son pion, ça peut être n'importe laquelle de ses deux cartes
    mutating func echangerCarte(carte : TCarte, partie : TPartie)

    //existeDeplacement : TJoueur -> Bool
    //Résultat: retourne true si le joueur peut déplacer au moins un de ses pions en vie avec les cartes qu'il a
    //Pré: le joueur à été créé
    func existeDeplacement() -> Bool

    //existePion : TJoueur x Int x Int -> Bool
    //Résultat: retourne true si le joueur possède un pion en vie à la position passée en paramètres
    func existePion(x : Int, y : Int) -> Bool

    //existeCarte : TJoueur x String -> Bool
    //Résultat: retourne true si le joueur possède une carte avec le nom passé en paramètres
    func existeCarte(nom : String) -> Bool

    //getCarte : TJoueur x String -> TCarte
    //Résultat: retourne la TCarte du joueur qui a le nom passé en paramètre
    //Pré: existeCarte(joueur,nom)==true
    func getCarte(nom : String) -> TCarte

    //getPion : TJoueur x Int x Int -> TPion
    //Résultat: retoune le TPion du joueur qui se trouve sur la position passée en paramètre
    //Pré: existePion(joueur, TPosition ) == true
    func getPion(x : Int, y : Int) -> TPion
}

class Joueur {
    private var _couleur : String
    private var _cartes : [Carte]=[] //rien a la place de deux cartes vide
    private var _caseMaitre : Position
    var pions : Array<Pion> = Array()

    init(couleur:String, posMaitre : Position) {
        self._couleur = couleur
        self._caseMaitre = posMaitre
        self.pions.reserveCapacity(5)
        for _ in 0..<4 {
        	self.pions.append(Pion(couleur:self._couleur, type:"eleve"))
        }
        self.pions.append(Pion(couleur:self._couleur, type:"maitre"))
    }

    var couleur : String {return self._couleur}
    var caseMaitre : Position {return self._caseMaitre}

    func getCartes() throws -> [Carte] {
        return _cartes
    }

    func getPionsEnVie() -> [Pion] {
    	var pions : [Pion] = []
    	for p in pions {
    		if(p.estVivant){
    			pions.append(p)
    		}
    	}
    	return pions
    }

    func echangerCarte(carte : Carte, partie : TPartie) throws {
    	// TODO : verif que la carte a permis le deplacement => que cette carte echange ou sinon les deux
    	if(self.existeCarte(nom:carte.nom)){
    		if(self._cartes[0].nom == carte.nom ){
    			self._cartes[0]=partie.carteMilieu()
    			partie.carteMilieu=carte
    		}else{
    			self._cartes.1=partie.carteMilieu()
    			partie.carteMilieu=carte
    		}
    	}else {
    		fatalError("Mauvaise carte")
    	}
    }

    func existeDeplacement() -> Bool { return false}

    func existePion(x : Int, y : Int) -> Bool {
    	var existe : Bool = false
    	var i : Int = 0
    	while existe == false {
    		let p : Pion = pions[i]
    		if let pos = p.position {
    			if pos.coordonnees == (x,y){
    				existe = true
    			}
    		}
    		i+=1
    	}
     	return false
 	}

    func existeCarte(nom : String) -> Bool { 
    	if self._cartes[0].nom==nom || self._cartes[1].nom==nom 	{
    		return true
    		}else {
    			return false
    		}
    }

    func getCarte(nom : String) throws -> Carte {
    	if(existeCarte(nom : nom)) {
    	    if(self._cartes[0].nom == nom ){
    			return self._cartes[0]
    		}else {
    			return self._cartes[1]
    		}	
    	}else {
    		fatalError("La carte n'existe pas")
    	}
    }

    func getPion(x : Int, y : Int) -> Pion {
    	var existe : Bool = false
    	var i : Int = 0
    	while existe == false {
    		let p : Pion = pions[i]
    		if let pos = p.position {
    			if pos.coordonnees == (x,y){
    				existe = true
    			}
    		}
    		i+=1
    	}
    	if(existe==true){
    		i-=1
    		return pions[i]
    	}else {
    		fatalError("Le pion n'est pas present")
    	}
    }

}
