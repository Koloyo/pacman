Pacman pacman;
Ghost Pinky;
Ghost Blinky;
Ghost Inky;
Ghost Clyde;
Table design;
Table scoretable;
boolean start;
int Ngum;
void setup(){
  size(920,880);
background(0);
pacman = new Pacman();
Blinky = new Ghost(0);
Pinky = new Ghost(1);
Inky = new Ghost (2);
Clyde = new Ghost (3);
design = loadTable("design.txt","csv");
scoretable = loadTable("score.csv","header");
int w= design.getRowCount()*40;
int h= design.getColumnCount()*40;
}

// on utilise le fichier .txt avec une option csv pour pouvoir utiliser les méthodes qui s'appliquent à une table.


void draw(){
  frameRate(6);
  background(0);


  int w= design.getRowCount()*40;
  int h= design.getColumnCount()*40;
  Ngum = 0;

// 'for' est une boucle qui s'arrête quand (i < nombre de lignes) n'est plus vraie, donc qu'il soit plus grand que le nombre de ligne
// à l'intérieur d'une boucle on a ( ce qui est au départ ; quand ça s'arrête ;  ce qui passe, soit on ajoute 1 à i jusqu'à ce qu'on dépasse le nb de lignes de design )
for (int i=0; i<design.getRowCount();i++){
  // on définit i comme 1 ligne de la table. 
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
   Ngum++;
 }
 else if (cell.equals("+")){
fill(255, 204, 51);
noStroke();
   ellipse(j*40+20,i*40+20,20,20);
   Ngum++;
 
}
}
 
}
//réinitialisation du jeu
if(Ngum == 0){
 start =false; 
 design = loadTable("design.txt","csv");

// Sauvegarder le score et la date dans un csv 
 int day = day();
 int month = month();
 int year = year();
 String date = String.valueOf(day) + "/" + String.valueOf(month) + "/" + String.valueOf(year);
 scoretable.addRow();
 scoretable.setInt(10, "score", pacman.score);
 scoretable.setString(10, "date", date);
 scoretable.sortReverse("score");
 scoretable.removeRow(10);
 saveTable(scoretable, "score.csv");
 
// Recommencer avec un nouveau pacman
 pacman = new Pacman();
 
 

 
 
}
fill(255);
textSize(20); //juste pour afficher le texte ça, taille du texte(20)
text("SCORE: "+ pacman.score, 60, 30); //position ou le texte est mis
//on move que quand cela start
  if (start){

  pacman.speed = 40;
  pacman.move();
  pacman.eatgum(design);
  check_wraps(design, pacman);

  if(frameCount%3 == 0){
    pacman.animation = 0;
  }
  else if(frameCount%3 == 1){
    pacman.animation = 1;
  }
  else{
    pacman.animation = 2;
  }
  pacman.display();
  Blinky.display();
  Pinky.display();
  Inky.display();
  Clyde.display();
  
  }
 else{
 // écran d'accueil
  background(0);
  textSize(40); //juste pour afficher le texte ça, taille du texte(20)
  text("PRESS SPACE BAR TO START", 160, 100);
  textSize(20); //juste pour afficher le texte ça, taille du texte(20)
  for(int rank = 1;rank <= 10;rank++){
     text("SCORE  "+rank+": "+scoretable.getInt(rank-1,"score")+"     Date: "+scoretable.getString(rank-1,"date"), 60, 40*rank+120); 



}

 }
 // indication de la directon qui pourrait être 0 1 2 ou 3, qui permettra de sélectionner la correcte partie de l'image originale en l'utilisant comme multiplicateur


  
  
}



