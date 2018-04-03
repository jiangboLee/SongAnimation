//
//  SongCollectionDatasource.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/3.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class SongCollectionDatasource: NSObject {

    var dataStack: DataStack
    var managedCollection: UICollectionView
    
    func load() {
        guard let file = Bundle.main.path(forResource: "CannedSongs", ofType: "plist") else {
            assertionFailure("找不到文件")
            return
        }
        if let dictionary = NSDictionary(contentsOfFile: file) as? [String: Any] {
            dataStack.load(distionary: dictionary, completion: { [weak self] success in
                self?.managedCollection.reloadData()
            })
        }
    }
    
    init(collectionView: UICollectionView) {
        dataStack = DataStack()
        managedCollection = collectionView
        super.init()
        managedCollection.dataSource = self
    }
    //只是为了多几个cell
    func song(at index: Int) -> Song {
        let realindex = index % dataStack.allSongs.count
        return dataStack.allSongs[realindex]
    }
}

extension SongCollectionDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataStack.allSongs.count * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "songcell", for: indexPath) as? SongCell else {
            assertionFailure("找不到cell")
            return UICollectionViewCell()
        }
        return configured(cell, at: indexPath)
    }
    
    func configured(_ cell: SongCell, at indexPath: IndexPath) -> SongCell {
        let isong = song(at: indexPath.row)
        cell.songTitle.text = isong.title
        cell.artistName.text = isong.artist
        isong.loadSongImage { (img) in
            cell.coverArt.image = img
        }
        return cell
    }
}








