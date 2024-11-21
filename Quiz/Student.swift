//
//  Student.swift
//  Quiz
//
//  Created by Vladimir Kurdiukov on 20.11.2024.
//

import SwiftUI

struct Avatar: View {
    var body: some View {
        
            LinearGradient(
                colors: [.red, .blue],
                startPoint: .top, endPoint: .bottom
            ).mask(Circle())
                .frame(width: 250, height: 250)
        
    }
}

struct Homework: Identifiable {
    let id = UUID().uuidString
    let title: String
    let description: String
    var rate: Double
}

struct Student: Identifiable {
    let id = UUID().uuidString
    let firstName: String
    let lastName: String
    var homeworks: [Homework]
}

struct StudentDetails: View {
    
    let student: Student
    
    @State
    var isLongLayout: Bool = true
    
    var body: some View {
        VStack {
            if !isLongLayout {
                ZStack {
                    Avatar()
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First name").bold()
                                .font(.headline)
                            Text(student.firstName)
                            Text("Last name").bold()
                                .font(.headline)
                            Text(student.lastName)
                        }
                    }
                }
            } else {
                Avatar()
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First name").bold()
                            .font(.headline)
                        Text(student.firstName)
                        Text("Last name").bold()
                            .font(.headline)
                        Text(student.lastName)
                    }
                    Spacer()
                }
                .padding()
            }
            
            Button("Change layout") {
                withAnimation(.spring(.smooth)) {
                    isLongLayout.toggle()
                }
            }
            Text("Homeworks")
                 .bold()
                .font(.headline)
            
            ScrollView {
                LazyVStack {
                    ForEach((0...100000), id: \.self) { _ in
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(student.homeworks) { homework in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(homework.title)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(homework.description)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text("Rate: \(homework.rate, specifier: "%.1f")")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemGray6))
                                    )
                                    .padding(.vertical, 4)
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
        Spacer()
    }
}


#Preview {
    StudentDetails(student: Student(
        firstName: "Alexey",
        lastName: "Kolobkov",
        homeworks: (0...100000).map { _ in
            return Homework(title: "Math", description: "Algebra problems", rate: 4.5)
        }
    ))
}
