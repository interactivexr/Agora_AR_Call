//
//  VideoCallService.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 01/03/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit
import UIKit

private let APP_ID = "b45135d13c8b4d278a1606c56d71550f"

class VideoCallService: NSObject {
    
    weak var localView: UIView?
    weak var remoteView: UIView?
    
    private var agoraKit: AgoraRtcEngineKit {
        let agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: APP_ID, delegate: self)
        agoraKit.disableAudio()
        return agoraKit
    }
    
    private let videoSource = VideoSource()
    
    // MARK: - Methods for HOST
    func setVideoSource() {
        agoraKit.setVideoSource(videoSource)
    }
    
    func consumeVideoData(pixelBuffer: CVPixelBuffer, with timestamp: TimeInterval) {
        videoSource.sendBuffer(pixelBuffer, timestamp: timestamp)
    }
    
    func enableVideoForHost() {
        DispatchQueue.main.async {
            self.agoraKit.enableVideo()
        }
    }
    
    // MARK: - Methods for both
    
    func setupLocalVideo(uid: UInt) {
        agoraKit.enableVideo()
        guard let view = localView else {
            return
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    func setupRemoteView(with uid: UInt) {
        guard let view = remoteView else {
            return
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func joinChannel(with uid: UInt, completion: ((UInt) -> ())? ) {
        self.agoraKit.joinChannel(byToken: nil, channelId: "test_room", info: nil, uid: uid) { channelName, uid, elapsed in
            DispatchQueue.main.async {
                print("Joined with uid: \(uid)")
                completion?(uid)
            }
        }
    }
    
}

extension VideoCallService: AgoraRtcEngineDelegate {
    // This delegate method don't work even if I provide nil for joinSuccess parameter in joinChannel method
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Local user joined \(channel) channel with \(uid) uid.")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Remote user joined channel with \(uid) uid")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print("Video size:\nWidth:\(size.width)\nHeight:\(size.height)")
        DispatchQueue.main.async {
            self.setupRemoteView(with: uid)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        print("\t\t\t\t\t\t\t**** receivedBitrate: \(stats.receivedBitrate)")
        print("\t\t\t\t\t\t\t**** decoderOutputFrameRate: \(stats.decoderOutputFrameRate)")
        print("\t\t\t\t\t\t\t**** rendererOutputFrameRate: \(stats.rendererOutputFrameRate)")
        print("\t\t\t\t\t\t\t**** totalFrozenTime: \(stats.totalFrozenTime)")
        print("\t\t\t\t\t\t\t**** frozenRate: \(stats.frozenRate)")
        print("\n\n")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStats stats: AgoraRtcLocalVideoStats) {
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** sentBitrate: \(stats.sentBitrate)")
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** sentFrameRate: \(stats.sentFrameRate)")
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** encoderOutputFrameRate: \(stats.encoderOutputFrameRate)")
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** rendererOutputFrameRate: \(stats.rendererOutputFrameRate)")
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** sentTargetBitrate: \(stats.sentTargetBitrate)")
        print("\t\t\t\t\t\t\t\t\t\t\t\t\t\t** sentTargetFrameRate: \(stats.sentTargetFrameRate)")
        print("\n\n")
    }
}
