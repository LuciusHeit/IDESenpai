//
//  StartupView.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 30/08/21.
//

//  NO LONGER USED

import SwiftUI

struct StartupView: View {
    var username = NSUserName()
    
    var body: some View {
        VStack{
            Text("Welcome, "+username+"!")
                .font(.title)
                .padding(.all)
            Text("I will do a quick search to list all the\nsoftware you have for programming, \nis it fine?")
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding([.leading, .bottom, .trailing])
                .scaledToFit()
            HStack(){
                Button("    Okay!    ") {
                    openApp("com.microsoft.VSCode");
                }
                .padding(.trailing)
                Button("Not really...") {
                    return ;
                }
                .padding(.leading)
            }
            .padding(.bottom)
        }.fixedSize()
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
