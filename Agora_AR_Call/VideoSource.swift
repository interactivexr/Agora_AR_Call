//
//  VideoSource.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 02/03/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit

class VideoSource: NSObject {
    var consumer: AgoraVideoFrameConsumer?
}

extension VideoSource: AgoraVideoSourceProtocol {
    
    func shouldInitialize() -> Bool {
        return true
    }
    
    func shouldStart() {
        
    }
    
    func shouldStop() {
        
    }
    
    func shouldDispose() {
        
    }
    
    // Return type of this method will determine what buffer type will consumer consume.
    // In this case it will consume pixelBuffer which is why I call consumePixelBuffer(_:, withTimestamp:, rotation:) method
    // in sendBuffer(_:, timestamp:) method.
    func bufferType() -> AgoraVideoBufferType {
        return .pixelBuffer
    }
    
    func sendBuffer(_ buffer: CVPixelBuffer, timestamp: TimeInterval) {
        let time = CMTime(seconds: timestamp, preferredTimescale: 10000)
        // Change this line of code to consumeRawData(_:, withTimestamp:, format:, size:, rotation:)
        // if bufferType() method will return .rawData.
        consumer?.consumePixelBuffer(buffer, withTimestamp: time, rotation: .rotationNone)
    }
}
