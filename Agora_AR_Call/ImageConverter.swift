//
//  ImageConverter.swift
//  Agora_AR_Call
//
//  Created by Luka Cefarin on 02/03/2020.
//  Copyright © 2020 Etiketa Interactive. All rights reserved.
//

import Foundation
import CoreVideo

struct ImageConverter {
    static func pixelBuffer (forImage image:CGImage) -> CVPixelBuffer? {
        
        
        let frameSize = CGSize(width: image.width, height: image.height)
        
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
}

extension CGImage
{
    func copyPixelbufferFromCGImageProvider() -> CVPixelBuffer?
    {
        guard let data = dataProvider?.data,
            let baseAddress = CFDataGetBytePtr(data)
        else
        {
            return nil
        }
        
        let unmanagedData = Unmanaged<CFData>.passRetained(data)
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreateWithBytes(nil,
                                                  width,
                                                  height,
                                                  kCVPixelFormatType_32BGRA,
                                                  UnsafeMutableRawPointer(mutating: baseAddress),
                                                  bytesPerRow,
                                                  {
                                                    releaseContext, baseAddress in
                                                    
                                                    if let releaseContext = releaseContext
                                                    {
                                                        let contextData = Unmanaged<CFData>.fromOpaque(releaseContext)
                                                        contextData.release()
                                                    }
                                                  },
                                                  unmanagedData.toOpaque(),
                                                  nil,
                                                  &pixelBuffer)
        if (status != kCVReturnSuccess)
        {
            return nil
        }
        
        return pixelBuffer
    }
}
