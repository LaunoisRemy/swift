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

// ------------------------------------------------------------------

protocol TPion {
    //init :  -> TPion
    //Résultat: crée un pion avec un couleur , un type de pion, et un boolean estVivant
    //Pré: la couleur est soit "rouge" soit "bleu", le type de pion est soit "eleve" soit "maitre"
    //Post : estVivant(init())==True)
    init(couleur:String,type:String)

    //couleur : TPion -> String
    //Résultat : retourne la couleur du pion, soit "bleu", soit "rouge"
    //Post: le pion a été crée auparavant
    var couleur : String {get}

    //type : TPion -> String
    //Résultat : retourne le type de pion, soit "maitre" soit "eleve"
    //Pré: le pion a été crée auparavant
    var type : String {get}

    //position : TPion -> TPosition
    //Résultat : retourne la position occupée par le pion
    //Pré: la partie à été crée et donc les pions initialisé à une position
    var position : TPosition? {get set}

    //estVivant : TPion -> Bool
    //Résultat: retourne true si le pion n'a pas été tué par l'adversaire 
    //Pré: la partie à été crée et donc les pions initialisé à une position
    var estVivant : Bool {get set}

    //peutBouger : TPion x Int x Int -> Bool
    //Résultat: true si le pion appartient au joueur, est vivant, et que la nouvelle position de ce pion ne sort pas de la grille, et n'est pas occupée par un de ses pions (de la même couleur).
    //Pré: le déplacement (x,y) par rapport à la case du joueur doit correspondre à un déplacement d'une carte du joueur
    func peutBouger(x : Int, y : Int) -> Bool


    //descriptionPion : TPion -> String
    //Résulat: retourne une chaine de caractères décrivant le pion passé en paramètre ex:pion(couleur : bleu (ou rouge), type : élève (ou maitre),position : x,y)
    //Pré: le pion a été crée auparavant
    func descriptionPion() -> String
        
    //bougerPion : TPion x Int x Int
    //Résultat: l'ancienne position n'est plus occupée. Le pion est sur la nouvelle position qui sera donc occupée.
    // Si lors de son déplacement le pion, arrive sur une case occupée par un pion du joueur adverse, on le tue (la valeur estVivant du pion adverse devient false)
    // ATTENTION si c'est le joueur de la couleur commence, il n'y a pas de problème on déplacera le pion de +x sur sa ligne et +y sur sa colonne
    // mais si c'est l'autre joueur les déplacement se font dans le sens opposé à cause de l'orientation du plateau: -x  sur sa ligne et -y sur sa colonne
    //Pré: peutBouger(pion, position)==vraie
    mutating func bougerPion(x : Int, y : Int)
}

class Pion : TPion {
    var estVivant : Bool
    private var _couleur : String
    private var _type : String
    // ?? pourquoi un T devant Position alors que c'est un protocol 
    var position : TPosition?
    // -------------------------------
    required init(couleur:String,type:String){
        self.estVivant = true 
        self._couleur=couleur
        self._type=type
        self.position = nil 
    }

    var couleur : String {return self._couleur}

    var type : String {return self._type}

    func peutBouger(x : Int, y : Int) -> Bool {return false}
    func descriptionPion() -> String {return "non"}
    func bougerPion(x : Int, y : Int) {}

}