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

// TPosition est passé en class (référence) car dans le type Partie, il y a une grille qui possède des positions
// et les pions qui pointent vers les mêmes positions. Afin d'éviter de faire une copie valeur des positions de la grille,
// initialiser la positions des pions en poitant vers la référence des positions assurera la modifications des positions.
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
    func peutBouger(joueur : TJoueur, x : Int, y : Int, partie : TPartie) -> Bool
    
    
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
    mutating func bougerPion(x : Int, y : Int, partie:TPartie)
}


class Pion:TPion {
    var estVivant : Bool
    private var _couleur : String
    private var _type : String
    var position : TPosition?
    
    required init(couleur:String,type:String){
        if couleur=="bleu" || couleur=="rouge"{
            self._couleur=couleur
        }
        else{
            self._couleur="erreur"
        }
        if type=="maitre" || type=="eleve"{
            self._type=type
        }
        else{
            self._type="erreur"
        }
        self.estVivant = true
        self.position = nil
    }
    
    var couleur : String {return self._couleur}
    var type : String {return self._type}
    
    func peutBouger(joueur : TJoueur, x : Int, y : Int, partie:TPartie) -> Bool {
        if self.estVivant{
            let pos : (Int,Int) = newPos(x:x,y:y,partie:partie)
            let newPosX : Int = pos.0
            let newPosY : Int = pos.1
            
            if newPosX>=0 && newPosX<5 && newPosY>=0 && newPosY<5{
                if let pos=partie.coordToPos(x:newPosX,y:newPosY){
                    if joueur.couleur==self.couleur{
                        if pos.estOccupee==false{
                            return true
                        }else{
                            // on regarde si le joueur possède un pion en x,y
                            if infoCase(joueur:joueur, x:newPosX, y:newPosY){
                                return false
                            }
                            else{return true}
                        }
                    }
                }
            }
        }
        return false
    }
    private func newPos(x:Int,y:Int,partie:TPartie) -> (Int,Int){
        var newPosX : Int = self.position!.coordonnees.0
        var newPosY : Int = self.position!.coordonnees.1
        if(self._couleur == "bleu") {
            newPosX += x
            newPosY += y
        }else {
            newPosX -= x
            newPosY -= y
        }
        return (newPosX,newPosY)
    }
    // false : ne possede pas de pion a cette case  true :joueur possde le pion
    private func infoCase(joueur:TJoueur,x:Int,y:Int)->Bool{
        var existe : Bool = false
        var i : Int = 0
        var pionsEnVie : [TPion] = joueur.getPionsEnVie()
        while existe==false && i<pionsEnVie.count{
            let p : TPion = pionsEnVie[i]
            if let pos = p.position {
                if pos.coordonnees == (x,y){
                    existe = true
                }
            }
            i+=1
        }
        return existe
    }
    
    func descriptionPion() -> String {
        var pos:String="Aucune"
        if let p=self.position{
            pos="("+String(p.coordonnees.0)+","
            pos+=String(p.coordonnees.1)+")"
        }
        return "Le pion est de couleur: "+self.couleur+"\n C'est un pion : "+self.type+"\n Il est à la position : "+pos
    }
    
    func bougerPion(x : Int, y : Int, partie:TPartie){
        if peutBouger(joueur:partie.joueurCourant, x:x,y:y,partie:partie){
            let posTmp : (Int,Int) = newPos(x:x,y:y,partie:partie)
            let newPosX : Int = posTmp.0
            let newPosY : Int = posTmp.1
            if let pos=partie.coordToPos(x:newPosX,y:newPosY){
                //vérifie si pion adverse sur case
                let joueurAdverse : TJoueur = partie.joueurAdverse
                if infoCase(joueur:joueurAdverse,x:newPosX,y:newPosY){
                    // on actualise les propriétés du pion adverse
                    var pionAdv : TPion = joueurAdverse.getPion(x:newPosX,y:newPosY)
                    pionAdv.estVivant=false
                    pionAdv.position=nil
                }
                //actualise la position du joueur courant
                self.position!.estOccupee=false
                self.position!=pos
                self.position!.estOccupee=true
            }
        }
    }
}




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


struct Carte : TCarte {
    private var _nom : String
    private var _couleur : String
    private var _motif : [(Int,Int)]
    
