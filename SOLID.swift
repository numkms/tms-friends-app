//
//  SOLID.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import Foundation

// DRY - Dont Repeat Yourself
// S - Single Responsobility Principle
class Person {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func printDescription() {
        print("Person name is \(name)")
    }
    
    func nameLengthDescription() {
        print("Person name length is \(name.count)")
    }

//    НЕ ПРАВИЛЬНО
//    func save() {
//        UserDefaults.standard.setValue(self, forKey: "person")
//    }
    
}

class PersonStorage {
    static func save(person: Person) {
        UserDefaults.standard.setValue(self, forKey: "person")
    }
    
    static func savedPerson() -> Person? {
        UserDefaults.standard.value(forKey: "person") as? Person
    }
}


// O - Open closed principle

protocol Animal {
    func makeSound()
}

// Default method
extension Animal {
    func makeSound() {
        print("No sound")
    }
}

class Cat: Animal {
    func makeSound() {
        print("Meow");
    }
}

class Dog: Animal {
    func makeSound() {
        print("Woof");
    }
}

class Cow: Animal {
    func makeSound() {
        print("Moo");
    }
}

class Bird {}

class ZooMarket {
    let animals: [Animal] = [Dog(), Cat(), Cow()]
    
    func showAnimals() {
        animals.forEach { animal in
            animal.makeSound()
        }
    }
}

//let market = ZooMarket()
//market.showAnimals()


// L - Liskov Substitution Principle

class Calculator {
    var res: Int = .zero
    
    func multiply() {
        sum(a: 1, b: 2)
    }
    
    func sum(a: Int, b: Int) {
        res += a + b
    }
    
    func result() {
        print(res)
    }
}


class OwnCalculator: Calculator {
    override func sum(a: Int, b: Int) {
        res = a * b
    }
}

//class Bird {
//    func fly() {
//        print("The bird is flying")
//    }
//}
//
//class Penguin: Bird {
//    override func fly() {
//        fatalError("Penguins can't fly!")
//    }
//}

//func makeBirdFly(_ bird: Bird) {
//    bird.fly()
//}
//
//let bird = Bird()
//makeBirdFly(bird) // "The bird is flying"
//
//let penguin = Penguin()
//makeBirdFly(penguin) // Runtime error: "Penguins can't fly!"

//protocol Flyable {
//    func fly()
//}
//
//class Bird {
//    // Базовый класс для всех птиц
//}
//
//class Sparrow: Bird, Flyable {
//    func fly() {
//        print("The sparrow is flying")
//    }
//}
//
//class Penguin: Bird {
//    // Пингвин не реализует Flyable, потому что не может летать
//}


// I - Interface segregation principle 
protocol ExcelUser {
    func countInExcel()
}

protocol CoffeeMaker {
    func makeCoffee()
    func addMilkToCoffee()
}

protocol WebsiteAdmin {
    func addArticleToWebsite()
}

protocol Employee {
    func countInExcel()
    func makeCoffee()
    func addArticleToWebsite()
}

struct EmployeeImpl: ExcelUser, CoffeeMaker, WebsiteAdmin {
    func addMilkToCoffee() {
        print("Its already in 3in1 coffee")
    }
    
    let name: String
    
    func countInExcel() {
        print("Counting in excel")
    }
    
    func makeCoffee() {
        print("Making 3 in 1 coffee")
    }
    
    func addArticleToWebsite() {
        print("adds article to website")
    }
}


struct CoffeeMachine: CoffeeMaker {
    func addMilkToCoffee() {
        print("Addin milk to coffee")
    }
    
    func makeCoffee() {
        print("Making latte coffee")
    }
}

class Office {
    func makeCoffe(maker: CoffeeMaker) {
        maker.makeCoffee()
        maker.addMilkToCoffee()
    }
}

class Main {
    func a() {
        let office = Office()
        let empl = EmployeeImpl(name: "Svofard")
        office.makeCoffe(maker: CoffeeMachine())
        office.makeCoffe(maker: empl)
        empl.countInExcel()
        empl.addArticleToWebsite()
        
    }
}

// D - Dependency Inversion Principle

protocol PersonStorageProtocol {
    func save(person: Person)
    func savedPerson() -> Person?
}

class PersonStorageImpl: PersonStorageProtocol {
    func save(person: Person) {
        UserDefaults.standard.setValue(self, forKey: "person")
    }
    
    func savedPerson() -> Person? {
        UserDefaults.standard.value(forKey: "person") as? Person
    }
}

class PersonSessionStorage: PersonStorageProtocol {
    var person: Person?
    
    func save(person: Person) {
        self.person = person
    }
    
    func savedPerson() -> Person? {
        return person
    }
}

class StorageMock: PersonStorageProtocol {
    
    var saveWasCalled: Int = 0
    var savePersonArgh: Person?
    func save(person: Person) {
        saveWasCalled += 1
        savePersonArgh = person
    }
    
    var savedPersonWasCalled: Int = 0
    var savedPersonStub: Person?
    func savedPerson() -> Person? {
        savedPersonWasCalled += 1
        return savedPersonStub
    }
}



class Profile {
    let personStorage: PersonStorageProtocol
    
    init(personStorage: PersonStorageProtocol) {
        self.personStorage = personStorage
    }
    
    func getPerson() {
        if let person =  personStorage.savedPerson() {
            print(person)
        } else {
            print("person not found")
        }
    }
}


class Application {
    func makeProfile() {
        let profile = Profile(personStorage: PersonSessionStorage())
        let profile2 = Profile(personStorage: PersonStorageImpl())
        
        let storageMock = StorageMock()
        let testProfile = Profile(personStorage: storageMock)
        testProfile.getPerson()
        
        if storageMock.savedPersonWasCalled == 1 {
            // тест прошел
        } else {
            
        }
    }
}