class Pacman{
  int xpos;
  int ypos;
  int speed;
  int direction;
  int animation;
  PImage pacman;
  int ipos;
  int jpos;
  int score;
   
  
Pacman(){
  speed = 0;
  direction = 0;
  animation = 2;
  ipos = 12;
  jpos = 11;
  pacman = loadImage("pacman.png");
  score = 0;
}
 void display(){
   xpos = jpos*40;
   ypos = ipos*40;
  if(animation < 2){
  image(pacman.get(animation*40,direction*40,40,40), xpos, ypos);
  }
  else if(animation == 2){
    fill(255,255,0);
    ellipse(xpos + 20, ypos + 20, 30, 30);

   }
 }
void move(){
   xpos = jpos*40;
   ypos = ipos*40;
  if(direction == 0){ 
    if(check_wall(design, this, direction)){
    }
    else{
    xpos = xpos - speed;
    jpos = jpos-1;
    }
  }
  else if(direction == 1){
    if(check_wall(design, this, direction)){
    }
    else{
    xpos = xpos+speed;
    jpos = jpos+1;
    }
  }
  else if(direction == 2){
      if(check_wall(design, this, direction)){
    }
    else{
    ypos = ypos-speed;
    ipos = ipos-1;
    }
}
else if(direction == 3){
    if(check_wall(design, this, direction)){
    }
    else{
  ypos = ypos+speed;
  ipos = ipos+1;
    }
}
}

void eatgum(Table design){
  String eatgumcell = design.getString(ipos, jpos);
  if (eatgumcell.equals("")){
    design.setString(ipos, jpos, "-");
    score = score+10;
  }
  else if(eatgumcell.equals("+")){
     design.setString(ipos, jpos, "-");
      score = score+50;
  }
  
}
}

void keyPressed (){
  int tmp_dir;
  if (keyCode == 32){
   start = true;
  }
  if (keyCode == RIGHT){
   tmp_dir = 1;
    if(check_wall(design, pacman, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    } 
  }
  else if(keyCode == LEFT){
    tmp_dir = 0;
    if(check_wall(design, pacman, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  else if(keyCode == UP){
    tmp_dir = 2;
    if(check_wall(design, pacman, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  else if(keyCode == DOWN){
    tmp_dir = 3;
    if(check_wall(design, pacman, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  
}
boolean check_wall(Table design, Pacman pacman, int direction){
 int nextjpos = pacman.jpos;
 int nextipos = pacman.ipos;
  if (direction == 0){
    nextjpos = pacman.jpos - 1;
  }
  else if(direction == 1){
    nextjpos = pacman.jpos + 1;
  }
  else if(direction == 2){
    nextipos = pacman.ipos - 1;
  }
  else if(direction == 3){
   nextipos = pacman.ipos + 1;
  }
  
  String nextcell = design.getString(nextipos, nextjpos);
  //println(nextipos, nextjpos);
  if(nextcell.equals("1")){
  return true;
  }
  else{
    return false;
  }
}

void check_wraps(Table design, Pacman pacman){
  String wraps = design.getString(pacman.ipos, pacman.jpos);
  if(wraps.equals("2")){
   if(pacman.jpos == 0){
     pacman.jpos = design.getColumnCount()-1;
   }
   else if(pacman.jpos == design.getColumnCount()-1){
     pacman.jpos = 0;
   }
   
    
  }
}
  

class Ghost{
  int speed;
  int direction;
  int ipos;
  int jpos;
  int xpos;
  int ypos;
  int couleur;
  PImage ghost;
  
  
  Ghost(int c){
  speed = 0;
  direction = 0;
  ipos = 10;
  jpos = 10;
  ghost = loadImage("ghosts.png");
  couleur = c;
}
 void display(){
   xpos = jpos*40+couleur*40;
   ypos = ipos*40;
 
  image(ghost.get(direction*40, couleur*40,40,40), xpos, ypos);
  

   
 
}
void move(){
   xpos = jpos*40;
   ypos = ipos*40;
  if(direction == 0){ 
    if(check_wall(design, this, direction)){
    }
    else{
    xpos = xpos - speed;
    jpos = jpos-1;
    }
  }
  else if(direction == 1){
    if(check_wall(design, this, direction)){
    }
    else{
    xpos = xpos+speed;
    jpos = jpos+1;
    }
  }
  else if(direction == 2){
      if(check_wall(design, this, direction)){
    }
    else{
    ypos = ypos-speed;
    ipos = ipos-1;
    }
}
else if(direction == 3){
    if(check_wall(design, this, direction)){
    }
    else{
  ypos = ypos+speed;
  ipos = ipos+1;
    }
}
}
