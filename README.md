# PacePilot - Running & Walking Pace Assistant

An iOS application designed for runners and walkers that provides real-time pace tracking with voice announcements.

## 🎯 Features

- 🏃‍♂️ **Real-time Pace Tracking** - Accurate GPS-based pace calculation
- 🚶‍♀️ **Dual Exercise Modes** - Support for both running and walking
- 🔊 **Smart Voice Announcements** - Automatic pace and distance updates
- 🎵 **Audio Coexistence** - Works alongside music apps
- 📱 **Background Operation** - Continues tracking when locked
- 🎨 **Dark Theme UI** - Clean and intuitive interface

## 🚀 Quick Start

### Requirements
- iOS 14.0+
- iPhone device with GPS capability

### Installation

1. **Using Xcode (Recommended)**
   ```bash
   # Open project in Xcode
   open PacePilot.xcodeproj
   
   # Select your iPhone device
   # Click Run button to build and install
   ```

2. **Command Line Testing**
   ```bash
   # Test core functionality
   cd PacePilotTest
   swift run
   ```

## 📱 Usage Guide

1. **First Time Use**
   - Open the app and grant location permissions
   - Select exercise mode (Running or Walking)
   - Tap "Start" button

2. **During Exercise**
   - Running: Voice announcements every 30 seconds
   - Walking: Voice announcements every 60 seconds  
   - Use music players normally
   - Works in background and locked screen

3. **Ending Exercise**
   - Tap "Stop" button
   - App announces final statistics
   - Workout record is saved automatically

## 🔧 Technical Architecture

### Core Components

- **PaceTracker** - GPS positioning and pace calculation
- **AudioManager** - Voice synthesis and audio management
- **ContentView** - SwiftUI user interface
- **HistoryView** - Workout history and statistics

### Location Tracking

- **Running Mode**: Updates every 10 meters movement
- **Walking Mode**: Updates every 5 meters movement
- **Distance Calculation**: Accumulates distance between consecutive GPS points
- **Pace Calculation**: Minutes per kilometer based on elapsed time and distance

### Permissions Required

- `Location Permission` - For GPS tracking
- `Background Location` - Continuous exercise tracking
- `Audio Permission` - Voice announcement functionality

## 🧪 Testing & Verification

Project includes comprehensive test suite:

```bash
# Run functional tests
cd PacePilotTest
swift run

# Sample test output
=== PacePilot Function Test ===
🏃‍♂️ Start running tracking
--- Announcement #1 (30 seconds later) ---
Current pace: 5:30 min/km
Running distance: 200 meters
🔊 Voice announcement: Pace 5:30, distance 200 meters
```

## 📋 Project Structure

```
PacePilot/
├── AppDelegate.swift          # App entry and audio configuration
├── ContentView.swift          # Main SwiftUI interface
├── PaceTracker.swift          # GPS tracking and pace calculation
├── AudioManager.swift         # Voice announcement management
├── Views/
│   └── HistoryView.swift      # Workout history view
├── Info.plist                # App configuration and permissions
└── LaunchScreen.storyboard   # Launch screen

PacePilotTest/                # Command line test project
└── Sources/
    └── PacePilotTest/
        └── main.swift         # Main test program
```

## 🎯 Future Plans

- [ ] Apple Watch integration
- [ ] HealthKit data synchronization
- [ ] Advanced workout statistics
- [ ] Customizable announcement intervals
- [ ] Multi-language support

---

# PacePilot - 跑步步行配速助手

专为跑步和步行爱好者设计的iOS应用，提供实时配速追踪和语音播报功能。

## 🎯 功能特性

- 🏃‍♂️ **实时配速追踪** - 基于GPS的精确配速计算
- 🚶‍♀️ **双运动模式** - 支持跑步和步行两种模式
- 🔊 **智能语音播报** - 自动播报配速和距离信息
- 🎵 **音频共存** - 可与音乐应用同时使用
- 📱 **后台运行** - 锁屏状态下持续追踪
- 🎨 **深色主题** - 简洁直观的用户界面

## 🚀 快速开始

### 环境要求
- iOS 14.0+
- 支持GPS的iPhone设备

### 安装方法

1. **使用Xcode（推荐）**
   ```bash
   # 用Xcode打开项目
   open PacePilot.xcodeproj
   
   # 选择你的iPhone设备
   # 点击运行按钮编译安装
   ```

2. **命令行测试**
   ```bash
   # 测试核心功能
   cd PacePilotTest
   swift run
   ```

## 📱 使用指南

1. **首次使用**
   - 打开应用，授予位置权限
   - 选择运动模式（跑步或步行）
   - 点击"开始"按钮

2. **运动过程中**
   - 跑步模式：每30秒语音播报一次
   - 步行模式：每60秒语音播报一次
   - 可正常使用音乐播放器
   - 支持后台和锁屏运行

3. **结束运动**
   - 点击"停止"按钮
   - 应用播报最终统计数据
   - 运动记录自动保存

## 🔧 技术架构

### 核心组件

- **PaceTracker** - GPS定位和配速计算
- **AudioManager** - 语音合成和音频管理
- **ContentView** - SwiftUI用户界面
- **HistoryView** - 运动历史和统计

### 定位追踪

- **跑步模式**：每移动10米更新一次位置
- **步行模式**：每移动5米更新一次位置
- **距离计算**：累加连续GPS点之间的距离
- **配速计算**：基于用时和距离计算每公里分钟数

### 所需权限

- `位置权限` - 用于GPS追踪
- `后台位置` - 持续运动追踪
- `音频权限` - 语音播报功能

## 🧪 测试验证

项目包含完整的测试套件：

```bash
# 运行功能测试
cd PacePilotTest
swift run

# 测试输出示例
=== PacePilot 功能测试 ===
🏃‍♂️ 开始跑步追踪
--- 第1次播报 (30秒后) ---
当前配速: 5分30秒 分钟/公里
跑步距离: 200米
🔊 语音播报: 每公里5分30秒，已跑200米
```

## 📋 项目结构

```
PacePilot/
├── AppDelegate.swift          # 应用入口和音频配置
├── ContentView.swift          # 主SwiftUI界面
├── PaceTracker.swift          # GPS追踪和配速计算
├── AudioManager.swift         # 语音播报管理
├── Views/
│   └── HistoryView.swift      # 运动历史视图
├── Info.plist                # 应用配置和权限
└── LaunchScreen.storyboard   # 启动界面

PacePilotTest/                # 命令行测试项目
└── Sources/
    └── PacePilotTest/
        └── main.swift         # 主测试程序
```

## 🎯 下一步计划

- [ ] Apple Watch集成
- [ ] HealthKit数据同步
- [ ] 高级运动统计
- [ ] 自定义播报间隔
- [ ] 多语言支持