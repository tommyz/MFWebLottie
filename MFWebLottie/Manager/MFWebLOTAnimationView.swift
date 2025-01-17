//
//  MFWebLotAnimationView.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/29.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

open class MFWebLOTAnimationView: UIView, MFZipToolDelegate{
    
    //MARK: - property
    fileprivate var currentResourceMD5:String = ""
    
    ///是否支持相应点击事件
    public var isThrough: Bool = false
    
    public var loopAnimation: Bool = false {
        didSet {
            animationView?.loopAnimation = loopAnimation
        }
    }
    
    public var autoReverseAnimation = false {
        didSet {
            animationView?.autoReverseAnimation = autoReverseAnimation
        }
    }
    
    public var animationSpeed: CGFloat? {
        didSet {
            animationView?.animationSpeed = animationSpeed ?? 1.0
        }
    }
    
    public var isPlay: Bool = false {
        didSet {
            isPlay ? play() : stop()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - MFWebLottieRefreshCached: 是否需要Url不变的情况下，更新图片内容
    public init(fileName:String, mfWebLottieRefreshCached:Bool){
        super.init(frame: CGRect.zero)
        var starDownload:Bool = false
        ///在Bundle内
        if let _ = Bundle.main.path(forResource: fileName, ofType: "json"){
            print("在Bundle内")
            self.animationView = LOTAnimationView.init(name: fileName)
            return
        }
        let str = MFCacheManager.shared.getCachePath(fileName: fileName)
        print("getCachePath str=\(str)")
        if MFCacheManager.shared.getCachePath(fileName: fileName) != "NotFound"{
            ///在硬盘内
            print("在硬盘内")
            let filePath = MFCacheManager.shared.getCachePath(fileName: fileName)
            self.animationView = LOTAnimationView.init(filePath: filePath)
        }else{
            print("需要下载")
            ///需要下载
            MFDownloadManager.shared.downloadResource(fileName: fileName, downloadFinishCallBack: {[weak self] in
//                self?.zipTool.unZipFile(zipFileName: fileName)
                print("tommy downloadFinishCallBack2")
                print("fileName=\(fileName)")
                print("self!.currentResourceMD5=\(self!.currentResourceMD5)")
                MFCacheManager.shared.updateCacheInfo(fileName: fileName, md5: fileName)
                let filePath = MFCacheManager.shared.getCachePath(fileName: fileName)
                self!.updateLottieViewFromHDD(filePath: filePath)
            })
            starDownload = true
        }
        setup()
        if !starDownload{
            self.refreshCachedOperation(fileName: fileName, mfWebLottieRefreshCached: mfWebLottieRefreshCached)
        }
    }
    
    private init(model: LOTComposition?, in bundle: Bundle?) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(model: model, in: bundle)
        setup()
    }
    private init(contentsOf url: URL) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(contentsOf: url)
        setup()
    }
    private init(filePath:String) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(filePath: filePath)
        setup()
    }
    private init(json: [AnyHashable : Any]) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(json: json)
        setup()
    }
    private init(name: String) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(name: name)
        setup()
    }
    private init(name: String, bundle: Bundle) {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init(name: name, bundle: bundle)
        setup()
    }
    private init() {
        super.init(frame: CGRect.zero)
        self.animationView = LOTAnimationView.init()
        setup()
    }
    //    MARK: 0410添加了一个
    private init(name: String, frames: CGRect) {
        super.init(frame: frames)
        self.animationView = LOTAnimationView.init(name: name)
        setup()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isThrough
    }
    
    private func setup() {
        guard let animationView = animationView else{
            print("🌶 animationView没有值")
            return
        }
        animationView.layer.rasterizationScale = UIScreen.main.scale
        animationView.layer.allowsEdgeAntialiasing = true
        isUserInteractionEnabled = true
        animationView.isUserInteractionEnabled = true
        addSubview(animationView)
    }
    
    override open func layoutSubviews() {
        animationView?.frame = self.bounds
    }
    
    public func play() {
        animationView?.play()
    }
    
    public func stop() {
        animationView?.stop()
    }
    
    public func pause() {
        animationView?.pause()
    }
    
    public func playWithCompletion(_ animationBlock: ((_ animationFinished: Bool)->())?) {
        animationView?.completionBlock = animationBlock
    }
    
    //    MARK:  设置json动画
    public func setName(name: String) {
        animationView?.setAnimation(named: name)
    }
    
    
    fileprivate var animationView: LOTAnimationView?
    
    
    fileprivate lazy var zipTool:MFZipManager = {
        let tool = MFZipManager()
        tool.delegate = self
        return tool
    }()
    
    deinit {
        #if debug
        print("✅ \(self.classForCoder)：LOTAnimationView 动画 被销毁")
        #endif
    }
}

extension MFWebLOTAnimationView{
    
    ///解压完成
    func unZipSuccess(fileName: String) {
        MFCacheManager.shared.updateCacheInfo(fileName: fileName, md5: self.currentResourceMD5)
        let filePath = MFCacheManager.shared.getCachePath(fileName: fileName)
        self.updateLottieViewFromHDD(filePath: filePath)
    }
    
    /// 从Bundle取出更新Lottie状态
    func updateLottieViewFromBundle(fileName: String){
        animationView = LOTAnimationView.init(name: fileName)
        animationView?.loopAnimation = loopAnimation
        animationView?.autoReverseAnimation = autoReverseAnimation
        animationView?.animationSpeed = animationSpeed ?? 1.0
        animationView?.play()
        animationView?.removeFromSuperview()
        addSubview(animationView ?? UIView())
    }
    /// 从硬盘取出更新Lottie状态
    func updateLottieViewFromHDD(filePath: String){
        animationView = LOTAnimationView.init(filePath: filePath)
        animationView?.loopAnimation = loopAnimation
        animationView?.autoReverseAnimation = autoReverseAnimation
        animationView?.animationSpeed = animationSpeed ?? 1.0
        animationView?.play()
        animationView?.removeFromSuperview()
        addSubview(animationView ?? UIView())
    }
    
    ///刷新缓存操作
    func refreshCachedOperation(fileName:String, mfWebLottieRefreshCached:Bool){
        if mfWebLottieRefreshCached{
            ///需要检查是否更新同url的内容
            MFDownloadManager.shared.checkResourceIsUpdate(fileName: fileName) { (md5) in
                self.currentResourceMD5 = md5
                print("tommy self.currentResourceMD5=\(self.currentResourceMD5)")
                if !MFCacheManager.shared.isExistInCache(fileName: fileName, md5: md5){
                    ///需要下载更新
                    MFDownloadManager.shared.downloadResource(fileName: fileName, downloadFinishCallBack: {[weak self] in
//                        self?.zipTool.unZipFile(zipFileName: fileName)
                        print("tommy downloadFinishCallBack")
                        MFCacheManager.shared.updateCacheInfo(fileName: fileName, md5: self!.currentResourceMD5)
                        let filePath = MFCacheManager.shared.getCachePath(fileName: fileName)
                        self!.updateLottieViewFromHDD(filePath: filePath)
                        
                    })
                }else{
                    ///在Bundle内
                    if let _ = Bundle.main.path(forResource: fileName, ofType: "json"){
                        self.updateLottieViewFromBundle(fileName: fileName)
                        return
                    }
                    ///在硬盘内
                    let filePath = MFCacheManager.shared.getCachePath(fileName: fileName)
                    self.updateLottieViewFromHDD(filePath: filePath)
                }
            }
        }
    }
}
