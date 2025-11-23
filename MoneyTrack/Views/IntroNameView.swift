//
//  IntroNameView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 15.09.2025.
//

import SwiftUI

struct IntroNameView: View {
    
    var onFinish: () -> Void
    
    @AppStorage("userName") private var userName: String = ""
    
    
    var body: some View {
        
            ZStack {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundStyle(Color.background)
                
                VStack {
                        Text("Welcome to MoneyTrack!")
                            .bold(true)
                            .font(.title2)
                            .padding(.bottom, 24)
                    
                    
                    Text("Let's get to know eachother!")
                        .font(.subheadline)
                    
                    HStack(spacing: 24) {
                        Spacer()
                        
                        TextField("Your name", text: $userName)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.primary.opacity(0.2)))
                        Spacer()
                    }
                    Button("Confirm") {
                        onFinish()
                    }
                    .tint(Color.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.icon))
                    .shadow(color: .primary.opacity(0.3), radius: 6, x: 0, y: 5)
                    
                }
                .background(Color.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
    }
}


#Preview {
    IntroNameView{
        
    }
}
