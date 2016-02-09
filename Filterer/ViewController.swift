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
        
        originalImage = imageView.image
        imageFiltered = ImageProcessor(imageInput: imageView.image!)
        
        originalImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        showOriginalImageLabel() //Test

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            imageView.image = image
            originalImage = image
            tempImage = image
            if compareButton.selected {
                compareButton.selected = false
                compareButton .enabled = false
                filterButton.enabled = true
            }
            imageFiltered?.imageInRGBA = RGBAImage(image: originalImage!)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action when compare button is pressed or image is tapped
    
    
    @IBAction func onCompare(sender: UIButton) {
      
        if (sender.selected) {
        
            imageView.image = tempImage!
            sender.selected = false
            filterButton.enabled = true
            originalImageOnDisplay = false
        } else {
            tempImage = imageView.image
            imageView.image = originalImage
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
    
        if (sender.state == UIGestureRecognizerState.Began) {
            tempImage = imageView.image
           imageView.image = originalImage
     
        
        }
    
        if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.image = tempImage
          
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
        
        imageView.image = imageFiltered?.applyFilter("red")
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    @IBAction func onGreenFilter(sender: UIButton) {
        
         imageView.image = imageFiltered?.applyFilter("green")
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    @IBAction func onBlueFilter(sender: UIButton) {
        
         imageView.image = imageFiltered?.applyFilter("blue")
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    @IBAction func onGrayFilter(sender: UIButton) {
        
        imageView.image = imageFiltered?.applyFilter("gray")
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    @IBAction func onInvertFilter(sender: UIButton) {
        
        imageView.image = imageFiltered?.applyFilter("invert")
        compareButton.enabled = true
        originalImageOnDisplay = false
    }
    
    
    
    @IBAction func onShare(sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    
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
        
        let widthScale: CGFloat =   imageView.frame.size.width / imageView.image!.size.width
        let heightScale: CGFloat =  imageView.frame.size.height / imageView.image!.size.height
        
        let minScale: CGFloat = min(widthScale, heightScale)
        
        let verticalConstant: CGFloat = (imageView.image!.size.height) * minScale/2
        
        
        print(verticalConstant)
        print(heightScale)
        print(imageView.image!.size.height*widthScale)
        print(imageView.frame.size.width)
        
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

