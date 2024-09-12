import UIKit

class Counter {
    var count: Int = 0
    
    private let queue = DispatchQueue(label: "com.myclass.queue")
    
    func increment() {
        print(queue)
        queue.sync {
            print(1)
        }
        
        queue.sync {
            print("queue: ", count)
            count += 1
        }
        
        queue.sync {
            print(2)
        }
    }
    
    func getCount() -> Int {
        return queue.sync {
            return count
        }
    }
}


//let counter = Counter()
let queue = DispatchQueue(label: "concurent", attributes: .concurrent)
let serialQueue = DispatchQueue(label: "queue")
let threadCount = 10
var result = 0


var array: [String] = []

for _ in 1...threadCount {
    queue.async {
        for _ in 1...100 {
            serialQueue.sync {
                array.append("before")
            }
            serialQueue.sync {
               array.append("\(result)")
               result += 1
            }
            serialQueue.sync {
                array.append("after")
            }
            let a = serialQueue.sync {
                return result + 1
            }
        }
    }
}

//01--------------------
//0
//01--------------------
sleep(10)

print(array)


let tmsQueue = DispatchQueue(label: "com.teachmeskills.queue")
tmsQueue.sync {
    print(1)
}
print(3)
tmsQueue.sync {
    print(2)
}


tmsQueue.sync { print(10) }
print(30)
tmsQueue.sync { print(100) }
print(30)
tmsQueue.sync {
    print(5)
    tmsQueue.async {
        print(10)
    }
}
print(30)
print(30)
tmsQueue.sync {
    print(400)
}
print(30)
tmsQueue.sync { print(350) }


let concurrentQueue = DispatchQueue(label: "conc", attributes: .concurrent)

var count = 0


DispatchQueue.global(qos: .userInitiated).async {
    DispatchQueue.main.async {
        //        ...
    }
}

let randomQueue = DispatchQueue(label: "randomqueue")

//randomQueue.async {
//    print("Outer block called")
//    randomQueue.sync {
//        print("Inner block called")
//    }
//    print("Outer next block")
//}


var i = 0
var someQueue = DispatchQueue(label: "someQueue", attributes: .concurrent)
var lock = NSLock()

for _ in 1...10000 {
    someQueue.async {
        lock.lock()
        i += 1
        lock.unlock()
    }
}

sleep(5)

print(i)


//DispatchQueue.main.sync {
//    
//}
