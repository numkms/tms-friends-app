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


protocol CarEngineDelegate: AnyObject {
    func maximumPower() -> Int
    func turnOn()
    func isRunning() -> Bool
}

class Car {
    weak var engineDelegate: CarEngineDelegate?
    
    func maximumPower() -> Int? {
        engineDelegate?.maximumPower()
    }
    
    func turnEngineOn() {
        engineDelegate?.turnOn()
    }
    
    func isEngineRuning() -> Bool? {
        return engineDelegate?.isRunning()
    }
    
}

class Engine {
    var isRunning: Bool = false
}

class EngineTSI: Engine, CarEngineDelegate {
    func maximumPower() -> Int {
        320
    }
    
    func turnOn() {
        isRunning = true
    }
    
    func isRunning() -> Bool {
        return isRunning
    }
}

class TwoJZEngine: Engine, CarEngineDelegate {
    func maximumPower() -> Int {
        190
    }
    
    func turnOn() {
        isRunning = true
    }
    
    func isRunning() -> Bool {
        return isRunning
    }
}

let carWW = Car()
let carToyota = Car()

let toyoutaEngine = TwoJZEngine()
let wwEngine = EngineTSI()

carWW.engineDelegate = wwEngine
carToyota.engineDelegate = toyoutaEngine


carWW.maximumPower()
carToyota.maximumPower()

//wwEngine.turnOn()
carWW.turnEngineOn()

carWW.isEngineRuning()


class MyViewController: UIViewController {
//    let parentVC: UIViewController
//    
//    init(parentViewController: UIViewController) {
//        self.parentVC = parentViewController
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(onAppear: @escaping () -> Void) {
        self.onAppear = onAppear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let onAppear: () -> Void
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onAppear()
        let viewController = MySecondController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension MyViewController: MySecondViewControllerDelegate {
    func loaded() {
        print("presented controller loaded")
    }
}

protocol MySecondViewControllerDelegate: AnyObject {
    func loaded()
}

class MySecondController: UIViewController {
    weak var delegate: MySecondViewControllerDelegate?
    
    
    override func viewDidLoad() {
        delegate?.loaded()
    }
}

let vc = UIViewController()

var a: String = ""

let myVc = MyViewController(onAppear: {
    a = "appeared"
})

vc.present(myVc, animated: true)

class Home {
    let flat: String
    
    init(flat: String) {
        self.flat = a
    }
    
    init() {
        flat = ""
    }
}

class House: Home {
    init(flat2: Int = 1) {
        super.init(flat: "\(flat2)")
    }
}

class Townhouse: Home {
    override init(flat: String) {
        super.init()
        print(flat)
    }
}

let b = Home(flat: "sadsa")

//let townhouse = Townhouse(flat2: "ten")
//let townhouse2 = Townhouse(flat2: "eight")

//Array.init(repeating: Townhouse(flat: "eight"), count: 1000)
//let townhouse = Townhouse(flat: "eight")
//Array.init(repeating: townhouse, count: 1000)
//let string = "A"
//Array.init(repeating: string, count: 1000)
//let house = House()













