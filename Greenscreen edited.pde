/*
    Copyright (C) 2015-2023 - All Rights Reserved

    Content written by:
    - Discord: Voidrunner#3600
    - E-Mail: Voidrunner42@gmail.com


    Unauthorized copying of this file using any medium is strictly prohibited.
    The content of this file is strictly proprietary and confidential.

    Distribution if this file or it's content will therefore be an unlawful act,
    and legal actions may be taken as a result.
*/


import processing.video.*;

PImage backgroundImage;
int numPixels;
Capture video;
int chromaKeyColor = color(0, 255, 0); // Change this to the desired chroma key color
int threshold = 20; // Change this to adjust the chroma key sensitivity

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start(); 
  numPixels = video.width * video.height;
  loadPixels();
  backgroundImage = loadImage("https://upload.wikimedia.org/wikipedia/commons/5/5a/Grand_Canyon.jpg"); // url of image
  backgroundImage.resize(video.width,video.height);
}

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    
    for (int i = 0; i < numPixels; i++) {
      color currColor = video.pixels[i];
      float currBrightness = brightness(currColor);
      float chromaKeyBrightness = brightness(chromaKeyColor);
      
      if (currBrightness > chromaKeyBrightness - threshold && currBrightness < chromaKeyBrightness + threshold) {
        // Replace pixels that match the chroma key color with the corresponding pixels from the background image
        color bgPixel = backgroundImage.pixels[i];
        pixels[i] = bgPixel;
      } else {
        pixels[i] = currColor;
      }
    }
    
    updatePixels();
  }
}
