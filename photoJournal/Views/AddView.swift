//
//  AddView.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit

protocol AddViewDelegate: class {
    func cameraButtonPressed()
    func photoLibraryPressed()
}

final class AddView: UIView {
    
    weak var delegate: AddViewDelegate?
    
    public lazy var imagePickerController: UIImagePickerController = {
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
           let pickerController = UIImagePickerController()
           pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
           return pickerController
       }()
    
    public lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: nil, action: #selector(presentCamera(_:)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let photoLibrary = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .plain, target: nil, action: #selector(presentPhotoLib(_:)))
        
        tool.barTintColor = .purple
        tool.tintColor = .green
        tool.items = [camera, flexSpace, photoLibrary]
        return tool
    }()
    
    @objc func presentCamera(_ sender: UIBarButtonItem) {
        delegate?.cameraButtonPressed()
    }
    
    @objc func presentPhotoLib(_ sender: UIBarButtonItem) {
        delegate?.photoLibraryPressed()
    }
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        return label
    }()
    
    public lazy var descriptionText: UITextView = {
        let label = UITextView()
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10
        label.font = .systemFont(ofSize: 15)
        label.layer.borderColor = UIColor.black.cgColor
        label.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return label
    }()
    
    public lazy var titleLabel: UITextField = {
        let label = UITextField()
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.placeholder = "Title Here"
        label.setLeftPadding(10)
        label.setRightPadding(10)
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.fill")
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.black.cgColor
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame:CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            toolBar.items![0].isEnabled = false
                     }
        toolBarSetup()
        titleLabelSetup()
        descriptionLabelSetup()
        descriptionTextViewSetup()
        imageViewSetup()
    }
    
    private func toolBarSetup() {
        addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func titleLabelSetup() {
        addSubview(titleLabel)
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 50)
    }
    
    private func descriptionLabelSetup() {
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 20, height: 30)
    }
    
    private func descriptionTextViewSetup() {
        addSubview(descriptionText)
        descriptionText.anchor(top: descriptionLabel.bottomAnchor, left: descriptionLabel.leftAnchor, right: descriptionLabel.rightAnchor, paddingTop: 10, height: 100)
    }
    
    private func imageViewSetup() {
        addSubview(imageView)
        imageView.anchor(top: descriptionText.bottomAnchor, left: leftAnchor, bottom: toolBar.topAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 20, paddingRight: 15)
        
    }
    
}
