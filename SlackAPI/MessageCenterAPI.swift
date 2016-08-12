//
//  MessageCenterAPI.swift
//  SlackAPI
//
//  Created by HongXuetao on 7/19/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import UIKit
import Alamofire

class MessageCenterAPI: NSObject
{
    let slackChannelID = "C1TJ547HC"
    static let sharedInstance = MessageCenterAPI();
    
    var botID:String?
    
    func configureChat()
    {
        SlackAPI.sharedInstance.rtm_start {
            (url:String) -> Void in
            
            SocketAPI.sharedInstance.connect(NSURL(string: url)!);
            
// use to join the channel
//            self.inviteBotToChannel()
            
            return;  
        }
        
// use to join the channel       SlackAPI.sharedInstance.channels_join("ainc") {
//            (channelID:String) -> Void in
//            print("In MessageCenterAPI when call channels_join the ID is",channelID)
//        }
        
        
    }
    
    func inviteBotToChannel()
    {
        if(self.botID == nil)
        {
            return;
        }
        
        SlackAPI.sharedInstance.channels_invite(slackChannelID, userID: self.botID!, completion: nil);
    }
}
