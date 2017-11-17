//
//  ConsoleDestination.swift
//  SwiftyBeaver
//
//  Created by Sebastian Kreutzberger on 05.12.15.
//  Copyright © 2015 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

public class ConsoleDestination: BaseDestination {

    /// use NSLog instead of print, default is false
    public var useNSLog = false
    /// uses colors compatible to Terminal instead of Xcode, default is false
    public var useTerminalColors: Bool = false {
        didSet {
            if useTerminalColors {
                // use Terminal colors
                reset = "\u{001b}[0m"
                escape = "\u{001b}[38;5;"
                levelColor.verbose = "251m"     // silver
                levelColor.debug = "38m"        // blue
                levelColor.info = "35m"         // green
                levelColor.warning = "178m"     // yellow
                levelColor.error = "197m"       // red

            } else {
                // use colored Emojis for better visual distinction
                // of log level for Xcode 8
                levelColor.verbose = "ℹ️ "       // silver
                levelColor.debug = "Ⓜ️ "         // blue
                levelColor.info = "✅ "          // green
                levelColor.warning = "⚠️ "       // yellow
                levelColor.error = "❌ "         // red
            }
        }
    }

    override public var defaultHashValue: Int { return 1 }

    public override init() {
        super.init()
        levelColor.verbose = "ℹ️ "      // silver
        levelColor.debug = "Ⓜ️ "        // blue
        levelColor.info = "✅ "         // green
        levelColor.warning = "⚠️ "      // yellow
        levelColor.error = "❌ "        // red
    }

    // print to Xcode Console. uses full base class functionality
    override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
                                file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)

        if let str = formattedString {
            if useNSLog {
                #if os(Linux)
                    print(str)
                #else
                    NSLog("%@", str)
                #endif
            } else {
                print(str)
            }
        }
        return formattedString
    }

}
