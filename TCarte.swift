protocol TCarte {
    //init: -> TCarte
    //Résultat: cette fonction crée une carte avec un nom, une couleur et un motif = l'ensemble des déplacements possibles par rapport à la case occupée par le joueur
    //Pré:la couleur est soit "rouge" soit "bleu"
    init(nom:String,couleur:String,motif:[(Int,Int)])

    //nom : TCarte -> String
    //Résultat: Retourne le nom de la carte
    //Pré: La carte passé en paramètre appartient au tas de cartes du plateaux
    var nom : String {get}

    //couleur : TCarte -> String
    //Résultat: Retourne la couleur de la carte, soit "bleu", soit "rouge"
    //Pré: La carte passé en paramètre appartient au tas de cartes du plateaux
    var couleur : String {get}

    //getMotif: -> ((Int,Int))
    //Résultat: retourne tous les déplacements relatifs pour la carte. Ces coordonsnées ne dépendent pas d'un pion.
    func getMotif() -> [(Int,Int)]

    //descriptionCarte : TCarte -> String
    //Resultat: retourne un string qui contient le nom et les déplacements possibles de la carte passée en paramètre. ex: carte(nom : dragon, déplacement : ((x1,y1),(x2,y2),.....)
    //Pré: les cartes ont été distribuées
    func descriptionCarte() -> String

    //deplacementAppartientMotif : TCarte x Int x Int -> Bool
    //Résultat: retourne true si le déplacement Int x Int appartient au motif de la carte passée en paramètre
    func deplacementAppartientMotif(x : Int, y : Int) -> Bool
}


struct Carte{
    private var _nom : String
    private var _couleur : String
    private var _motif : [(Int,Int)]

    init(nom:String,couleur:String,motif:[(Int,Int)]){
        self._nom=nom
        self._couleur=couleur
        self._motif=motif
    }

    func getMotif() -> [(Int,Int)] {return _motif}

    func descriptionCarte() -> String{return "Ceci est la carte : "+self.nom+"\n Voici les déplacements associés : "+String(self.getMotif())}

    func deplacementAppartientMotif(x : Int, y : Int) -> Bool{
        motif=self.getMotif()
        var check:Bool=false
        for element in motif{
            if x==element.0 && y==element.1{
                check=true
            }
        }
        return check
    }
}