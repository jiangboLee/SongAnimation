![demo.gif](https://upload-images.jianshu.io/upload_images/2868618-7556535d49fbc665.gif?imageMogr2/auto-orient/strip)
直接上图片，再来慢慢分析一番。
#### 总结
一开始看到这个动画，我的第一感觉是自定义转场动画。但看了demo后发现竟然只是普通的`present`模式.并且配上巧妙的截图方式运用，让人产生一种视觉享受~
```swift
//截图
extension UIView {
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
```
这个整体动画效果，包含了背景图片动画、整个scrollView动画、专辑封面动画、歌曲详情动画、tabbar动画。
```swift
override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
        animateLowerModuleIn()
        animateBottomSectionOut()
    }
```
将每一部分动画组合在一起就大功告成啦~
所以说做动画一定要细嚼慢咽，将每一步都拆开，然后再组装。难的是怎么拆怎么装喽。继续加油吧~
