//
//  SettingsWindow.swift
//  BrightIntosh
//
//  Created by Niklas Rousset on 17.09.23.
//

import KeyboardShortcuts
import CoreGraphics
import SwiftUI

@MainActor
class BasicSettingsViewModel: ObservableObject {
    private var brightIntoshActive = BrightIntoshSettings.shared.brightintoshActive
    var brightIntoshActiveToggle: Bool {
        set { BrightIntoshSettings.shared.brightintoshActive = newValue }
        get { brightIntoshActive }
    }

    private var timerAutomation = BrightIntoshSettings.shared.timerAutomation
    private var timerAutomationTimeoutValue = BrightIntoshSettings.shared.timerAutomationTimeout
    var timerAutomationTimeout: Int {
        set {
            BrightIntoshSettings.shared.timerAutomation = newValue > 0
            BrightIntoshSettings.shared.timerAutomationTimeout = newValue
        }
        get { timerAutomation ? timerAutomationTimeoutValue : 0 }
    }

    private var powerAdapterAutomation = BrightIntoshSettings.shared.powerAdapterAutomation
    var powerAdapterAutomationToggle: Bool {
        set { BrightIntoshSettings.shared.powerAdapterAutomation = newValue }
        get { powerAdapterAutomation }
    }

    init() {
        BrightIntoshSettings.shared.addListener(setting: "brightintoshActive") {
            if BrightIntoshSettings.shared.brightintoshActive && !checkBatteryAutomationContradiction() {
                BrightIntoshSettings.shared.brightintoshActive = false
            }
            if self.brightIntoshActive != BrightIntoshSettings.shared.brightintoshActive {
                self.brightIntoshActive = BrightIntoshSettings.shared.brightintoshActive
                self.objectWillChange.send()
            }
        }
        BrightIntoshSettings.shared.addListener(setting: "timerAutomation") {
            if self.timerAutomation != BrightIntoshSettings.shared.timerAutomation {
                self.timerAutomation = BrightIntoshSettings.shared.timerAutomation
                self.objectWillChange.send()
            }
        }
        BrightIntoshSettings.shared.addListener(setting: "timerAutomationTimeout") {
            if self.timerAutomationTimeoutValue != BrightIntoshSettings.shared.timerAutomationTimeout {
                self.timerAutomationTimeoutValue = BrightIntoshSettings.shared.timerAutomationTimeout
                self.objectWillChange.send()
            }
        }
        BrightIntoshSettings.shared.addListener(setting: "powerAdapterAutomation") {
            if self.powerAdapterAutomation != BrightIntoshSettings.shared.powerAdapterAutomation {
                self.powerAdapterAutomation = BrightIntoshSettings.shared.powerAdapterAutomation
                self.objectWillChange.send()
            }
        }
    }
}

private struct SettingsInfoRow: View {
    var symbolName: String = "info.circle"
    var text: String

    var body: some View {
        Label(text, systemImage: symbolName)
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}

private struct CliInstallationSheet: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("安装命令行工具")
                .font(.title2)
                .bold()

            Text("复制下面的命令到终端运行。之后可以用 `brightintosh status`、`brightintosh enable`、`brightintosh disable` 控制本地 App。")
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Text(getCliInstallCommand())
                    .textSelection(.enabled)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: copyToClipboard) {
                    Image(systemName: "document.on.document")
                }
                .help("复制命令")
            }
            .padding(10)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))

            HStack {
                Spacer()
                Button("完成") {
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 520)
    }

    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(getCliInstallCommand(), forType: .string)
    }

    private func getCliInstallCommand() -> String {
        let bundlePath = Bundle.main.bundlePath
        return "echo \"alias brightintosh='\(bundlePath)/Contents/Resources/cli.sh'\" >> ~/.zshrc && source ~/.zshrc"
    }
}

private struct AdvancedSettingsSheet: View {
    @Binding var isPresented: Bool
    @Binding var useAlternateBrightnessBackend: Bool
    @Binding var waitForHDRBeforeIncreasingBrightness: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("高级设置")
                .font(.title2)
                .bold()

            Toggle("使用备用亮度后端", isOn: $useAlternateBrightnessBackend)
                .onChange(of: useAlternateBrightnessBackend) { _, new in
                    BrightIntoshSettings.shared.useAlternateBrightnessBackend = new
                }

