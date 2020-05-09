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
scoretable.setColumnType("score", Table.INT);
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
if(Ngum == 0 || pacman.eaten){
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
 Pinky = new Ghost(0);
 Blinky = new Ghost(1);
 Inky = new Ghost(2);
 Clyde = new Ghost(3);
 
}
fill(255);
textSize(20); //juste pour afficher le texte ça, taille du texte(20)
text("SCORE: "+ pacman.score, 60, 30); //position ou le texte est mis
//on move que quand cela start
if (start){

  pacman.move();

  pacman.checkghost(Blinky);
  pacman.checkghost(Pinky);
  pacman.checkghost(Inky);
  pacman.checkghost(Clyde);
  //println(pacman.score);
  
  Blinky.move();
  Pinky.move();
  Inky.move();
  Clyde.move();  
  
  pacman.checkghost(Blinky);
  pacman.checkghost(Pinky);
  pacman.checkghost(Inky);
  pacman.checkghost(Clyde);
  //println(pacman.score);
  
  pacman.eatgum(design);
  if(pacman.chrono > 0){
   pacman.chrono--; 
  }
  else if (pacman.chrono == 0){
   pacman.numberghosteaten = 0;
  }

  check_wraps(design, pacman);
  check_wraps_ghost(design, Blinky);
  check_wraps_ghost(design, Pinky);
  check_wraps_ghost(design, Inky);
  check_wraps_ghost(design, Clyde);
  
// le % sert à prendre le modulo
  if(frameCount%3 == 0){
    pacman.animation = 0;
  }
  else if(frameCount%3 == 1){
    pacman.animation = 1;
  }
  else{
    pacman.animation = 2;
  }
  if(!pacman.eaten){
  pacman.display();
  }
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
  int direction;
  int animation;
  PImage pacman;
  int ipos;
  int jpos;
  int score;
  int chrono;
  int numberghosteaten;
  boolean eaten;
   
  
Pacman(){
  direction = 0;
  animation = 2;
  ipos = 12;
  jpos = 11;
  pacman = loadImage("pacman.png");
  score = 0;
  chrono = 0;
  numberghosteaten = 0;
  eaten = false;
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
  if(direction == 0){ 
    if(check_wall(design, ipos, jpos, direction)){
    }
    else{
    jpos = jpos-1;
    }
  }
  else if(direction == 1){
    if(check_wall(design, ipos, jpos, direction)){
    }
    else{
    jpos = jpos+1;
    }
  }
  else if(direction == 2){
      if(check_wall(design, ipos, jpos, direction)){
    }
    else{
    ipos = ipos-1;
    }
}
else if(direction == 3){
    if(check_wall(design, ipos, jpos, direction)){
    }
    else{
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
   Pinky.weakghost = true;
   Blinky.weakghost = true;
   Inky.weakghost = true;
   Clyde.weakghost = true;
   chrono = 42;
  }
  
}
void checkghost(Ghost ghost){
 if (ipos == ghost.ipos && jpos == ghost.jpos){
  if (ghost.weakghost == false){
  eaten = true;
  }
  else{
    score = score + 200*(int(pow(2, numberghosteaten)));
    numberghosteaten++;
    ghost.weakghost = false;
    ghost.ipos = 10;
    ghost.jpos = 10+ghost.couleur;
  }
 }
}
}

void keyPressed (){
  // 0 : gauche, 1 : droite, 2 : haut, 3 : bas
  int tmp_dir;
  if (keyCode == 32){
   start = true;
  }
  if (keyCode == RIGHT){
   tmp_dir = 1;
    if(check_wall(design, pacman.ipos, pacman.jpos, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    } 
  }
  else if(keyCode == LEFT){
    tmp_dir = 0;
    if(check_wall(design, pacman.ipos, pacman.jpos, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  else if(keyCode == UP){
    tmp_dir = 2;
    if(check_wall(design, pacman.ipos, pacman.jpos, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  else if(keyCode == DOWN){
    tmp_dir = 3;
    if(check_wall(design, pacman.ipos, pacman.jpos, tmp_dir)){
    }
    else{
   pacman.direction = tmp_dir;
    }
  }
  
}
boolean check_wall(Table design, int ipos, int jpos, int direction){
  // 0 : gauche, 1 : droite, 2 : haut, 3 : bas
 int nextjpos = jpos;
 int nextipos = ipos;
  if (direction == 0){
    nextjpos = jpos - 1;
  }
  else if(direction == 1){
    nextjpos = jpos + 1;
  }
  else if(direction == 2){
    nextipos = ipos - 1;
  }
  else if(direction == 3){
   nextipos = ipos + 1;
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

void check_wraps_ghost(Table design, Ghost ghost){
  String wraps = design.getString(ghost.ipos, ghost.jpos);
  if(wraps.equals("2")){
   if(ghost.jpos == 0){
     ghost.jpos = design.getColumnCount()-2;
   }
   else if(ghost.jpos == design.getColumnCount()-1){
     ghost.jpos = 1;
   }
  }
}
  

class Ghost{
  int direction;
  int ipos;
  int jpos;
  int xpos;
  int ypos;
  int couleur;
  PImage ghost;
  PImage blueghost;
  boolean weakghost;
  IntList list_dir;
  int new_d;
  
  
  Ghost(int c){
  direction = 0;
  weakghost = false;
  ghost = loadImage("ghosts.png");
  blueghost = loadImage("dead-ghosts.png");
  couleur = c;
  ipos = 10;
  jpos = 10 + couleur;
}
 void display(){
   xpos = jpos*40;
   ypos = ipos*40;
   if(pacman.chrono == 0){
     weakghost = false;
   }
   if (weakghost == true){
     image(blueghost.get(direction*40,0,40,40), xpos, ypos);
   }
   else{
     
 
  image(ghost.get(direction*40, couleur*40,40,40), xpos, ypos);
   }
}
void move(){
  // 0 : haut, 1 : droite, 2 : bas, 3 : gauche
  IntList list_dir = get_list_dir(); 
  
  if(direction == 0){ 
    if(check_wall_ghost(design, ipos, jpos, direction)){
      go_new_dir(); 
    }
    else{
     if(list_dir.size() > 2) {
       go_new_dir(); 
     }
     else{
       if(weakghost){
         go_new_dir();
       }
       else{
       go_dir(direction);
       }
     }
    }
  }
  else if(direction == 1){
    if(check_wall_ghost(design, ipos, jpos, direction)){
         go_new_dir(); 
    }
    else{
     if(list_dir.size() > 2) {
       go_new_dir(); 
     }
     else{
       if(weakghost){
         go_new_dir();
       }
       else{
       go_dir(direction);
       }
     }
    }
  }
  else if(direction == 2){
      if(check_wall_ghost(design, ipos, jpos, direction)){
          go_new_dir();   
    }
    else{
     if(list_dir.size() > 2) {
       go_new_dir(); 
     }
     else{
       if(weakghost){
         go_new_dir();
       }
       else{
       go_dir(direction);
       }
     }
    }
}
else if(direction == 3){
    if(check_wall_ghost(design, ipos, jpos, direction)){
      go_new_dir();
    }
    else{
     if(list_dir.size() > 2) {
       go_new_dir(); 
     }
     else{
       if(weakghost){
         go_new_dir();
       }
       else{
       go_dir(direction);
       }
     }
    }
}
}
boolean check_wall_ghost(Table design, int ipos, int jpos, int direction){
  // 0 : haut, 1 : droite, 2 : bas, 3 : gauche
 int nextjpos = jpos;
 int nextipos = ipos;
  if (direction == 0){
    nextipos = ipos - 1;
  }
  else if(direction == 1){
    nextjpos = jpos + 1;
  }
  else if(direction == 2){
    nextipos = ipos + 1;
  }
  else if(direction == 3){
   nextjpos = jpos - 1;
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

IntList get_list_dir(){
 
 list_dir = new IntList();
 for (int i=0; i<4;i++){
   
  if (check_wall_ghost(design,ipos,jpos,i)){
     
     }
  else{
    //println(i);
    list_dir.append(i);
    }
   }
  //println(list_dir);
  return list_dir;
}

// logique des fantômes 
void go_new_dir(){
 if(couleur == 3 && weakghost == false){
  // clyde random 
  float index = random(list_dir.size());
  //println(list_dir.size());
  direction = list_dir.get(int(index));
  go_dir(direction);
  
 }
 else if(couleur == 1 && weakghost == false){
   // follow  pacman
  int new_d = go_close();
  if(!check_wall_ghost(design, ipos, jpos, new_d)){
    direction = new_d;
    go_dir(direction);
  }
 }
 else if((couleur == 0 || couleur == 2) && weakghost == false){
  float choice = random(1);
  if(choice <= 0.5){
    // follow pacman
  int new_d = go_close();
  if(!check_wall_ghost(design, ipos, jpos, new_d)){
    direction = new_d;
    go_dir(direction);
  }
  }
  else{
    // avoid pacman
  int new_d = go_far();
  if(!check_wall_ghost(design, ipos, jpos, new_d)){
    direction = new_d;
    go_dir(direction);  
  }
 }
 }
 else if(weakghost){
   // avoid pacman
  int new_d = go_far();
  if(!check_wall_ghost(design, ipos, jpos, new_d)){
    direction = new_d;
    go_dir(direction);
  }
 }
 
}
void go_dir(int d){
  // 0 : haut, 1 : droite, 2 : bas, 3 : gauche

  if(d == 0){
    if(weakghost){
      if(frameCount%2 == 0){
        ipos = ipos - 1;
      }
    }
    else{
      ipos = ipos - 1;
    }
  }
  else if(d == 1){
    if(weakghost){
      if(frameCount%2 == 0){
        jpos = jpos + 1;
      }
    }
    else{
      jpos = jpos + 1;
    }  }
  else if(d == 2){
    if(weakghost){
      if(frameCount%2 == 0){
        ipos = ipos + 1;
      }
    }
    else{
      ipos = ipos + 1;
    }  }
  else if(d == 3){
    if(weakghost){
      if(frameCount%2 == 0){
        jpos = jpos - 1;
      }
    }
    else{
      jpos = jpos - 1;
    }  }
  
 }
int go_far(){
  // 0 : haut, 1 : droite, 2 : bas, 3 : gauche
 if(ipos >= pacman.ipos && jpos >= pacman.jpos){
  if(!check_wall_ghost(design, ipos, jpos, 2)){
    // Pacman plus haut que fantome, fantome va en bas si pas de mur
    new_d = 2;
  }
  else if(check_wall_ghost(design, ipos, jpos, 1) == false){
    // Pacman à gauche du fantome, fantome va à droite si pas de mur
    new_d = 1;
  }
 }
 else if(ipos <= pacman.ipos && jpos <= pacman.jpos){
     if(!check_wall_ghost(design, ipos, jpos, 0)){
    // Pacman en bas du fantome, fantome va en haut si pas de mur
    new_d = 0;
    }
  else if(check_wall_ghost(design, ipos, jpos, 3) == false){
    // Pacman à droite du fantome, fantome va à gauche si pas de mur
    new_d = 3;
    }
 }
 else if(ipos >= pacman.ipos && jpos <= pacman.jpos){ 
   if(check_wall_ghost(design, ipos, jpos, 2) == false){
    // Pacman en haut du fantome, fantome va en bas si pas de mur
    new_d = 2;
    }
  else if(check_wall_ghost(design, ipos, jpos, 3) == false){
    // Pacman à droite du fantome, fantome va à gauche si pas de mur
    new_d = 3;
    }
 }
 else if(ipos <= pacman.ipos && jpos >= pacman.jpos){ 
   if(check_wall_ghost(design, ipos, jpos, 0) == false){
    // Pacman en bas du fantome, fantome va en haut si pas de mur
    println(direction);
    new_d = 0;
    println(new_d);
    }
  else if(check_wall_ghost(design, ipos, jpos, 1) == false){
    // Pacman à gauche du fantome, fantome va à droite si pas de mur
    new_d = 1;
    }
 }
 else new_d = list_dir.get(0);
 
 return new_d;
 }
int go_close(){
  // 0 : haut, 1 : droite, 2 : bas, 3 : gauche
 if(ipos >= pacman.ipos && jpos >= pacman.jpos){
  if(!check_wall_ghost(design, ipos, jpos, 0)){
    // Pacman plus haut que fantome, fantome va en haut si pas de mur
    new_d = 0;
  }
  else if(check_wall_ghost(design, ipos, jpos, 3) == false){
    // Pacman à gauche du fantome, fantome va à gauche si pas de mur
    new_d = 3;
  }
 }
 else if(ipos <= pacman.ipos && jpos <= pacman.jpos){
     if(!check_wall_ghost(design, ipos, jpos, 2)){
    // Pacman en bas du fantome, fantome va en bas si pas de mur
    new_d = 2;
    }
  else if(check_wall_ghost(design, ipos, jpos, 1) == false){
    // Pacman à droite du fantome, fantome va à droite si pas de mur
    new_d = 1;
    }
 }
 else if(ipos >= pacman.ipos && jpos <= pacman.jpos){ 
   if(check_wall_ghost(design, ipos, jpos, 0) == false){
    // Pacman en haut du fantome, fantome va en haut si pas de mur
    new_d = 0;
    }
  else if(check_wall_ghost(design, ipos, jpos, 1) == false){
    // Pacman à droite du fantome, fantome va à droite si pas de mur
    new_d = 1;
    }
 }
 else if(ipos <= pacman.ipos && jpos >= pacman.jpos){ 
   if(check_wall_ghost(design, ipos, jpos, 2) == false){
    // Pacman en bas du fantome, fantome va en bas si pas de mur
    println(direction);
    new_d = 2;
    println(new_d);
    }
  else if(check_wall_ghost(design, ipos, jpos, 3) == false){
    // Pacman à gauche du fantome, fantome va à gauche si pas de mur
    new_d = 3;
    }
 }
 else new_d = list_dir.get(0);
 
 return new_d;
 }

}
