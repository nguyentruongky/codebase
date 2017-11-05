//
//  ImageSelector.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 2/28/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


protocol knPhotoSelectorDelegate: class {
    
    func present(_ controller: UIViewController)
    
    func didSelect(_ image: UIImage)
    
}

class knPhotoSelector : NSObject {

    var delegate: knPhotoSelectorDelegate?

    func showSelection() {
        
        let pickPhoto = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.pickImageFromPhotoLibrary()
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.takePhoto()
        }
        
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(takePhoto)
        menu.addAction(pickPhoto)
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        delegate?.present(menu)
    }
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}


extension knPhotoSelector: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        var pickedImage : UIImage
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
        }
        else {
            pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        delegate?.didSelect(pickedImage)
    }
    
    func takePhoto() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        delegate?.present(imagePicker)
    }
    
    func pickImageFromPhotoLibrary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        delegate?.present(imagePicker)
    }
    
}




class knPhotoSelectorWorker : knWorker {
    
    var successResponse : ((UIImage) -> Void)? = nil
    var selectedImage : UIImage?
    var picker: knPhotoSelector?
    
    init(finishSelection: ((UIImage) -> Void)?) {
        successResponse = finishSelection
    }
    
    func execute() {
        picker = knPhotoSelector()
        picker?.delegate = self
        picker?.showSelection()
    }
    
}

extension knPhotoSelectorWorker : knPhotoSelectorDelegate {
    
    func present(_ controller: UIViewController) {
        
        let topController = UIApplication.topViewController()
        topController?.present(controller, animated: true, completion: nil)
    }
    
    func didSelect(_ image: UIImage) {
        
        selectedImage = image
        successResponse?(image)
        picker = nil
    }
}


