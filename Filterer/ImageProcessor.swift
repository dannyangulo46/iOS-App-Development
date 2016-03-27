//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Lloyd Angulo on 1/23/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit

class ImageProcessor {
    
    
    // properties of imageProcessor
    
    internal var imageInRGBA: RGBAImage?
    
    var totalRed = 0
    var totalGreen = 0
    var totalBlue = 0
    
    
    var avgRed: Int = 0
    var avgGreen: Int = 0
    var avgBlue: Int = 0
    var pixelsCount: Int = 0
    
    var priorIntensityValue = 0
    var incrementalIntensity = 0
    
    // initialization of class
    init(imageInput: UIImage){
        
        imageInRGBA = RGBAImage(image: imageInput)
        self.calculateRGBAverages()
        
    }
    
    
    
    // method that applies the filters at default intensity using String input (to every pixel of image)
    func applyFilter(filter: String, intensity: Int=3) -> UIImage{
  
        
        switch filter{
        case "red":
           
            iterateAndApplyFilter() {
                var pixel = $3
                let redDiff = Int (pixel.red) - self.avgRed
                if (redDiff>0) {
                    pixel.red = UInt8(max(0,min(255, self.avgRed+redDiff*intensity)))
                    self.imageInRGBA!.pixels[$2] = pixel
                }
                
            }
        
        case "green":
            
            iterateAndApplyFilter() {
                var pixel = $3
                let greenDiff = Int (pixel.green) - self.avgGreen
                if (greenDiff>0) {
                    pixel.green = UInt8(max(0,min(255, self.avgGreen+greenDiff*intensity)))
                    self.imageInRGBA!.pixels[$2] = pixel
                }
                
            }
   
            
         case "blue":
            
            iterateAndApplyFilter() {
                var pixel = $3
                let blueDiff = Int (pixel.blue) - self.avgBlue
                if (blueDiff>0) {
                    pixel.blue = UInt8(max(0,min(255, self.avgBlue+blueDiff*intensity)))
                    self.imageInRGBA!.pixels[$2] = pixel
                }
                
            }
            
            
            
        case "gray":
            
            
            iterateAndApplyFilter() {
                var pixel = $3
                let weightedAvgRed = Double(pixel.red) * 0.21
                let weightedAvgGreen = Double(pixel.green) * 0.72
                let weightedAvgBlue = Double(pixel.blue) * 0.07
                let avgValue = weightedAvgRed + weightedAvgGreen + weightedAvgBlue / 3
                pixel.red = UInt8(max(0,min(255,avgValue)))
                pixel.green = UInt8(max(0,min(255,avgValue)))
                pixel.blue = UInt8(max(0,min(255,avgValue)))
                self.imageInRGBA!.pixels[$2] = pixel
                
            }
        
            
        case "invert":
            iterateAndApplyFilter() {
                    var pixel = $3
                    let newRed = 255 - Int(pixel.red)
                    let newGreen = 255 - Int(pixel.green)
                    let newBlue = 255 - Int(pixel.blue)
                    pixel.red = UInt8(max(0,min(255,newRed)))
                    pixel.green = UInt8(max(0,min(255,newGreen)))
                    pixel.blue = UInt8(max(0,min(255,newBlue)))
                    self.imageInRGBA!.pixels[$2] = pixel
            }
            
        case "sepia":
            for y in 0..<imageInRGBA!.height{
                for x in 0..<imageInRGBA!.width{
                    let arrayIndex = y * imageInRGBA!.width + x
                    var selectedPixel = imageInRGBA!.pixels[arrayIndex]
                    let red = Double(selectedPixel.red)
                    let green = Double(selectedPixel.green)
                    let blue = Double(selectedPixel.blue)
                    let redAlgo = (red * 0.393) + (green * 0.769) + (blue * 0.189)
                    let greenAlgo = (red * 0.349) + (green * 0.686) + (blue * 0.168)
                    let blueAlgo = (red * 0.272) + (green * 0.534) + (blue * 0.131)
                    selectedPixel.red = UInt8(max(0,min(255,redAlgo)))
                    selectedPixel.green = UInt8(max(0,min(255,greenAlgo)))
                    selectedPixel.blue = UInt8(max(0,min(255,blueAlgo)))
                    imageInRGBA!.pixels[arrayIndex] = selectedPixel
                }
            }
        case "brighter":
            
            for y in 0..<imageInRGBA!.height{
                for x in 0..<imageInRGBA!.width{
                    let arrayIndex = y * imageInRGBA!.width + x
                    var selectedPixel = imageInRGBA!.pixels[arrayIndex]
                    let red = Int(selectedPixel.red)*2
                    let green = Int(selectedPixel.green)*2
                    let blue = Int(selectedPixel.blue)*2
                    selectedPixel.red = UInt8(max(0,min(255,red)))
                    selectedPixel.green = UInt8(max(0,min(255,green)))
                    selectedPixel.blue = UInt8(max(0,min(255,blue)))
                    imageInRGBA!.pixels[arrayIndex] = selectedPixel
                }
            }
        case "bright":
            
            incrementalIntensity = intensity - priorIntensityValue
            
            for y in 0..<imageInRGBA!.height{
                for x in 0..<imageInRGBA!.width{
                    let arrayIndex = y * imageInRGBA!.width + x
                    var selectedPixel = imageInRGBA!.pixels[arrayIndex]
                    let red = Int(selectedPixel.red) + incrementalIntensity
                    let green = Int(selectedPixel.green) + incrementalIntensity
                    let blue = Int(selectedPixel.blue) + incrementalIntensity
                    selectedPixel.red = UInt8(max(0,min(255,red)))
                    selectedPixel.green = UInt8(max(0,min(255,green)))
                    selectedPixel.blue = UInt8(max(0,min(255,blue)))
                    imageInRGBA!.pixels[arrayIndex] = selectedPixel
                }
            }
            priorIntensityValue = intensity
        default: print("ERROR: No filter selected. Could not apply filter.") ;break; // break the switch in case of error
        }
        return imageInRGBA!.toUIImage()!
    }
    
    // Helper functions
    
    func calculateRGBAverages() {
       
        for y in 0..<imageInRGBA!.height {
            for x in 0..<imageInRGBA!.width {
                let index = y * imageInRGBA!.width + x
                var pixel = imageInRGBA!.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        pixelsCount = imageInRGBA!.pixels.count
        
        avgRed = totalRed/pixelsCount
        avgGreen = totalGreen/pixelsCount
        avgBlue = totalBlue/pixelsCount

    }
    

    //Helper function to iterate thru each pixel
    
    func iterateAndApplyFilter( filter: (Int,Int, Int, Pixel) -> Void) {
        for y in 0..<imageInRGBA!.height {
            for x in 0..<imageInRGBA!.width {
                let index = y * imageInRGBA!.width + x
                let pixel = imageInRGBA!.pixels[index]
    
                filter(x,y, index, pixel)
    
            }
        }
        
        
    }
    
    
}
