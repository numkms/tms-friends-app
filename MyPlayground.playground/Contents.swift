import UIKit


class A {}

class B {
    var a: A = .init()
    weak var a1: A?
}

protocol ViewDelegate: AnyObject {
    func updateSomething()
}

class AnotherView: ViewDelegate {
    let view: View = .init()
    
    func updateSomething() {
        
    }
    
    deinit {
        print("AnotherView deinited")
    }
}

class View {
    weak var delegate: ViewDelegate?
    
    func a() {
        delegate?.updateSomething()
    }
    
    deinit {
        print("View deinited")
    }
}

var anotherView: AnotherView = .init()

anotherView.view.delegate = anotherView


anotherView = .init()



struct Cat: Equatable {
    var name: String
}

class Dog: Equatable {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        lhs.name == rhs.name
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

var cat = Cat(name: "Liza")
let dog = Dog(name: "Booblik")

var catLink = cat
catLink.name = "Masha"
print(cat.name)
print(catLink.name)

let dogLink = dog

let dog2 = Dog(name: "Sharik")
dogLink.name = "Sharik"
print(dog.name)
print(dogLink.name)
print(dogLink === dog)
print(catLink == cat)
print(dog2 == dog)
print(dog2 === dog)


class C {
    var closure: (() -> Void)?
    
    init() {
        closure = { [unowned self] in
            self.toPrint()
        }
    }
    
    func toPrint() {
        print("aaaa")
    }
    
    deinit {
        print("C is deinited")
    }
}

var c = C()
c.closure?()
c = .init()
