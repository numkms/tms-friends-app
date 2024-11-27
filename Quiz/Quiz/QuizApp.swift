//
//  QuizApp.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI

@main
struct QuizApp: App {
    
    @State var isTabBarHidden = false
    
    var body: some Scene {
        WindowGroup {
            TabView {
                QuizList(isTabBarHidden: $isTabBarHidden)
                    .tabItem {
                    Label(
                        title: { Text("Мои квизы") },
                        icon: { Image(systemName: "42.circle") }
                    )
                }.toolbar(isTabBarHidden ? .hidden : .visible, for: .tabBar)
                
                VStack {
                    Text("Лидеры квизов").font(.system(size: 35))
                    Text("Раздел в разработке")
                }.tabItem { Label(
                    title: { Text("Лидеры в квизах") },
                    icon: { Image(systemName: "figure.archery") }
                ) }
                
                VStack {
                    Text("История квизов").font(.system(size: 35))
                    Text("Раздел в разработке")
                }.tabItem { Label(
                    title: { Text("История квизов") },
                    icon: { Image(systemName: "clock.badge") }
                )}
            }
        }.environmentObject(Storage())
    }
}


#Preview {
    QuizList(isTabBarHidden: .constant(false)).environmentObject(Storage())
}
