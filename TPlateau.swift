protocol TPlateau{
    //init: -> TPlateau
    //Pré : les cartes du jeu doivent être créer
    //Résultat : création d'un TPlateau (une grille de TPositions de taille 5x5) et attribution de la carteMilieu (TCarte)
    init()

    //carteMilieu : TPlateau -> TCarte
    //Pré: les carte ont déjà été distribuées 
    //Résultat: retourne la carte du milieu du plateau 
    var carteMilieu : TCarte! {get set}

}
