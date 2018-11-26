import java.io.*; 
import java.util.*; 
/*----------------------
ImgStack 

Stores all images within a folder as an array of PImages. 
Default folder is "data". 
Contains screen-res array for preview rendering and original-resolution
images for printing. 
----------------------*/
public class ImgStack {
	int totalImgs; 
	int width; //width of SMALL images
	int height; //height of SMALL images
	int fullWidth; //width of ORIGINAL images
	int fullHeight; //height of ORIGINAL images
	float scale;

	ArrayList<PImage> smallImgs; 
	ArrayList<PImage> fullResImgs; 
	String inputFolderPath = "";

	ImgStack(){
		//DANGER FIX THIS
		inputFolderPath = sketchPath("") + "/data/";
		loadImages(inputFolderPath);
		renderSmallImgs();
	}

	ImgStack(String path){
		inputFolderPath = sketchPath("") + "/" + path + "/"; 
		//this();
		loadImages(inputFolderPath);
		renderSmallImgs();
	}


	public PImage get(int i){
		if(i < totalImgs){
			return smallImgs.get(i);
		} else {
			// println("Index " + i + " is outside of image array bounds.");
			// return createImage(1,1, RGB);
			throw new ArrayIndexOutOfBoundsException("Index " + i + " is outside of image array bounds.");
		}
		
	}

	public PImage getBig(int i){
		if(i < totalImgs){
			return fullResImgs.get(i);
		} else {
			println("Index " + i + " is outside of image array bounds.");
			return createImage(1,1, RGB);
		}
	}

	public PImage[] get(int... imgIndices){
		PImage[] imgArray = new PImage[imgIndices.length];
		for(int i = 0; i < imgIndices.length; i++){
			imgArray[i] = this.get(imgIndices[i]);
		}
		return imgArray; 
	}

	public PImage[] getBig(int... imgIndices){
		PImage[] imgArray = new PImage[imgIndices.length];
		for(int i = 0; i < imgIndices.length; i++){
			imgArray[i] = fullResImgs.get(imgIndices[i]);
		}
		return imgArray; 
	}

	private void loadImages(String path){
		
		File file = new File(path);
		File[] files = file.listFiles();

		println("# of files found in \"" + path + "\" folder: " + files.length);

		//Sort files according to alphaNum
		//---------------------------------
		//By default, Java.io lists files by ASCII value. Eg:
		// - slice1.jpg
		// - slice10.jpg
		// - slice11.jpg
		// - slice12.jpg
		// - slice13.jpg
		// - ... 
		//Using alphanum sort will return user's intended file ordering
		// - slice1.jpg
		// - slice2.jpg
		// - slice3.jpg 
		// - ...
		//---------------------------------
		ArrayList<String> fileNamesList = new ArrayList<String>();
		for(File f : files){
			fileNamesList.add(f.getName());
		}
		Collections.sort(fileNamesList);
		for(String n : fileNamesList){
			println(n);
		}


		//Load PImages arrayList
		fullResImgs = new ArrayList<PImage>();
		for (File f : files){
			if(!f.getName().contains("DS_Store")){
				PImage img = loadImage( path + "/" + f.getName());
				fullResImgs.add(img);
				println(f.getName());
				}
		}
		totalImgs = fullResImgs.size(); 

		this.fullWidth = fullResImgs.get(0).width;
		this.fullHeight = fullResImgs.get(0).height;
		println("Images successfully loaded: " + fullResImgs.size());
	}


	private void renderSmallImgs(){
		smallImgs = new ArrayList<PImage>();
		for(PImage img : fullResImgs){
			PImage resizedImg = img.copy(); 
			resizedImg.resize(0, displayHeight);
			smallImgs.add(resizedImg);
		}
		this.width = smallImgs.get(0).width;
		this.height = smallImgs.get(0).height;
		this.scale = this.fullHeight * 1.0 / this.height;
		println("Low res previews successfully generated. ");
	}
}

//PARALLAX HELPER CLASSES
//---------------------------------

//Returns an int[] of the array indices of staged images
int skip;
int photoadj;
int[] getStagedImages(int totalImages, int totalFrames){
  //Assumes max variance between frames is desired. 
  //So first frame should be 0-th image, last frame n-th image of n-size array
  //then (totalFrames - 2) images will be picked from the remaining images in the array

  if(totalFrames > 1 && totalFrames <= totalImages){ 
    int[] stagedImgs = new int[totalFrames]; 
    if(sequential == 0){
      skip = ((totalImages-totalFrames)/(totalFrames-1))+1; //Rounded-down number of images to skip
      offset = -1;
  }
    else{
      skip = 1;
    }
    if (offset == 1){
      photoadj = totalImages-totalFrames;
    }
    else if (offset == 0){
      photoadj = (totalImages-totalFrames)/2;
    }
    else{
      photoadj = 0;
    }
    for(int i = 0; i < totalFrames; i++){
      stagedImgs[i] = i * skip + photoadj; 
    }
    println("Staged images: ");
    for(int x : stagedImgs){
      print(x + ", ");
    }
    return stagedImgs;

  } else {
    throw new ArrayIndexOutOfBoundsException( "Unable to render " + totalFrames + " frames from image array of size " + totalImages);
  }
}