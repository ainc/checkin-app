//
//  AwesomeUViewController.swift
//  SlackAPI
//
//  Created by HongXuetao on 8/6/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import UIKit

class AwesomeUViewController: UIViewController {
    
    let slackChannelID = "C1TJDNL7R"
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //******for youtube**********
        var youTubeLink: String = "https://www.youtube.com/embed/wuwgjpPsIDw"
        let width = 300
        let height = 200
        let frame = 0
        let Code:NSString = "<iframe width=\(width) height=\(height) src=\(youTubeLink) frameborder=\(frame) allowfullscreen></iframe>";
        self.webView.loadHTMLString(Code as String, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func notiyAwesomeU(sender: UIButton) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
