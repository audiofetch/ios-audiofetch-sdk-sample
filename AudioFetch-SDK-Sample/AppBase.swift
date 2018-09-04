//
//  AppBase.swift
//  audiofetch
//
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

import UIKit

class AppBase: UIApplication {
    lazy var notify = NotificationCenter.default
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    /// Sends notification events for remote control use in control center
    ///
    /// - Parameter event: 
    override func remoteControlReceived(with event: UIEvent?) {
        if let evt = event {
            DLog("Received remote control event: \(evt)\n")
            switch evt.subtype {
            case .remoteControlPreviousTrack:
                notify.post(name: NSNotification.Name.backwardPressed, object: nil)
            case .remoteControlNextTrack:
                notify.post(name: NSNotification.Name.forwardPressed, object: nil)
            case .remoteControlPlay:
                notify.post(name: NSNotification.Name.playPressed, object: nil)
            case .remoteControlPause:
                notify.post(name: NSNotification.Name.pausePressed, object: nil)
            case .remoteControlStop:
                notify.post(name: NSNotification.Name.stopPressed, object: nil)
            default:
                break
            }
        }
    }
}
