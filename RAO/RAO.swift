//
//  RAO.swift
//  RAO
//
//  Created by Antonio J Rossi on 7/1/15.
//  Copyright (c) 2015 Antonio J Rossi. All rights reserved.
//

import Cocoa

public class RunningApplicationObserver: NSObject {
    
    public typealias SimpleClosure = () -> ()
    let appName: NSString
    var launchedClosure: SimpleClosure?
    var terminatedClosure: SimpleClosure?
    
    public init(appName: NSString) {
        self.appName = appName
        super.init()
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "appLaunched:", name: NSWorkspaceDidLaunchApplicationNotification, object: nil)
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "appTerminated:", name: NSWorkspaceDidTerminateApplicationNotification, object: nil)
    }
    
    public func whenLaunched(closure: SimpleClosure) {
        self.launchedClosure = closure
    }
    
    public func whenTerminated(closure: SimpleClosure) {
        self.terminatedClosure = closure
    }
    
    public func isRunning() -> Bool {
        return !NSWorkspace.sharedWorkspace().runningApplications.filter(){
            (item: AnyObject) -> Bool in
                return (item as NSRunningApplication).bundleIdentifier == self.appName
        }.isEmpty
    }
    
    func appLaunched(notification: NSNotification) {
        notificationReceived(notification, closure: self.launchedClosure)
    }
    
    func appTerminated(notification: NSNotification) {
        notificationReceived(notification, closure: self.terminatedClosure)
    }
    
    func notificationReceived(notification: NSNotification, closure: SimpleClosure?) {
        if let info = notification.userInfo {
            let runningApplication = info[NSWorkspaceApplicationKey] as NSRunningApplication
            if runningApplication.bundleIdentifier! == self.appName {
                closure?()
            }
        }
    }
}
