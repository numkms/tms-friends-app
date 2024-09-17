//
//  City.swift
//  Weather
//
//  Created by Vladimir Kurdiukov on 16.09.2024.
//

import Foundation

struct City: Codable {
    let name: String
    let established: Int?
    let area: Int
    let population: Int
    let growthIndex: Double
    let peopleKnowledgeIndex: Int?
    let dateOfLastRevolution: Date?
    
    var establishedStr: String {
        guard let established else { return "unknown" }
        return "\(established)"
    }
    
    init(
        name: String,
        established: Int? = nil,
        area: Int,
        population: Int,
        growthIndex: Double,
        peopleKnowledgeIndex: Int? = nil,
        dateOfLastRevolution: Date? = nil
    ) {
        self.name = name
        self.established = established
        self.area = area
        self.population = population
        self.growthIndex = growthIndex
        self.peopleKnowledgeIndex = peopleKnowledgeIndex
        self.dateOfLastRevolution = dateOfLastRevolution
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.established = try container.decodeIfPresent(Int.self, forKey: .established)
        self.area = try container.decode(Int.self, forKey: .area)
        if let population = try? container.decode(Int.self, forKey: .population) {
            self.population = population
        } else if let stringPopulation = try? container.decode(String.self, forKey: .population), let intPopulation = Int(stringPopulation) {
            self.population = intPopulation
        } else {
            self.population = 0
        }
        self.peopleKnowledgeIndex = try container.decodeIfPresent(Int.self, forKey: .peopleKnowledgeIndex)
        self.dateOfLastRevolution = try container.decodeIfPresent(Date.self, forKey: .dateOfLastRevolution)
        self.growthIndex = try container.decode(Double.self, forKey: .growthIndex)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case established
        case area
        case population
        case peopleKnowledgeIndex
        case dateOfLastRevolution
        case growthIndex = "growth"
    }
}

extension String {
    static let empty = ""
}
