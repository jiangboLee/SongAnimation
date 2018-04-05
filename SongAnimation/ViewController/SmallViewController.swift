//
//  SmallViewController.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

protocol SmallPlayerDelegate: class {
    func expandSong(song: Song)
}

class SmallViewController: UIViewController, SongSubscriber {

    var currentSong: Song?
    weak var delegate: SmallPlayerDelegate?
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(song: nil)
    }
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        guard let song = currentSong else { return }
        delegate?.expandSong(song: song)
    }
}

extension SmallViewController {
    
    func configure(song: Song?) {
        if let song = song {
            songTitle.text = song.title
            song.loadSongImage(completion: { [weak self] (image) in
                self?.thumbImage.image = image
            })
        } else {
            songTitle.text = nil
            thumbImage.image = nil
        }
        currentSong = song
    }
}

extension SmallViewController: BigPlayerSourceProtocol {
    
    var originatingFrameInWindow: CGRect {
        return view.convert(view.frame, to: nil)
    }
    
    var originatingCoverImageView: UIImageView {
        return thumbImage
    }
}












