//
//  AlertView.swift
//  IDESenpai
//
//  Created by Andrea Atzei on 02/09/21.
//

import SwiftUI
import AppKit
import Cocoa

struct AlertView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NSHostin
    }
    
}
extension UIAlertController {
    convenience init(alert: AlertConfig) {
        self.init(title: alert.title, message: nil, preferredStyle: .alert)
        addTextField { $0.placeholder = alert.placeholder }
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil)
        })
        let textField = self.textFields?.first
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text)
        })
    }
}



struct AlertHelper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: AlertConfig
    let content: Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertHelper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    final class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertHelper>) {
        uiViewController.rootView = content
        if isPresented && uiViewController.presentedViewController == nil {
            var alert = self.alert
            alert.action = {
                self.isPresented = false
                self.alert.action($0)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}

public struct AlertConfig {
    public var title: String
    public var placeholder: String = ""
    public var accept: String = "OK"
    public var cancel: String = "Cancel"
    public var action: (String?) -> ()
}

extension View {
    public func alert(isPresented: Binding<Bool>, _ alert: AlertConfig) -> some View {
        AlertHelper(isPresented: isPresented, alert: alert, content: self)
    }
}

struct ContentView: View {
    @State var isAlert = false
    var body: some View {
        VStack {
            Button("Show Alert") {
                self.isAlert = true
            }
        }
        .alert(isPresented: $isAlert, AlertConfig(title: "Title", action: {
            print("Text \($0 ?? "Cancelled")")
        }))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
