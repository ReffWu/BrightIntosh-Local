//
//  Alerts.swift
//  BrightIntosh
//
//  Created by Niklas Rousset on 02.10.23.
//

import Foundation
import Cocoa

@MainActor func createBatteryAutomationContradictionAlert() -> NSAlert {
    let alert = NSAlert()
    alert.messageText = "当前电量低于 \(BrightIntoshSettings.shared.batteryAutomationThreshold)%。仍要开启增强亮度吗？\n\n继续后会关闭电量自动化。"
    alert.addButton(withTitle: "继续")
    alert.addButton(withTitle: "取消")
    return alert
}
