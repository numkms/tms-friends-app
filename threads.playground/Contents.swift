import UIKit

func printMultithreading() {
    print("2")
    DispatchQueue.global().async {
        print("3")
        DispatchQueue.main.async {
            print("4")
        }
        print("5")
    }
    print("6")
}

print("1")
printMultithreading()
print("7")

// 1, 2, 6, 7, 3, 5, 4
