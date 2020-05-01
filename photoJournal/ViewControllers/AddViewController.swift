//
//  ViewController.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit
import DataPersistence

protocol AddViewControllerDelegate: class {
    func didUpdate(viewController: AddViewController)
}

final class AddViewController: UIViewController {
    
    weak var delegate: AddViewControllerDelegate?
    private let addView = AddView()
    public var mediaData: Data?
    public var videoURL: URL?
    public var videoData: Data?
    private var photoObject: PhotoObject?
    private var dataPersistence: DataPersistence<PhotoObject>
    private var updateBool = false
    
    init(dataPersistence: DataPersistence<PhotoObject>, object: PhotoObject? = nil) {
        self.dataPersistence = dataPersistence
        self.photoObject = object
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePicked()
        navigationItem.rightBarButtonItem = save
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
        if let video = videoURL {
          do {
             videoData = try Data(contentsOf: video)
          } catch {
            print("failed to convert url to data with error: \(error)")
          }
        }
        
        let newPhotoObject = PhotoObject(imageData: safeMediaData, videoData: videoData, description: descriptionText, date: Date(), title: titleText, id: UUID().uuidString)
        if updateBool == false {
       try? dataPersistence.createItem(newPhotoObject)
        } else {
            if let object = photoObject {
            let updatePhotoObject = PhotoObject(imageData: safeMediaData, videoData: videoData, description: descriptionText, date: Date(), title: titleText, id: object.id)
                updateObject(object: updatePhotoObject)
            }
        }
        navigationController?.popViewController(animated: true)
            
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateObject(object: PhotoObject) {
        if let oldObject = photoObject {
                dataPersistence.update(oldObject, with: object)
            delegate?.didUpdate(viewController: self)
        }
    }
    
    private func updatePicked() {
        if photoObject != nil {
            updateBool = true
            addView.titleLabel.text = photoObject?.title
            addView.descriptionText.text = photoObject?.description
            if let photoData = photoObject?.imageData {
            mediaData = photoData
            addView.imageView.image = UIImage(data: photoData)
            }
            navigationItem.title = "Update"
        } else {
            navigationItem.title = "Create"
        }
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
                    videoURL = nil
                   }
                   
               case  "public.movie":
                   if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                       let image = mediaURL.videoPreviewThumbnail(), let imageData = image.jpegData(compressionQuality: 1.0) {
                    addView.imageView.image = image
                    videoURL = mediaURL
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
