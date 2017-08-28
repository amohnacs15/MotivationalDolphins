//
//  ImageObject.swift
//  MotivationalDolphins
//
//  Created by Adrian Max Mohnacs on 8/27/17.
//  Copyright © 2017 Adrian Max Mohnacs. All rights reserved.
//

import UIKit

class DolphinImage {
    
    
    var title: String?
    var displayUrl: String?
    var image: UIImage?
    
    init?() {
        
    }
    
    init?(title: String, displayUrl: String) {
        
        if displayUrl.isEmpty {
            return nil
        }
        
        self.title = title
        self.displayUrl = displayUrl
    }
    
    init?(title: String, displayUrl: String, image: UIImage) {
        
        if displayUrl.isEmpty {
            return nil
        }
        
        self.title = title
        self.displayUrl = displayUrl
        self.image = image
    }
}
