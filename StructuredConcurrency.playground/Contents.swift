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
Task {
    let a = A()
    print("A Created")
    await a.start()
    print("A did count")
    await a.start()
    await a.start()
    await a.start()
    await a.start()
}

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
}
print("After task placed")

