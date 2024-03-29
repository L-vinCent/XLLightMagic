//
//  XFilterManager.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/28.
//

import Foundation
import UIKit
import GPUImage

class XFilterManager{
        
    static let shared = XFilterManager()
    
    func brightness(to image: UIImage?) -> UIImage? {
        guard let _ = image else { return nil }
        let brightnessAdjustment = BrightnessAdjustment()
        brightnessAdjustment.brightness = 0.2
        
        var filterImage = image?.filterWithOperation(brightnessAdjustment)
        return filterImage
        
        
    }
    
    
}

