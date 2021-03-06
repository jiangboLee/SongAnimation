//
//  BigViewController.swift
//  SongAnimation
//
//  Created by ljb48229 on 2018/4/4.
//  Copyright © 2018年 ljb48229. All rights reserved.
//


import UIKit

protocol BigPlayerSourceProtocol: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingCoverImageView: UIImageView { get }
}

class BigViewController: UIViewController, SongSubscriber {
    
    //动画时间
    let primaryDuration = 0.5
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
    //歌曲详情
    @IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
    
    //tabbarimage
    var tabBarImage: UIImage?
    @IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //接管状态栏属性
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .overFullScreen //这句话不写回来的时候有问题！！！！
        /*
         简单说就是不隐藏presenting VC，用于presented VC的view有透明的情况使用。那么这个和之前的有什么区别呢，区别主要在亮点：1.背景不会变深色（但还是会屏蔽触控）2.presented VC view的大小和presenting VC一样大时（即完全遮挡），前面几个选项会直接隐藏presenting VC，而overFullScreen不考虑遮挡问题，无条件显示presenting VC。这就对presented VC大小和presenting VC一样大但有透明的情况适用。
         */
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
        stretchySkirt.backgroundColor = .white //避免封面图片和下面的 songPlayControl 之间显示出间隙
        configureLowerModuleInStartPosition()
        configureBottomSection()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
        animateLowerModuleIn()
        animateBottomSectionOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SongSubscriber {
            destination.currentSong = currentSong
        }
    }
}
extension BigViewController {
    
    @IBAction func dismissAction(_ sender: Any) {
        animateBackingImageOut()
        animateCoverImageOut()
        animateImageLayerOut { _ in
            self.dismiss(animated: false, completion: nil)
        }
        animateLowerModuleOut()
        animateBottomSectionIn()
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

// MARK: - 歌曲详情动画
extension BigViewController {
    
    private var lowerModuleInsetForOutPosition: CGFloat {
        let bounds = view.bounds
        return bounds.height - bounds.width
    }
    
    func configureLowerModuleInStartPosition() {
        lowerModuleTopConstraint.constant = lowerModuleInsetForOutPosition
    }
    
    func animateLowerModule(isPresenting: Bool) {
        let topInset = isPresenting ? 0 : lowerModuleInsetForOutPosition
        UIView.animate(withDuration: primaryDuration , delay: 0 , options: [.curveEaseIn], animations: {
            self.lowerModuleTopConstraint.constant = topInset
            self.view.layoutIfNeeded()
        })
    }
    
    func animateLowerModuleOut() {
        animateLowerModule(isPresenting: false)
    }
    
    func animateLowerModuleIn() {
        animateLowerModule(isPresenting: true)
    }
}

// MARK: - tab bar animation
extension BigViewController {
    
    func configureBottomSection() {
        if let image = tabBarImage {
            bottomSectionHeight.constant = image.size.height
            bottomSectionImageView.image = image
        } else {
            bottomSectionHeight.constant = 0
        }
        view.layoutIfNeeded()
    }
    //将 image view 移到屏幕底部以下
    func animateBottomSectionOut() {
        if let image = tabBarImage {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = -image.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    //将 image view 移到正常位置
    func animateBottomSectionIn() {
        if tabBarImage != nil {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}









