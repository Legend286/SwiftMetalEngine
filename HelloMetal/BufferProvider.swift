//
//  BufferProvider.swift
//  HelloMetal
//
//  Created by Samuel Hall on 19/10/2022.
//  Copyright © 2022 razeware. All rights reserved.
//

import Foundation
import Metal

class BufferProvider : NSObject
{
    let inflightBuffersCount: Int
    private var uniformBuffers: [MTLBuffer]
    private var availableBufferIndex: Int = 0
    var availableResourcesSemaphore: DispatchSemaphore
    
    init(device:MTLDevice, inflightBuffersCount: Int, sizeOfUniformBuffer: Int)
    {
        availableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)
        
        self.inflightBuffersCount = inflightBuffersCount
        uniformBuffers = [MTLBuffer]()
        
        for _ in 0...inflightBuffersCount-1
        {
            let uniformBuffer = device.makeBuffer(length: sizeOfUniformBuffer, options: [])
            
            uniformBuffers.append(uniformBuffer!)
        }
    }
    
    func nextUniformBuffer(projectionMatrix: Matrix4, modelViewMatrix: Matrix4) -> MTLBuffer
    {
        let buffer = uniformBuffers[availableBufferIndex]
        
        let bufferPointer = buffer.contents()
        
        memcpy(bufferPointer, modelViewMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size * Matrix4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size*Matrix4.numberOfElements())
        
        availableBufferIndex += 1
        if availableBufferIndex == inflightBuffersCount
        {
            availableBufferIndex = 0
        }
        
        return buffer
    }
    
    deinit
    {
        for _ in 0...self.inflightBuffersCount
        {
            self.availableResourcesSemaphore.signal()
        }
    }
}
