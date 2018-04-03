//
//  SongViewController.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {

    var datasourse: SongCollectionDatasource!
    var currentSong: Song?
    var smallPlayer: SmallViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasourse = SongCollectionDatasource(collectionView: collectionView)
        datasourse.load()
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SmallViewController {
            smallPlayer = destination
            smallPlayer?.delegate = self
        }
    }
}

extension SongViewController: SmallPlayerDelegate {
    func expandSong(song: Song) {
        
    }
}

extension SongViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSong = datasourse.song(at: indexPath.row)
        smallPlayer?.configure(song: currentSong)
    }
}






