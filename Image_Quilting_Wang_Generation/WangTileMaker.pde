class WangTileMaker {
  PImage sourceImage;
  int leftRightNum, topBottomNum;
  ArrayList<WangColorSample> colorSamplesLR;
  ArrayList<WangColorSample> colorSamplesTB;

  ArrayList<Triangle> noGoTriangles;
  ArrayList<String> colors;

  WangTileMaker(PImage _sourceImage) {
    sourceImage = _sourceImage;

    // This isn't necessary and slows things down but is here for
    // explanatory purposes. We can use colors as sides when debugging.

    colors = new ArrayList<String>();
    colors.add("blue");
    colors.add("red");
    colors.add("green");
    colors.add("brown");
    colors.add("purple");
    colors.add("yellow");
    colors.add("black");
    colors.add("puce");
    colors.add("orange");
    colors.add("magenta");
  }

  // See the paper in the data folder for an explanation of what is happening here.
  // In short, we'll create a tileset that we will use by placing the upper-left tile
  // first, and then filling across the top row (matching on the left), then moving
  // to the following row, matching on the top and left. In order to create a tileset
  // that displays stochastic tiling, we need to make sure there are multiple options
  // for each Left-Top matching, so that we can use a random number generator to pick
  // a tile each time we need to place one. 

  // We assign 'colors' to the tiles sides and determine how many colors we will use
  // for the top-bottom and left-right. For each unique combination of left-top colors,
  // we want at least two different bottom-right combinations. For a minimal stochastic set, we
  // should have two tiles for each left-top color combination.

  // The original paper suggests that we take diamond shaped samples from the original image.
  // However, our image quilting algorithm, which we have to use again to stitch together the
  // samples, works with square samples. Because of this, we'll do the following:
  // 1. Rotate the sourceImage by 45 degrees.
  // 2. Take square samples and give them color codes.
  // 3. Quilt together the square samples.
  // 4. Rotate the resulting image back 45 degrees to a diamond
  // 5. Take a square sample from the middle of the diamond: a Wang tile.
  // 6. Repeat this process for each Wang tile we need.

  // Avoid going over 3 for each of these parameters
  void makeWangTileSet(int _numTopBottomColors, int _numLeftRightColors) {
    println("Making Want tile set with " + _numTopBottomColors + " on the top and bottom and " + _numLeftRightColors + " on the left and right.");
    leftRightNum = _numLeftRightColors;
    topBottomNum = _numTopBottomColors;

    displayRotatedSource();
    createNoGoTriangles();
    makeWangColorSamples();
    showWangColorSamples();
  }

  void displayRotatedSource() {
    background(0);
    pushMatrix();
    translate(width/2, -height*sqrt(2)*(1/8.0));
    rotate(PI/4.0);
    image(sourceImage, 0, 0);
    popMatrix();
  }

  void createNoGoTriangles() {
    noGoTriangles = new ArrayList<Triangle>();

    Triangle t1 = new Triangle(0, 0, width*(1/3.0), 0, 0, height*(1/3.0));
    noGoTriangles.add(t1);

    Triangle t2 = new Triangle(width*(2/3.0), 0, width, 0, width, height*(1/3.0));
    noGoTriangles.add(t2);

    Triangle t3 = new Triangle(width, height*(2/3.0), width, height, width*(2/3.0), height);
    noGoTriangles.add(t3);

    Triangle t4 = new Triangle(0, height*(2/3.0), width*(1/3.0), height, 0, height);
    noGoTriangles.add(t4);

    t1.display();
    t2.display();
    t3.display();
    t4.display();
  }

  void makeWangColorSamples() {
    colorSamplesLR = new ArrayList<WangColorSample>();
    colorSamplesTB = new ArrayList<WangColorSample>();

    for (int i = 0; i < leftRightNum; i++) {
      WangColorSample wcs = null;
      boolean goodSample = false;

      while (!goodSample) {
        PVector p;
        int randX  = (int)random(width -  (int)(wangTileDimension*1.5));
        int randY  = (int)random(height - (int)(wangTileDimension*1.5));
        p          = new PVector(randX, randY);
        wcs        = new WangColorSample(p, (int)(wangTileDimension*1.5), colors.get(i));
        goodSample = wcs.allowed(noGoTriangles);
      }

      // Sample is good, so let's save it as a PImage
      wcs.createSample();

      colorSamplesLR.add(wcs);
      println("LeftRight: " + wcs.colorname);
    }

    for (int i = leftRightNum; i < (leftRightNum + topBottomNum); i++) {
      WangColorSample wcs = null;
      boolean goodSample  = false;

      while (!goodSample) {
        PVector p;
        int randX  = (int)random(width -  (int)(wangTileDimension*1.5));
        int randY  = (int)random(height - (int)(wangTileDimension*1.5));
        p          = new PVector(randX, randY);
        wcs        = new WangColorSample(p, (int)(wangTileDimension*1.5), colors.get(i));
        goodSample = wcs.allowed(noGoTriangles);
      }

      // Sample is good, so let's save it as a PImage
      wcs.createSample();

      colorSamplesTB.add(wcs);
      println("TopBottom: " + wcs.colorname);
    }
  }

  // Just for explanatory purposes
  void showWangColorSamples() {
    background(0);

    int yPos = wangTileDimension;
    
    fill(255);
    textSize(20);
    text("Left / Right 'Color' Samples",2 * wangTileDimension + 10,yPos - 20);
    
    for (int i = 0; i < colorSamplesLR.size(); i++) {
      int xPos = (i+1) * 2 * wangTileDimension + 10; 
      WangColorSample wcs = colorSamplesLR.get(i); 
      image(wcs.imageSample.sample, xPos, yPos);
      text(wcs.colorname, xPos, yPos + (wangTileDimension * 2) + 5);
    }

    yPos = wangTileDimension * 5; 
    
    text("Top / Bottom 'Color' Samples",2 * wangTileDimension + 10,yPos - 20);
    
    for (int i = 0; i < colorSamplesTB.size(); i++) {
      int xPos = (i+1) * 2 * wangTileDimension + 10; 
      WangColorSample wcs = colorSamplesTB.get(i); 
      image(wcs.imageSample.sample, xPos, yPos);
      text(wcs.colorname, xPos, yPos + (wangTileDimension * 2) + 5);
    }
  }
}

