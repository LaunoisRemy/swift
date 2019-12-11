
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
    func peutBouger(joueur : Joueur, x : Int, y : Int) -> Bool


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

class Pion:TPion {
    var estVivant : Bool
    private var _couleur : String
    private var _type : String
    var position : Position?

    required init(couleur:String,type:String){
        self.estVivant = true 
        self._couleur=couleur
        self._type=type
        self.position = nil 
    }

    var couleur : String {return self._couleur}

    var type : String {return self._type}
    // TO DO :  faire une fonction qui permet de retrouver une position avec x et y ... on suppose que c'est la fonction coordToPos(x,y)
    func peutBouger(joueur : Joueur, x : Int, y : Int) -> Bool {
        if self.estVivant{
            if x>=0 && x<=5 && y>=0 && y<=5{
                var pos=coordToPos(x:x,y:y)
                if joueur.couleur==self.couleur && pos.estOccupee==false{
                    return true
                }   
            }  
        }
        return false
    }
        

    func descriptionPion() -> String {
    	var pos:String=""
    	pos+="("+String(self.position.0)+","
    	pos+=String(self.position.1)+")"

        return "Le pion est de couleur: "+self.couleur+"\n C'est un pion : "+self.type+"\n Il est à la position : "+pos
    }



    func bougerPion(x : Int, y : Int) {
        var pos=coordToPos(x:x,y:y)
        self.position.estOccupee=false
        self.position=pos
        self.position.estOccupee=true
    }

}
