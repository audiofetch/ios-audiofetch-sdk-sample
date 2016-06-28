//
//  Extensions.swift
//
//

import Foundation

/*==============================================================================================
// MARK: - GLOBAL FUNCTIONS
//============================================================================================*/

/**
@brief Replacement for Obj-C @synchronized block
*/
func synced(closure: () -> ()) {
    let lockQueue = dispatch_queue_create("com.audiofetch.LockQueue", nil)
    dispatch_sync(lockQueue) {
        closure()
    }
    
//    objc_sync_enter(lock)
//    closure()
//    objc_sync_exit(lock)
}

/**
 @brief runs code in background
 */
func runInBackground(closure: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
        closure()
    }
}

/**
 Runs block on main UIs
 */
func runOnUiThread(closure : () -> ()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}

/**
 Utility function to show installed fonts
 */
func showInstalledFonts() {
    for family: String in UIFont.familyNames() {
        DLog("\(family)")
        for names: String in UIFont.fontNamesForFamilyName(family) {
            DLog("== \(names)")
        }
    }
}

//func methodNotImplementedException() {
//    var error: NSError?
//    NSException.raise("MethodNotImplementedException", format: "rename must be overriden in sub-classes: %@", arguments: getVaList([error ?? "nil"]))
//}
//
//func illegalStateException(_ msg : String = "In invalid state was encountered") {
//    let error: NSError?
//    NSException.raise("IllegalStateException", format: "\(msg)\n\n %@", arguments: getVaList([error ?? "nil"]))
//}


/**
 Returns the index of object in array

 @param arr - The array
 
 @param object - The object needing identified by index number
 */
func indexOfObject<T:Equatable>(arr : Array<T>, object : T) -> Int {
    if let found = arr.indexOf(object) {
        return found
    }
    return NSNotFound
}

/**
 Prints Diagnostic logs to consol
 
 @param msg - String to printed
 */
func DLog(msg : String) {
    print("\n\n======>>>>>>>\n\(msg)\n")
}

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item : Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    func peek() -> Element? {
        return items.last
    }
}

/*==============================================================================================
// MARK: - NSDate
//============================================================================================*/


/**
 @brief NSDate extensions
 */
extension NSDate {
    class func unixTime() -> NSTimeInterval {
        let dt = NSDate()
        return dt.timeIntervalSince1970
    }
    
    class func localTimeOffsetSeconds() -> Int64 {
//        let tz = NSTimeZone.systemTimeZone()
        let tz = NSTimeZone.localTimeZone()
        return Int64(tz.secondsFromGMT)
    }
    
    class func localTimeZoneOffsetMs() -> Int64 {
        let ms = NSDate.localTimeOffsetSeconds() * 1000
        return ms
    }
}

/*==============================================================================================
// MARK: - NSData
//============================================================================================*/

/**
@brief NSData extensions
*/
extension NSData {
    func toUInt8Array() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytes = [UInt8](count: count, repeatedValue: 0x00)
        let len = count * sizeof(UInt8)
        self.getBytes(&bytes, length: len)
        return bytes
    }
}

/*==============================================================================================
// MARK: - UIViewController
//============================================================================================*/

/**
@brief UIViewController extensions
*/
extension UIViewController {
    func hideBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRectZero))
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}

/*==============================================================================================
// MARK: - UIColor
//============================================================================================*/

/**
@brief UIColor extensions
*/
extension UIColor {
    
    convenience init(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        self.init(Int(red), Int(green), Int(blue))
    }
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, alpha: Float? = nil) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        let alphaFloat:CGFloat = (nil != alpha) ? CGFloat(alpha!) : 1.0
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alphaFloat)
    }
    
    convenience init(hex:Int) {
        self.init((hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff)
    }
    
    convenience init(hexa:Int) {
        self.init((hexa >> 16) & 0xff, (hexa >> 8) & 0xff, hexa & 0xff, alpha: Float(hexa >> 24))
    }
    
    class func colorToHSV(color : Int, inout hsv : [CGFloat]) {
        let clr = UIColor(hex: color)
        var hue:CGFloat = 0, sat:CGFloat = 0, brite:CGFloat = 0
        var red:CGFloat = 0, grn:CGFloat = 0, blue:CGFloat = 0, a:CGFloat = 0
        
        if clr.getRed(&red, green: &grn, blue: &blue, alpha: &a) {
            let minColor = CGFloat(min(red, min(grn, blue)))
            let maxColor = CGFloat(max(red, max(grn, blue)))
            if (minColor != maxColor) {
                let d:CGFloat = (red == minColor) ? grn - blue : ((blue == minColor) ? red - grn : blue - red)
                let h:CGFloat = (red == minColor) ? 3 : ((blue == minColor) ? 1 : 5)
                hue = (h - d / (maxColor - minColor)) / 6.0
                sat = (maxColor - minColor)/maxColor
                brite = maxColor
            }
        }
        hsv[0] = hue
        hsv[1] = sat
        hsv[2] = brite
    }
}

