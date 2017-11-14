//
//  DolphinViewController.swift
//  MotivationalDolphins
//
//  Created by Adrian Max Mohnacs on 8/26/17.
//  Copyright © 2017 Adrian Max Mohnacs. All rights reserved.
//

import UIKit

// Quotes API can only be downloaded 10 times in an hour.  Let's keep track of that shall we or at least have something to display when error handling catches it


class DolphinViewController: UIViewController  {
    
    @IBOutlet weak var dolphinImageView: UIImageView!
    
    let PLACEHOLDER_URL = "http://jsonplaceholder.typicode.com/users/1"
    let QUOTE_URL: String = "https://quotes.rest/qod"
    let IMAGE_URL: String = "https://api.gettyimages.com/v3/search/images?minimum_size=xx_large&page_size=%d&phrase=%@&prestige_content_only=true&sort_order=%@"
    //?page_size=%d&phrase=dolphin&prestige_content_only=true&sort_order=newest
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //hideNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        DispatchQueue.global(qos: .userInitiated).async { //qos means Quality of Service = Priority
        
            print("dispatch global queue")
            
            self.fetchDolphinImage()
            //download motivational text still needs to be presented to the canvas
            //let overlayText = self.downloadMotivationalQuote()
            
            DispatchQueue.main.async {
                print("main async")
                //self.fadeInNewImage((overlayImage?.image)!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func hideNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func fadeInNewImage(_ newImage: UIImage) {
        
        let tmpImageView = UIImageView(image: newImage)
        //tmpImageView.image = newImage
        
        tmpImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tmpImageView.contentMode = dolphinImageView.contentMode
        tmpImageView.frame = dolphinImageView.bounds
        tmpImageView.alpha = 0.0
        
        dolphinImageView.addSubview(tmpImageView)
        
        UIView.animate(withDuration: 0.75, animations: {
            tmpImageView.alpha = 1.0
        }, completion: {
            finished in
            self.dolphinImageView.image = newImage
            tmpImageView.removeFromSuperview()
        })
    }
    
    func downloadMotivationalQuote() -> Quote {
        
        var newQuote: Quote!
        let url = URL(string: self.QUOTE_URL)
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url!, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Parse the data in the response and use it
            if error != nil {
                print("ERROR : " + error!.localizedDescription)
            } else {
                print(response ?? "ERROR : No response found")
                do {
                    //parsing the JSON respones and mapping to Quote object
                    let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let json = JSON(jsonObject)
                    
                    let contents = json["contents"].dictionary
                    let quoteArray = contents?["quotes"]?.array
                    
                    let jsonQuote = quoteArray?.first
                    newQuote = Quote(quote: (jsonQuote?["quote"].stringValue)!, author: (jsonQuote?["author"].stringValue)!, category: (jsonQuote?["category"].stringValue)!)!
                    
                } catch {
                    print("Error deserializing JSON \(error)")
                }
            }
        })
        task.resume()
        
        return newQuote
    }
    
    func fetchDolphinImage() {
        
        var tempDolphinArray = [DolphinImage]()
        var bossDolphin : DolphinImage!
        
        //build our request and inject our own header
        let url = URL(string: String(format: self.IMAGE_URL, 20, "dolphin", "newest"))
        var request = URLRequest(url: url!)
        request.setValue("yehymx4mpcazvquf5c72bawy", forHTTPHeaderField: "Api-Key")
        
        //session
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Parse the data in the response and use it
            if error != nil {
                print("ERROR : " + (error?.localizedDescription)!)
            } else {
                print(response ?? "ERROR : No response found")
                do {
                    //parsing the JSON respones and mapping to Quote object
                    let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let json = JSON(jsonObject)
                    
                    let imagesArray = json["images"].arrayValue
                    
                    for jsonObject in imagesArray {
                        let tinyJson = JSON(jsonObject)
                        
                        let tinyTitle = tinyJson["title"].stringValue
                        let tinyDisplaySizes = tinyJson["display_sizes"].arrayValue
                        let tinyDisplayUrl = tinyDisplaySizes.first?["uri"].stringValue
                        
                        tempDolphinArray.append(DolphinImage(title: tinyTitle, displayUrl: tinyDisplayUrl!)!)
                        print("\(tinyTitle) was added to array -> \(tempDolphinArray.count)")
                    }
                    
                } catch {
                    print("Error deserializing JSON \(error)")
                }
                
                //select random image to pass to our downloader
                let diceRoll = Int(arc4random_uniform(UInt32(tempDolphinArray.count)))
                bossDolphin = tempDolphinArray[diceRoll]
                
                print("bossDolphin added")
                self?.downloadDolphinImage(dolphinImage: bossDolphin)
            }
            
        })
        task.resume()
        
        print("fetch post task.resume()")
    }
    
    private func downloadDolphinImage(dolphinImage: DolphinImage) {
        
        print("download just inside")
        
        //build our request and inject our own header
        let url = URL(string: String(format: dolphinImage.displayUrl!))
        var request = URLRequest(url: url!)
        request.setValue("yehymx4mpcazvquf5c72bawy", forHTTPHeaderField: "Api-Key")
        
        //session
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Parse the data in the response and use it
            if error != nil {
                print("ERROR : " + (error?.localizedDescription)!)
            } else {
                print("download session datatask")
                print(response ?? "downloading - no response")
                print(data ?? "downloading - no data")
                
                if response != nil && data != nil {
                    
                    dolphinImage.image? = UIImage(data: data!)!
                    
                    //task with updating the imageview on the main thread
                    DispatchQueue.main.async {
                        print("download - on main thread")
                        
                        self?.fadeInNewImage(UIImage(data: data!)!)
                    }
                }
            }
        })
        task.resume()
        
        print("download - post task.resume()")
    }
}
