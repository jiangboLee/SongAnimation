//
//  SongBuilder.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class SongBuilder: NSObject {
    // MARK: - Properties
    private var title: String?
    private var duration: TimeInterval = 0
    private var artist: String?
    private var mediaURL: URL?
    private var coverArtURL: URL?
    
    func build() -> Song? {
        guard let title = title,
            let artist = artist else {
                return nil
        }
        
        return Song(title: title, duration: duration, artist: artist, mediaUrl: mediaURL, coverArtURL: coverArtURL)
    }
    
    func with(title: String?) -> Self {
        self.title = title
        return self
    }
    
    func with(duration: TimeInterval?) -> Self {
        self.duration = duration ?? 0
        return self
    }
    
    func with(artist: String?) -> Self {
        self.artist = artist
        return self
    }
    
    func with(mediaURL url: String?) -> Self {
        guard let urlstring = url else {
            return self
        }
        
        self.mediaURL = URL(string: urlstring)
        return self
    }
    
    func with(coverArtURL url: String?) -> Self {
        guard let urlstring = url else {
            return self
        }
        
        self.coverArtURL = URL(string: urlstring)
        return self
    }
}
