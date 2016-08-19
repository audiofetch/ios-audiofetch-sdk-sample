//
//  ViewController.swift
//  AudioFetch-SDK-Sample
//
//  Copyright © 2016 Audio Fetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCurrentChannel: UILabel!
    @IBOutlet weak var labelCurrentName: UILabel!
    
    private let CELL_CHANNEL = "ChannelCell" // also enter this string as the cell identifier in the storyboard
    
    /*===========================
    // MARK: - DATA MEMBERS
    //===========================*/
    
    // appdelegate and notificationcenter
    private lazy var app = AppDelegate.sharedInstance
    private lazy var notify = NSNotificationCenter.defaultCenter()
    private lazy var mediaInfo = MPNowPlayingInfoCenter.defaultCenter()
    
    // business colleagues
    private lazy var audioMgr = AudioManager.sharedInstance()
    
    var channelArray = [Channel]()
    var selectedChannel:Channel?
    var currentChannelIndex = 0,
        discoSuccessCallbackCount = 0,
        discoFailureCallbackCount = 0
    
    
    /*=====================
    // MARK: - OVERRIDES
    //====================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeSlider.value = audioMgr.volume
        collectionView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        notify.removeObserver(self)
    }
    
    /*=====================
     // MARK: - UICollectionViewDataSource
     //====================*/
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_CHANNEL, forIndexPath: indexPath) as! ChannelCollectionViewCell
        
        cell.title_LB.text = String(format:"%d", indexPath.row + 1)
        cell.backgroundColor = UIColor.clearColor()
        cell.iconView.backgroundColor = UIColor.lightGrayColor()
        cell.iconView.layer.cornerRadius = 6.0
        cell.iconView.layer.borderWidth = 1.0
        cell.iconView.layer.borderColor = UIColor.grayColor().CGColor
        cell.iconView.layer.masksToBounds = true
        
        return cell
    }
    
    /*=====================
    // MARK: - UICollectionViewDelegate
    //====================*/
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        DLog("You selected cell #\(indexPath.item)!")
        setCurrentChannel(indexPath.row)
        updateNowPlaying()
    }
    
    /*=====================
    // MARK: - Notifications
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
                    self.labelCurrentChannel.text = ""
                    self.labelCurrentName.text = NSLocalizedString("No channels found!", comment: "No channels found!")
                }
            }
            if let dict = notification.userInfo as? [String : AnyObject]
                where nil != dict[channelsLoadedNotificationChannelsKey] && nil != dict[channelsLoadedNotificationAudioModeKey] {
                
                if let cnlList = dict[channelsLoadedNotificationChannelsKey] as? [Channel], // channel list
                    let audioMode = dict[channelsLoadedNotificationAudioModeKey] as? UInt { // 1 = mono, 2 = stereo
                    
                    if cnlList.count > 0 {
                        self.channelArray = cnlList
                        
                        DLog("Recieved list: \(cnlList) with audio mode:\(audioMode)")
                        
                        setCurrentChannel(0)
                        labelCurrentChannel.text = String(format:"%d", channelArray[0].channel)
                        labelCurrentName.text = channelArray[0].name
                        
                        collectionView.reloadData()
                        updateNowPlaying()
                    } else {
                        labelCurrentChannel.text = ""
                        labelCurrentName.text = NSLocalizedString("No channels found!", comment: "No channels found!")
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
                // load a default set of channels
                labelCurrentChannel.text = ""
                labelCurrentName.text = NSLocalizedString("No channels found!", comment: "No channels found!")
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
                    if !audioMgr.isAudioPlaying {
                        audioMgr.startAudio()
                    }
                } else {
                    if audioMgr.isAudioPlaying {
                        audioMgr.stopAudio()
                    }
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
            var channelName = String(format:STR_CHANNEL_NUM, NSNumber(unsignedLong: audioMgr.currentChannel + 1))
            
            if let currentCnl = selectedChannel
                where nil != currentCnl.name && !currentCnl.name.isEmpty {
                channelName = String(format:STR_CHANNEL_NUM, currentCnl.name)
            }
            
            self.mediaInfo.nowPlayingInfo = [
                MPMediaItemPropertyArtist : productName,
                MPMediaItemPropertyTitle : channelName,
                MPMediaItemPropertyArtwork : albumArt,
                MPNowPlayingInfoPropertyPlaybackRate : (audioMgr.isAudioPlaying) ? 1.0 : 0.0,
                MPNowPlayingInfoPropertyElapsedPlaybackTime : 0
            ]
        }
    }

    /*=====================
    // MARK: - IBActions
    //====================*/
    
    /**
     Calls setVolume and sets the volume
     */
    @IBAction func volumeChanged(sender : AnyObject?) {
        setVolume(volumeSlider.value)
    }
    
    /*=====================
    // MARK: - INSTANCE METHODS
    //====================*/
    
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
        if audioMgr.hasChannel(curCnl) {
            audioMgr.currentChannel = curCnl
            currentChannelIndex = channel
            labelCurrentChannel.text = String(format:"%d", channelArray[channel].channel)
            labelCurrentName.text = channelArray[channel].name
        }
    }
    
    /**
     Calls setCurrentChannel
     */
    func setChannel(channel : Channel, _ carouselIndex: Int) {
        let apbIdx = Int(channel.apbIndex)
        if audioMgr.allApbs.count > apbIdx,
            let apbs = audioMgr.allApbs as? [Apb] {
            let switchToChannel = Int(apbs[apbIdx].baseChannel) + Int(channel.channel)
            self.selectedChannel = channel
            
            DLog("SWITCHING TO CHANNEL: \(switchToChannel)")
            setCurrentChannel(switchToChannel)
        }
        updateNowPlaying()
    }
}

