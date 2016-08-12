//
//  AwesomeIncViewController.swift
//  SlackAPI
//
//  Created by HongXuetao on 8/4/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import UIKit

class AwesomeIncViewController: UIViewController {
    
    //id for ainc
    let slackChannelID = "C1TJ547HC"
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Viewload on CalendarAPI**********")
        
        //******for youtube url**********
        var youTubeLink: String = "https://www.youtube.com/embed/Oz9RdQC5KbY"
        let width = 300
        let height = 200
        let frame = 0
        let Code:NSString = "<iframe width=\(width) height=\(height) src=\(youTubeLink) frameborder=\(frame) allowfullscreen></iframe>";
        self.webView.loadHTMLString(Code as String, baseURL: nil)
        
    }
    
    @IBAction func NotifyAwesomeInc(sender: AnyObject) {
        let alertController = UIAlertController(title: "Awesome Inc", message: "Do you want to notify Awesome Inc staff for further assisstance.", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Notify", style: .Default) { (action) in
            SocketAPI.sharedInstance.sendMessage(0, type: "message", channelID: self.slackChannelID, text: "This is check-in-bot, someone is ringing the bell!")
        }
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
