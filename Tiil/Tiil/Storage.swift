//
//  Storage.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation

protocol TargetsStorage {
    func add(target: Target)
    func preparedTargets() -> [Target]
    func delete(target: Target)
}

class FileManagerStorage: TargetsStorage {
    private let fileManager: FileManager = FileManager.default
    
    private var documentsPath: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private var targetsFolder: URL? {
        documentsPath?.appendingPathComponent("Targets")
    }
    
    private var mainTargetsFile: URL? {
        targetsFolder?.appendingPathComponent("targets_main.json")
    }
    
    private func createFolderIfNeeded() {
        if let targetsFolder, fileManager.fileExists(atPath: targetsFolder.path) == false {
            do {
              try fileManager.createDirectory(at: targetsFolder, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
    }
    
    private func save(targets: [Target]) {
        guard let mainTargetsFile else { return }
        let encoder = JSONEncoder()
        let data = try? encoder.encode(targets)
        fileManager.createFile(atPath: mainTargetsFile.path, contents: data)
    }
    
    private func readTargets() -> [Target] {
        createFolderIfNeeded()
        guard let mainTargetsFile else { return [] }
        guard let data = try? Data(contentsOf: mainTargetsFile) else { return [] }
        let decoder = JSONDecoder()
        guard let targets = try? decoder.decode([Target].self, from: data) else { return [] }
        return targets
    }
    
    func add(target: Target) {
        var currentTargets = readTargets()
        currentTargets.append(target)
        save(targets: currentTargets)
    }
    
    func delete(target: Target) {
        var currentTargets = readTargets()
        currentTargets.removeAll { $0 == target }
        save(targets: currentTargets)
    }
    
    func preparedTargets() -> [Target] {
        readTargets().reversed()
    }
}

class LocalStorage: TargetsStorage {
    private let defaults = UserDefaults.standard
    private let key = "localstoragekey"
    
    private func savedTargets() -> [Target]  {
        guard let data = defaults.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        guard let targets = try? decoder.decode([Target].self, from: data) else { return [] }
        return targets
    }
    
    private func save(targets: [Target]) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(targets)
        defaults.set(data, forKey: key)
    }
    
    func add(target: Target) {
        var currentTargets = savedTargets()
        currentTargets.append(target)
        save(targets: currentTargets)
    }
    
    func preparedTargets() -> [Target] {
        return savedTargets().reversed()
    }
    
    func delete(target: Target) {
        var currentTargets = savedTargets()
        currentTargets.removeAll { $0 == target }
        save(targets: currentTargets)
    }
}

class Storage: TargetsStorage {
    static let shared = Storage()
    
    var targets: [Target] = []
    
    func add(target: Target) {
        targets.append(target)
    }
    
    func preparedTargets() -> [Target] {
        return targets.reversed()
    }
    
    func delete(target: Target) {
        targets.removeAll { $0 == target }
    }
}
