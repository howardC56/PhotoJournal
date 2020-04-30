//
//  MainView.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit

protocol MainViewDelegate: class {
    func addTapped()
}

class MainView: UIView {

    weak var delegate: MainViewDelegate?
    
    public lazy var collectionview: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.minimumLineSpacing = 20
           layout.scrollDirection = .vertical
           layout.itemSize = CGSize(width: frame.width / 1.2, height: frame.height / 1.5)
           layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.backgroundColor = .white
           return cv
       }()
    
    public lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: #selector(create(_:)))
        )
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        tool.barTintColor = .purple
        tool.tintColor = .green
        tool.setItems(items, animated: true)
        return tool
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
        collectionViewSetup()
    }
    
    @objc func create(_ sender: UIBarButtonItem) {
        delegate?.addTapped()
    }
    
    private func toolBarSetup() {
        addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func collectionViewSetup() {
        addSubview(collectionview)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), collectionview.leadingAnchor.constraint(equalTo: leadingAnchor), collectionview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), collectionview.bottomAnchor.constraint(equalTo: toolBar.topAnchor)])
    }

}