    init(nom:String,couleur:String,motif:[(Int,Int)]){
        //Vérification de la couleur
        if couleur=="rouge" || couleur=="bleu"{
            self._couleur=couleur
        }
        else{
            self._couleur="erreur"
        }
        self._nom=nom
        self._motif=motif
    }
    
    var nom:String {return self._nom}
    var couleur:String {return self._couleur}
    
    func getMotif() -> [(Int,Int)] {return _motif}
    
    func descriptionCarte() -> String{
        
        var pos:String="["
        for i in 0..<self._motif.count{
            let element:(Int,Int)=self._motif[i]
            pos+="("+String(element.0)+","+String(element.1)+")"
            if i<self._motif.count-1{
                pos+=","
            }
        }
        pos+="]"
        return "Ceci est la carte : "+self.nom+"\n Voici les déplacements associés : "+pos
    }
    
    func deplacementAppartientMotif(x : Int, y : Int) -> Bool{
        var check:Bool=false
        var i:Int=0
        let motif:[(Int,Int)]=self.getMotif()
        while i<motif.count && check==false{
            let element:(Int,Int)=motif[i]
            if x==element.0 && y==element.1{
                check=true
            }
            i+=1
        }
        return check
    }
}
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
    
    
    //var plateau:[[TPosition]] {get}
    func coordToPos(x:Int,y:Int)->TPosition?
    
    
}

// x sens horizontale a partir de la case noir et y vertical
class Partie : TPartie{
    
    private var grille:[[TPosition]]=[]
    var carteMilieu:TCarte!
    private var deck:[TCarte]=[]
    private var _commence:TJoueur!
    var joueurCourant:TJoueur!
    var joueurAdverse:TJoueur!
    var aGagne:String?
    var commence:TJoueur! { get  { return _commence} }
    
    var plateau : [[TPosition]] { return self.grille }
    
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
            }
            self.grille.append(ligne)
        }
        //Création des joueurs
        self.j1=Joueur(couleur:"bleu",posMaitre:self.grille[0][2])
        self.j2=Joueur(couleur:"rouge",posMaitre:self.grille[4][2])
        
        //Attribution de la carte situé au Milieu
        self.carteMilieu=carteAlea()
        //Attribution des deux cartes aux joueurs
        for _ in 0..<2{
            self.j1.setCartes(c: carteAlea())
            self.j2.setCartes(c: carteAlea())
        }
        
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
    private func carteAlea()->TCarte{
        let i:Int=Int.random(in: 0..<self.deck.count)
        let carte:TCarte = self.deck[i]
        self.deck.remove(at:i)
        return carte
    }
    
    
    
    private func initPosPions(j: inout TJoueur){
        var pionsJc : [TPion] = j.getPionsEnVie()
        if j.couleur=="bleu"{
            positionPourJoueur(pionsJc :&pionsJc, ligne : 0)
        }else{
            positionPourJoueur(pionsJc :&pionsJc, ligne : 4)
        }
    }
    private func positionPourJoueur(pionsJc : inout [TPion], ligne : Int) {
        let poseleve:[Int]=[0,1,3,4]
        let posmaitre:Int=2
        //placement des pions en fonction de leur type
        for i in 0...pionsJc.count - 1 {
            if pionsJc[i].type=="eleve"{
                var posgrille : TPosition = self.grille[ligne][poseleve[i]]
                pionsJc[i].position=posgrille
                posgrille.estOccupee=true
            }
            else{
                var posgrille : TPosition = self.grille[ligne][posmaitre]
                pionsJc[i].position=posgrille
                posgrille.estOccupee=true
            }
        }
    }
    
    
    
    func finPartie() -> Bool{
        var res:Bool=false
        var indice_adv:Int=0
        let pionsEnVieJa : [TPion] = self.joueurAdverse.getPionsEnVie()
        
        var indice_cour:Int=0
        let pionsEnVieJc : [TPion] = self.joueurCourant.getPionsEnVie()
        //vérifie si le joueurCourant possède un maitre
        while indice_cour < pionsEnVieJc.count && pionsEnVieJc[indice_cour].type != "maitre"{
            indice_cour+=1
        }
        
        //vérifie si le pions maitre est dans la liste des pions du joueur adverse
        while indice_adv < pionsEnVieJa.count && pionsEnVieJa[indice_adv].type != "maitre" {
            indice_adv+=1
        }
        if indice_cour<pionsEnVieJc.count && indice_adv<pionsEnVieJa.count{
            //stocke la position maitre de l'ancien joueur courant
            let jaPion:TPion=self.joueurAdverse.getPionsEnVie()[indice_cour]
            let posMaitreJa : TPosition = jaPion.position!
            // test si la position du de l'ancien maitre courant est sur la case maitre adverse
            if posMaitreJa.coordonnees == self.joueurCourant.caseMaitre.coordonnees{
                res=true
            }
        }
        else{
            res=true
        }
        if res{
            self.aGagne=joueurAdverse.couleur
        }
        return res
    }
    
    
    func changerJoueur(){
        if self.joueurCourant.couleur==self.j1.couleur{
            self.joueurCourant=self.j2
            self.joueurAdverse=self.j1
        }
        else{
            self.joueurCourant=self.j1
            self.joueurAdverse=self.j2
        }
    }
    
    func coordToPos(x:Int,y:Int)->TPosition?{
        if x >= 0 && y >= 0 && x < 5 && y < 5{
            // on rappelle que x représente les déplacement horizentaux
            // et y ceux verticaux
            return self.grille[y][x]
        }else{
            return nil
        }
    }
    
    
}

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
    
    //getCartes : TJoueur
    //Resultat: créé les deux cartes du joueur
    //Pré: les cartes ont été initialisé
    func setCartes(c:TCarte)
    
    //getPionsEnVie : TJoueur -> [TPion]
    //Résultat : retourne les pions en vie du joueur
    //Pré : le joueur à été créé
    func getPionsEnVie() -> [TPion]
    
    
    //echangerCarte : TJoueur x TCarte x TPartie-> TJoueur
    //Résultat: echange la carte du joueur passée en paramètre avec la carteMilieu du plateau
    //Pré: la carte doit appartenir au joueur, et s'il a pu déplacer son pion, ça doit être la carte qu'il a utilisé. Si il n'a pas pu déplacer son pion, ça peut être n'importe laquelle de ses deux cartes
    mutating func echangerCarte(carte : TCarte, partie : inout TPartie)
    
    //existeDeplacement : TJoueur -> Bool
    //Résultat: retourne true si le joueur peut déplacer au moins un de ses pions en vie avec les cartes qu'il a
    //Pré: le joueur à été créé
    func existeDeplacement(partie : TPartie) -> Bool
    
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

