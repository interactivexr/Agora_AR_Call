//
//  AgoraViewControllerProtocol.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 02/03/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit

protocol AgoraViewControllerProtocol {
    var videoCallService: VideoCallService! { get set }
}
