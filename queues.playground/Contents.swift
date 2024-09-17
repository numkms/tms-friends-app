import UIKit
//
//let greenQueue = DispatchQueue(label: "green")
//let redQueue = DispatchQueue(label: "green")
//
//greenQueue.sync {
//    print(1)
//    print(2)
//    print(3)
//    print(4)
//    print(5)
//    redQueue.async {
//        sleep(2)
//        print(10)
//        greenQueue.async {
//            print(20)
//        }
//    }
//    print(6)
//}



// Создаем очередь
let serialQueue = DispatchQueue(label: "serial-queue.id")
let secondQueue = DispatchQueue(label: "serial-queue.id2")

// Создаем семафор
let semaphore = DispatchSemaphore(value: 1) // count

serialQueue.async {
    print("Semaphore one")
    semaphore.wait() // count - 1 = 0
    print(1)
    // Создаем задержку на 1 секунду
    sleep(5)
    // Разблокируем семафор
    semaphore.signal() // count + 1 = 0
}

secondQueue.async {
    print("Semaphore two")
    semaphore.wait() // count - 1 = -1
    print(4)
    // Создаем задержку на 1 секунду
    sleep(5)
    // Разблокируем семафор
    semaphore.signal() // count + 1
}

print(2)
// Блокируем очередь
semaphore.wait() // count - 1 // 0
print(3)




func performTask() {
    // Update UI on the main thread
    DispatchQueue.main.async {
        print("UI updated")
        // Background task
        DispatchQueue.global(qos: .background).async {
            // Simulate a long-running task
            sleep(2)
            print("Background task completed")
        }
    }
}

func downloadData() {
    let dispatchGroup = DispatchGroup()
    
    let sources = ["source1", "source2", "source3"]
    
    for source in sources {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            // Simulate network call
            sleep(1)
            print("\(source) downloaded")
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
        print("All downloads completed!")
    }
}


func downloadData() {
    let dispatchGroup = DispatchGroup()
    
    let sources = ["source1", "source2", "source3"]
    
    for source in sources {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            // Simulate network call
            sleep(1)
            print("\(source) downloaded")
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
        print("All downloads completed!")
    }
}


