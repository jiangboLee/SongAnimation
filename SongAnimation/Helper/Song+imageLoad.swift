//
//  Song+imageLoad.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

extension Song {
    func loadSongImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = coverArtURL,
            let file = Bundle.main.path(forResource: imageUrl.absoluteString, ofType: "jpeg")
        else { return }
        
        DispatchQueue.global(qos: .background).async {
            let image = UIImage(contentsOfFile: file)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
