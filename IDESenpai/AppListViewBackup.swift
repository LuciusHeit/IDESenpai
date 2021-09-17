//
//  AppListView.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 30/08/21.
//

import SwiftUI

/*struct AppListView: View {
    var categories : [Category] = []
    var applications : [Application] = []
    var customCategories : [Category] = []
    @State var searchText = ""
    @State var showGroupMenu = false
    @State var selectedApplication: Application = Application(name: "XCode", appID: "com.apple.dt.Xcode")
    @State private var isFirstTimeGroupMenu = true
    @State private var showGroups = false
    
    init(categories: [Category]) {
        //creation of category "All"
        self.categories = categories
        for category in categories {
            for app in category.contents {
                applications.append(app)
            }
        }
        self.categories.insert(Category(name: "All", contents: applications), at: 0)
        
        let groups = loadGroups()
        for group in groups {
            self.customCategories.append(group.toCategory())
        }
        
        //initialization of user favorites
        /*GlobalData().$favorites = UserDefaults.standard.object(forKey: "favorites") as? [String:String]*/
    }
    
    var body: some View {
        ZStack{
            VStack{
                Searchbar(text: $searchText)
                
                NavigationView{
                    VStack{
                        List(categories.filter { !$0.isEmpty() }) { category in
                            CategoryCell(category: category, searchText: $searchText, showGroupMenu: $showGroupMenu, selectedApplication: $selectedApplication)
                        }
                        Divider()
                        if !showGroups {
                            VStack{
                                Button(action: {
                                    withAnimation(.linear(duration: 0.3)){
                                        showGroups = true
                                    }
                                }, label: {
                                    ZStack{
                                        Color(.purple).opacity(0.001)
                                            .frame(width: 135, height: 40.0)
                                        Text("(Close Groups)")
                                            .font(.subheadline)
                                            .padding(.bottom)
                                            .padding(.top, -20)
                                            .padding([.leading, .trailing], 25)
                                            .foregroundColor(Color(NSColor.white).opacity(0.34))
                                    }
                                    
                                })
                                .buttonStyle(PlainButtonStyle())
                                List(customCategories.filter { !$0.isEmpty() }) { category in
                                    CategoryCell(category: category, searchText: $searchText, showGroupMenu: $showGroupMenu, selectedApplication: $selectedApplication)
                                }
                                Spacer()
                            }
                        }else {
                            Button(action: {
                                withAnimation(.linear(duration: 0.3)){
                                    showGroups = true
                                }
                            }, label: {
                                ZStack{
                                    Color(.purple).opacity(0.001)
                                        .frame(width: 135, height: 40.0)
                                    Text("Your Groups")
                                        .padding(.bottom)
                                        .padding(.top, 6)
                                        .padding([.leading, .trailing], 25)
                                }
                                
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                }
                .frame(maxHeight: 350)
                .allowsHitTesting(!showGroupMenu)
            }
            if showGroupMenu {
                ZStack{
                    Rectangle().opacity(0.2)
                    if isFirstTimeGroupMenu {
                        Text("Click anywhere to cancel")
                            .font(.title)
                    }
                }.onTapGesture {
                    if showGroupMenu {
                        withAnimation(.linear(duration: 0.3)) {
                        showGroupMenu = false
                        }
                        isFirstTimeGroupMenu = false
                    }
                }
            }
        }
        ZStack{
            if showGroupMenu {
                GroupsView(showGroupMenu: $showGroupMenu, selectedApplication: selectedApplication)
            }
                
        }
    }
}

struct CategoryCell: View {
    var category : Category
    @Binding var searchText: String
    @State var active = true
    @Binding var showGroupMenu: Bool
    @Binding var selectedApplication: Application
    
    //old initialization, no longer useful
    /*init(category: Category, searchText: Binding<String>) {
        
        self.category = category
        self._searchText = searchText
        
        for app in category.contents {
            if(isAppInstalled(app.appID)){
                appNum += 1
            }
        }
        if(appNum == 0){
            isHidden = true
        }
    }*/
    
    var body: some View {
        if category.name == "All" {
            NavigationLink(
                destination: AppList(category: category.contents, searchText: $searchText, showGroupMenu: $showGroupMenu, selectedApplication: $selectedApplication), isActive: $active
            ){
                Text(category.name)
            }.fixedSize()
        }
        else {
            NavigationLink(
                destination: AppList(category: category.contents, searchText: $searchText, showGroupMenu: $showGroupMenu, selectedApplication: $selectedApplication)
            ){
                Text(category.name)
            }.fixedSize()
        }
    }
}

struct AppList: View {
    var category : [Application]
    @Binding var searchText: String
    @Binding var showGroupMenu: Bool
    @Binding var selectedApplication: Application
    
    var body: some View {
        List(category.filter({(searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())) && isAppInstalled($0.appID)}).sorted(by: {
                let favorites = UserDefaults.standard.object(forKey: "favorites") as? [String:String] ?? [:]
                let firstFav = favorites[$0.appID] ?? "false"
                let secondFav = favorites[$1.appID] ?? "false"
                
                if (firstFav == "true") && (secondFav == "false") {
                    //first is favorite, second is not
                    return true
                }else if (firstFav == "false") && (secondFav == "true") {
                    //second is favorite, first is not
                    return false
                }else {
                    //both are either favorites or not, so they order alphabetically
                    return $0.name.lowercased() < $1.name.lowercased()
                }
            } )){ app in
            AppListCell(application: app, showGroupMenu: $showGroupMenu, selectedApplication: $selectedApplication)
        }
    }
}

struct AppListCell: View {
    var application: Application
    @State var icon = "star"
    var initIcon: String
    @Binding var showGroupMenu: Bool
    @Binding var selectedApplication: Application
    
    init(application: Application, showGroupMenu: Binding<Bool>, selectedApplication: Binding<Application>) {
        self.application = application
        self._showGroupMenu = showGroupMenu
        self._selectedApplication = selectedApplication
        let favorites = UserDefaults.standard.object(forKey: "favorites") as? [String:String] ?? [:]
        let onLoadFavorite = favorites[application.appID] ?? "false"
        if onLoadFavorite == "true" {
            self.initIcon = "star.fill"
        }else {
            self.initIcon = "star"
        }
    }
    
    var body: some View {
        ZStack{
            Color.accentColor.opacity(0.12)
            HStack{
                Image(nsImage: getIcon(appID: application.appID))
                Text(application.name)
                Spacer()
                Button(action: {
                    changeFavorite()
                }){
                    Image(systemName: icon)
                        .font(.title2)
                        //State variable wouldn't change on init, so this forces to update when the button appears
                        .onAppear{self.icon = self.initIcon}
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.leading)
        }.onTapGesture {
            openApp(application.appID)
        }.contextMenu {
            Button(action: {
                print("Showing add-to-group menu")
                withAnimation(.linear(duration: 0.3)) {
                    showGroupMenu = true
                    selectedApplication = application
                }
            }){
                HStack{
                    Image(systemName: "folder.fill")
                    Text("Add to group...")
                }
            }
            
            /*Button(action: {
                print("New group")
            }){
                HStack{
                    Image(systemName: "plus.rectangle.fill.on.folder.fill")
                    Text("Add to new group")
                }
            }*/
        }
    }
    
    func changeFavorite() -> Void {
        var fav: [String:String] = UserDefaults.standard.object(forKey: "favorites") as? [String:String] ?? [:]
        if(fav[application.appID] == "true") {
            icon = "star"
            fav[application.appID] = "false"
            UserDefaults.standard.setValue(fav, forKey: "favorites")
        }else {
            icon = "star.fill"
            fav[application.appID] = "true"
            UserDefaults.standard.setValue(fav, forKey: "favorites")
        }
    }
}

struct AppListView_Previews: PreviewProvider {
    static var previews: some View {
        AppListView(categories: categoryList)
    }
}
*/
