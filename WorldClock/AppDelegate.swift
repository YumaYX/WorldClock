//
//  AppDelegate.swift
//  WorldClock
//
//  Created by Yuma SATO on 2024/01/07.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    var worldClocks: [WorldClock] = []
    var selected_num = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.setActivationPolicy(.accessory)
        // 都市のタイムゾーンを追加
        let cities = ["America/New_York", "America/Los_Angeles", "Europe/London", "Europe/Paris", "Asia/Tokyo", "Australia/Sydney", "Asia/Shanghai"].sorted()
        for city in cities {
            if let timeZone = TimeZone(identifier: city) {
                worldClocks.append(WorldClock(timeZone: timeZone))
            }
        }
        // メニューアイテムを設定
        statusItem.button?.title = 
        replaceUnderscoreWithSpace(worldClocks[0].timeZone.identifier) + " " +
        worldClocks[0].getCurrentTime()
        statusItem.menu = menu
        
        // メニューに都市を追加
        for worldClock in worldClocks {
            let menuItem = NSMenuItem(title: replaceUnderscoreWithSpace(worldClock.timeZone.identifier), action: #selector(menuItemClicked(_:)), keyEquivalent: "")
            menuItem.target = self
            menu.addItem(menuItem)
        }
        // Quit メニューアイテムを追加
                let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quitClicked(_:)), keyEquivalent: "q")
                quitMenuItem.target = self
                menu.addItem(quitMenuItem)
        
        // タイマーを開始して定期的に更新
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.updateWorldClocks()
            }
        }
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc func menuItemClicked(_ sender: NSMenuItem) {
        // メニューアイテムがクリックされたときの処理
        if menu.index(of: sender) != -1 {
            let index = menu.index(of: sender)
            let worldClock = worldClocks[index]
            statusItem.button?.title = worldClock.getCurrentTime()
            selected_num = index
        }
    }

    func updateWorldClocks() {
        statusItem.button?.title =
        replaceUnderscoreWithSpace(worldClocks[selected_num].timeZone.identifier) + " " +
        worldClocks[selected_num].getCurrentTime()
    }

    @objc func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    func replaceUnderscoreWithSpace(_ inputString: String) -> String {
        let resultString = inputString.replacingOccurrences(of: "_", with: " ")
        return resultString
    }
}
