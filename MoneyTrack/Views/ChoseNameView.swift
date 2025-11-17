//
//  ChoseNameView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 16.09.2025.
//

import SwiftUI

struct ChoseNameView: View {
    
    @AppStorage("userName") private var userName: String = "hello"
    @State private var userNameShowing: String = ""
 
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea(.all)
                VStack{
                    Text("Your name is: ")
                        .font(.headline)
                    + Text("\(userName)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.icon)
                    
                    HStack(spacing: 24) {
                        Spacer()
                        TextField("Enter your name", text: $userNameShowing)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.primary.opacity(0.2)))
                        Spacer()
                    }
                    
                    Button("Save") {
                        userName = userNameShowing
                    }
                    .tint(Color.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.icon))
                    .shadow(color: .primary.opacity(0.15), radius: 6, x: 0, y: 5)
                    
                        
                }
            }
        }
        .onAppear {
            userNameShowing = userName
        }
    }
}

#Preview {
    ChoseNameView()
}
