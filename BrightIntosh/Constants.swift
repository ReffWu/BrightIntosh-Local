//
//  Constants.swift
//  BrightIntosh
//
//  Created by Niklas Rousset on 22.09.23.
//

import Carbon
import KeyboardShortcuts
import SwiftUI

struct BrightIntoshUrls {
    static let time = URL(string: "https://brightintosh.de/time.php")!
}

extension KeyboardShortcuts.Name {
    @MainActor static let toggleBrightIntosh = Self("toggleIncreasedBrightness", default: .init(carbonKeyCode: kVK_ANSI_B, carbonModifiers: (0 | optionKey | cmdKey)))
    @MainActor static let increaseBrightness = Self("increaseBrightness", default: .init(carbonKeyCode: kVK_ANSI_N, carbonModifiers: (0 | optionKey | cmdKey)))
    @MainActor static let decreaseBrightness = Self("decreaseBrightness", default: .init(carbonKeyCode: kVK_ANSI_M, carbonModifiers: (0 | optionKey | cmdKey)))
    @MainActor static let openSettings = Self("openSettings", default: .init(carbonKeyCode: kVK_ANSI_B, carbonModifiers: (0 | optionKey | cmdKey | shiftKey)))
}

let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!

let supportedDevices = ["MacBookPro18,1", "MacBookPro18,2", "MacBookPro18,3", "MacBookPro18,4", "Mac14,6", "Mac14,10", "Mac14,5", "Mac14,9", "Mac15,7", "Mac15,9", "Mac15,11", "Mac15,6", "Mac15,8", "Mac15,10", "Mac15,3", "Mac16,1", "Mac16,6", "Mac16,8", "Mac16,7", "Mac16,5", "Mac17,2", "Mac17,6", "Mac17,8", "Mac17,7", "Mac17,9"
]
#if DEBUG
let externalXdrDisplays = ["Pro Display XDR", "Studio Display XDR", "C34H89x"]
#else
let externalXdrDisplays = ["Pro Display XDR", "Studio Display XDR"]
#endif
let sdr600nitsDevices = ["Mac15,3", "Mac15,6", "Mac15,7", "Mac15,8", "Mac15,9", "Mac15,10", "Mac15,11", "Mac16,1", "Mac16,6", "Mac16,8", "Mac16,7", "Mac16,5", "Mac17,2", "Mac17,6", "Mac17,8", "Mac17,7", "Mac17,9"]
