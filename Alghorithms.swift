//
//  Alghorithms.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 14.08.2024.
//

import Foundation

struct Alghs {
    struct Person: Hashable {
        let name: String
        let age: Int
    }
    
    func main() {
        func simpleHash(_ input: String) -> Int {
            let prime = 31
            var hash = 0
            
            for character in input.unicodeScalars {
                let value = Int(character.value)
                hash = hash &* prime &+ value
            }
            
            return hash
        }

        let person = Person(name: "Vladimir", age: 10)
        let person2 = Person(name: "Vladimir", age: 10)
        let person3 = Person(name: "Nikita", age: 10)
        let person4 = Person(name: "Vladimir", age: 20)

        print(person.hashValue)
        print(person2.hashValue)
        print(person3.hashValue)
        print(person4.hashValue)

        //print(simpleHash("abc"))
        //print(simpleHash("abc"))
        //print(simpleHash("abс"))

        var personDict: [Person: String] = [:
        //    person2: "Major",
        //    person: "Minor",
        //    person4: "Senior"
        ]

        var dict: [String: String] = ["key": "value"]
        dict["key"] = "data"

        struct Sportsman {
            let name: String
            let sport: String
            let age: Int
        }

        let sportsmanTop: [Sportsman] = [/*......*/]

        //sportsmanTop[55]

        let a: [Int] = [1,2,3,5,6,10,100,300]
        print(a.first!) // O(1)
        print(a[0])
        print(a[3])
        print(a.last!)
        print(a[a.count - 1])

        let array: [String] = .init(repeating: "A", count: 10000)
        array[8423] // О(1)

        let array2: [Int] = [1,3,4,6,7,8,10, 100]

        //findElement(arr: array2, target: 5) // O(n)

        func findElement(arr: [Int], target: Int) -> Bool {
            for element in arr {
                if element == target {
                    return true
                }
            }
            return false
        }

        // O(log n)
        let binaryData: [Int] = [0,1,2,5,10,100,300,1000,1000000]

        func binarySearch(arr: [Int], target: Int) -> Bool {
            var left = 0
            var right = arr.count - 1
            
            while left <= right {
                0 + (9 - 0) / 2 // 5
                let mid = left + (right - left) / 2
                if arr[mid] == target {
                    return true
                } else if arr[mid] < target {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
            return false
        }

        // O(n log n)
        let unsortedArray = [100, 500, 1, 5, 200, 1000, 1000000, 0, -2]
        func quickSort(arr: [Int]) -> [Int] {
            guard arr.count > 1 else { return arr }
            
            let pivot = arr[arr.count / 2]
            let less = arr.filter { $0 < pivot }
            let equal = arr.filter { $0 == pivot }
            let greater = arr.filter { $0 > pivot }
            // less [100,500,1,5, 200, 0, -2]
            // equal [1000]
            // greate [100000]
            
            // less  [1 0 -2]
            // equal [5]
            // greater [100 500 200]
            // [100,500,1,5, 200, 0, -2]
            return quickSort(arr: less) + equal + quickSort(arr: greater)
        }

        let result = quickSort(arr: unsortedArray)


        let abc = [1] + [1,2,3] + [5]
        print(abc)

        // O(n^2)
        func bubbleSort(arr: [Int] = [0,4,3,2]) -> [Int] {
            var sortedArr = arr
            for i in 0..<sortedArr.count {
                // 4 итерации
                for j in 0..<sortedArr.count - i - 1 {
                    /// 3
                    if sortedArr[j] > sortedArr[j + 1] {
                        let temp = sortedArr[j]
                        sortedArr[j] = sortedArr[j + 1]
                        sortedArr[j + 1] = temp
                    }
                }
            }
            return sortedArr
        }

        /// 2^n
        var count = 0
        func hanoi(n: Int, from: String, to: String, via: String) {
            count += 1
            print(count)
            if n == 1 {
                print("Move disk \(String(repeating: "_", count: n)) from \(from) to \(to)")
            } else {
                hanoi(n: n - 1, from: from, to: via, via: to)
                print("Move disk \(String(repeating: "_", count: n)) from \(from) to \(to)")
                hanoi(n: n - 1, from: via, to: to, via: from)
            }
        }
        hanoi(n: 6, from: "A", to: "C", via: "B")
        print(count)
        //
        //hanoi(n: 10, from: "A", to: "C", via: "B")
        //print(count)

        /// O(n!)
        ///
        var permuteCount = 0
        func permute(arr: [Int]) -> [[Int]] {
            
            if arr.count == 0 { return [[]] }
            permuteCount += 1
            var result = [[Int]]()
            for i in 0..<arr.count {
                var rest = arr
                let element = rest.remove(at: i)
                let permutations = permute(arr: rest)
                result += permutations.map { [element] + $0 }
            }
            
            return result
        }


        print(permute(arr: [1,2,3,4,5,19]))//,323,3421/*,32,3222,23,2,34,553,32,33,1322,322,4,12,412,3,3,123*/]))
        print(permuteCount)

    }
}










