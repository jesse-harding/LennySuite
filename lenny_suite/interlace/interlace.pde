//USER INPUT VALS //<>//

boolean REVERSE = false;
String path = "data/large"; // select your source folder
float LPI = 20;
float observedLPI = 20;

//END USER INPUT VALS

import java.io.*;
import java.util.*;

float resizeRatio = LPI / observedLPI;
String inputFolderPath;
PImage img;
PImage interlaced;
ArrayList<String> cleanFilesList;

int frames;


void setup() {
  inputFolderPath = sketchPath("")+"/" + path + "/";
  File file = new File(inputFolderPath);
  File[] files = file.listFiles();
  println("# of files found in \"" + path + "\" folder: " + files.length);
  cleanFilesList = new ArrayList<String>();
  for (File f : files){ 
    if(!f.getName().contains("DS_Store")){
      String name = f.getName();
      String imgPath = path + "/" + name;
      cleanFilesList.add(imgPath);
      println(name + " added to cleanFilesList"); 
    }
  }
  println("total images loaded: " + cleanFilesList.size());
  frames = cleanFilesList.size();
  size(100,100);
  //noSmooth();


  
}

void draw() {
  
  img = loadImage(cleanFilesList.get(0));
  interlaced = createImage(img.width, img.height, RGB);
 
  interlaced.loadPixels();
  
  if(REVERSE){
    for (int i=frames-1; i >= 0; i--){  //pull pixels from each image
      println("Reverse mode: " + REVERSE + "   current frame: " + i);
      img = loadImage(cleanFilesList.get(i));
      img.loadPixels();
      for (int y = 0; y < img.height; y++){
        for (int x = frames-i; x < img.width; x = x + frames) {
              interlaced.pixels[x+(y*img.width)] = img.pixels[x+(y*img.width)];
            } 
      }
      interlaced.updatePixels(); 
    }
  } else {
    for (int i=0; i< frames; i++){  //pull pixels from each image
      println("Reverse mode: " + REVERSE + "   current frame: " + i);
      img = loadImage(cleanFilesList.get(i));
      img.loadPixels();
      for (int y = 0; y < img.height; y++){
        for (int x = i; x < img.width; x = x + frames) {
              interlaced.pixels[x+(y*img.width)] = img.pixels[x+(y*img.width)];
            } 
      }
      interlaced.updatePixels(); 
    }
  }
  image(interlaced,0,0, int(img.width*resizeRatio), int(img.height*resizeRatio));
  String exportPath;
  if(REVERSE){
    exportPath = sketchPath("") + "/interlaced_export/" + "interlaced_export-reverse.tif";
  } else {
    exportPath = sketchPath("") + "/interlaced_export/" + "interlaced_export.tif";
  }
  println("saved to " + exportPath);
  interlaced.save(exportPath);
  exit();
}