class Joueur : TJoueur {
    private var _couleur : String
    private var _cartes : [TCarte]=[] //rien a la place de deux cartes vide
    private var _caseMaitre : TPosition
    private var pions : Array<TPion> = Array()
    
    required init(couleur:String, posMaitre:TPosition) {
        if couleur=="rouge" || couleur=="bleu"{
            self._couleur = couleur
        }
        else{
            self._couleur="erreur"
        }
        self._caseMaitre = posMaitre
        self.pions.reserveCapacity(5)
        for _ in 0..<4 {
            self.pions.append(Pion(couleur:self._couleur, type:"eleve"))
        }
        self.pions.append(Pion(couleur:self._couleur, type:"maitre"))
    }
    
    var couleur : String {return self._couleur}
    var caseMaitre : TPosition {return self._caseMaitre}
    
    func getCartes()  -> [TCarte] {
        return _cartes
    }
    func setCartes(c:TCarte)  {
        self._cartes.append(c)
    }
    
    func getPionsEnVie() -> [TPion] {
        var pionsEnVie : [TPion] = []
        for p in self.pions {
            if(p.estVivant){
                pionsEnVie.append(p)
            }
        }
        return pionsEnVie
    }
    
    func echangerCarte(carte : TCarte, partie : inout TPartie)  {
        // TODO : verif que la carte a permis le deplacement => que cette carte echange ou sinon les deux
        if(self.existeCarte(nom:carte.nom)){
            if(self._cartes[0].nom == carte.nom ){
                self._cartes[0]=partie.carteMilieu
                partie.carteMilieu=carte
            }else{
                self._cartes[1]=partie.carteMilieu
                partie.carteMilieu=carte
            }
            
        }else {
            fatalError("Mauvaise carte")
        }
    }
    
