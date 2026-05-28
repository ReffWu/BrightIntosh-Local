//
//  Cli.swift
//  BrightIntosh
//
//  Created by Niklas Rousset on 10.05.25.
//
import Foundation

@MainActor func toggleCli() {
    BrightIntoshSettings.shared.brightintoshActive.toggle()
    notifyMainApp(active: BrightIntoshSettings.shared.brightintoshActive)
}

@MainActor func setActiveStateCli(active: Bool) {
    BrightIntoshSettings.shared.brightintoshActive = active
    notifyMainApp(active: active)
}

@MainActor func statusCli() {
    let status = BrightIntoshSettings.shared.brightintoshActive
    print("状态：\(status ? "已开启" : "已关闭")")
}

enum CliCommand: String, CaseIterable {
    case enable = "enable"
    case disable = "disable"
    case status = "status"
    case toggle = "toggle"
    case help = "help"
    case cli = "cli"
}

func getHelpText() -> String {
    return
"""
BrightIntosh CLI
用法：brightintosh <command>

注意：命令行工具需要 BrightIntosh 主程序正在运行。

命令：
  enable       开启增强亮度
  disable      关闭增强亮度
  status       查看当前状态
  toggle       切换开启/关闭
  help         显示帮助
"""
}

func helpCli() {
    print(getHelpText())
}

func notifyMainApp(active: Bool) {
    DistributedNotificationCenter.default().postNotificationName(
        controlActiveToggleNotificationName,
        object: nil,
        userInfo: ["active": active],
        deliverImmediately: true
    )
}

@MainActor func cliBase() -> Bool {
    if CommandLine.argc > 1 {
        guard let cliMode = CliCommand(rawValue: CommandLine.arguments[1]), cliMode == .cli else {
            return false
        }
        
        guard CommandLine.argc > 2 else {
            helpCli()
            return true;
        }
        
        guard let command = CliCommand(rawValue: CommandLine.arguments[2]) else {
            helpCli()
            return true
        }
        
        switch command {
        case .toggle:
            toggleCli()
        case .enable:
            setActiveStateCli(active: true)
        case .disable:
            setActiveStateCli(active: false)
        case .status:
            statusCli()
        case .help:
            helpCli()
        case .cli:
            helpCli()
        }
        return true
    }
    return false
}
