//
//  GroupsController.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 31/08/21.
//

import Foundation

class Group : Identifiable {
    var id = UUID()
    var name: String
    var contents: [Application]
    
    init(name: String){
        self.name = name
        self.contents = []
    }
    init(name: String, contents: [Application]){
        self.name = name
        self.contents = contents
    }
}

var testGroups: [Group] = [
    Group(name: "TestOne", contents: [
        Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode")
    ]),
    Group(name: "TestTwo", contents: [
        Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"),
        Application(name: "XCode", appID: "com.apple.dt.Xcode")
    ]),
    Group(name: "TestThree", contents: [
        Application(name: "XCode", appID: "com.apple.dt.Xcode")
    ]),
    Group(name: "TestTwo", contents: [
        Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"),
        Application(name: "XCode", appID: "com.apple.dt.Xcode")
    ]),
    Group(name: "TestTwo", contents: [
        Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"),
        Application(name: "XCode", appID: "com.apple.dt.Xcode")
    ])
]
