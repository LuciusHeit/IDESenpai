//
//  IDESenpaiApp.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 30/08/21.
//

import SwiftUI

@main
struct IDESenpaiApp: App {
    var body: some Scene {
        WindowGroup {
            AppListView(categories: categoryList)
        }
        //WIP, command menu
        /*.commands {
            CommandMenu("First menu") {
            }
        }
        */
    }
}
