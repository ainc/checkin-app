//
//  SlackAPI.swift
//  SlackAPI
//
//  Created by HongXuetao on 7/19/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SlackAPI: NSObject
{
    static let sharedInstance = SlackAPI()
    
    func rtm_start(completion: (String) -> Void)
    {
        
        //different
        Alamofire.request(.GET, Slack.URL.rtm.start, parameters: [Slack.param.token: Slack.token.bot]).responseJSON(completionHandler: {
            response in
            
            if (response.result.error != nil)
            {
                print("In SlackAPI response error: ")
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!);
            print(json);
            
            if let users = json[Slack.param.users].array
            {
                for user in users
                {
                    if user[Slack.param.name].string != nil && user[Slack.param.name].stringValue == Slack.misc.bot_name
                    {
                        MessageCenterAPI.sharedInstance.botID = user[Slack.param.id].string;
                    }
                }
            }
            
            if let url = json[Slack.param.url].string  
            {
                completion(url);  
            }
        })
        
      
    }
    
    func channels_join(channel_name:String, completion: (channelID: String) -> Void)
    {
        Alamofire.request(.GET, Slack.URL.channels.join, parameters: [Slack.param.token: Slack.token.admin, Slack.param.name: channel_name]).responseJSON {
            response in
            
            if (response.result.error != nil)
            {
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!);
            
            if  let channel = json[Slack.param.channel].dictionary,
                let channelID = channel[Slack.param.id]?.string
            {
                completion(channelID: channelID);  
            }
        }  
    }
    
    func channels_invite(channelID:String, userID:String, completion: (() -> Void)?)
    {
        Alamofire.request(.GET, Slack.URL.channels.invite, parameters: [Slack.param.token: Slack.token.admin, Slack.param.channel: channelID, Slack.param.user: userID]).responseJSON {
            response in
            
            if response.result.error != nil
            {
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!);
            
            print(json);
            
            if(completion != nil)
            {
                completion!();  
            }
        }  
    }
}


