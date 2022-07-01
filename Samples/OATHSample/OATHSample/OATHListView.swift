//
//  ContentView.swift
//  OATHSample
//
//  Created by Jens Utbult on 2021-11-11.
//

import SwiftUI



struct OATHListView: View {
    
    @StateObject var model = OATHListModel()
    @State private var isShowingSettings = false
    @State private var isKeyInserted = false

    var body: some View {
        NavigationView {
            List(model.codes) {
                Text($0.code)
            }
            .navigationTitle("Codes (\(model.source))")
            #if os(iOS)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button( "\(isKeyInserted ? "Remove YubiKey" : "Insert YubiKey")") {
                        isKeyInserted.toggle()
                        model.simulateYubiKey(insert: isKeyInserted)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { model.stopWiredConnection(); isShowingSettings.toggle() }) {
                        Image(systemName: "ellipsis.circle")
                    }
                    .sheet(isPresented: $isShowingSettings, onDismiss: {
                        model.startWiredConnection()
                    }, content: {
                        SettingsView()
                    })
                }
            })
            .refreshable {
                model.calculateCodes(connectionType: .nfc)
            }
            #endif
        }
        .onAppear {
            model.startWiredConnection()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OATHListView()
    }
}
