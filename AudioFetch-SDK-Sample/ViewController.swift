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
    var toolbarButton: UIBarButtonItem!
    
    fileprivate let cellChannel = "ChannelCell" // also enter this string as the cell identifier in the storyboard
    
    /// Set this to the channel, on which, you want the player to start playing audio.
    fileprivate let startingChannel = 1
    
    /*===========================
    // MARK: - DATA MEMBERS
    //===========================*/
    
    fileprivate lazy var app = AppDelegate.sharedInstance
    fileprivate lazy var notify = NotificationCenter.default
    fileprivate lazy var mediaInfo = MPNowPlayingInfoCenter.default()
    fileprivate lazy var prefs = UserDefaults.standard
    
    // business colleagues
    fileprivate lazy var audioMgr = AudioManager.sharedInstance()!
    
    var channelArray = [Channel]()
    var selectedChannel:Channel?
    var currentChannelIndex = 0,
        discoSuccessCallbackCount = 0,
        discoFailureCallbackCount = 0
    
    var hasShownWifiSettings = false,
        isPlaying = true
    
    static var isWifiConnected = true
    
    /*=====================
    // MARK: - OVERRIDES
    //====================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clear
        
        labelCurrentName.font = APP_LABEL_FONT
        labelCurrentName.text = LOADING_CHANNELS
        
        
        labelVolume.font = APP_VOLUME_FONT
        labelCurrentChannel.font = APP_LABEL_FONT
        labelError.font = APP_LABEL_FONT
        
        navigationItem.title = APP_NAME
        navigationController?.navigationBar.isTranslucent = false
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarButton = UIBarButtonItem(image: UIImage(named: "ic_pause"), style: .plain, target: self, action: #selector(playPauseTapped(_:)))
        toolbarButton.tintColor = UIColor.white
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.backgroundColor = APP_COLOR_ORANGE
        setToolbarItems([flexSpace, toolbarButton, flexSpace], animated: true)
        
        if !audioMgr.isAudioPlaying {
            // show fetching audio message for a few seconds while discovery finishes
            app.showHUD(STR_FETCHING_AUDIO)
            afterDelay(5) {
                self.app.hideHUD()
            }
        }
        
        afterDelay(1.2) {
            self.setVolume(0.2)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        notify.removeObserver(self)
    }
    
    /*=====================
     // MARK: - UICollectionViewDataSource
     //====================*/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellChannel, for: indexPath) as! ChannelCollectionViewCell
        
        cell.channelText.font = UIFont(name: APP_PRIMARY_FONT_NAME, size: 14)
        cell.channelText.textColor = APP_COLOR_BLUE
        cell.channelText.text = getChannelName(indexPath.row)
        
        
        cell.channelLabel.font = UIFont(name: APP_BOLD_FONT_NAME, size: 14)
        cell.channelLabel.textColor = APP_COLOR_BLUE
        cell.backgroundColor = UIColor.clear
        cell.iconView.backgroundColor = APP_COLOR_SILVER
        cell.iconView.layer.cornerRadius = 6.0
        cell.iconView.layer.borderWidth = 1.0
        cell.iconView.layer.masksToBounds = true
        
        cell.iconView.layer.borderColor = UIColor.gray.cgColor
        if let selectedItem = collectionView.indexPathsForSelectedItems,
            selectedItem.contains(indexPath) {
            cell.iconView.layer.borderColor = APP_COLOR_ORANGE.cgColor
        }
        return cell
    }
    
    /*=====================
    // MARK: - UICollectionViewDelegate
    //====================*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            if let iconCell = cell as? ChannelCollectionViewCell {
                iconCell.iconView.layer.borderColor = UIColor.gray.cgColor
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? ChannelCollectionViewCell {
            cell.iconView.layer.borderColor = APP_COLOR_ORANGE.cgColor
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
    
    
    /// Sets up all the notification handlers
    func initNotifications() {
        let notificationsToObserve = [
            NSNotification.Name.channelsLoaded,
            NSNotification.Name.deviceDiscoveryFailed,
            NSNotification.Name.forwardPressed,
            NSNotification.Name.backwardPressed,
            NSNotification.Name.networkConnection,
            NSNotification.Name.hardwareButtonVolume
        ]
        for notification in notificationsToObserve {
            notify.addObserver(self, selector: #selector(ViewController.handleNotifications(_:)), name: notification, object: nil)
        }
    }
    
    /// Handlers for all the notifications.
    ///
    /// - Parameter notification: Notification to be processed
    @objc func handleNotifications(_ notification : Notification) {
        switch notification.name {
            
        //==================================================
        // MAIN DISCOVERY FINISHED: userInfo contains all the channels for UI to display
        case NSNotification.Name.channelsLoaded where nil != notification.userInfo: // triggered in AudioManager after discovery
            afterDelay(0.7) {
                if 0 == self.discoSuccessCallbackCount { // only trigger on first failure callback
                    self.showNotConnectedMessage()
                }
            }
            if let dict = notification.userInfo as? [String : AnyObject],
                nil != dict[channelsLoadedNotificationChannelsKey] && nil != dict[channelsLoadedNotificationAudioModeKey] {
                
                if let cnlList = dict[channelsLoadedNotificationChannelsKey] as? [Channel], // channel list
                    let audioMode = dict[channelsLoadedNotificationAudioModeKey] as? UInt { // 1 = mono, 2 = stereo
                    
                    if cnlList.count > 0 { // channels received from APBs
                        labelError.isHidden = true
                        app.hideHUD()
                        self.channelArray = cnlList
                        
                        DLog("Recieved list: \(cnlList) with audio mode:\(audioMode)")
                        collectionView.reloadData() // load UI channel grid first time
                        
                        if channelArray.count > startingChannel {
                            labelCurrentName.text = channelArray[startingChannel].name
                            audioMgr.startAudio(on: UInt(startingChannel))
                            afterDelay(0.5) {
                                // make the selection of grid view item happen through UI methods
                                self.setUIChannel(self.startingChannel)
                            }
                            updateNowPlaying()
                        }
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
        case NSNotification.Name.deviceDiscoveryFailed:
            if 0 == discoFailureCallbackCount {
                // load a default set of channels
                showNotConnectedMessage()
            }
            self.discoFailureCallbackCount += 1
            
        //==================================================
        // hardware volume button notification, object contains volume as float between 0 and 1
        case NSNotification.Name.hardwareButtonVolume where nil != notification.object:
            if let obj = notification.object,
                let volume = obj as? Float {
                volumeSlider.value = volume
                prefs.set(volumeSlider.value, forKey: PREF_LAST_VOLUME)
                prefs.synchronize()
            }
            
        //==================================================
        // lock-screen media controls notifications
        case NSNotification.Name.forwardPressed:
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
            
        case NSNotification.Name.backwardPressed:
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
        case NSNotification.Name.networkConnection where nil != notification.object:
            if let ob = notification.object {
                type(of: self).isWifiConnected = nil != (ob as? Bool) ? (ob as! Bool) : false
                
                if type(of: self).isWifiConnected {
                    if !audioMgr.isAudioPlaying {
                        audioMgr.startAudio()
                    }
                } else {
                    app.hideHUD()
                    if audioMgr.isAudioPlaying {
                        audioMgr.stopAudio()
                    }
                    
                    let okAction = UIAlertAction(title: STR_OK, style: .default, handler: { (action) in
                        if !self.hasShownWifiSettings {
                            if !type(of: self).isWifiConnected {
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
    
    
    /// Calls setVolume and sets the volume
    ///
    /// - Parameter sender:
    @IBAction func volumeChanged(_ sender : AnyObject?) {
        setVolume(volumeSlider.value)
    }
    
    
    /// Called when play/pause is tapped
    ///
    /// - Parameter sender:
    @IBAction func playPauseTapped(_ sender: AnyObject?) {
        if isPlaying {
            toolbarButton.image = UIImage(named: "ic_play")
            navigationController?.toolbar.backgroundColor = UIColor(hex: K_APP_COLOR_GREEN)
            runInBackground { [unowned self] in
                self.audioMgr.stopAudio()
            }
            isPlaying = false
        } else {
            toolbarButton.image = UIImage(named: "ic_pause")
            navigationController?.toolbar.backgroundColor = APP_COLOR_ORANGE
            runInBackground { [unowned self] in
                self.audioMgr.startAudio()
            }
            isPlaying = true
        }
    }
    
    /*=====================
    // MARK: - INSTANCE METHODS
    //====================*/
    
    
    /// Updates the lock-screen and MPNowPlayingInfoCenter
    func updateNowPlaying() {
        let productName = Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? APP_NAME
        
        if let icon = UIImage(named: "icon-512") {
            let albumArt = MPMediaItemArtwork(image: icon)
            let curChannel = audioMgr.currentChannel + 1
            var channelName = String(format:STR_CHANNEL_NUM, NSNumber(value: curChannel))
            
            if let currentCnl = selectedChannel,
                nil != currentCnl.name && !currentCnl.name.isEmpty {
                channelName = String(format:STR_CHANNEL_NUM, currentCnl.name).uppercased()
            } else if Int(audioMgr.currentChannel) < channelArray.count {
                let cnl = channelArray[Int(audioMgr.currentChannel)]
                channelName = String(format:STR_CHANNEL_NUM, cnl.name).uppercased()
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
    
    
    /// Displays the not connected message
    func showNotConnectedMessage() {
        app.hideHUD()
        labelCurrentName.text = CHANNELS_NOT_LOADED
        labelError.isHidden = false
        labelError.text = STR_NO_CONNECTION
    }
    
    
    /// Sets the volume on the AudioManager
    ///
    /// - Parameter volume:
    func setVolume(_ volume : Float) {
        DLog("SYSTEM VOLUME CHANGING TO: \(volume)")
        audioMgr.volume = volume
        prefs.set(volumeSlider.value, forKey: PREF_LAST_VOLUME)
        prefs.synchronize()
    }
    
    
    /// Sets the channel by changing the UI
    ///
    /// - Parameter channelIdx:
    func setUIChannel(_ channelIdx : Int) {
        if channelIdx < self.channelArray.count {
            let indexPath = IndexPath(row: channelIdx, section: 0)
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    
    /// Sets the current channel, by determining the actual APB channel number
    ///
    /// - Parameter channel:
    func setChannel(_ channel : Channel) {
        let apbIdx = Int(channel.apbIndex)
        if audioMgr.allApbs.count > apbIdx,
            let apbs = audioMgr.allApbs as? [Apb] {
            let switchToChannel = Int(apbs[apbIdx].baseChannel) + Int(channel.channel)
            self.selectedChannel = channel
            
            DLog("SWITCHING TO CHANNEL: \(switchToChannel)")
            setAudioManagerChannel(Int(switchToChannel))
        }
        updateNowPlaying()
    }
    
    
    /// Sets AudioManager to the specified channel
    ///
    /// - Parameter channel:
    func setAudioManagerChannel(_ channel : Int) {
        let curCnl = UInt(channel)
        if audioMgr.hasChannel(curCnl) {
            audioMgr.currentChannel = curCnl
        }
    }
    
    
    
    /// Returns the name for the given channel number
    ///
    /// - Parameter channel:
    /// - Returns: Returns the name for the given channel number
    func getChannelName(_ channel : Int) -> String {
        var cnlName = String(format: "%d", channel)
        
        if channel < channelArray.count {
            let cnl = channelArray[channel]
            if nil != cnl.name && !cnl.name.isEmpty {
                if cnl.name.length > 5 {
                    cnlName = NSString(string: cnl.name).substring(to: 5).uppercased()
                } else {
                    cnlName = cnl.name.uppercased()
                }
            }
        }
        return cnlName
    }
}

