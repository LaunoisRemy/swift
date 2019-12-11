protocol TJoueur{
    //init: -> TJoueur
    //Résultat: cette fonction crée un joueur avec une couleur, 4 pions élèves et un pion maître (tous en vie) , avec deux cartes vides
    //Post: les pions auront la même couleur que le joueur
    init()
    
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

    //echangerCarte : TJoueur x TCarte x TPlateau -> TJoueur
    //Résultat: echange la carte du joueur passée en paramètre avec la carteMilieu du plateau
    //Pré: la carte doit appartenir au joueur, et s'il a pu déplacer son pion, ça doit être la carte qu'il a utilisé. Si il n'a pas pu déplacer son pion, ça peut être n'importe laquelle de ses deux cartes
    mutating func echangerCarte(carte : TCarte, plateau : TPlateau)

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
