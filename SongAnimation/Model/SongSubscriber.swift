//
//  SongSubscriber.swift
//  SongAnimation
//
//  Created by 李江波 on 2018/4/5.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

protocol SongSubscriber: class {
    var currentSong: Song? { get set }
}
