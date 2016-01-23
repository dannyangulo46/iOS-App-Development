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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onNewPhoto(sender: UIButton) {
        
    let actionSheetVC = UIAlertController(title: "NewPhoto", message: nil, preferredStyle: .ActionSheet)
        
        actionSheetVC.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        
        }))
        
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
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func onFilter(sender: UIButton) {
        
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
            
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
        
        
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

    
    
}

