//
//  AppBase.swift
//  audiofetch
//
//  Created by Patron on 5/16/16.
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

import UIKit

class AppBase: UIApplication {
    lazy var notify = NSNotificationCenter.defaultCenter()
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    /**
     Sends notification events for remote control use in control center
     
     @param event - UIEvent
     */
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if let evt = event {
            DLog("Received remote control event: \(evt)\n")
            switch evt.subtype {
            case .RemoteControlPreviousTrack:
                notify.postNotificationName(backwardPressedNotification, object: nil)
            case .RemoteControlNextTrack:
                notify.postNotificationName(forwardPressedNotification, object: nil)
            
            case .RemoteControlPlay:
                notify.postNotificationName(playPressedNotification, object: nil)
            case .RemoteControlPause:
                notify.postNotificationName(pausePressedNotification, object: nil)
            case .RemoteControlStop:
                notify.postNotificationName(stopPressedNotification, object: nil)
            default:
                break
            }
        }
    }
}
