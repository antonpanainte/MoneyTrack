//
//  SettingsView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 16.09.2025.
//

import SwiftUI
import AVFoundation


struct SettingsView: View {
    @State var selecetedSetting: Int? = 1
    @State private var audioPlayer: AVAudioPlayer?

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea(edges: .all)
                List {
                    NavigationLink("Edit Monthly Limit", destination: ChoseLimitView())
                    NavigationLink("Edit Your Name", destination: ChoseNameView())
                    NavigationLink("Edit Currency", destination: ChoseCurrencyView())
                }
                .navigationTitle(Text("Settings"))
                .toolbar{
                    ToolbarItem(placement: .navigation) {
                        Button(action : {
                            playSound(named: "audio1", withExtension: "mp3", player: &audioPlayer)
                        }){
                            Image("mascot")
                                .resizable()         // <-- Tells the image to resize
                                .scaledToFit()       // <-- Keeps its aspect ratio
                                .frame(width: 50)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    SettingsView()
}
