//
//  Utility.swift
//  MotivationalDolphins
//
//  Created by Adrian Max Mohnacs on 8/27/17.
//  Copyright © 2017 Adrian Max Mohnacs. All rights reserved.
//

import UIKit

class Utility {
    
    
    public static func createDialog(actionTitle: String, title: String, message: String) -> UIAlertController{
        
        let contactAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        contactAlert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            if title == "Reach Out" {
                //make phone call
                let number = URL(string: "tel://" + "5712428438")
                UIApplication.shared.open(number!, options: [:], completionHandler: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }))
        
        present(contactAlert, animated: true, completion: nil)
    }
}
