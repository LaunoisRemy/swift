// Ce protocole représente le joueur de la partie. 
// Le joueur aura accès a plusieurs fonctions, comme celle de voir les pièces qu'il lui reste.
// Chaque joueur aura une couleur et des pièces de couleurs identiques.
protocol Joueur {

    //init : -> Joueur 
    // Fonction de création du joueur a partir de sa couleur qui est différente des autres joueurs 
    // Postcondition : Initialise sa couleur qui ne change pas et ses 8 pièces composées de  2 carré , 2 cylindre , 2 cercle, 2 triangle et pas d'autres.
    // Postcondition : Toutes les pièces sont aussi de la même couleur que le joueur. 
    init(couleur : String)

    // couleur : Joueur -> String
    // Paramètre : Joueur
    // Renvoie la couleur du joueur en paramètre
    // PostCondition : le string de retour est soit "33" = claire ou "92" = foncée
    // Détail : Cela représente les codes de couleurs pour l'affichage. 
    var couleur : String {get}

    // PieceDispo : Joueur x Piece -> Bool
    // Renvoie un booléen afin de savoir si le joueur possède la pièce sélectionnée
    // Paramètre : Joueur , Pièce 
    // Résultat : renvoie True si le joueur possède encore cette pièce, False sinon 
    func PieceDispo(piece : Piece) -> Bool  

    // PieceRestantes : Joueur -> [Piece]
    // Informe sur les pièces restantes et leur quantités
    // Paramètre : Joueur 
    // Resultat : Renvoie la liste des pièces non jouées du joueur pris en paramètre. 
    // Postcondition : le tableau contient les pièces que le joueur possède.
    // Détail : S'il possède 2 carré, alors il y aura 2 fois carré dans la collection. 
    var PieceRestantes : [Piece] { get }


    // peutJouer : Jeu x Joueur -> Bool
    // Informe sur la possibilité du joueur de poser une pièce sur le plateau
    // Paramètres : Jeu , Joueur 
    // Renvoie True si avec les pièces restantes que le joueur possède, il peut jouer. False sinon 
    func peutJouer(jeu : Jeu) -> Bool

    // retirerPiece : Joueur x Piece -> Joueur
    // Retire la piece que le joueur vient de placer de ses pièces restantes 
    // Paramètre : Joueur qui représente le joueur courant 
    // Paramètre : Piece qui représente celle qui vient d'être placée 
    // Précondition : La pièce prise en paramètre a bien été placée 
    // Résultat : Renvoie un joueur avec cette pièce en moins dans sa collection de pièces restantes. 
    mutating func retirerPiece(p:Piece)

}


// Le protocole Piece représente les différentes pièces présentes dans le jeu. 
// Chaque joueur possède 2 pièce de chaque forme. 
// La création de pièce ne sera effectué qu'en début de partie
protocol Piece {
    // init : String x String -> Piece
    // Initialise une pièce grâce a son nom et sa couleur 
    // Paramètre : nom de type string correspondant à la forme de la piece ( ce : Cercle - ca : Carre - cy : Cylindre - tr : Triangle)
    // Paramètre : couleur correspondant a la couleur de la pièce 
    // Cette fonction ne peut pas être utilisé autre qu'en début de partie (fileprivate)
    // init(nom : String, couleur : String )

    // nom : Piece -> String
    // Paramètre : Piece
    // Postcondition : nom de la piece :  ce : Cercle - ca : Carre - cy : Cylindre - tr : Triangle
    var nom : String { get }

    // couleur : Piece -> Couleur
    // Paramètre : Piece 
    // Postcondition : Renvoie "33"=claire ou "92"=fonce et rien d'autre. 
    var couleur : String { get }

}