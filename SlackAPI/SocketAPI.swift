//
//  SocketAPI.swift
//  SlackAPI
//
//  Created by HongXuetao on 7/19/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class SocketAPI: NSObject, WebSocketDelegate
{
    static let sharedInstance = SocketAPI()
    
    var socket:WebSocket?
    
    var isConnected:Bool {
        return self.socket?.isConnected ?? false;
    }
    
    func connect(url:NSURL)
    {
        self.socket = WebSocket(url: url)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect()
    {
        socket?.disconnect()
        socket = nil
    }
    
    func sendMessage(id:Int, type:String, channelID:String, text:String)
    {
        var json:JSON = [Slack.param.id: id,
                         Slack.param.type: type,
                         Slack.param.channel: channelID,
                         Slack.param.text: text];
        
        if let string = json.rawString()
        {
            self.send(string);  
        }
    }
    
    func send(message:String)
    {
        if let socket = self.socket
        {
            if(!socket.isConnected)
            {
                return;
            }
            
            print(message);
            
            socket.writeString(message);  
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String)
    {
        print("websocketDidReceiveMessage:: \(text)");
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }

}