            Toggle("等待 HDR 模式就绪后再增强亮度", isOn: $waitForHDRBeforeIncreasingBrightness)
                .onChange(of: waitForHDRBeforeIncreasingBrightness) { _, new in
                    BrightIntoshSettings.shared.waitForHDRBeforeIncreasingBrightness = new
                }

            Text("这些选项主要用于处理特定显示器或系统版本上的亮度兼容问题。正常情况下保持默认即可。")
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack {
                Spacer()
                Button("完成") {
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 440)
    }
}

struct BasicSettings: View {
    @StateObject private var viewModel = BasicSettingsViewModel()

    @State private var showInDock = BrightIntoshSettings.shared.showInDock
    @State private var hideMenuBarItem = BrightIntoshSettings.shared.hideMenuBarItem
    @State private var launchOnLogin = BrightIntoshSettings.shared.launchAtLogin
    @State private var brightIntoshOnlyOnBuiltIn = BrightIntoshSettings.shared.brightIntoshOnlyOnBuiltIn
    @State private var disableWhenLidClosed = BrightIntoshSettings.shared.disableWhenLidClosed
    @State private var showHDRRetryCooldownNotice = BrightIntoshSettings.shared.showHDRRetryCooldownNotice
    @State private var showIncompatibleAppsNotice = BrightIntoshSettings.shared.showIncompatibleAppsNotice
    @State private var useAlternateBrightnessBackend = BrightIntoshSettings.shared.useAlternateBrightnessBackend
    @State private var waitForHDRBeforeIncreasingBrightness = BrightIntoshSettings.shared.waitForHDRBeforeIncreasingBrightness
    @State private var batteryLevelThreshold = BrightIntoshSettings.shared.batteryAutomationThreshold

    @State private var showCliPopup = false
    @State private var showAdvancedSettingsSheet = false

