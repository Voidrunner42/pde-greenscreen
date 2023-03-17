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

PImage backgroundImage1, backgroundImage2;
int numPixels;
Capture video;
int chromaKeyColor = color(0, 255, 0); // Change this to the desired chroma key color
int threshold = 20; // Change this to adjust the chroma key sensitivity
int boxSize = 100; // Size of the red box
int boxX = width - boxSize; // X position of the red box
int boxY = 0; // Y position of the red box
int pixelCount = 0; // Number of pixels that match the chroma key color
boolean isBackground1 = true; // Flag to determine which background to use

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start(); 
  numPixels = video.width * video.height;
  loadPixels();
  backgroundImage1 = loadImage("https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/ATV-1_Jules_Verne_approaches_ISS_%2825524892462%29.jpg/240px-ATV-1_Jules_Verne_approaches_ISS_%2825524892462%29.jpg");
  backgroundImage1.resize(video.width,video.height);
  backgroundImage2 = loadImage("https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Having_a_Solar_Blast_-_Flickr_-_NASA_Goddard_Photo_and_Video.jpg/240px-Having_a_Solar_Blast_-_Flickr_-_NASA_Goddard_Photo_and_Video.jpg");
  backgroundImage2.resize(video.width,video.height);
}

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    
    for (int i = 0; i < numPixels; i++) {
      color currColor = video.pixels[i];
      float currBrightness = brightness(currColor);
      float chromaKeyBrightness = brightness(chromaKeyColor);
      
      // Check if pixel is in the red box
      int x = i % video.width;
      int y = i / video.width;
      if (x >= boxX && x < boxX + boxSize && y >= boxY && y < boxY + boxSize) {
        if (currBrightness > chromaKeyBrightness - threshold && currBrightness < chromaKeyBrightness + threshold) {
          pixelCount++;
        }
      }
      
      if (currBrightness > chromaKeyBrightness - threshold && currBrightness < chromaKeyBrightness + threshold) {
        // Replace pixels that match the chroma key color with the corresponding/same pixels from the background image
        color bgPixel = isBackground1 ? backgroundImage1.pixels[i] : backgroundImage2.pixels[i];
        pixels[i] = bgPixel;
      } else {
        pixels[i] = currColor;
      }
    }
    
    // Check if more than 50% of the pixels in the box have changed
    if (pixelCount > boxSize * boxSize / 2) {
      isBackground1 = !isBackground1;
      pixelCount = 0;
    }
    
    updatePixels();
    
    // Draw the red box
    stroke(255, 0, 0);
    strokeWeight(5);
    noFill();
    rect(boxX, boxY, boxSize, boxSize);
  }
}