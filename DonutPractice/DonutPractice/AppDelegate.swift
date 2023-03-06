//
//  AppDelegate.swift
//  DonutPractice
//
//  Created by 김호준 on 2023/03/06.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
  private var window: NSWindow?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(contentRect: NSMakeRect(0, 0, 600, 600),
                      styleMask: [.miniaturizable, .closable, .resizable, .titled],
                      backing: .buffered,
                      defer: false)
    window?.title = "Car Render"
    window?.contentViewController = ViewController()
    window?.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

