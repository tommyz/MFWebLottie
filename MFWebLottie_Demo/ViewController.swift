//
//  ViewController.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/28.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aview.frame = CGRect.init(x: 0, y: 0, width: 375, height: 200)
        self.view.addSubview(aview)
        
        actionButton.frame = CGRect.init(x: 0, y: 200, width: 375, height: 200)
        self.view.addSubview(actionButton)
        
    }

//    lazy var aview:MFWebLOTAnimationView = {
//       let view = MFWebLOTAnimationView.init(fileName: "zucistar_data",
//                                             mfWebLottieRefreshCached: true)
//        view.play()
//        view.loopAnimation = true
//        return view
//    }()
    
    lazy var aview:MFWebLOTAnimationView = {
//        let view = MFWebLOTAnimationView.init(fileName: "https://d6dzb6iytrcde.cloudfront.net/monster-json/b90f17fb-8c8e-4a76-9c21-e8f90a61dde8.json",
//                                              mfWebLottieRefreshCached: false)
        let view = MFWebLOTAnimationView.init(fileName: "http://52.220.49.115:8086/lottie.json",
                                              mfWebLottieRefreshCached: false)
//        let view = MFWebLOTAnimationView.init(fileName: "http://52.220.49.115:8086/lottie2.json",
//                                              mfWebLottieRefreshCached: false)
        view.play()
        view.loopAnimation = true
        return view
    }()
    
    /*
    lazy var aview:LOTAnimationView = {
        let url: URL = URL(string: "https://d6dzb6iytrcde.cloudfront.net/monster-json/b90f17fb-8c8e-4a76-9c21-e8f90a61dde8.json")!
//        let url: URL = URL(string: " http://52.220.49.115:8086/lottie.json")!
//        let str: String = "http://52.220.49.115/lottie.json"
//        let str: String = "http://52.220.49.115:8086/lottie.json"
//        let url: URL = URL(string: str)!
        let view = LOTAnimationView(contentsOf: url)
        view.play()
        view.loopAnimation = true
        return view
    }()
    */
    @objc func actionClick(sender:UIButton) {
        print("actionClick")
//        delegate?.actionAdSingleSquareView(self)
        let size = MFWebLottieManager.getCacheSize()
        print("size=\(size)")
//        MFWebLottieManager.clearCache()
//        MFWebLottieManager.clearCache()
    }
    
    lazy var actionButton: UIButton = {
        let tempButton = UIButton()
        tempButton.backgroundColor = .clear
        tempButton.backgroundColor = .red
        tempButton.addTarget(self, action: #selector(actionClick(sender:)), for: .touchUpInside)
        return tempButton
    }()
//
}

