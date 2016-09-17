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
func synced(_ closure: () -> ()) {
    let lockQueue = DispatchQueue(label: "com.audiofetch.LockQueue")
    lockQueue.sync {
        closure()
    }
}

/**
 @brief runs code in background
 */
func runInBackground(_ closure: @escaping () -> ()) {
    DispatchQueue.global().async {
        closure()
    }
}

/**
 Runs block on main UIs
 */
func runOnUiThread(_ closure : @escaping () -> ()) {
    DispatchQueue.main.async(execute: closure)
}

/**
 Executes a task after delay
 */
func afterDelay(_ delay:Double, _ closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/**
 Logs to console when in debug mode
 
 @param msg - String to printed
 */
func DLog(_ msg : String) {
    if _isDebugAssertConfiguration() {
        print("\n\n======>>>>>>>\n\(msg)\n")
    }
}

/*==============================================================================================
// MARK: - UIColor
//============================================================================================*/

/**
 @brief Extensions for String
 */
extension String {
    
    var length:Int {
        return (self as NSString).length
    }
}

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
}
