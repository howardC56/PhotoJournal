//
//  AddView.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit

class AddView: UIView {

    public lazy var toolBar: UIToolbar = {
           let tool = UIToolbar()
           var items = [UIBarButtonItem]()
           items.append(
            UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: nil, action: #selector(presentCamera(_:)))
        )
           items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
           items.append(
               UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .plain, target: nil, action: #selector(presentPhotoLib(_:)))
           )
           tool.barTintColor = .purple
           tool.tintColor = .green
           tool.setItems(items, animated: true)
           return tool
       }()
    
    @objc func presentCamera(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func presentPhotoLib(_ sender: UIBarButtonItem) {
        
    }
    
    public lazy var descriptionLabel: UITextField = {
        let label = UITextField()
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10
        label.contentVerticalAlignment = .top
        label.layer.borderColor = UIColor.black.cgColor
        label.placeholder = "Description"
        label.setRightPadding(10)
        label.setLeftPadding(10)
        return label
    }()
    
    public lazy var titleLabel: UITextField = {
        let label = UITextField()
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.contentVerticalAlignment = .top
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
        toolBarSetup()
           
       }
    
    private func toolBarSetup() {
           addSubview(toolBar)
           toolBar.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               toolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
               toolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
               toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
       }

}
