class Drop
{
int dropBaseSize=1;
int dropSizeFix=7;
float dropAlphaFix=5;
int dropCount=0;
float loopCount=255/dropAlphaFix;
int dropColor;
int dropX,dropY;

Drop(int initColor){
  dropX=mouseX;
  dropY=mouseY;
  dropColor = initColor;
}

public boolean make(){
  int i;
  if(frameCount%2==1){
  dropCount++;
  }
  if(dropCount>loopCount){
    return true;
  }
  noStroke();
  
  int dropSize=dropBaseSize+dropSizeFix*dropCount;
  float dropAlpha=255-dropAlphaFix*dropCount;
  noFill();
  stroke(dropColor,dropAlpha);
  ellipse(dropX,dropY,dropSize,dropSize);
  
  return false;
}

}