    var body: some View {
        Form {
            Section("亮度") {
                Toggle("增强亮度", isOn: $viewModel.brightIntoshActiveToggle)

                if isDeviceSupported() {
                    Toggle("只增强内建 XDR 显示屏", isOn: $brightIntoshOnlyOnBuiltIn)
                        .onChange(of: brightIntoshOnlyOnBuiltIn) { _, new in
                            BrightIntoshSettings.shared.brightIntoshOnlyOnBuiltIn = new
                        }
                } else {
                    SettingsInfoRow(
                        symbolName: "exclamationmark.triangle.fill",
                        text: "这台 Mac 没有内建 XDR 显示屏，只能对外接 XDR 显示器启用增强亮度。"
                    )
                    .foregroundStyle(.yellow)
                }

                Toggle("需要等待 HDR 时显示提示", isOn: $showHDRRetryCooldownNotice)
                    .onChange(of: showHDRRetryCooldownNotice) { _, new in
                        BrightIntoshSettings.shared.showHDRRetryCooldownNotice = new
                    }

                Toggle("检测到亮度类 App 冲突时显示提示", isOn: $showIncompatibleAppsNotice)
                    .onChange(of: showIncompatibleAppsNotice) { _, new in
                        BrightIntoshSettings.shared.showIncompatibleAppsNotice = new
                    }

                Button("恢复显示颜色设置") {
                    BrightIntoshSettings.shared.brightintoshActive = false
                    CGDisplayRestoreColorSyncSettings()
                }
                .help("关闭增强亮度，并让 macOS 恢复当前显示器的 ColorSync 设置")
            }

            Section("定时") {
                Picker("自动关闭", selection: $viewModel.timerAutomationTimeout) {
                    Text("永不").tag(0)
                    ForEach(Array(stride(from: 10, to: 51, by: 10)), id: \.self) { minutes in
                        Text("\(minutes) 分钟").tag(minutes)
                    }
                    ForEach([60, 90, 120, 150, 180, 210, 240, 270], id: \.self) { minutes in
                        Text(timerTitle(for: minutes)).tag(minutes)
                    }
                }
            }

            Section("自动化") {
                Toggle("登录时启动", isOn: $launchOnLogin)
                    .onChange(of: launchOnLogin) { _, new in
                        BrightIntoshSettings.shared.launchAtLogin = new
                    }

                Toggle("合上 MacBook 屏幕后关闭", isOn: $disableWhenLidClosed)
                    .onChange(of: disableWhenLidClosed) { _, new in
                        BrightIntoshSettings.shared.disableWhenLidClosed = new
                    }

                Picker("电量低于", selection: $batteryLevelThreshold) {
                    Text("不自动关闭").tag(100)
                    ForEach(Array(stride(from: 5, to: 100, by: 5)), id: \.self) { percent in
                        Text("\(percent)%").tag(percent)
                    }
                }
                .onChange(of: batteryLevelThreshold) { _, new in
                    BrightIntoshSettings.shared.batteryAutomation = new != 100
                    BrightIntoshSettings.shared.batteryAutomationThreshold = new
                }

                Toggle("使用电池时关闭，接入电源后恢复", isOn: $viewModel.powerAdapterAutomationToggle)
            }

            Section("快捷键") {
                KeyboardShortcuts.Recorder("切换增强亮度：", name: .toggleBrightIntosh)
                KeyboardShortcuts.Recorder("打开设置：", name: .openSettings)
            }

            Section("界面") {
                Toggle("隐藏菜单栏图标", isOn: $hideMenuBarItem)
                    .onChange(of: hideMenuBarItem) { _, new in
                        BrightIntoshSettings.shared.hideMenuBarItem = new
                    }

                if hideMenuBarItem {
                    SettingsInfoRow(
                        symbolName: "exclamationmark.triangle.fill",
                        text: "隐藏后，可在 Spotlight 搜索“BrightIntosh 设置”重新打开设置窗口。"
                    )
                    .foregroundStyle(.yellow)
                }

                Toggle("在程序坞中显示", isOn: $showInDock)
                    .onChange(of: showInDock) { _, new in
                        BrightIntoshSettings.shared.showInDock = new
                    }
            }

            Section("本地工具") {
                Button("复制诊断报告") {
                    Task {
                        let report = await generateReport()
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(report, forType: .string)
                    }
                }

                Button("安装命令行工具...") {
                    showCliPopup = true
                }
            }

            Section("高级") {
                Button("高级设置...") {
                    showAdvancedSettingsSheet = true
                }
            }

#if DEBUG
            Section("开发") {
                Text("本地调试构建")
                    .foregroundStyle(.secondary)
            }
#endif
        }
        .formStyle(.grouped)
        .sheet(isPresented: $showCliPopup) {
            CliInstallationSheet(isPresented: $showCliPopup)
        }
        .sheet(isPresented: $showAdvancedSettingsSheet) {
            AdvancedSettingsSheet(
                isPresented: $showAdvancedSettingsSheet,
                useAlternateBrightnessBackend: $useAlternateBrightnessBackend,
                waitForHDRBeforeIncreasingBrightness: $waitForHDRBeforeIncreasingBrightness
            )
        }
    }

    private func timerTitle(for minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) 分钟"
        }
        let hours = Double(minutes) / 60.0
        if hours.rounded(.down) == hours {
            return "\(Int(hours)) 小时"
        }
        return String(format: "%.1f 小时", hours)
    }
}

private struct LocalEditionFooter: View {
    var body: some View {
        HStack(spacing: 6) {
            Image("LogoBordered")
                .resizable()
                .frame(width: 16, height: 16)
            Text("BrightIntosh 本地版 \(appVersion)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 8) {
            if #unavailable(macOS 15) {
                Text("设置")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            BasicSettings()
            LocalEditionFooter()
        }
        .padding()
        .userStatusTask()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 660, height: 620)
    }
}

final class SettingsWindowController: NSWindowController, NSWindowDelegate {
    init() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 660, height: 620),
            styleMask: [.titled, .closable, .unifiedTitleAndToolbar],
            backing: .buffered,
            defer: false
        )
        settingsWindow.title = "BrightIntosh 设置"

        let contentView = SettingsView().frame(width: 660, height: 620)

        settingsWindow.contentView = NSHostingView(rootView: contentView)
        settingsWindow.center()

        super.init(window: settingsWindow)
        settingsWindow.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        window?.level = .floating
        super.showWindow(sender)
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
}
