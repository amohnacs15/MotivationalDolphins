//
//  ViewController.swift
//  MotivationalDolphins
//
//  Created by Adrian Max Mohnacs on 8/26/17.
//  Copyright © 2017 Adrian Max Mohnacs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let QUOTE_URL: String = "https://quotes.rest/qod"
    
    @IBOutlet weak var quoteTextView: UILabel!
    @IBOutlet weak var authorTextView: UILabel!
    @IBOutlet weak var diveinButton: UIButton!
    @IBOutlet weak var contactDevButton: UIButton!
    
    
    //MARK: lifecycle methods for your View Controller
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createButtonBorder(button: diveinButton)
        createButtonBorder(button: contactDevButton)
        
        hideNavigationController()
        
    }
    
    //this is our main guy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quoteTextView.alpha = 0
        self.authorTextView.alpha = 0
        
        contactDevButton.addTarget(self,
                                   action: #selector(self.onContactClick(button:)),
                                   for: .touchUpInside)
        
        
        
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
    
    //view methods
    
    private func hideNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    public func createDialog(dialogButtonText: String, title: String, message: String) {
        
        let contactAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        contactAlert.addAction(UIAlertAction(title: dialogButtonText, style: .default, handler: { (action: UIAlertAction!) in
            
            if title == "Reach Out" {
                //make phone call
                let number = URL(string: "tel://" + "5712428438")
                UIApplication.shared.open(number!, options: [:], completionHandler: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        present(contactAlert, animated: true, completion: nil)
    }
    
    private func createButtonBorder(button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = (UIColor.white).cgColor
    }
    
    //action methods
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // save something
        //self.dismiss(animated: true, completion: nil)
        createDialog(dialogButtonText: "Cool", title: "Feature Locked!", message: "Plan a date with the developer of this application to unlock")
        
    }
    
    @IBAction func diveButtonTapped(_ sender: UIButton) {
        print("onDiveInClick")
        
        DispatchQueue.global(qos: .userInitiated).async { //qos means Quality of Service = Priority
            
            print("dispatch global queue")
            
            self.downloadMotivationalQuote()
        }
    }
    
    @IBAction func longPressEasterEgg(_ sender: UILongPressGestureRecognizer) {
        print("gotcha long press")
        //Do Whatever You want on End of Gesture
        
        createDialog(dialogButtonText: "Mission Accepted", title: "Welcome, Secret Agent",
                     message: "Congratulations. You've found one of the app's many hidden features. For having worked so hard to find it this app's developer now owes you one night out in Washington DC. \n\n Something you should know about the dev is that one of his favorite things to do is visit the Natural History Museum. Stemming from his youthful desires to become a Paleontologist and travel the world's deserts. Now, he honors those memories of a lost childhood by revisitng the museums.\n\n Mission: Spend the whole day inside the Natural History Museum with him BUT as adults we sneak in mixed drinks and snacks")
    }
    
    @objc private func onContactClick(button: UIButton) {
        print("onContactClick")
        
        createDialog(dialogButtonText: "OK", title: "Reach Out", message: "You now have your very own developer available to you at any hour whenever you need assistance. Give him a call.")
    }
    
    func downloadMotivationalQuote() {
        
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
                    
                    if json["success"].dictionary == nil {
                        print("You've hit the quotes limit")
                        
                        let happyError = json["error"].dictionary
                        let code = happyError?["code"]?.stringValue
                        let message = happyError?["message"]?.stringValue
                        
                        newQuote = Quote(quote: "\(code!) \(message!)", author: "Sorry about that", category: "broken")!
                        
                    } else {
                        
                        let contents = json["contents"].dictionary
                        let quoteArray = contents?["quotes"]?.array
                        
                        let jsonQuote = quoteArray?.first
                        newQuote = Quote(quote: (jsonQuote?["quote"].stringValue)!, author: (jsonQuote?["author"].stringValue)!, category: (jsonQuote?["category"].stringValue)!)!
                        
                    }
                    //MARK: our main work here after loading
                    DispatchQueue.main.async {
                        print("main async")
                        //reseting alphas for animation
                        self?.quoteTextView.alpha = 0
                        self?.authorTextView.alpha = 0
                        
                        //where display out new quote and author on the main thread
                        self?.quoteTextView.text = newQuote.quote
                        self?.authorTextView.text = "- \(newQuote.author!)"
                        
                        self?.fadeViewIn()
                    }
                } catch {
                    print("Error deserializing JSON \(error)")
                }
            }
        })
        task.resume()
    }
    
    
    func fadeViewIn() {
        
        
        UIView.animate(withDuration: 1.5,
                       animations: {
                        self.quoteTextView.alpha = 1.0
                        self.authorTextView.alpha = 1.0
        })
        
    }
    
    func longTap(sender : UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
            
            createDialog(dialogButtonText: "Thank You", title: "Well, look at what we found",
                         message: "Congratulations. You've found one of the many hidden feature inside the app. For having worked so hard to find it this app's developer now owes you one night out in Washington DC. \n\n Something you should know about the dev is that one of this favorite things to do is visit the Natural History Museum. Stemming from his youthful desires to become a Paleontologist and travel the world's desserts. Now, he honors those memories of a lost childhood by revisitng the museums.\n\n Mission: Spend the whole day inside the Natural History Museum with Adrian but as adults we sneak in mixed drinks and snacks")
            
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
        }
    }
}

