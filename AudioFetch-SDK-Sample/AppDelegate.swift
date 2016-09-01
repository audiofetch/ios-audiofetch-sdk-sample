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

    lazy var sharedApplication = UIApplication.sharedApplication()

    /*=========================================
     // MARK: - INIT AND SINGLETON
     //========================================*/
    
    class var sharedInstance:AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate! as! AppDelegate
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
    
    /**
     Runs block on main thread
     */
    func runOnMainThread(closure : () -> ()) {
        dispatch_async(dispatch_get_main_queue(), closure)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        sharedApplication.beginReceivingRemoteControlEvents()
        registerDefaults()
        initStyles()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    /*=========================================
     // MARK: - INSTANCE METHODS
     //========================================*/
    
    /**
     Presents a standard alert dialog window, with only OK button
     
     @param title
     
     @param msg
     
     @param action - Provide an alt to ok only action
     */
    func alert(title : String, _ msg : String = "", _ action: UIAlertAction) {
        runOnUiThread {
            let alertDlg = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            alertDlg.addAction(action)
            if let vc = self.window?.rootViewController {
                vc.presentViewController(alertDlg, animated: true, completion: nil)
            }
        }
    }
    
    /**
     Displays a progress HUD (heads-up-display)
     
     @param msg
     
     @param title [optional]
     */
    func showHUD(msg : String) {
        if let win = self.window {
            if let view = win.rootViewController?.view {
                if nil == self.dynamicType.HUD {
                    self.dynamicType.HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
                    self.dynamicType.HUD.mode = .Indeterminate
                    self.dynamicType.isHUDShowing = true
                }
                
                if nil != self.dynamicType.HUD {
                    self.dynamicType.HUD.labelText = msg
                } else {
                    DLog("FAILED TO SHOW HUD!!!!")
                }
            }
        }
    }
    
    /**
     Updates an existing progress HUD message, or displays a new one
     
     @param msg
     
     @param title [optional]
     */
    func updateHUD(msg : String) {
        if nil != self.dynamicType.HUD {
            self.dynamicType.HUD.labelText = msg
            self.dynamicType.isHUDShowing = true
        } else {
            showHUD(msg)
        }
    }
    
    /**
     Hides the progress HUD
     */
    func hideHUD() {
        if nil != self.dynamicType.HUD {
            self.dynamicType.HUD.hide(true)
            self.dynamicType.HUD = nil
        }
        self.dynamicType.isHUDShowing = false
    }
    
    /**
     Displays a toast message, similar to Android toast message
     */
    func makeToast(msg: String, _ duration: NSTimeInterval = 2.5, _ position: String = CSToastPositionBottom, _ viewController: UIViewController? = nil) {
        if let vc = viewController {
            if nil != vc.view {
                vc.view.makeToast(msg, duration: duration, position: position)
            }
        } else if let win = self.window,
            let vc = win.rootViewController where nil != vc.view {
            vc.view.makeToast(msg, duration: duration, position: position)
        }
    }
    
    
    /**
     Displays the Wifi settings screen in the settings app
     */
    func showWifiSettings() {
        runOnUiThread {
            UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=WIFI")!)
        }
    }
    
    /**
     Register default preferences
     */
    func registerDefaults() {
        let defaults:[String : AnyObject] = [
            PREF_LAST_VOLUME : NSNumber(float: PREF_LAST_VOLUME_DEFAULT)
        ]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    }
    
    /**
     Sets up app styles
     */
    func initStyles() {
        if let win = self.window {
            win.tintColor = APP_COLOR_BLUE
            
            if let navVc = win.rootViewController as? UINavigationController,
                let rootVc = navVc.viewControllers[0] as? ViewController {
                rootVc.view.backgroundColor = UIColor.whiteColor()
                
                // add a system volume control so that the volume dialog doesn't show
                let volumeView = MPVolumeView(frame: CGRectMake(-2000, -2000, 0, 0))
                volumeView.alpha = 1
                volumeView.userInteractionEnabled = false
                win.addSubview(volumeView)
            }
        }
        
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = APP_COLOR_BLUE
        navBar.titleTextAttributes = [ NSFontAttributeName : APP_NAVBAR_FONT,
                                       NSForegroundColorAttributeName: UIColor.whiteColor() ]
        
        let slider = UISlider.appearance()
        slider.maximumTrackTintColor = APP_COLOR_SILVER
        slider.minimumTrackTintColor = APP_COLOR_ORANGE
    }

}

