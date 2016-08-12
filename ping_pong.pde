import processing.sound.*;

boolean keyUp1 = false;
boolean keyDown1 = false;
boolean keyUp2 = false;
boolean keyDown2 = false;

int score1 = 0;
int score2 = 0;
int balls = 5;

float y1 = 100;
float y2 = 100;
float speed1 = 0;
float speed2 = 0;

float ballX = 0;
float ballY = 0;
float speedX = 0;
float speedY = 0;

PFont scoreFont;
PFont bigFont;
SoundFile ballBounceSound;
SoundFile whistleSound;

boolean showText = true;
int frames = 0;
String state;

void setup() {
  size(1024, 768);
  frameRate(60);

  ballX = width/2;
  ballY = height/2;
  speedX = 10;
  speedY = 5;

  //String[] fontList = PFont.list();
  //printArray(fontList);
  scoreFont = createFont("Famirids", 32);
  bigFont = createFont("Famirids", 90);

  ballBounceSound = new SoundFile(this, "ball-bounce.wav");
  whistleSound = new SoundFile(this, "referee-whistle.wav");

  state = "READY";

  smooth();
}

void draw() {
  background(45, 106, 45);
  noFill();
  stroke(255, 255, 255);
  rect(10, 60, width-20, height-70);
  patternLine(width/2, 60, width/2, height-10, 0x5555, 8);

  textFont(scoreFont);
  textAlign(LEFT, TOP);
  text("Score "+score1, 10, 5);
  textAlign(RIGHT, TOP);
  text("Score "+score2, width-10, 5);
  textAlign(CENTER, TOP); 
  text("BALLS "+balls, width/2, 5);

  fill(255, 255, 255);
  rect(20, y1, 30, 100);
  rect(width-50, y2, 30, 100);

  if (frameCount % 30 == 0) {
    showText = !showText;
  }

  /*
  // AUTO PLAYER 2 
  if (ballY<y2) {
   speed2 = -5;
   } else if (ballY>y2+100) {
   speed2 = +5;
   } else {
   speed2 = 0;
   }
   */

  speed1 = 0;
  speed2 = 0;
  if (keyUp1) {
    speed1 = speed1-10;
  }
  if (keyDown1) {
    speed1 = speed1+10;
  }
  if (keyUp2) {
    speed2 = speed2-10;
  }
  if (keyDown2) {
    speed2 = speed2+10;
  }
  
  y1 = y1 + speed1;
  y2 = y2 + speed2;

  if (y1<60) { 
    y1 = 60;
  }
  if (y1>height-110) {
    y1 = height-110;
  }
  if (y2<60) {
    y2 = 60;
  }
  if (y2>height-110) {
    y2 = height-110;
  }

  switch(state) {
  case "READY":
    if (showText) {
      textFont(bigFont);
      textAlign(CENTER, CENTER); 
      text("READY", width/2, height/2+75);    
      textFont(scoreFont);
      if (keyPressed) {
        state="3";
        frames=0;
      }
    }
    return;    
  case "3":    
    frames++;
    textFont(bigFont);
    textAlign(CENTER, CENTER); 
    text("3", width/2, height/2+75);
    textFont(scoreFont);
    if (frames==60) {
      frames=0;
      state="2";
    }
    return;
  case "2":
    frames++;
    textFont(bigFont);
    textAlign(CENTER, CENTER); 
    text("2", width/2, height/2+75);
    textFont(scoreFont);
    if (frames==60) {
      frames=0;
      state="1";
    }
    return;
  case "1":
    frames++;
    textFont(bigFont);
    textAlign(CENTER, CENTER); 
    text("1", width/2, height/2+75);
    textFont(scoreFont);
    if (frames==60) {
      frames=0;
      state="GAME";
    }
    return;
  case "GAME":
    break;
  case "END":
    int winner;
    textFont(bigFont);
    textAlign(CENTER, CENTER); 
    if (score1>score2) {
      winner = 1;
    } else {
      winner = 2;
    }      
    text(""+score1+" : "+score2+"\nPLAYER "+winner+" WINS!", width/2, height/2+75);    
    textFont(scoreFont);
    if (keyPressed) {
      state="READY";
    }
    return;
  }

  ellipse(ballX, ballY, 40, 40);

  ballX = ballX + speedX;
  ballY = ballY + speedY;

  if (ballX<=70 && (ballY>=y1-10 && ballY<=y1+100+10)) {
    ballX = 70;
    speedX = -speedX;
    score1 = score1+1;
    ballBounceSound.play();
  }
  if (ballX>=width-70 && (ballY>=y2-10 && ballY<=y2+100+10)) {
    ballX = width-70;
    speedX = -speedX;
    score2 = score2+1;
    ballBounceSound.play();
  }

  if (ballX<30) {
    //ballX = 30;
    speedX = -speedX;
    score2 = score2 + 100;
    ballX = width/2;
    ballY = height/2;    
    whistleSound.play();
    balls = balls-1;
    state = "3";
  }

  if (ballX>width-30) {
    //ballX = width-30;
    speedX = -speedX;
    score1 = score1 + 100;
    ballX = width/2;
    ballY = height/2;
    whistleSound.play();
    balls = balls-1;
    state = "3";
  }

  if (balls==0) {
    balls=5;
    state = "END";
  }

  if (ballY<90) {
    ballY = 90;
    speedY = -speedY;
    ballBounceSound.play();
  }
  if (ballY > height-30) {
    ballY = height-30;
    speedY = -speedY;
    ballBounceSound.play();
  }
}

void keyPressed() {
  if (key=='q') {
    keyUp1 = true;
  }
  if (key=='a') {
    keyDown1 = true;
  }
  if (key=='p') {
    keyUp2 = true;
  }
  if (key=='ñ') {
    keyDown2 = true;
  }
}

void keyReleased() {
  if (key=='q') {
    keyUp1 = false;
  }
  if (key=='a') {
    keyDown1 = false;
  }
  if (key=='p') {
    keyUp2 = false;
  }
  if (key=='ñ') {
    keyDown2 = false;
  }
}

//based on Bresenham's algorithm from wikipedia
//http://en.wikipedia.org/wiki/Bresenham's_line_algorithm
void patternLine(int xStart, int yStart, int xEnd, int yEnd, int linePattern, int lineScale) {
  int temp, yStep, x, y;
  int pattern = linePattern;
  int carry;
  int count = lineScale;

  boolean steep = (abs(yEnd - yStart) > abs(xEnd - xStart));
  if (steep == true) {
    temp = xStart;
    xStart = yStart;
    yStart = temp;
    temp = xEnd;
    xEnd = yEnd;
    yEnd = temp;
  }    
  if (xStart > xEnd) {
    temp = xStart;
    xStart = xEnd;
    xEnd = temp;
    temp = yStart;
    yStart = yEnd;
    yEnd = temp;
  }
  int deltaX = xEnd - xStart;
  int deltaY = abs(yEnd - yStart);
  int error = - (deltaX + 1) / 2;

  y = yStart;
  if (yStart < yEnd) {
    yStep = 1;
  } else {
    yStep = -1;
  }
  for (x = xStart; x <= xEnd; x++) {
    if ((pattern & 1) == 1) {
      if (steep == true) {
        point(y, x);
      } else {
        point(x, y);
      }
      carry = 0x8000;
    } else {
      carry = 0;
    }  
    count--;
    if (count <= 0) {
      pattern = (pattern >> 1) + carry;
      count = lineScale;
    }

    error += deltaY;
    if (error >= 0) {
      y += yStep;
      error -= deltaX;
    }
  }
}