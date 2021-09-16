//
//  GroupsView.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 31/08/21.
//

import SwiftUI

struct GroupsView: View {
    @Binding var showGroupMenu: Bool
    @State var appGroups: [Group]
    var selectedApplication: Application
    
    init(showGroupMenu: Binding<Bool>, selectedApplication: Application) {
        self._showGroupMenu = showGroupMenu
        self.selectedApplication = selectedApplication
        
        self.appGroups = loadGroups()
    }
    init(showGroupMenu: Binding<Bool>, selectedApplication: Application, appGroups: [Group]) {
        self._showGroupMenu = showGroupMenu
        self.selectedApplication = selectedApplication
        
        self.appGroups = appGroups
    }
    
    var body: some View {
        ZStack{
            Color.black.brightness(0.1).opacity(showGroupMenu ? 0.3 : 0).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {

                ScrollView{
                    NewGroupCell(appGroups: $appGroups)
                    ForEach(self.appGroups){ group in
                        GroupCell(group: group, selectedApplication: selectedApplication, appGroups: $appGroups)
                    }
                }
                .padding(.vertical)
                

                HStack{
                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            showGroupMenu = false
                        }
                        
                        //Save the modified groups
                        saveGroups(groups: appGroups)
                    }, label: {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                            .frame(height: 34, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.accentColor.brightness(-0.2).opacity(0.2))
                            .font(Font.system(size: 13, weight: .semibold))
                            .padding([.leading, .bottom])
                        
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            //.frame(maxWidth: 400)
        }
    }
}

struct GroupCell: View {
    var group : Group
    var selectedApplication: Application
    @State private var addInGroupIcon: String
    @State private var isAppInGroup: Bool
    @Binding var appGroups: [Group]
    
    init(group: Group, selectedApplication: Application, appGroups: Binding<[Group]>){
        self.group = group
        self.selectedApplication = selectedApplication
        self._appGroups = appGroups
        if self.group.contents.contains(selectedApplication) {
            self.addInGroupIcon = "folder.fill"
            self.isAppInGroup = true
        }else {
            addInGroupIcon = "folder"
            self.isAppInGroup = false
        }
    }
    
    var body: some View {
        ZStack{
            Color.accentColor.opacity(0.12).padding(.trailing, 15)
            Button(action: {
                if isAppInGroup {
                    print("Removing app "+selectedApplication.name+" to group "+group.name)
                    group.removeApp(application: selectedApplication)
                    self.addInGroupIcon = "folder"
                    self.isAppInGroup = false
                }else {
                    print("Adding app "+selectedApplication.name+" to group "+group.name)
                    group.addApp(application: selectedApplication)
                    self.addInGroupIcon = "folder.fill"
                    self.isAppInGroup = true
                }
            }){
                HStack{
                    Text(group.name)
                    ZStack {
                        Color.black.opacity(0.001)
                        Spacer()
                    }
                    Image(systemName: addInGroupIcon)
                        .padding(.trailing)
                        .font(.title)
                }
                .padding([.leading, .vertical], 3.0)
                .padding(.trailing, 6)
                
            }.buttonStyle(PlainButtonStyle())
        }.contextMenu {
            Button(action: {
                print("Removing group")
                appGroups = removeGroup(remove: group, groups: appGroups)
            }){
                HStack{
                    Image(systemName: "trash.fill")
                    Text("Delete group...")
                }
            }
        }
    }
}

struct NewGroupCell: View {
    @State var groupName = ""
    @State var newIcon = "folder.badge.plus"
    @State var showTextField = false
    @State var iconPaddingRight: CGFloat? = 16
    @Binding var appGroups: [Group]
    
    var body: some View {
        ZStack{
            Color.accentColor.opacity(0.12).padding(.trailing, 15)
            
            Button(action: {
                toggleTextField()
            }){
                HStack{
                    Text("New group").bold()
                    if !showTextField {
                        ZStack {
                            Color.black.opacity(0.001)
                            Spacer()
                        }
                    }
                    Button(action: {
                       toggleTextField()
                    }){
                        Image(systemName: newIcon)
                            .padding(.leading)
                            .padding(.trailing, iconPaddingRight)
                            .font(.title)
                    }.buttonStyle(PlainButtonStyle())
                    if showTextField {
                        TextField("Insert group name...", text: $groupName, onCommit: {
                            groupName = groupName.trimmingCharacters(in: .whitespacesAndNewlines)
                            if groupName != "" {
                                print("Creating group "+groupName)
                                appGroups = addGroup(name: groupName, groups: appGroups)
                                toggleTextField()
                            }
                        })
                        .padding(.trailing, 20)
                    }
                }
                .padding([.leading, .vertical], 6.0)
                .padding(.trailing, 6)
                
            }.buttonStyle(PlainButtonStyle())
        }
        .padding(.bottom, 5.0)
    }
    
    func toggleTextField(){
        withAnimation(.linear(duration: 0.4)) {
            showTextField = !showTextField
            
            if showTextField {
                newIcon = "chevron.forward"
                iconPaddingRight = 0
            }else {
                newIcon = "folder.badge.plus"
                iconPaddingRight = 16
            }
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    
    static var previews: some View {
        /*GroupsView(showGroupMenu: .constant(true), selectedApplication: Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"), appGroups: testGroups)*/
        GroupsView(showGroupMenu: .constant(true), selectedApplication: Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"))
    }
}
