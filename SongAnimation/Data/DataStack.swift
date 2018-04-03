//
//  DataStack.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

enum DataStackState {
    case unloaded
    case loaded
}

class DataStack: NSObject {
    
    //只读
    private(set) var allSongs: [Song] = []
    
    func load(distionary: [String: Any], completion: (Bool) -> Void) {
        if let songs = distionary["Songs"] as? [[String: Any]] {
            for songDictionary in songs {
                let builder = SongBuilder()
                    .with(title: songDictionary["title"] as? String)
                    .with(artist: songDictionary["artist"] as? String)
                    .with(duration: songDictionary["duration"] as? TimeInterval)
                    .with(mediaURL: songDictionary["mediaURL"] as? String)
                    .with(coverArtURL: songDictionary["coverArtURL"] as? String)
                if let song = builder.build() {
                    allSongs.append(song)
                }
            }
            completion(true)
        } else {
            completion(false)
        }
    }
}