    func existeDeplacement(partie : TPartie) -> Bool {
        var pionsEnVie : [TPion] = self.getPionsEnVie()
        var i : Int = 0
        var peutDeplacer : Bool = false
        if (pionsEnVie.count > 0) { // Si j'ai des pionts en vie
            while !peutDeplacer && i < pionsEnVie.count{ // si je n'ai pas trouvé de déplacement et si j'ai pas parcourus tout mes pions
                peutDeplacer=self.parCarte(pion : pionsEnVie[i],partie : partie)
                i+=1
            }
        }
        return peutDeplacer
    }
    /*
     Fonction qui permet de savoir si un déplacement est possible pour chaque carte
     S'arrete dès qu'il en a trouvé un ou s' il a parcouru les deux cartes
     */
    private func parCarte ( pion : TPion,partie : TPartie) -> Bool{
        var c : Int = 0
        var peutSeDeplacer : Bool = false
        while !peutSeDeplacer && c < 2 { // pour chaque carte
            peutSeDeplacer = chaqueMotif(pion : pion, partie : partie, c : self._cartes[c])
            c+=1
        }
        return peutSeDeplacer
        
    }
    
    /*
     Fonction qui permet de savoir si un déplacement est possible pour chaque motif d'une carte
     S'arrete dès qu'il en a trouvé un ou s'il a parcouru tous les motifs
     */
    private func chaqueMotif (pion : TPion,partie : TPartie, c : TCarte) -> Bool{
        var deplacement : [(Int,Int)] = c.getMotif()
        var d : Int = 0
        var peutSeDeplacer : Bool = false
        while !peutSeDeplacer && d < deplacement.count{  // pour chaque motif d'une carte
            peutSeDeplacer = pourUnMotif(pion : pion, partie : partie, motif : deplacement[d])
            
            d+=1
        }
        return peutSeDeplacer
    }
    
    /*
     Fonction qui permet de savoir si un déplacement est possible pour le motif
     */
    private func pourUnMotif (pion : TPion,partie : TPartie, motif : (Int,Int)) -> Bool{// possible pour un motif
        let newPosX : Int
        var newPosY : Int
        
        if(self._couleur == "bleu") {
            newPosX = pion.position!.coordonnees.0 + motif.0
            newPosY = pion.position!.coordonnees.1 + motif.1
        }else {
            newPosX = pion.position!.coordonnees.0 - motif.0
            newPosY = pion.position!.coordonnees.1 - motif.1
        }
        
        return pion.peutBouger(joueur : self, x : newPosX , y : newPosY, partie : partie )
        
    }
    
    
    func existePion(x : Int, y : Int) -> Bool {
        var existe : Bool = false
        var i : Int = 0
        if x>=0 && x<5 && y>=0 && y<5{
            while existe == false && i<self.pions.count{
                let p : TPion = pions[i]
                if let pos = p.position {
                    if pos.coordonnees == (x,y){
                        existe = true
                    }
                }
                i+=1
            }
        }
        
        return existe
    }
    
    func existeCarte(nom : String) -> Bool {
        if self._cartes[0].nom==nom || self._cartes[1].nom==nom     {
            return true
        }else {
            return false
        }
    }
    
