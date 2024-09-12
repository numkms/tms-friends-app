import UIKit

class Counter {
    var count: Int = 0
    
    private let queue = DispatchQueue(label: "com.myclass.queue")
    
    func increment() {
        print(queue)
        queue.sync {
            print(1)
        }
        
//        queue.sync(flags: .barrier) {
//            print("queue: ", count)
//            count += 1
//
//        }
        
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
let queue = DispatchQueue(label: "serial")
let serialQueue = DispatchQueue(label: "queue")
let concurentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
let threadCount = 10
var result = 0

var array: [String] = []

for _ in 1...threadCount {
    concurentQueue.async {
        for _ in 1...100 {
            queue.sync {
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
            }
        }
    }
}


//01--------------------
//0
//01--------------------
sleep(10)

print(array)
