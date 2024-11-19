//
//  ContentView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 11.11.2024.
//

import SwiftUI


struct HelloWorldView: View {
    @State
    var something: String
    @Binding
    var helloWorldMessage: String
    
    var body: some View {
        Text(helloWorldMessage)
        Button("Change text") {
            helloWorldMessage = "asdas"
            something = "1111"
        }
    }
}

struct ContentView: View {
    @State
    var condition: Bool = true
    
    @State
    var message: String = "Hello, world! ---"
    
    @State
    var name: String = "Vladimir"
    
    @State
    var something: String = "Something"
    
    func create() {}
    
    
    var body: some View {
        VStack {
            if condition {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(message)
                Text(something)
                HelloWorldView(
                    something: something,
                    helloWorldMessage: $message
                )
                Text(something)
                Text(name)
                HelloWorldView(
                    something: something,
                    helloWorldMessage: $name
                )
            } else {
                Text("Hello Teach me skills onl-39")
            }
            Button("Показать другой текст") {
                condition.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
