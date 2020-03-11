//
//  HostViewController.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 02/03/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import UIKit
import ARKit

class HostViewController: UIViewController, AgoraViewControllerProtocol {
    
    var videoCallService: VideoCallService!
    
    @IBOutlet weak var sceneView: ARSCNView!
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
        
        // Set remote view
        videoCallService.remoteView = remoteView
        
        // Set scene view delegate
        sceneView.delegate = self
        setupDebugOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.configureArSession()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoCallService.setVideoSource()
        videoCallService.enableVideoForHost()
        videoCallService.joinChannel(with: 0) { _ in
            self.startCaptureView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseArSession()
    }
    
    // MARK: - Private methods
    private func configureArSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: .removeExistingAnchors)
    }
    
    private func pauseArSession() {
        sceneView.session.pause()
    }
    
    private func setupDebugOptions() {
        sceneView.showsStatistics = true
        sceneView.preferredFramesPerSecond = 30
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }

    // THIS IS PART WHERE CAPTURING HAPPENS
    private func startCaptureView() {
        startTimerForCapturing()
    }
    
    private func startDisplayLinkForCapturing()
    {
        displayLink.isPaused = false
    }
    
    private func startTimerForCapturing()
    {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            let sceneImage: UIImage = self.sceneView.snapshot()
            DispatchQueue.global(qos: .utility).async {
                let cgImage = sceneImage.cgImage!
                let buffer = ImageConverter.pixelBuffer(forImage: cgImage)!
                // Here you must provide pixel buffer or raw data to consumer.
                // To change between pixel buffer and raw data take a look at VideoSource class.
                self.videoCallService.consumeVideoData(pixelBuffer: buffer, with: Double(mach_absolute_time()))
            }
        }
        timer.fire()
    }
    // THIS IS PART WHERE CAPTURING HAPPENS
}

extension HostViewController: ARSCNViewDelegate {
    
}