    func getCarte(nom : String)  -> TCarte {
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
    
    func getPion(x : Int, y : Int) -> TPion {
        var existe : Bool = false
        var i : Int = 0
        while existe == false {
            let p : TPion = self.pions[i]
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


//je crée la partie :
var p : TPartie = Partie()

//affectation du joueur courant
p.joueurCourant = p.commence
print("Joueur " + p.joueurCourant.couleur + " à toi de jouer ! \n ")

while (!p.finPartie()) {
    
    print("les pions en vie de ton adversaire sont les suivants: \n")
    for pion in p.joueurAdverse.getPionsEnVie(){ //affiche les pions en vie de l'adversaire
        print(pion.descriptionPion())
    }
    
    if(p.joueurCourant.existeDeplacement(partie:p)){ //vérifie si un déplacement est possible avec les cartes qu'il possède
        
        //variable pour déterminer si le tour est terminé (un pion a été bougé ou non)
        var finTour : Bool = false
        
        repeat {
            
            print("Tes pions en vie sont les suivant: \n")
            for pion in p.joueurCourant.getPionsEnVie(){ //affiche les pions en vie du joueur
                print(pion.descriptionPion())
            }
            
            print("Tes deux cartes sont les suivantes: \n")
            for carte in p.joueurCourant.getCartes(){ //affiche les cartes de la main du joueur
                print(carte.descriptionCarte())
            }
            
            //Le joueur choisis un de ses pions toujours en vie
            var x1 : Int
            var y1 : Int
            
            repeat {
                print("Il faut choisir la position d'un des pions parmis ceux proposés : \n")
                
                //Demande la coordonée x au joueur : permet de demander tant la saisie n'est pas un entier
                var v : Int? = nil
                while v == nil {
                    print("il faut une valeur entière pour x")
                    v = Int( readLine() ?? "" )
                }
                x1 = v! // v != nil
                
                //Demande la coordonée y au joueur : permet de demander tant la saisie n'est pas un entier
                var w : Int? = nil
                while w == nil {
                    print("il faut une valeur entière pour y")
                    w = Int( readLine() ?? "" )
                }
                y1 = w! // w != nil
                
            } while !(p.joueurCourant.existePion(x : x1, y : y1)) //redemande un pion tant qu'il ne saisie pas la position d'un de ses pions en vie
            var pionChoisi : TPion = p.joueurCourant.getPion(x : x1, y : y1) //récupérer le pion choisi
            
            //Le joueur choisis maintenant une carte
            var nomCarteChoisie : String
            repeat {
                print("Il faut saisir le nom d'une des cartes parmis celles proposées : \n")
                
                var w : String? = nil
                while w == nil || w == "" {
                    print("il faut une valeur entière pour y")
                    w = readLine() ?? ""
                }
                // w != nil
                nomCarteChoisie = w!
                
            } while !(p.joueurCourant.existeCarte(nom : nomCarteChoisie)) //redemande une carte tant qu'il ne saisie pas le nom d'une de ses cartes
            let carteChoisie : TCarte = p.joueurCourant.getCarte(nom : nomCarteChoisie) //récupérer la carte choisie
            
            //le joueur choisi le déplacement qu'il veut faire.
            var x2 : Int
            var y2 : Int
            
            repeat {
                print("Il faut choisir le déplacement que tu veux réaliser: x puis y : \n")
                
                var v : Int? = nil
                while v == nil {
                    print("il faut une valeur entière pour x")
                    v = Int( readLine() ?? "" )
                }
                // v != nil
                x2 = v!
                
                var w : Int? = nil
                while w == nil {
                    print("il faut une valeur entière pour y")
                    w = Int( readLine() ?? "" )
                }
                // w != nil
                y2 = w!
            } while !( carteChoisie.deplacementAppartientMotif(x : x2, y : y2) ) //vérifier que le déplacement appartient à la carte que le joueur à choisi
            
            //vérifier que le mouvement que le mouvement choisit est possible avec sa carte et son pion qu'il a choisi
            if (pionChoisi.peutBouger(joueur:p.joueurCourant,x:x2, y:y2, partie:p)){
                pionChoisi.bougerPion(x:x2, y:y2,partie:p)  //je tue le pion adverse si besoin lorsque je bouge
                
                //Une fois que le joueur a bougé son pion: la carte utilisée est échangée avec celle du milieu
                var localp:TPartie=p
                p.joueurCourant.echangerCarte(carte:carteChoisie, partie:&localp)
                
                //le tour est fini
                finTour = true
            } else {
                print("Le mouvement choisi pour ce pion n'est pas possible avec cette carte, il faut choisir une autre carte ou un autre pion \n ")
            }
        } while(!finTour)
    } else {
        print("Aucun déplacement n'est possible avec les cartes que tu possèdes. Quelle carte veut tu échanger avec celle du plateau ? \n")
        print("Voici les cartes que tu possèdes")
        for carte in p.joueurCourant.getCartes(){ //affiche les pions en vie du joueur
            print(carte.descriptionCarte())
        }
        
        var nomCarteChoisie : String
        repeat {
            print("Il faut saisir le nom de la carte à échanger : \n")
            
            var w : String? = nil
            while w == nil || w == "" {
                print("Il faut saisir un String pour le nom de la carte")
                w = readLine() ?? ""   //Le joueur saisi en console le nom de la carte qu'il veut
            }
            nomCarteChoisie = w! // w != nil
            
        } while !(p.joueurCourant.existeCarte(nom : nomCarteChoisie) )//redemande une carte tant qu'il ne saisie pas le nom d'une de ses cartes
        let carteChoisie : TCarte = p.joueurCourant.getCarte(nom : nomCarteChoisie ) //récupérer la carte choisie
        
        //echanger les cartes
        var localp:TPartie=p
        p.joueurCourant.echangerCarte(carte:carteChoisie, partie:&localp)
    }
    
    //changement du joueur courant
    p.changerJoueur()
}
print("La partie est terminée, le gagnant est le joueur de couleur" + (p.aGagne ?? "nil") )


