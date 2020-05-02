
void setup(){
  size(920,880);
background(0);
  
   Table design = loadTable("design.txt","csv");
int w= design.getRowCount()*40;
int h= design.getColumnCount()*40;

}

// on utilise le fichier .txt avec une option csv pour pouvoir utiliser les méthodes qui s'appliquent à une table.


void draw(){
  background(0);
  Table design = loadTable("design.txt","csv");
int w= design.getRowCount()*40;
int h= design.getColumnCount()*40;

// 'for' est une boucle qui s'arrête quand (i < nombre de lignes) n'est plus vraie, donc qu'il soit plus grand que le nombre de ligne
// à l'intérieur d'une boucle on a ( ce qui est au départ ; quand ça s'arrête ;  ce qui passe, soit on ajoute 1 à i jusqu'à ce qu'on dépasse le nb de lignes de design )
for (int i=0; i<design.getRowCount();++i){
  // on définit i comme 1 ligne de la table. 
TableRow row = design.getRow(i);
// même boucle mais pour les colonnes, on utilise souvent i pour les lignes & j pour les colonnes. 
for (int j=0; j<design.getColumnCount();j++){
//passe en revue tous les éléments du tableau avec i (ligne) et j (colonne)
 String cell = design.getString(i,j);
 //permet d'afficher tous les éléments du tableau
 //cell est la valeur dans i et j : le nombre ou le signe à l'intérieur de la case
// println(cell);
 
//on ne peut pas utiliser == avec strings, il faut utiliser la fonction/méthode .equals et ne pas oublier les parenthèses après puisque c'est une fonction. 
 if(cell.equals("1")) {
   fill(0,0,255);
//on évite les contours afin que les carrés ne soient pas les uns sur les autres 
   noStroke();
   rect(j*40,i*40,40,40);
 }
 else if (cell.equals("")){
fill(255, 204, 51);
noStroke();
   ellipse(j*40+20,i*40+20,12,12);
   
 }
 else if (cell.equals("+")){
fill(255, 204, 51);
noStroke();
   ellipse(j*40+20,i*40+20,20,20);
 
}
}
 
}



}
class Pacman{
  
}

  
