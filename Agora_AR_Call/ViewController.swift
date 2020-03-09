//
//  ViewController.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 28/02/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import UIKit


class ViewController: UIViewController, AgoraViewControllerProtocol {
    
    var videoCallService: VideoCallService!
    
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var cancelCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    
    @IBAction func cancelCallButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rotateCameraButtonPressed(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set local and remote view
        videoCallService.localView = localView
        videoCallService.remoteView = remoteView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Join channel and setup local video with user id
        videoCallService.joinChannel(with: 0) { uid in
            self.videoCallService.setupLocalVideo(uid: uid)
        }
    }
}

