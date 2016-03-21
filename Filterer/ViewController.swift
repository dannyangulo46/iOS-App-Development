//
//  ViewController.swift
//  Filterer
//
//  Created by Lloyd Angulo on 1/5/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var topImageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet var originalImageLabel: UILabel!
    
    
    var originalImageOnDisplay: Bool = true  {
        didSet {
            if originalImageOnDisplay == true {
                showOriginalImageLabel()
            } else {
                hideOriginalImageLabel()
            }
        }
    }
    
    
    
    var originalImage: UIImage?
    var tempImage: UIImage?
    var imageFiltered: ImageProcessor?
    
    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewDidLoad Finished")
        imageView.userInteractionEnabled = true
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        compareButton.enabled = false
        
        originalImage = topImageView.image
        imageFiltered = ImageProcessor(imageInput: topImageView.image!)
        
        originalImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        showOriginalImageLabel() //Test

    }

    
    
    
    // MARK: - Actions when buttons are pressed
    
    

    @IBAction func onNewPhoto(sender: UIButton) {
        
    let actionSheetVC = UIAlertController(title: "NewPhoto", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            actionSheetVC.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
                self.showCamera()
        
            }))
        }
        
        actionSheetVC.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
            
        }))
        
        actionSheetVC.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(actionSheetVC, animated: true, completion: nil)
        
        
    }
    
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
        
        
    }
    
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if topImageView.alpha == 1 {
                topImageView.image = image
            } else {
                imageView.image = image
            }
            originalImage = image
            tempImage = image
            originalImageOnDisplay = true
            if compareButton.selected {
                compareButton.selected = false
                filterButton.enabled = true
            }
                compareButton .enabled = false
            imageFiltered?.imageInRGBA = RGBAImage(image: originalImage!)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action when compare button is pressed or image is tapped
    
    
    @IBAction func onCompare(sender: UIButton) {
      
        if (sender.selected) {
            
            if topImageView.alpha == 1 {
                topImageView.image = tempImage!
            } else {
                imageView.image = tempImage!
            }
                
            sender.selected = false
            filterButton.enabled = true
            originalImageOnDisplay = false
        
        } else {
        
            if topImageView.alpha == 1 {
                tempImage = topImageView.image
                topImageView.image = originalImage
            } else {
                tempImage = imageView.image
                imageView.image = originalImage
            
            }
            
            sender.selected = true
            filterButton.enabled = false
            originalImageOnDisplay = true
            if filterButton.selected {
                hideSecondaryMenu()
                filterButton.selected = false
            }
        }
        
    }
    
    
    @IBAction func onImagePressAndRelease(sender: UILongPressGestureRecognizer) {
    
        
        if !compareButton.selected {
        
            if (sender.state == UIGestureRecognizerState.Began) {
                if topImageView.alpha == 1 {
                    tempImage = topImageView.image
                    topImageView.image = originalImage
                } else {
                    tempImage = imageView.image
                    imageView.image = originalImage
                }
                originalImageOnDisplay = true
                
            }
            
            if (sender.state == UIGestureRecognizerState.Ended) {
                if topImageView.alpha == 1 {
                    topImageView.image = tempImage
                    originalImageOnDisplay = false
                } else {
                    imageView.image = tempImage
                    originalImageOnDisplay = false
                }
                
            }
        }
        
    }
    
    
    // MARK: - Show Filters and apply filters when buttons are pressed
    
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    @IBAction func onRedFilter(sender: UIButton) {
        applyFilter("red")
    }
    
    @IBAction func onGreenFilter(sender: UIButton) {
        applyFilter("green")
    }
    
    @IBAction func onBlueFilter(sender: UIButton) {
        applyFilter("blue")
    }
    
    @IBAction func onGrayFilter(sender: UIButton) {
        applyFilter("gray")
    }
    
    @IBAction func onInvertFilter(sender: UIButton) {
        applyFilter("invert")
    }
    

 // MARK: Apply Filter Helper Function
    
    func applyFilter(color: String) {
        
        if topImageView.alpha == 1 {
            imageView.image = imageFiltered?.applyFilter(color)
            UIView.animateWithDuration(0.7){
                self.topImageView.alpha = 0
            }
        } else {
            topImageView.image = imageFiltered?.applyFilter(color)
            UIView.animateWithDuration(0.7) {
                self.topImageView.alpha = 1
                
            }
        }
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    
    
    @IBAction func onShare(sender: UIButton) {
        
        let imageDisplayed: UIImage?
        
        if topImageView.alpha == 1 {
            imageDisplayed = topImageView.image!
        } else {
            imageDisplayed = imageView.image!
        }
    
        
        let activityController = UIActivityViewController(activityItems: [imageDisplayed!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
 // MARK: Show or Hide Secondary Menu
    
    func showSecondaryMenu() {
        
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4){
            self.secondaryMenu.alpha = 1
        }
        
        
    }
    
    func hideSecondaryMenu() {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            })  { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        
        }
    
    
    }

    
    func showOriginalImageLabel() {
    
         view.addSubview(originalImageLabel)
//        
//        let widthScale: CGFloat =   imageView.frame.size.width / imageView.image!.size.width
//        let heightScale: CGFloat =  imageView.frame.size.height / imageView.image!.size.height
//        
//        let minScale: CGFloat = min(widthScale, heightScale)
//        
//        let verticalConstant: CGFloat = (imageView.image!.size.height) * minScale/2
//        
//        
//        print(verticalConstant)
//        print(heightScale)
//        print(imageView.image!.size.height*widthScale)
//        print(imageView.frame.size.width)
        
        //let topConstraint = originalImageLabel.topAnchor.constraintEqualToAnchor(imageView.topAnchor)
        let leftConstraint = originalImageLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = originalImageLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = originalImageLabel.heightAnchor.constraintEqualToConstant(44)
        
        let verticalPosition = NSLayoutConstraint(item: originalImageLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .CenterY, multiplier: 1, constant:0)
        
        NSLayoutConstraint.activateConstraints([rightConstraint, leftConstraint, heightConstraint, verticalPosition])

        view.layoutIfNeeded()
        
        
        
    }
    
    func hideOriginalImageLabel() {
        originalImageLabel.removeFromSuperview()
    }
    
    
}

