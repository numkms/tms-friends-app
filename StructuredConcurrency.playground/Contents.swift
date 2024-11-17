import UIKit

class A {
    func start() -> Double async {
        print("Count started")
        let b = B()
        return await b.count()
        print("Count ended")
    }
}

class B {
    func count() async -> Double  {
        var a: Double  = 1
        for _ in 0...100000 {
            a = a * 0.0000333222
        }
        return a
    }
}

print("Task placed")

print("A")
Task {
    let a = A()
    await a.start()
    await a.start()
    await a.start()
    await a.start()
    await a.start()
    print("B")
}
print("C")

Task {
    let a = A()
    await withTaskGroup(of: Double.self) { group in
        group.addTask {
            await a.start()
        }
        group.addTask {
            await a.start()
        }
        group.addTask {
            await a.start()
        }
        group.addTask {
            await a.start()
        }
    }
    /// Загрузилось
}
print("After task placed")




