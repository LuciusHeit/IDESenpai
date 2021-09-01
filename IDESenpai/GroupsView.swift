//
//  GroupsView.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 31/08/21.
//

import SwiftUI

struct GroupsView: View {
    @Binding var showGroupMenu: Bool
    var selectedApplication: Application
    
    var body: some View {
        ZStack{
            Color.black.brightness(0.1).opacity(showGroupMenu ? 0.3 : 0).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {

                ScrollView{
                    ForEach(testGroups){ group in
                        GroupCell(group: group, selectedApplication: selectedApplication)
                    }
                }
                .padding(.vertical)
                

                HStack{
                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            showGroupMenu = false
                        }
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
    var addInGroupIcon: String
    
    init(group: Group, selectedApplication: Application){
        self.group = group
        self.selectedApplication = selectedApplication
        for app in self.group.contents {
            if app.equals(app: self.selectedApplication){
                addInGroupIcon = "plus.app.fill"
                return
            }
        }
        addInGroupIcon = "plus.app"
        
    }
    
    var body: some View {
        ZStack{
            Color.accentColor.opacity(0.12).padding(.trailing, 15)
            HStack{
                Text(group.name)
                Spacer()
                Button(action: {
                    print("test")
                }){
                    Image(systemName: addInGroupIcon)
                        .padding(.trailing)
                        .font(.title)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding([.leading, .vertical], 3.0)
            .padding(.trailing, 6)
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    
    static var previews: some View {
        GroupsView(showGroupMenu: .constant(true), selectedApplication: Application(name: "Visual Studio Code", appID: "com.microsoft.VSCode"))
    }
}
