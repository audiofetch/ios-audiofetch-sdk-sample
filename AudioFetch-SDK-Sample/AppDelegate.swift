//
//  AppDelegate.swift
//  AudioFetch-SDK-Sample
//
//  Created by Ryan Stickel on 6/13/16.
//  Copyright © 2016 Audio Fetch. All rights reserved.
//

import UIKit

//@UIApplicationMain // See main.swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var isHUDShowing = false
    static var HUD:MBProgressHUD!
    
    var window: UIWindow?
    lazy var sharedApplication = UIApplication.shared

    /*=========================================
     // MARK: - INIT AND SINGLETON
     //========================================*/
    
    
    /// Singleton
    class var sharedInstance:AppDelegate {
        get {
            return UIApplication.shared.delegate! as! AppDelegate
        }
    }
    
    override init() {
        super.init()
        
        NSSetUncaughtExceptionHandler { (exception) -> Void in
            print("UNCAUGHT EXCEPTION!!!\n===========================\n\n")
            print(exception)
            print(exception.callStackSymbols)
        }
    }
    
    
    /// Runs block on main thread
    ///
    /// - Parameter closure:
    func runOnMainThread(_ closure : @escaping () -> ()) {
        DispatchQueue.main.async(execute: closure)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        sharedApplication.beginReceivingRemoteControlEvents()
        registerDefaults()
        initStyles()
        return true
    }

    
    /*=========================================
     // MARK: - INSTANCE METHODS
     //========================================*/
    
    /// Presents a standard alert dialog window, with only OK button
    ///
    /// - Parameters:
    ///   - title:
    ///   - msg:
    ///   - action:
    func alert(_ title : String, _ msg : String = "", _ action: UIAlertAction) {
        runOnUiThread {
            let alertDlg = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alertDlg.addAction(action)
            if let vc = self.window?.rootViewController {
                vc.present(alertDlg, animated: true, completion: nil)
            }
        }
    }
    
    /// Displays a progress HUD (heads-up-display)
    ///
    /// - Parameter msg:
    func showHUD(_ msg : String) {
        if let win = self.window {
            if let view = win.rootViewController?.view {
                if nil == type(of: self).HUD {
                    type(of: self).HUD = MBProgressHUD.showAdded(to: view, animated: true)
                    type(of: self).HUD.mode = .indeterminate
                    type(of: self).isHUDShowing = true
                }
                
                if nil != type(of: self).HUD {
                    type(of: self).HUD.labelText = msg
                } else {
                    DLog("FAILED TO SHOW HUD!!!!")
                }
            }
        }
    }
    
    /// Updates an existing progress HUD message, or displays a new one
    ///
    /// - Parameter msg:
    func updateHUD(_ msg : String) {
        if nil != type(of: self).HUD {
            type(of: self).HUD.labelText = msg
            type(of: self).isHUDShowing = true
        } else {
            showHUD(msg)
        }
    }
    
    /// Hides the progress HUD
    func hideHUD() {
        if nil != type(of: self).HUD {
            type(of: self).HUD.hide(true)
            type(of: self).HUD = nil
        }
        type(of: self).isHUDShowing = false
    }
    
    /// Displays the Wifi settings screen in the settings app
    func showWifiSettings() {
        runOnUiThread {
            UIApplication.shared.openURL(URL(string: "prefs:root=WIFI")!)
        }
    }
    
    /// Register default preferences
    func registerDefaults() {
        let defaults:[String : AnyObject] = [
            PREF_LAST_VOLUME : NSNumber(value: PREF_LAST_VOLUME_DEFAULT as Float)
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    /// Sets up app styles
    func initStyles() {
        if let win = self.window {
            win.tintColor = APP_COLOR_BLUE
            
            if let navVc = win.rootViewController as? UINavigationController,
                let rootVc = navVc.viewControllers[0] as? ViewController {
                rootVc.view.backgroundColor = UIColor.white
                
                // add a system volume control so that the volume dialog doesn't show
                let volumeView = MPVolumeView(frame: CGRect(x: -2000, y: -2000, width: 0, height: 0))
                volumeView.alpha = 1
                volumeView.isUserInteractionEnabled = false
                win.addSubview(volumeView)
            }
        }
        
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = APP_COLOR_BLUE
        navBar.titleTextAttributes = [ NSAttributedStringKey.font : APP_NAVBAR_FONT,
                                       NSAttributedStringKey.foregroundColor: UIColor.white ]
        
        let slider = UISlider.appearance()
        slider.maximumTrackTintColor = APP_COLOR_SILVER
        slider.minimumTrackTintColor = APP_COLOR_ORANGE
    }

}

