//
//  MainViewController.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit
import DataPersistence

class MainViewController: UIViewController {

    private let dataPersistence = DataPersistence<PhotoObject>(filename: "photos.plist")
    let mainView = MainView()
    var photos = [PhotoObject]() {
        didSet {
            mainView.collectionview.reloadData()
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        mainView.collectionview.delegate = self
        mainView.collectionview.dataSource = self
        mainView.collectionview.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        
    }
    

}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved = photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { fatalError() }
        return cell
    }
    
    
}
