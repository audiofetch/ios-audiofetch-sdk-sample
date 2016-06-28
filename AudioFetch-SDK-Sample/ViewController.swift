//
//  ViewController.swift
//  AudioFetch-SDK-Sample
//
//  Created by Ryan Stickel on 6/13/16.
//  Copyright © 2016 Audio Fetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentChannel_LB: UILabel!
    @IBOutlet weak var currentName_LB: UILabel!
    
    let reuseIdentifier = "ChannelCell" // also enter this string as the cell identifier in the storyboard
    
    /*===========================
     // MARK: DATA MEMBERS
     //===========================*/
    
    // appdelegate and notificationcenter
    private lazy var app = AppDelegate.sharedInstance
    private lazy var notify = NSNotificationCenter.defaultCenter()
    private lazy var mediaInfo = MPNowPlayingInfoCenter.defaultCenter()
    
    // business colleagues
    private lazy var audioMgr = AudioManager.sharedInstance()
    
    var channelArray = [Channel]()
    var currentChannelIndex = 0;
    
    // ez plot / diagnostics mode
    private var
    discoSuccessCallbackCount = 0,
    discoFailureCallbackCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setCurrentChannel(0)
        
        
        volumeSlider.value = audioMgr.volume
        
        collectionView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initNotifications()
    }
    
    /*=====================
     // MARK: Notifications
     //====================*/
    
    /**
     Sets up all the notification handlers
     */
    func initNotifications() {
        let notificationsToObserve = [
            channelsLoadedNotification,
            deviceDiscoveryFailedNotification,
            forwardPressedNotification,
            backwardPressedNotification,
            networkConnectionNotification,
            hardwareButtonVolumeNotification
        ]
        for notification in notificationsToObserve {
            notify.addObserver(self, selector: #selector(ViewController.handleNotifications(_:)), name: notification, object: nil)
        }
    }
    
    /**
     Handlers for all the notifications.
     
     @param notification - NSNotification to be processed
     */
    func handleNotifications(notification : NSNotification) {
        switch notification.name {
            
            //==================================================
        // MAIN DISCOVERY FINISHED: userInfo contains all the channels for UI to display
        case channelsLoadedNotification where nil != notification.userInfo: // triggered in AudioManager after discovery
            afterDelay(0.7) {
                
                if 0 == self.discoSuccessCallbackCount { // only trigger on first failure callback
                    
                    DLog("FAILED TO DISCOVER AND DEMO MODE REJECTED!!!!!");
                }
            }
            if let dict = notification.userInfo as? [String : AnyObject]
                where nil != dict[channelsLoadedNotificationChannelsKey] && nil != dict[channelsLoadedNotificationAudioModeKey] {
                
                if let cnlList = dict[channelsLoadedNotificationChannelsKey] as? [Channel], // channel list
                    let audioMode = dict[channelsLoadedNotificationAudioModeKey] as? UInt { // 1 = mono, 2 = stereo
                    
                    if !audioMgr.isExpressDevice {
                        self.channelArray = cnlList
                        
                        DLog("Recieved list: \(cnlList) with audio mode:\(audioMode)")
                        
                        currentChannel_LB.text = String(format:"%d", channelArray[0].channel)
                        currentName_LB.text = channelArray[0].name
                        
                        collectionView.reloadData()
                        updateNowPlaying()
                    }
                    self.discoSuccessCallbackCount += 1
                } else { // channelsLoadedNotificationChannelsKey == NSNull if no channels
                    fallthrough // fallthrough to deviceDiscoveryFailedNotification
                }
            }
            //==================================================
        // DISCOVERY FAILED
        case deviceDiscoveryFailedNotification:
            if 0 == discoFailureCallbackCount {
                //self.wifiLabel.hidden = false
                //self.wifiLabel.text = APP_WIFI_MSG_BRANDED
                // only show toast the first tiem
                //self.app.makeToast(APP_WIFI_MSG_BRANDED)
                
                if !audioMgr.isExpressDevice {
                    // load a default set of channels
                    for i:UInt in 0..<16 {
                        channelArray.append(Channel(i, withName: "\(i+1)"))
                    }
                }
            }
            self.discoFailureCallbackCount += 1
            
            //==================================================
        // hardware volume button notification, object contains volume as float between 0 and 1
        case hardwareButtonVolumeNotification where nil != notification.object:
            if let obj = notification.object,
                let volume = obj as? Float {
                volumeSlider.value = volume
            }
            
            //==================================================
        // lock-screen media controls notifications
        case forwardPressedNotification:
            var idx = -1
            let channelCount = self.channelArray.count,
            curIdx = currentChannelIndex
            if (channelCount > (curIdx + 1)) {
                idx = curIdx + 1
            } else if !self.channelArray.isEmpty {
                idx = 0
            }
            if idx >= 0 {
                if idx < self.channelArray.count {
                    let channel = self.channelArray[idx]
                    setChannel(channel, idx)
                }
            }
            
        case forwardPressedNotification:
            var idx = -1
            if (self.channelArray.count > (currentChannelIndex + 1)) {
                idx = currentChannelIndex + 1
            } else if !self.channelArray.isEmpty {
                idx = 0
            }
            if idx >= 0 {
                if idx < self.channelArray.count {
                    let channel = self.channelArray[idx]
                    setChannel(channel, idx)
                    updateNowPlaying()
                }
            }
            
        case backwardPressedNotification:
            var idx = -1
            if (currentChannelIndex - 1) >= 0 {
                idx = currentChannelIndex - 1
            } else {
                idx = self.channelArray.count - 1
            }
            if idx >= 0 {
                if idx < self.channelArray.count {
                    let channel = self.channelArray[idx]
                    setChannel(channel, idx)
                    updateNowPlaying()
                }
            }
            
            
            //==================================================
        // wifi toggled/dropped notification, object contains a Bool
        case networkConnectionNotification where nil != notification.object:
            if let ob = notification.object {
                if let isWifiPresent = ob as? Bool where isWifiPresent {
                    //if isWifiMessageVisible {
                      //  hideWifiMessage()
                    //}
                    if !audioMgr.isAudioPlaying {
                        audioMgr.startAudio()
                    }
                } else {
                    if audioMgr.isAudioPlaying {
                        audioMgr.stopAudio()
                    }
                    //showWifiMessage()
                }
            }
        default:
            DLog("FAILED TO HANDLE NOTIFICATION: \(notification.name)")
        }
    }
    
    /**
     Updates the lock-screen and MPNowPlayingInfoCenter
     */
    func updateNowPlaying() {
        let productName = NSBundle.mainBundle().infoDictionary?["CFBundleDisplayName"] ?? APP_NAME
        
        if let icon = UIImage(named: "icon-512") {
            let albumArt = MPMediaItemArtwork(image: icon)
            let channelName = String(format:STR_CHANNEL_NUM, channelArray[currentChannelIndex].channel + 1)
            
            self.mediaInfo.nowPlayingInfo = [
                MPMediaItemPropertyArtist : productName,
                MPMediaItemPropertyTitle : channelName,
                MPMediaItemPropertyArtwork : albumArt,
                MPNowPlayingInfoPropertyPlaybackRate : (audioMgr.isAudioPlaying) ? 1.0 : 0.0,
                MPNowPlayingInfoPropertyElapsedPlaybackTime : 0
            ]
        }
    }
    
    /**
     Calls setVolume and sets the volume
     */
    @IBAction func volumeChanged(sender : AnyObject?) {
        setVolume(volumeSlider.value)
    }
    
    /**
     Sets the volume on the AudioManager
     */
    func setVolume(volume : Float) {
        DLog("SYSTEM VOLUME CHANGING TO: \(volume)")
        audioMgr.volume = volume
    }
    
    /**
     Sets the current chanel etc
     */
    func setCurrentChannel(channel : Int) {
        let curCnl = UInt(channel)
        if !audioMgr.demoModeEnabled {
            if audioMgr.hasChannel(curCnl) {
                audioMgr.currentChannel = curCnl
                currentChannelIndex = channel
                currentChannel_LB.text = String(format:"%d", channelArray[channel].channel)
                currentName_LB.text = channelArray[channel].name
            }
        } else {
            audioMgr.playDemoTrack(curCnl)
        }
    }
    
    /**
     Calls setCurrentChannel
     */
    func setChannel(channel : Channel, _ carouselIndex: Int) {
        // TODO: clean this up and handle it better within AudioManager
        let apbIdx = Int(channel.apbIndex)
        if audioMgr.allApbs.count > apbIdx,
            let apbs = audioMgr.allApbs as? [Apb] {
            // TODO: this logic seems too complicated for UI layer, and should be refactored lower in stack
            let switchToChannel = Int(apbs[apbIdx].baseChannel) + Int(channel.channel)
            
            DLog("SWITCHING TO CHANNEL: \(switchToChannel)")
            setCurrentChannel(switchToChannel)
            //updateChannelDisplay(carouselIndex)
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return channelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChannelCollectionViewCell
        
        cell.title_LB.text = String(format:"%d", indexPath.row + 1)
        cell.backgroundColor = UIColor.clearColor()
        cell.iconView.backgroundColor = UIColor.lightGrayColor()
        cell.iconView.layer.cornerRadius = 6.0
        cell.iconView.layer.borderWidth = 1.0
        cell.iconView.layer.borderColor = UIColor.grayColor().CGColor
        cell.iconView.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        setCurrentChannel(indexPath.row)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

