//
//  MainCollectionViewCell.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol MainCollectionViewCellDelegate: class {
    func didPressMoreOptionsButton(cell: MainCollectionViewCell, object: PhotoObject)
}

final class MainCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MainCollectionViewCellDelegate?
    private var currentObject: PhotoObject!
    var player: AVPlayer!
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .white
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    public lazy var videoView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    public lazy var descriptionLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.backgroundColor = .white
        label.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10
        label.isEditable = false
        label.layer.borderColor = UIColor.black.cgColor
        label.text = "SimsSImsSimsSimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSims SimsSImsSimsSimsSImsSimsSimsSImsSimsSimsSImsSims"
        return label
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.text = "Test"
        return label
    }()
    
    public lazy var moreOptionsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func moreButtonPressed(_ sender: UIButton) {
        animateButtonView(sender)
        delegate?.didPressMoreOptionsButton(cell: self, object: currentObject)
    }
    
    override init(frame: CGRect) {
           super.init(frame:frame)
           commonSetup()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private func commonSetup() {
        imageViewConstraints()
        moreOptionsButtonConstraints()
        titleLabelConstraints()
        descriptionLabelConstraints()
        setupVideoView()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        backgroundColor = .white
    }
    
    public func configureCell(object: PhotoObject) {
        currentObject = object
        imageView.image = UIImage(data: currentObject.imageData)
        titleLabel.text = currentObject.title
        descriptionLabel.text = "Date Posted: \(currentObject.date.convertToString()) \n\(currentObject.description)"
        videoView.isHidden = true
        imageView.isHidden = false
        if let videoURL = currentObject.videoData?.convertToURL() {
            videoView.isHidden = false
            imageView.isHidden = true
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoView.bounds
            playerLayer.videoGravity = .resizeAspect
            playerLayer.masksToBounds = true
            videoView.layer.addSublayer(playerLayer)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoPlay))
            videoView.addGestureRecognizer(tap)
    }
    }
    
    @objc func videoPlay() {
        var playing = false
        if playing == false {
        player.play()
            playing.toggle()
        } else {
            player.pause()
            playing.toggle()
        }
    }
    
    private func imageViewConstraints() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: centerXAnchor), imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10), imageView.widthAnchor.constraint(equalToConstant: 200), imageView.heightAnchor.constraint(equalToConstant: 333)])
    }
    
    private func moreOptionsButtonConstraints() {
        addSubview(moreOptionsButton)
        moreOptionsButton.anchor(top: imageView.topAnchor, right: rightAnchor, paddingRight: 10, width: 24, height: 24)
    }
    
    
    private func titleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 12, paddingRight: 10, height: 20)
    }
    
    private func descriptionLabelConstraints() {
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    private func setupVideoView() {
    addSubview(videoView)
       videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([videoView.centerXAnchor.constraint(equalTo: centerXAnchor), videoView.topAnchor.constraint(equalTo: topAnchor, constant: 35), videoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10), videoView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10), videoView.heightAnchor.constraint(equalToConstant: 300)])
    }
}
