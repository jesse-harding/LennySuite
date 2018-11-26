//USER INPUT VARS
int LPI = 20; //enter the advertised pitch of your lenticular sheet
int DPI = 600; //enter your printer/display DPI/PPI
               //if doing scanimation or barrier grid, make your life easier and make DPI divisible by LPI
float xDim = 10; //enter horizontal document size in inches (keep print margins in mind)
float yDim = 7.5; //enter vertical document size in inches (keep print margins in mind)
float pitchVariance = 0.1; //enter variance in printed test pitches
int varianceCount = 10; //enter number of alternative pitches to be generated
String path = savePath("data/exports/test.tif"); //export filename & location
int type = 0; //0 for pitch test
              //1 for scanimation & barrier grid
int resampleScanimation = 0; //0 for no
                             //1 for yes
                             //see line 55 for barrier grid
                             
//END USER INPUT VALS

//AFTER EXPORT, RESIZE IMAGE TO PROPER DPI OUTSIDE OF PROCESSING (PHOTOSHOP ETC.)
//AFTER EXPORT, RESIZE IMAGE TO PROPER DPI OUTSIDE OF PROCESSING (PHOTOSHOP ETC.)
//AFTER EXPORT, RESIZE IMAGE TO PROPER DPI OUTSIDE OF PROCESSING (PHOTOSHOP ETC.)
//AFTER EXPORT, RESIZE IMAGE TO PROPER DPI OUTSIDE OF PROCESSING (PHOTOSHOP ETC.)

//generated variables
int docWidth = int(DPI * xDim);
int docHeight = int(DPI * yDim);
int DPL = DPI/LPI;
float floatDPL = float(DPI)/float(LPI);
float resampleWidth;
float varianceStep = pitchVariance / varianceCount;
int gapHeight = DPI/8; //divided by 8 to make a 1/8" gap between strips
int stripHeight = (docHeight - gapHeight*(varianceCount-1)) / varianceCount;
int totalHeight = gapHeight + stripHeight;

int counter = 0;
float testLPI;

PGraphics exportDoc;
PGraphics strip;
PFont myFont;

void setup() {
  noLoop();
  size(displayWidth, displayHeight);
  if (type == 1){
    varianceCount = 1;
    pitchVariance = 0;
    stripHeight = docHeight;
  }
  exportDoc = createGraphics(docWidth, docHeight);
  strip = createGraphics(docWidth, stripHeight);
  myFont = createFont("Verdana-24",50);
}

void draw() {
  strip.beginDraw();
  strip.background(0);
  strip.stroke(255);
  for (int i=0; i<docWidth; i=i+DPL)
  {
    if (type == 0){
  for (int e=0; e < DPL/2; e++){ //change DPL/2 to an integer for barrier grid and select the scanimation option
  strip.line(i+e, 0, i+e, stripHeight);
  }
    }
      else{
  strip.line(i, 0, i, stripHeight);
  
    }
  }

  strip.endDraw();

  exportDoc.beginDraw();
  exportDoc.background(255);
if (type == 0){

   for (int i = 0; i < varianceCount; i++){
      resampleWidth=docWidth * (1-(pitchVariance/2)+(varianceStep*i));
      exportDoc.image(strip, 90, i*totalHeight, resampleWidth, stripHeight);
      testLPI = float(LPI) * (1-(pitchVariance/2)+(varianceStep*i));
      exportDoc.fill(0,0,0);
      exportDoc.textSize(20);
      exportDoc.text(testLPI, 0, (i*totalHeight) + stripHeight/2); 
   }

}
else{
  if (resampleScanimation == 1){
        resampleWidth = float(docWidth) * float(DPL) / floatDPL;
        exportDoc.image(strip, 0, 0, int(resampleWidth), stripHeight);
  }
  else{
    exportDoc.image(strip, 0, 0, docWidth, stripHeight);
  }
}
    exportDoc.endDraw();
      exportDoc.save(path);
 println("saved to " + path);

  exit();
}