//
//  MainViewController.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit
import DataPersistence

final class MainViewController: UIViewController, MainViewDelegate {
    
    func addTapped() {
        navigationController?.pushViewController(AddViewController(dataPersistence: dataPersistence), animated: true)
    }
    
    private let dataPersistence = DataPersistence<PhotoObject>(filename: "photos.plist")
   private let mainView = MainView()
    var photos = [PhotoObject]() {
        didSet {
            DispatchQueue.main.async {
                self.mainView.collectionview.reloadData()
        }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionview.delegate = self
        mainView.collectionview.dataSource = self
        mainView.collectionview.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        mainView.delegate = self
        getPhotoObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func getPhotoObjects() {
        do {
            photos = try dataPersistence.loadItems()
        } catch {
            showAlert(title: "failed to fetch", message: "failed: \(error)")
        }
    }
    
    private func deleteObject(_ object: PhotoObject) {
        guard let index = photos.firstIndex(of: object) else { return }
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "failed to delete", message: "\(error)")
        }
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved = photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else { fatalError() }
        cell.configureCell(object: saved)
        return cell
    }
    
    
}

extension MainViewController: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        getPhotoObjects()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        getPhotoObjects()
    }
}

extension MainViewController: MainCollectionViewCellDelegate {
    func didPressMoreOptionsButton(cell: MainCollectionViewCell, object: PhotoObject) {
        let alertController = UIAlertController(title: "Choose", message: "Book's Destiny", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (alertAction) in
            self.navigationController?.pushViewController(AddViewController(dataPersistence: self.dataPersistence, object: object), animated: true)
        }
        let delete = UIAlertAction(title: "Throw Out", style: .destructive) { (alertAction) in
            self.deleteObject(object)
        }
        let image = UIImage(systemName: "trash")
        let editImage = UIImage(systemName: "pencil")
        delete.setValue(image, forKey: "image")
        editAction.setValue(editImage, forKey: "editImage")
        alertController.addAction(delete)
        alertController.addAction(cancelAction)
        alertController.addAction(delete)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController,animated: true)
        }
        
    }
}