/*==============================================================================================
// MARK: - NSObject
//============================================================================================*/

/**
@brief Extensions for NSObject
*/
extension NSObject {
    
    /**
    Executes a task after delay
    */
    func afterDelay(delay:Double, _ closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
//    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
//        
//        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
//        return timer
//    }
    
    /**
     TODO: Description
     */
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
    
    /**
     TODO: Description
     */
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval, cancelClosure:()->(Bool)) {
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            if (!cancelClosure()) {
                NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
            }
        })
    }
}

/*==============================================================================================
// MARK: - String
//============================================================================================*/


/**
@brief Extensions for String
*/
extension String {
    
    var length:Int {
        return (self as NSString).length
    }
    
    /**
     Returns an "exploded" array from a seperated-value string
     */
    static func explode(separatedValueString : String?, _ delim : Character? = ",") -> [String]? {
        var result:[String]? = nil
        if let codes = separatedValueString where !codes.isEmpty {
            let dlm:Character = (nil != delim) ? delim! : ","
            let list = codes.characters.split{ $0 == dlm }.map(String.init)
            if !list.isEmpty {
                result = list
            }
        }
        return result
    }
    
    /**
     Formats a string into phone format (nnn) nnn-nnnn
     */
    static func formatPhone(phone : String) -> String {
        var formatted = ""
        let regex = try! NSRegularExpression(pattern: "[^\\d]", options: .CaseInsensitive)
        formatted = regex.stringByReplacingMatchesInString(phone, options: [], range: NSRange(0..<phone.characters.count), withTemplate: "")
        if 10 == formatted.characters.count {
            let pref = formatted.substringToIndex(formatted.startIndex.advancedBy(3)),
                exch = formatted.substringWithRange(formatted.startIndex.advancedBy(3)..<formatted.startIndex.advancedBy(6)),
                numb = formatted.substringWithRange(formatted.startIndex.advancedBy(6)..<formatted.startIndex.advancedBy(10))
            formatted = "(\(pref)) \(exch)-\(numb)"
        }
        return formatted
    }
    
//    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let length = UInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = algorithm.digestLength()
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        let objcKey = key as NSString
//        let keyStr = objcKey.cStringUsingEncoding(NSUTF8StringEncoding)
//        let keyLen = UInt(objcKey.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        
//        CCHmac(algorithm.toCCHmacAlgorithm(), keyStr, keyLen, str!, length, result)
//        
////        CCHmac(algorithm.toCCHmacAlgorithm(), keyStr, keyLen, str!, strLen, result)
//        
//        var hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        
//        result.destroy()
//        
//        return String(hash)
//    }
//    
//    func md5(key : String) -> String {
//        return self.hmac(.MD5, key: key)
//    }
    
    /**
     Returns True if characters filter has any capital letters
     TODO: Confirm if in use
     */
    func hasCapitals() -> Bool {
        let result = self.characters.filter { ("A"..."Z").contains($0) }
        return result.count > 0
    }
    
    /**
     Searches a string and returns Bool
     
     @param find - string to be found
     
     @param caseInsensitive - Bool to set yes or no to case sensitive search
     */
    func contains(find: String, _ caseInsensitive : Bool = true) -> Bool {
        let searchOptions:NSStringCompareOptions = (caseInsensitive) ? NSStringCompareOptions.CaseInsensitiveSearch : NSStringCompareOptions.LiteralSearch
        if let _ = self.rangeOfString(find, options: searchOptions) {
            return true
        }
        return false
    }
    
    /**
     Converts utf8 to bytes
     TODO: Confirm if in use
     */
    func toBytes() -> [UInt8] {
        var bytes = [UInt8]()
        for char in self.utf8 {
            bytes += [char]
        }
        return bytes
    }
    
    /**
     Trims a string of white space characters
     */
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}

/**
 TODO: Description
 */
extension NSString {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
