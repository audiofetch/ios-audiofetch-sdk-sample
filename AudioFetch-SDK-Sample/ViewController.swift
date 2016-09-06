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
    
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var labelVolume: UILabel!
    @IBOutlet weak var labelCurrentChannel: UILabel!
    @IBOutlet weak var labelCurrentName: UILabel!
    
    private let CELL_CHANNEL = "ChannelCell" // also enter this string as the cell identifier in the storyboard
    
    /*===========================
    // MARK: - DATA MEMBERS
    //===========================*/
    
    private lazy var app = AppDelegate.sharedInstance
    private lazy var notify = NSNotificationCenter.defaultCenter()
    private lazy var mediaInfo = MPNowPlayingInfoCenter.defaultCenter()
    private lazy var prefs = NSUserDefaults.standardUserDefaults()
    
    // business colleagues
    private lazy var audioMgr = AudioManager.sharedInstance()
    
    var channelArray = [Channel]()
    var selectedChannel:Channel?
    var currentChannelIndex = 0,
        discoSuccessCallbackCount = 0,
        discoFailureCallbackCount = 0
    
    var hasShownWifiSettings = false
    
    static var isWifiConnected = true
    
    /*=====================
    // MARK: - OVERRIDES
    //====================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clearColor()
        
        labelCurrentName.font = APP_LABEL_FONT
        labelCurrentName.text = LOADING_CHANNELS
        
        
        labelVolume.font = APP_VOLUME_FONT
        labelCurrentChannel.font = APP_LABEL_FONT
        labelError.font = APP_LABEL_FONT
        
        navigationItem.title = APP_NAME
        navigationController?.navigationBar.translucent = false
        
        if !audioMgr.isAudioPlaying {
            // show fetching audio message for a few seconds while discovery finishes
            app.showHUD(STR_FETCHING_AUDIO)
            afterDelay(5) {
                self.app.hideHUD()
            }
        }
        
        afterDelay(1.2) {
            self.setVolume(self.prefs.floatForKey(PREF_LAST_VOLUME))
        }
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
        
        cell.channelText.font = UIFont(name: APP_PRIMARY_FONT_NAME, size: 14)
        cell.channelText.textColor = APP_COLOR_BLUE
        cell.channelText.text = getChannelName(indexPath.row)
        
        
        cell.channelLabel.font = UIFont(name: APP_BOLD_FONT_NAME, size: 14)
        cell.channelLabel.textColor = APP_COLOR_BLUE
        cell.backgroundColor = UIColor.clearColor()
        cell.iconView.backgroundColor = APP_COLOR_SILVER
        cell.iconView.layer.cornerRadius = 6.0
        cell.iconView.layer.borderWidth = 1.0
        cell.iconView.layer.masksToBounds = true
        
        cell.iconView.layer.borderColor = UIColor.grayColor().CGColor
        if let selectedItem = collectionView.indexPathsForSelectedItems()
            where selectedItem.contains(indexPath) {
            cell.iconView.layer.borderColor = APP_COLOR_ORANGE.CGColor
        }
        return cell
    }
    
    /*=====================
    // MARK: - UICollectionViewDelegate
    //====================*/
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        for cell in collectionView.visibleCells() {
            if let iconCell = cell as? ChannelCollectionViewCell {
                iconCell.iconView.layer.borderColor = UIColor.grayColor().CGColor
            }
        }
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ChannelCollectionViewCell {
            cell.iconView.layer.borderColor = APP_COLOR_ORANGE.CGColor
        }
        DLog("You selected cell #\(indexPath.item)!")
        currentChannelIndex = indexPath.row
        labelCurrentName.text = getChannelName(currentChannelIndex)
        setChannel(channelArray[currentChannelIndex])
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
                    self.showNotConnectedMessage()
                }
            }
            if let dict = notification.userInfo as? [String : AnyObject]
                where nil != dict[channelsLoadedNotificationChannelsKey] && nil != dict[channelsLoadedNotificationAudioModeKey] {
                
                if let cnlList = dict[channelsLoadedNotificationChannelsKey] as? [Channel], // channel list
                    let audioMode = dict[channelsLoadedNotificationAudioModeKey] as? UInt { // 1 = mono, 2 = stereo
                    
                    if cnlList.count > 0 { // channels received from APBs
                        labelError.hidden = true
                        app.hideHUD()
                        self.channelArray = cnlList
                        
                        DLog("Recieved list: \(cnlList) with audio mode:\(audioMode)")
                        labelCurrentName.text = channelArray[0].name
                        collectionView.reloadData() // load UI channel grid first time
                        
                        afterDelay(0.5) {
                            // make the selection of grid view item happen through UI methods
                            self.setUIChannel(0)
                        }
                        updateNowPlaying()
                    } else {
                        // TODO: may want to implement 0..15 channel grid since this indicates old firmware, as an APB was discovered, just no channels
                        showNotConnectedMessage()
                    }
                    self.discoSuccessCallbackCount += 1 // prevent not connected message from showing
                    
                } else { // channelsLoadedNotificationChannelsKey == NSNull if no channels
                    // TODO: may want to implement 0..15 channel grid since this indicates old firmware, as an APB was discovered, just no channels
                    fallthrough // fallthrough to deviceDiscoveryFailedNotification
                }
            }
        //==================================================
        // DISCOVERY FAILED
        case deviceDiscoveryFailedNotification:
            if 0 == discoFailureCallbackCount {
                // load a default set of channels
                showNotConnectedMessage()
            }
            self.discoFailureCallbackCount += 1
            
        //==================================================
        // hardware volume button notification, object contains volume as float between 0 and 1
        case hardwareButtonVolumeNotification where nil != notification.object:
            if let obj = notification.object,
                let volume = obj as? Float {
                volumeSlider.value = volume
                prefs.setFloat(volumeSlider.value, forKey: PREF_LAST_VOLUME)
                prefs.synchronize()
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
                    setUIChannel(idx)
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
                    setUIChannel(idx)
                    updateNowPlaying()
                }
            }
            
            
        //==================================================
        // wifi toggled/dropped notification, object contains a Bool
        case networkConnectionNotification where nil != notification.object:
            if let ob = notification.object {
                self.dynamicType.isWifiConnected = nil != (ob as? Bool) ? (ob as! Bool) : false
                
                if self.dynamicType.isWifiConnected {
                    if !audioMgr.isAudioPlaying {
                        audioMgr.startAudio()
                    }
                } else {
                    app.hideHUD()
                    if audioMgr.isAudioPlaying {
                        audioMgr.stopAudio()
                    }
                    
                    let okAction = UIAlertAction(title: STR_OK, style: .Default, handler: { (action) in
                        if !self.hasShownWifiSettings {
                            if !self.dynamicType.isWifiConnected {
                                self.app.showWifiSettings()
                            }
                            self.hasShownWifiSettings = true
                        }
                    })
                    app.alert(APP_WIFI_MSG_BRANDED_SHORT, APP_WIFI_MSG_BRANDED, okAction)
                }
            }
        default:
            DLog("FAILED TO HANDLE NOTIFICATION: \(notification.name)")
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
     Updates the lock-screen and MPNowPlayingInfoCenter
     */
    func updateNowPlaying() {
        let productName = NSBundle.mainBundle().infoDictionary?["CFBundleDisplayName"] ?? APP_NAME
        
        if let icon = UIImage(named: "icon-512") {
            let albumArt = MPMediaItemArtwork(image: icon)
            var channelName = String(format:STR_CHANNEL_NUM, NSNumber(unsignedLong: audioMgr.currentChannel + 1))
            
            if let currentCnl = selectedChannel
                where nil != currentCnl.name && !currentCnl.name.isEmpty {
                channelName = String(format:STR_CHANNEL_NUM, currentCnl.name).uppercaseString
            } else if Int(audioMgr.currentChannel) < channelArray.count {
                let cnl = channelArray[Int(audioMgr.currentChannel)]
                channelName = String(format:STR_CHANNEL_NUM, cnl.name).uppercaseString
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
    
    /**
     Displays the not connected message
     */
    func showNotConnectedMessage() {
        app.hideHUD()
        labelCurrentName.text = CHANNELS_NOT_LOADED
        labelError.hidden = false
        labelError.text = STR_NO_CONNECTION
    }
    
    /**
     Sets the volume on the AudioManager
     */
    func setVolume(volume : Float) {
        DLog("SYSTEM VOLUME CHANGING TO: \(volume)")
        audioMgr.volume = volume
        prefs.setFloat(volumeSlider.value, forKey: PREF_LAST_VOLUME)
        prefs.synchronize()
    }
    
    /**
     Sets the channel by changing the UI
     */
    func setUIChannel(channelIdx : Int) {
        if channelIdx < self.channelArray.count {
            let indexPath = NSIndexPath(forRow: channelIdx, inSection: 0)
            self.collectionView(self.collectionView, didSelectItemAtIndexPath: indexPath)
            self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredVertically)
        }
    }
    
    /**
     Sets the current channel, by determining the actual APB channel number
     */
    func setChannel(channel : Channel) {
        let apbIdx = Int(channel.apbIndex)
        if audioMgr.allApbs.count > apbIdx,
            let apbs = audioMgr.allApbs as? [Apb] {
            let switchToChannel = Int(apbs[apbIdx].baseChannel) + Int(channel.channel)
            self.selectedChannel = channel
            
            DLog("SWITCHING TO CHANNEL: \(switchToChannel)")
            setAudioManagerChannel(switchToChannel)
        }
        updateNowPlaying()
    }
    
    /**
     Sets AudioManager to the specified channel
     */
    func setAudioManagerChannel(channel : Int) {
        let curCnl = UInt(channel)
        if audioMgr.hasChannel(curCnl) && channel < channelArray.count {
            audioMgr.currentChannel = curCnl
        }
    }
    
    
    /**
     @return Returns the name for the given channel number
     */
    func getChannelName(channel : Int) -> String {
        var cnlName = String(format: "%d", channel)
        
        if channel < channelArray.count {
            let cnl = channelArray[channel]
            if nil != cnl.name && !cnl.name.isEmpty {
                if cnl.name.length > 5 {
                    cnlName = cnl.name.uppercaseString.substringToIndex(cnl.name.startIndex.advancedBy(5))
                } else {
                    cnlName = cnl.name.uppercaseString
                }
            }
        }
        return cnlName
    }
}

