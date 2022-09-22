//
//  ViewController.swift
//  iOS16-BUG-PIP
//
//  Created by wuqihan on 2022/9/22.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVPictureInPictureControllerDelegate {
    
    private let player = AVPlayer()
    
    private var playerView: PlayerView {
        return self.view as! PlayerView
    }
    
    private var pictureInPictureController: AVPictureInPictureController?
    
    private var playerItemStatusObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Audio session setCategory failed")
        }
        
        let liveStreamURL = URL(string: "http://220.161.87.62:8800/hls/0/index.m3u8")!
        let asset = AVURLAsset(url: liveStreamURL)
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        playerView.playerLayer.player = player;
        
        playerItemStatusObserver = playerItem.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] (item, _) in
            guard let strongSelf = self else { return }
            strongSelf.player.play()
            if item.status == .readyToPlay {
                if strongSelf.pictureInPictureController == nil {
                    strongSelf.setupPictureInPictureController()
                }
            }
        }
    }
    
    private func setupPictureInPictureController() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerView.playerLayer)
        }
    }
    
    // MARK: - Action
    @IBAction func playButtonClick(_ sender: Any) {
        player.play()
    }

    @IBAction func testButtonClick(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.lightGray
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

