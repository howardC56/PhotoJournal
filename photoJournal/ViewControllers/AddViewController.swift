//
//  ViewController.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    let addView = AddView()
    private var mediaData: Data?
    //private var imagePickerController = UIImagePickerController()
    
    override func loadView() {
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = save
        navigationItem.title = "Create"
        navigationItem.leftBarButtonItem = customBackButton
        self.navigationController?.navigationBar.isHidden = false
        addView.imagePickerController.delegate = self
        addView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        addView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    lazy private var customBackButton: UIBarButtonItem = {
    [unowned self] in
        return UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
    }()
    
    lazy private var save: UIBarButtonItem = {
        [unowned self] in
        return UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(saveItem(_:)))
        }()
    
    @objc func saveItem(_ sender: UIBarButtonItem) {
        guard let titleText = addView.titleLabel.text, !titleText.isEmpty, let descriptionText = addView.descriptionText.text, !descriptionText.isEmpty, mediaData != nil, let safeMediaData = mediaData else {
            showAlert(title: "Fill Missing Fields", message: "Fill All Fields")
            return
        }
        let photoObject = PhotoObject(imageData: safeMediaData, description: descriptionText, date: Date(), title: titleText)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        switch mediaType {
               case "public.image":
                   if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                    addView.imageView.image = originalImage
                    mediaData = imageData
                   }
                   
               case  "public.movie":
                   if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                       let image = mediaURL.videoPreviewThumbnail(), let imageData = image.jpegData(compressionQuality: 1.0) {
                    addView.imageView.image = image
                    mediaData = imageData
                   }
               default:
                   print("unsupported media type")
               }
               picker.dismiss(animated: true)
    }
}

extension AddViewController: AddViewDelegate {
    func cameraButtonPressed() {
        addView.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        present(addView.imagePickerController, animated: true)
    }
    
    func photoLibraryPressed() {
        addView.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(addView.imagePickerController, animated: true)
    }
    
}
