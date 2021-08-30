//
//  AppUtils.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 30/08/21.
//

import Foundation
import Cocoa

class GlobalData: ObservableObject {
    @Published var favorites: [String: String] = [:]
}

class Application : Identifiable{
    var id = UUID()
    var name : String
    var appID : String
    
    init(name: String, appID: String){
        self.name = name
        self.appID = appID
    }
}

class Category : Identifiable{
    var id = UUID()
    var name : String
    var contents : [Application]
    
    init(name: String, contents: [Application]){
        self.name = name
        self.contents = contents
    }
    
    
    func isEmpty() -> Bool {
        var i = 0
        for app in self.contents {
            if isAppInstalled(app) {
                i += 1
            }
        }
        if i == 0 {
            return true
        }
        else {
            return false
        }
    }
}

func getURL(appID: String) -> URL? {
    let url = NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: appID
    )
    return url
}

func getIcon(appID: String) -> NSImage{
    guard let url = getURL(appID: appID)
    else {
        return NSImage()
    }
    return  NSWorkspace.shared.icon(forFile: url.path)
}

func openApp(_ appID: String) -> Void {
    guard let url = getURL(appID: appID)
    else {
        return
    }
    
    let path = "/bin"
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.arguments = [path]
    NSWorkspace.shared.openApplication(at: url,
                                       configuration: configuration,
                                       completionHandler: nil)
    return
}

func isAppInstalled(_ appID: String) -> Bool {
    guard let url = getURL(appID: appID)
    else {
        return false
    }
    
    let path = "/bin"
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.arguments = [path]
    
    if(( NSWorkspace.shared.urlForApplication(toOpen: url) ) != nil) {
        return true
    }
    else {
        return false
    }
}
func isAppInstalled(_ app: Application) -> Bool {
    let appID = app.appID
    guard let url = getURL(appID: appID)
    else {
        return false
    }
    
    let path = "/bin"
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.arguments = [path]
    
    if(( NSWorkspace.shared.urlForApplication(toOpen: url) ) != nil) {
        return true
    }
    else {
        return false
    }
}


var categoryList : [Category] = [
    Category(name: "IDE", contents: [
        Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"),
        Application(name: "Visual Studio", appID: "com.microsoft.visual-studio"),
        Application(name: "XCode", appID: "com.apple.dt.Xcode"),
        Application(name: "XCodeTest", appID: "com.apple.dt.Xcodededede"),
        Application(name: "IDLE", appID: "org.python.IDLE")
    ]),
    Category(name: "VM & Containers", contents: [
        Application(name: "Parallels", appID: "com.parallels.desktop.console"),
        Application(name: "Docker", appID: "com.docker.docker")
    ]),
    Category(name: "Database", contents: [
        Application(name: "XAMPP", appID: "com.bitnami.manager"),
        Application(name: "MAMP", appID: "de.appsolute.MAMP"),
        Application(name: "MAMP PRO", appID: "de.appsolute.mamppro")
    ]),
    Category(name: "DB Management", contents: [
        Application(name: "DBeaver", appID: "org.jkiss.dbeaver.core.product"),
        Application(name: "Azure Data Studio", appID: "com.azuredatastudio.oss"),
        Application(name: "MongoDB Compass", appID: "com.mongodb.compass"),
        Application(name: "SQLPRO (MSSQL)", appID: "com.hankinsoft.osx.tinysqlstudio"),
        Application(name: "SQLPRO (MySQL)", appID: "com.hankinsoft.osx.mysql")
    ]),
    Category(name: "Game Dev", contents: [
        Application(name: "Unity Hub", appID: "com.unity3d.unityhub"),
        Application(name: "GB Studio", appID: "dev.gbstudio.gbstudio")
    ]),
    Category(name: "Pentesting", contents: [
        Application(name: "LanScan", appID: "com.iwaxx.LanScan")
    ]),
    Category(name: "Test", contents: [
        Application(name: "Testapp", appID: "test.id")
    ]),
    Category(name: "Utils", contents: [
        Application(name: "Terminal", appID: "com.apple.Terminal"),
        Application(name: "iTerm", appID: "com.googlecode.iterm2"),
        Application(name: "Github Desktop", appID: "com.github.GitHubClient")
    ])
]
