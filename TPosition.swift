protocol TPosition{
    //init: -> TPosition
    //Résultat: création d'une TPosition qui ne contient pas de pion
    //post: estOccupee(init())=false
    init(x:Int,y:Int)

    //estOccupee : Bool
    //Résultat: retourne True si un pion est sur la position, false sinon 
    var estOccupee : Bool {get set}

    //coordonnees : TPosition -> (Int x Int)
    //Résultat: retourne les coordonnees pour un TPosition
    var coordonnees : (Int,Int) {get}
}

class Position : TPosition {
    var estOccupee : Bool
    private var _coordonnees : (Int,Int)
    
    required init(x:Int,y:Int){
        self.estOccupee=false
        self._coordonnees=(x,y)
    }

    var coordonnees : (Int,Int) {return self._coordonnees}
}