//
//  ViewController.swift
//  SlackAPI
//
//  Created by HongXuetao on 7/19/16.
//  Copyright © 2016 Awesome Inc. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var calendarTableView: UITableView!
    
    let slackChannelID = "C1T4JTCLU"
    
    var gtlCalendarEvetns: [GTLCalendarEvent]!
    
    //*********************************Calendar API (member variables or google API)**********************************
    //The google calendar API is taught here https://developers.google.com/google-apps/calendar/quickstart/ios?ver=swift
    //unique name for different google account. If kClientID is changed, kKeychainItemName should be changed too.
    private let kKeychainItemName = "Google Calendar API"
    //this is created by using Oauth,
    private let kClientID = "739355203143-ij8qqrgjs4i26v7sv4ofgsb5kts72d51.apps.googleusercontent.com"
    //this is id for google calendar, right now it is the id of conference room. (use calendar app)
    private let calendarID = "av1rspu9cnsotu0tcdncocqseg@group.calendar.google.com"
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    //this mean you can only read from google calendar, can't modify google calendar.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    private let service = GTLServiceCalendar()
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    //*********************************Calendar API end**********************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gtlCalendarEvetns = [];
        print("Viewload on VC**********")
        //establish connection with slack
        MessageCenterAPI.sharedInstance.configureChat()
        
        //*********************************Calendar API**********************************
        //????????????????????????????????????????????????????
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        //*********************************Calendar API end**********************************
    }

    override func viewDidAppear(animated: Bool) {
        //*********************************Calendar API**********************************
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            fetchEvents()
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
        //*********************************Calendar API end**********************************
    }

    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        
        //*********************************Calendar API**********************************
        let query = GTLQueryCalendar.queryForEventsListWithCalendarId(calendarID)
        query.maxResults = 10
        query.timeMin = GTLDateTime(date: NSDate(), timeZone: NSTimeZone.localTimeZone())
        query.singleEvents = true
        query.orderBy = kGTLCalendarOrderByStartTime
        print(query)
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: "displayResultWithTicket:finishedWithObject:error:"
        )
        //*********************************Calendar API end**********************************
        
    }
    
    //*********************************Calendar API**********************************
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
                           error : NSError?) {
        
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        var eventString = ""
        var calendarEvents: [GTLCalendarEvent] = []
        
        if let events = response.items() where !events.isEmpty {
            for event in events as! [GTLCalendarEvent] {
                let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                let startString = NSDateFormatter.localizedStringFromDate(
                    start.date,
                    dateStyle: .ShortStyle,
                    timeStyle: .ShortStyle
                )
                let end : GTLDateTime! = event.end.dateTime ?? event.start.date
                let endString = NSDateFormatter.localizedStringFromDate(
                    end.date,
                    dateStyle: .ShortStyle,
                    timeStyle: .ShortStyle
                )
                
                let location = event.location
                let unknown = "Unknown"
                
                eventString += "\(startString) - \(endString)- \(event.summary) - location is \(location ?? unknown) \n"
                
                calendarEvents.append(event)
            }
        } else {
            eventString = "No upcoming events found."
        }
        
        print(eventString)
        self.gtlCalendarEvetns = calendarEvents
        [calendarTableView .reloadData()]
    }
    //*********************************Calendar API end**********************************
    
    
    //*********************************Calendar API**********************************
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    //*********************************Calendar API end**********************************
    
    //*********************************Calendar API**********************************
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
    //*********************************Calendar API end**********************************
    
    //*********************************Calendar API**********************************
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertView(
            title: title,
            message: message,
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        alert.show()
    }
    //*********************************Calendar API end**********************************
    
    //*********************************Table View *********************************
    
    var people = [
        "aaa",
        "bbb",
        "ccc"
    ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.gtlCalendarEvetns != nil){
            return self.gtlCalendarEvetns.count}else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cellType",forIndexPath: indexPath) as UITableViewCell

        let summary = gtlCalendarEvetns[indexPath.row].summary
        cell.textLabel?.text = summary
        let eventDate = gtlCalendarEvetns[indexPath.row].start
        let start : GTLDateTime! = eventDate.dateTime ?? eventDate.date
        
        let wholeWeekString =  NSDateFormatter.localizedStringFromDate(
            start.date,
            dateStyle: .FullStyle,
            timeStyle: .ShortStyle
        )
        let index:String.Index = wholeWeekString.startIndex.advancedBy(3)
        var weekShortStyle:String
        weekShortStyle = wholeWeekString.substringToIndex(index)
        let startString = NSDateFormatter.localizedStringFromDate(
            start.date,
            
            dateStyle: .MediumStyle,
            timeStyle: .ShortStyle
        )
        let finalString = weekShortStyle.stringByAppendingFormat(" %@", startString)
        
        cell.detailTextLabel?.text = finalString
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Calendar of Events"
    }
    //*********************************Table View End*********************************

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

