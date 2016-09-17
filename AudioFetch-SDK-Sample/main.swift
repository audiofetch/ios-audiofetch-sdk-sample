//
//  main.swift
//  audiofetch
//
//  Copyright © 2016 AudioFetch, Inc. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(AppBase.self),
    NSStringFromClass(AppDelegate.self)
)
