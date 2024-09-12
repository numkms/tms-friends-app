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




