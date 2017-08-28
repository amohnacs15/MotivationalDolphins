//
//  Quote.swift
//  MotivationalDolphins
//
//  Created by Adrian Max Mohnacs on 8/27/17.
//  Copyright © 2017 Adrian Max Mohnacs. All rights reserved.
//

import UIKit

class Quote {
    
    var quote : String?
    var author : String?
    var category : String?
    
    init?() {
        
    }
    
    init?(quote: String, author: String, category: String) {
        
        if quote.isEmpty {
            return nil
        }
        
        self.quote = quote
        self.author = author
        self.category = category
    }
}
