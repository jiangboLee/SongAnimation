//
//  BigViewController.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/4.
//  Copyright © 2018年 ljb48229. All rights reserved.
//
https://blog.csdn.net/kmyhy/article/details/79670878

import UIKit

protocol BigPlayerSourceProtocol: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingCoverImageView: UIImageView { get }
}

class BigViewController: UIViewController {
    
    //动画时间
    let primaryDuration = 5.0
    let backingImageEdgeInset: CGFloat = 15.0
    let cardCornerRadius: CGFloat = 10
    var currentSong: Song?
    weak var sourceView: BigPlayerSourceProtocol!
    
    var backingImage: UIImage?
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerLayer: UIView!
    @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stretchySkirt: UIView!
    //cover image
    @IBOutlet weak var coverImageContainer: UIView!
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var dismissChevron: UIButton!
    
    @IBOutlet weak var coverImageLeading: NSLayoutConstraint!
    @IBOutlet weak var coverImageTop: NSLayoutConstraint!
    @IBOutlet weak var coverImageBottom: NSLayoutConstraint!
    @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
    //cover image constraints
    @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
    
    
    
    var tabBarImage: UIImage?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backingImageView.image = backingImage
        scrollView.contentInsetAdjustmentBehavior = .never
        coverImageContainer.layer.cornerRadius = cardCornerRadius
        coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] //ios11新属性倒圆角
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureImageLayerInStartPosition()
        coverArtImage.image = sourceView.originatingCoverImageView.image
        configureCoverImageInStartPosition()
        stretchySkirt.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        animateBackingImageOut()
        animateCoverImageOut()
        animateImageLayerOut { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
}

// MARK: - 背景图片动画
extension BigViewController {
    
    private func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? backingImageEdgeInset : 0
        let dimmerAlpha: CGFloat = presenting ? 0.3 : 0
        let cornerRadius: CGFloat = presenting ? cardCornerRadius : 0
        
        backingImageLeadingInset.constant = edgeInset
        backingImageTrailingInset.constant = edgeInset
        let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
        backingImageTopInset.constant = edgeInset * aspectRatio
        backingImageBottomInset.constant = edgeInset * aspectRatio
        
        dimmerLayer.alpha = dimmerAlpha
        backingImageView.layer.cornerRadius = cornerRadius
    }
    
    private func animateBackingImage(presenting: Bool) {
        UIView.animate(withDuration: TimeInterval(primaryDuration)) {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded() //IMPORTANT!
        }
    }
    
    func animateBackingImageIn() {
        animateBackingImage(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateBackingImage(presenting: false)
    }
}

// MARK: - scrollview动画
extension BigViewController {
    
    private var startColor: UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
    
    private var endColor: UIColor {
        return .white
    }
    
    private var imageLayerInsetForOutPosition: CGFloat {
        let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
        let inset = imageFrame.minY - backingImageEdgeInset
        return inset
    }
    
    func configureImageLayerInStartPosition() {
        coverImageContainer.backgroundColor = startColor
        let startInset = imageLayerInsetForOutPosition
        dismissChevron.alpha = 0
        coverImageContainer.layer.cornerRadius = 0
        coverImageContainerTopInset.constant = startInset
        view.layoutIfNeeded()
    }
    
    func animateImageLayerIn() {
        UIView.animate(withDuration: primaryDuration / 4.0) {
            self.coverImageContainer.backgroundColor = self.endColor
        }
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.coverImageContainerTopInset.constant = 0
            self.dismissChevron.alpha = 1
            self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
            self.view.layoutIfNeeded()
        })
    }
    
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
        
        let endInset = imageLayerInsetForOutPosition
        UIView.animate(withDuration: primaryDuration / 4.0, delay: primaryDuration , options: [.curveEaseOut], animations: {
            self.coverImageContainer.backgroundColor = self.startColor
        }, completion: { finished in
            completion(finished)
        })
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.coverImageContainerTopInset.constant = endInset
            self.dismissChevron.alpha = 0
            self.coverImageContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - 封面动画
extension BigViewController {
    
    func configureCoverImageInStartPosition() {
        let originatingImageFrame = sourceView.originatingCoverImageView.frame
        coverImageHeight.constant = originatingImageFrame.height
        coverImageLeading.constant = originatingImageFrame.minX
        coverImageTop.constant = originatingImageFrame.minY
        coverImageBottom.constant = originatingImageFrame.minY
    }
    func animateCoverImageIn() {
        let coverImageEdgeContraint: CGFloat = 30
        let endHeight = coverImageContainer.bounds.width - coverImageEdgeContraint * 2
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.coverImageHeight.constant = endHeight
            self.coverImageLeading.constant = coverImageEdgeContraint
            self.coverImageTop.constant = coverImageEdgeContraint
            self.coverImageBottom.constant = coverImageEdgeContraint
            self.view.layoutIfNeeded()
        })
    }
    func animateCoverImageOut() {
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.configureCoverImageInStartPosition()
            self.view.layoutIfNeeded()
        })
    }
}












