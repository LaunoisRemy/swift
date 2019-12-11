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
    private var _cartes : (Carte?, Carte?)
    private var _caseMaitre : Position
    private var _pions : [Pion]

    init(couleur:String, posMaitre : Position) {
        self._couleur = couleur
        self._cartes = (nil,nil)
        self._caseMaitre = posMaitre
        for i in 0..<4 {

        	_pions[i] = Pion(couleur:self._couleur, type:"eleve")
        }
        _pions[_pions.count] = Pion(couleur:self._couleur, type:"maitre")


    }

    var couleur : String {return self._couleur}
    var caseMaitre : Position {return self._caseMaitre}

    func getCartes() throws -> [Carte] {
        guard let c1 = _cartes.0 else { fatalError("Erreur vous appel trop tot") }
        guard let c2 = _cartes.1 else { fatalError("Erreur vous appel trop tot") }
        return [c1,c2]
    }

    func getPionsEnVie() -> [Pion] {
    	var pions : [Pion]
    	return pions
    }
    func echangerCarte(carte : Carte, partie : TPartie) {
    	self._cartes = (nil,nil)
    }
    func existeDeplacement() -> Bool { return false}
    func existePion(x : Int, y : Int) -> Bool { return false}
    func existeCarte(nom : String) -> Bool { return false}
    func getCarte(nom : String) -> Carte {
        guard let c1 = _cartes.0 else { fatalError("Erreur vous appel trop tot") }
        guard let c2 = _cartes.1 else { fatalError("Erreur vous appel trop tot") }
        return c1
    }
    func getPion(x : Int, y : Int) -> Pion {
    	return _pions[0]
    }
}
