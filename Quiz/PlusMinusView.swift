//
//  PlusMinusView.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 18.11.2024.
//

import SwiftUI

// @State - делает свойство мутабельным (изменяемым), изменяем его внутри структуры, можем превратить его в биндинг добавив $ в начале и тем самым передать его внутрь другой структуры как binding, когда он внутри View при изменении body перерисовывается
// @Binding - не хранит в себе значение, а хранит ссылку на какой-то стейт, когда мы меняем биндинг, мы на самом деле меняем стейт на который он ссылается

struct ApplicationView: View {
    @State var initialValue: Int = 10000
    
    var body: some View {
        PlusMinusView(value: initialValue)
        Button("Change init value") {
            initialValue = 1000
        }.onChange(of: initialValue) { oldValue, newValue in
            print(oldValue, newValue)
        }
    }
}

struct PlusMinusView: View {
    @State var value: Int = 0
     
    var body: some View {
        HStack {
            MinusButton(value: $value)
            ValueView(value: value)
            PlusButton(value: $value)
        }
    }
}

struct ValueView: View {
    var value: Int
    
    var body: some View {
        Text("\(value)")
        Button("Reset") {}
    }
}

struct PlusButton: View {
    @Binding var value: Int
    
    var body: some View {
        Button("+") {
            value += 1
        }
    }
}

struct MinusButton: View {
    @Binding var value: Int
    
    var body: some View {
        Button("-") {
            value -= 1
        }
    }
}

#Preview {
    ApplicationView()
}
