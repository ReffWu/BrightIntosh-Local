# BrightIntosh Local

<p align="center">
  <img width="180" height="180" alt="BrightIntosh Local app icon" src="docs/assets/app-icon.png">
</p>

BrightIntosh Local 是一个 macOS 菜单栏工具，用来在支持的 XDR 显示屏上快速开启或关闭增强亮度。本版本面向本地自用：去掉商店购买流程和营销入口，改为中文界面、本地构建、本地命令行控制。

> [!IMPORTANT]
> 长时间使用高亮度可能增加耗电和发热。请按实际环境使用；macOS 仍会控制显示系统的保护策略。

## 功能

- 菜单栏一键开启/关闭增强亮度
- 中文原生 macOS 设置窗口
- 自动关闭定时器
- 登录启动、电量、电源适配器和合盖自动化
- 键盘快捷键
- 本地 CLI：`brightintosh status`、`brightintosh enable`、`brightintosh disable`、`brightintosh toggle`
- 诊断报告复制和显示颜色设置恢复

## 支持设备

- MacBook Pro M5 from 2025 / 2026: `Mac17,2`, `Mac17,6`, `Mac17,7`, `Mac17,8`, `Mac17,9`
- MacBook Pro M4 from 2024: `Mac16,1`, `Mac16,5`, `Mac16,6`, `Mac16,7`, `Mac16,8`
- MacBook Pro M3 from 2023: `Mac15,3`, `Mac15,6`, `Mac15,7`, `Mac15,8`, `Mac15,9`, `Mac15,10`, `Mac15,11`
- MacBook Pro M2 14" / 16" from 2023: `Mac14,5`, `Mac14,6`, `Mac14,9`, `Mac14,10`
- MacBook Pro M1 14" / 16" from 2021: `MacBookPro18,1`, `MacBookPro18,2`, `MacBookPro18,3`, `MacBookPro18,4`
- Pro Display XDR
- Studio Display XDR experimental

## 构建和安装

需要 macOS 和完整 Xcode。

```sh
./scripts/build-local.sh
```

脚本会执行 Release 构建、ad-hoc 签名，并安装到：

```text
/Applications/BrightIntosh.app
```

安装后打开 App：

```sh
open /Applications/BrightIntosh.app
```

## 命令行工具

在 App 的“设置 -> 本地工具 -> 安装命令行工具...”中复制安装命令。安装后可使用：

```sh
brightintosh status
brightintosh enable
brightintosh disable
brightintosh toggle
brightintosh help
```

CLI 需要主 App 正在运行。

## 本地版改动

- Bundle ID 改为 `local.reff.brightintosh`
- App Group 改为 `group.local.reff.brightintosh`
- 默认不自动开启增强亮度
- 去掉主要 UI 中的商店、官网、帮助、社交和作者营销入口
- 设置窗口、菜单栏、首次启动页、提示和 CLI 文案改为中文
- CLI 和小组件通过分布式通知同步运行中的主 App
- 本地诊断报告跳过 StoreKit 检查

## 许可和来源

本项目基于 [niklasr22/BrightIntosh](https://github.com/niklasr22/BrightIntosh) 修改，继续遵循原项目的 GPL-3.0 license。原始版权和许可证见 [LICENSE](LICENSE)。

## 已知问题

- BrightIntosh 与 f.lux 等也会调节显示器亮度或颜色的 App 可能互相影响
- 开启增强亮度时，部分 HDR 视频可能出现高光裁剪
- 本地构建使用 ad-hoc 签名，不等同于 App Store 分发版本
