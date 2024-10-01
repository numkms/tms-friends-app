//
//  Storage.swift
//  Tiil
//
//  Created by Vladimir Kurdiukov on 28.08.2024.
//

import Foundation
import CoreData
import UIKit
import RealmSwift

protocol TargetsStorage {
    func add(target: Target)
    func preparedTargets() -> [Target]
    func delete(target: Target)
    func addNote(note: Note, to: Target)
}

class RealmDataStorage: TargetsStorage {
    
    var realm: Realm {
        try! Realm()
    }
    
    func add(target: Target) {
        let realmTarget = RealmTarget()
        realmTarget.name = target.name
        realmTarget.date = target.date
        try? realm.write {
            realm.add(realmTarget)
        }
    }
    
    func preparedTargets() -> [Target] {
        let targets = realm.objects(RealmTarget.self)
        return targets.map {
            .init(
                id: $0.id.stringValue,
                name: $0.name,
                date: $0.date,
                notes: []
            )
        }
    }
    
    func delete(target: Target) {
        
    }
    
    func addNote(note: Note, to: Target) {
        
    }
}

class CoreDataStorage: TargetsStorage {
    func addNote(note: Note, to target: Target) {
        guard let coreDataContext,
              let target = getTargetById(id: target.id)
        else { return }
        let dbNote = TargetNote(context: coreDataContext)
        dbNote.message = note.message
        dbNote.createdAt = note.createdAt
        target.addToNotes(dbNote)
        try? coreDataContext.save()
    }
    
    var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    var coreDataContext: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }
    
    private func readTargets() -> [TargetModel] {
        let request = TargetModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let targets = try? coreDataContext?.fetch(request)
        guard let targets else { return [] }
        return targets
    }
    
    func add(target: Target) {
        guard let coreDataContext else { return }
        let _ = target.convertToTargetModel(context: coreDataContext)
        do {
            try coreDataContext.save()
        } catch {
            print(error)
        }
    }
    
    func preparedTargets() -> [Target] {
        let targets = readTargets()
        return targets.convertToTargets()
    }
    
    func getTargetById(id: String) -> TargetModel? {
        let request = TargetModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        let targets = try? coreDataContext?.fetch(request)
        return targets?.first
    }
    
    func delete(target: Target) {
        guard let targetToDelete = getTargetById(id: target.id) else { return }
        coreDataContext?.delete(targetToDelete)
        try? coreDataContext?.save()
    }
}

class FileManagerStorage: TargetsStorage {
    func addNote(note: Note, to target: Target) {
        
    }
    
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
    func addNote(note: Note, to target: Target) {
    }
    
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
    func addNote(note: Note, to target: Target) {
     
    }
    
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
