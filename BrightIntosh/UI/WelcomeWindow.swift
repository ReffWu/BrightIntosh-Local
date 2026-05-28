//
//  WelcomeWindow.swift
//  BrightIntosh
//
//  Created by Niklas Rousset on 12.09.23.
//

import SwiftUI

struct IntroView: View {
    var supportedDevice: Bool = false
    var onAccept: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 14) {
                Image("LogoBorderedHighRes")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .aspectRatio(contentMode: .fit)

                VStack(alignment: .leading, spacing: 4) {
                    Text("BrightIntosh 本地版")
                        .font(.title)
                        .bold()
                    Text("从菜单栏快速控制 XDR 增强亮度。")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }

            if !supportedDevice {
                Label("这台 Mac 没有内建 XDR 显示屏，只能对外接 XDR 显示器启用增强亮度。", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.yellow)
            }

            VStack(alignment: .leading, spacing: 12) {
                Label("点击菜单栏的太阳图标开启或关闭增强亮度", systemImage: "sun.max")
                Label("继续用系统亮度键调节基础亮度", systemImage: "keyboard")
                Label("显示异常时，可在设置里恢复显示颜色设置", systemImage: "arrow.counterclockwise")
            }
            .font(.body)

            Text("增强亮度会调用 macOS 显示接口提高 XDR 可用亮度。长时间高亮可能增加耗电和发热，请按实际环境使用。")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Spacer()
                Button("开始使用") {
                    onAccept()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(28)
    }
}

#if STORE
struct WelcomeStoreView: View {
    var onContinue: () -> Void
    var trial: TrialData

    @Environment(\.isUnrestrictedUser) private var isUnrestrictedUser: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text(isUnrestrictedUser || trial.stillEntitled() ? "启用 BrightIntosh" : "试用已结束")
                .font(.title)
                .bold()

            BrightIntoshStoreView(showLogo: false)

            if !isUnrestrictedUser && trial.stillEntitled() && trial.getRemainingDays() > 0 {
                Button("开始 \(trial.getRemainingDays()) 天试用", action: onContinue)
                    .keyboardShortcut(.defaultAction)
            } else if isUnrestrictedUser {
                Button("启用", action: onContinue)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(28)
    }
}
#endif

struct WelcomeView: View {
    var supportedDevice: Bool = false
    var closeWindow: () -> Void

    @State var showStore = false

    @Environment(\.trial) private var trial: TrialData?
    @Environment(\.isUnrestrictedUser) private var isUnrestrictedUser: Bool

    var body: some View {
        Group {
            if !showStore {
                IntroView(
                    supportedDevice: supportedDevice,
                    onAccept: {
#if STORE
                        if isUnrestrictedUser {
                            closeWindow()
                            return
                        }
                        showStore = true
#else
                        closeWindow()
#endif
                    }
                )
            } else {
#if STORE
                if let trial = trial {
                    WelcomeStoreView(onContinue: closeWindow, trial: trial)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
#else
                EmptyView()
#endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(closeWindow: {})
            .frame(width: 520, height: 420)
    }
}

final class WelcomeWindowController: NSWindowController, NSWindowDelegate {
    init(supportedDevice: Bool) {
        let welcomeWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        welcomeWindow.title = "首次设置"

        let contentView = WelcomeView(supportedDevice: supportedDevice, closeWindow: welcomeWindow.close)
            .frame(width: 520, height: 420)
            .userStatusTask()

        welcomeWindow.contentView = NSHostingView(rootView: contentView)
        welcomeWindow.center()

        super.init(window: welcomeWindow)
        welcomeWindow.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
}
