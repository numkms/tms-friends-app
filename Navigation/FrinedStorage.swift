//
//  FrinedStorage.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 21.08.2024.
//

import Foundation
import UIKit

class FriendsStorage {
    static var myFriends: [FriendViewController.Friend] = [
        .init(name: "Влад", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Наталья", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Николай", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Вячеслав", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Владимир", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Максим", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Олег", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Евгений", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Алексей", age: 45, avatar: UIImage(systemName: "eraser")),
    ]
    
    static var friendsRequests: [FriendViewController.Friend] = [
        .init(name: "Анна", age: 20, avatar: UIImage(systemName: "person")),
        .init(name: "Наталья", age: 25, avatar: UIImage(systemName: "scribble")),
        .init(name: "Юлия", age: 45, avatar: UIImage(systemName: "eraser")),
        .init(name: "Яна", age: 20, avatar: UIImage(systemName: "person")),
    ]
}
