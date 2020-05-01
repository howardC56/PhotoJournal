//
//  PhotoObject.swift
//  photoJournal
//
//  Created by Howard Chang on 4/30/20.
//  Copyright © 2020 Howard Chang. All rights reserved.
//

import Foundation

struct  PhotoObject: Codable & Equatable {
      let imageData: Data
      let videoData: Data?
      let description: String
      let date: Date
      let title: String
      let id = UUID().uuidString
}
