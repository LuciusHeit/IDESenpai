//
//  GroupsController.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 31/08/21.
//

import Foundation

class Group : Identifiable, Equatable, Encodable, Decodable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
    
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
    
    func addApp(application: Application){
        self.contents.append(application)
    }
    func removeApp(application: Application){
        if let index = self.contents.firstIndex(of: application) {
            self.contents.remove(at: index)
        }
    }
    func toCategory() -> Category {
        return Category(name: self.name, contents: self.contents)
    }
}

func saveGroups(groups: [Group]) -> Void{
    UserDefaults.standard.set(try? PropertyListEncoder().encode(groups), forKey: "groups")
}

func loadGroups() -> [Group]{
    var groupsData: [Group]
    if let data = UserDefaults.standard.value(forKey: "groups") as? Data {
        groupsData = try! PropertyListDecoder().decode([Group].self, from: data)
            return groupsData as? [Group] ?? []
    } else {
        return []
    }
}

func addGroup(add: Group, groups: [Group]) -> [Group]{
    var newGroups = groups
    newGroups.append(add)
    return newGroups
}
func addGroup(name: String, groups: [Group]) -> [Group]{
    var newGroups = groups
    newGroups.append(Group(name: name))
    return newGroups
}

func removeGroup(remove: Group, groups: [Group]) -> [Group]{
    var newGroups = groups
    
    if let index = newGroups.firstIndex(of: remove) {
        newGroups.remove(at: index)
    }
    
    return newGroups
}
func removeGroup(name: String, groups: [Group]) -> [Group]{
    var newGroups = groups
    
    if let index = newGroups.firstIndex(of: Group(name: name)) {
        newGroups.remove(at: index)
    }
    
    return newGroups
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
