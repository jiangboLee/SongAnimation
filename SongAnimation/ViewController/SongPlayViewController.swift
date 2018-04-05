//
//  SongPlayViewController.swift
//  SongAnimation
//
//  Created by 李江波 on 2018/4/4.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class SongPlayViewController: UIViewController, SongSubscriber {
    
    var currentSong: Song? {
        didSet {
            configureFields()
        }
    }

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songDuration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFields()
    }

}

// MARK: - Internal
extension SongPlayViewController {
    
    func configureFields() {
        guard songTitle != nil else {
            return
        }
        
        songTitle.text = currentSong?.title
        songArtist.text = currentSong?.artist
        songDuration.text = "Duration \(currentSong?.presentationTime ?? "")"
    }
}

// MARK: - Song Extension
extension Song {
    
    var presentationTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: duration)
        return formatter.string(from: date)
    }
}
