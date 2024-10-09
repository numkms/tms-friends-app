//
//  Models.swift
//  SpaceXLaunch
//
//  Created by Vladimir Kurdiukov on 09.10.2024.
//

import UIKit

struct ViewModels {
    struct Launch {
        let title: String
        let subtitle: String
        let icon: UIImage
    }
}

struct Models {
    // MARK: - Launch
    struct Launch: Codable {
        let flightNumber: Int?
        let missionName: String?
        let missionID: [JSONAny]?
        let upcoming: Bool?
        let launchYear: String?
        let launchDateUnix: Int?
        let launchDateUTC: String?
//        let launchDateLocal: Date?
//        let isTentative: Bool?
//        let tentativeMaxPrecision: String?
//        let tbd: Bool?
//        let launchWindow: Int?
//        let rocket: Rocket?
//        let ships: [JSONAny]?
//        let telemetry: Telemetry?
//        let launchSite: LaunchSite?
        let launchSuccess: Bool?
//        let launchFailureDetails: LaunchFailureDetails?
//        let links: Links?
//        let details, staticFireDateUTC: String?
//        let staticFireDateUnix: Int?
//        let timeline: Timeline?
//        let crew: JSONNull?

        enum CodingKeys: String, CodingKey {
            case flightNumber = "flight_number"
            case missionName = "mission_name"
            case missionID = "mission_id"
            case upcoming
            case launchYear = "launch_year"
            case launchDateUnix = "launch_date_unix"
            case launchDateUTC = "launch_date_utc"
//            case launchDateLocal = "launch_date_local"
//            case isTentative = "is_tentative"
//            case tentativeMaxPrecision = "tentative_max_precision"
//            case tbd
//            case launchWindow = "launch_window"
//            case rocket, ships, telemetry
//            case launchSite = "launch_site"
            case launchSuccess = "launch_success"
//            case launchFailureDetails = "launch_failure_details"
//            case links, details
//            case staticFireDateUTC = "static_fire_date_utc"
//            case staticFireDateUnix = "static_fire_date_unix"
//            case timeline, crew
        }
    }

    // MARK: - LaunchFailureDetails
    struct LaunchFailureDetails: Codable {
        let time: Int?
        let altitude: JSONNull?
        let reason: String?
    }

    // MARK: - LaunchSite
    struct LaunchSite: Codable {
        let siteID, siteName, siteNameLong: String?

        enum CodingKeys: String, CodingKey {
            case siteID = "site_id"
            case siteName = "site_name"
            case siteNameLong = "site_name_long"
        }
    }

    // MARK: - Links
    struct Links: Codable {
        let missionPatch, missionPatchSmall: String?
        let redditCampaign, redditLaunch, redditRecovery, redditMedia: JSONNull?
        let presskit: JSONNull?
        let articleLink: String?
        let wikipedia, videoLink: String?
        let youtubeID: String?
        let flickrImages: [JSONAny]?

        enum CodingKeys: String, CodingKey {
            case missionPatch = "mission_patch"
            case missionPatchSmall = "mission_patch_small"
            case redditCampaign = "reddit_campaign"
            case redditLaunch = "reddit_launch"
            case redditRecovery = "reddit_recovery"
            case redditMedia = "reddit_media"
            case presskit
            case articleLink = "article_link"
            case wikipedia
            case videoLink = "video_link"
            case youtubeID = "youtube_id"
            case flickrImages = "flickr_images"
        }
    }

    // MARK: - Rocket
    struct Rocket: Codable {
        let rocketID, rocketName, rocketType: String?
        let firstStage: FirstStage?
        let secondStage: SecondStage?
        let fairings: Fairings?

        enum CodingKeys: String, CodingKey {
            case rocketID = "rocket_id"
            case rocketName = "rocket_name"
            case rocketType = "rocket_type"
            case firstStage = "first_stage"
            case secondStage = "second_stage"
            case fairings
        }
    }

    // MARK: - Fairings
    struct Fairings: Codable {
        let reused, recoveryAttempt, recovered: Bool?
        let ship: JSONNull?

        enum CodingKeys: String, CodingKey {
            case reused
            case recoveryAttempt = "recovery_attempt"
            case recovered, ship
        }
    }

    // MARK: - FirstStage
    struct FirstStage: Codable {
        let cores: [Core]?
    }

    // MARK: - Core
    struct Core: Codable {
        let coreSerial: String?
        let flight: Int?
        let block: JSONNull?
        let gridfins, legs, reused: Bool?
        let landSuccess: JSONNull?
        let landingIntent: Bool?
        let landingType, landingVehicle: JSONNull?

        enum CodingKeys: String, CodingKey {
            case coreSerial = "core_serial"
            case flight, block, gridfins, legs, reused
            case landSuccess = "land_success"
            case landingIntent = "landing_intent"
            case landingType = "landing_type"
            case landingVehicle = "landing_vehicle"
        }
    }

    // MARK: - SecondStage
    struct SecondStage: Codable {
        let block: Int?
        let payloads: [Payload]?
    }

    // MARK: - Payload
    struct Payload: Codable {
        let payloadID: String?
        let noradID: [JSONAny]?
        let reused: Bool?
        let customers: [String]?
        let nationality, manufacturer, payloadType: String?
        let payloadMassKg, payloadMassLbs: Int?
        let orbit: String?
        let orbitParams: OrbitParams?

        enum CodingKeys: String, CodingKey {
            case payloadID = "payload_id"
            case noradID = "norad_id"
            case reused, customers, nationality, manufacturer
            case payloadType = "payload_type"
            case payloadMassKg = "payload_mass_kg"
            case payloadMassLbs = "payload_mass_lbs"
            case orbit
            case orbitParams = "orbit_params"
        }
    }

    // MARK: - OrbitParams
    struct OrbitParams: Codable {
        let referenceSystem, regime: String?
        let longitude, semiMajorAxisKM, eccentricity: JSONNull?
        let periapsisKM, apoapsisKM, inclinationDeg: Int?
        let periodMin, lifespanYears, epoch, meanMotion: JSONNull?
        let raan, argOfPericenter, meanAnomaly: JSONNull?

        enum CodingKeys: String, CodingKey {
            case referenceSystem = "reference_system"
            case regime, longitude
            case semiMajorAxisKM = "semi_major_axis_km"
            case eccentricity
            case periapsisKM = "periapsis_km"
            case apoapsisKM = "apoapsis_km"
            case inclinationDeg = "inclination_deg"
            case periodMin = "period_min"
            case lifespanYears = "lifespan_years"
            case epoch
            case meanMotion = "mean_motion"
            case raan
            case argOfPericenter = "arg_of_pericenter"
            case meanAnomaly = "mean_anomaly"
        }
    }

    // MARK: - Telemetry
    struct Telemetry: Codable {
        let flightClub: JSONNull?

        enum CodingKeys: String, CodingKey {
            case flightClub = "flight_club"
        }
    }

    // MARK: - Timeline
    struct Timeline: Codable {
        let webcastLiftoff: Int?

        enum CodingKeys: String, CodingKey {
            case webcastLiftoff = "webcast_liftoff"
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
                return true
        }

        public var hashValue: Int {
                return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if !container.decodeNil() {
                        throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
                }
        }

        public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encodeNil()
        }
    }

    class JSONCodingKey: CodingKey {
        let key: String

        required init?(intValue: Int) {
                return nil
        }

        required init?(stringValue: String) {
                key = stringValue
        }

        var intValue: Int? {
                return nil
        }

        var stringValue: String {
                return key
        }
    }

    class JSONAny: Codable {

        let value: Any

        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
                return DecodingError.typeMismatch(JSONAny.self, context)
        }

        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
                return EncodingError.invalidValue(value, context)
        }

        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
                if let value = try? container.decode(Bool.self) {
                        return value
                }
                if let value = try? container.decode(Int64.self) {
                        return value
                }
                if let value = try? container.decode(Double.self) {
                        return value
                }
                if let value = try? container.decode(String.self) {
                        return value
                }
                if container.decodeNil() {
                        return JSONNull()
                }
                throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
                if let value = try? container.decode(Bool.self) {
                        return value
                }
                if let value = try? container.decode(Int64.self) {
                        return value
                }
                if let value = try? container.decode(Double.self) {
                        return value
                }
                if let value = try? container.decode(String.self) {
                        return value
                }
                if let value = try? container.decodeNil() {
                        if value {
                                return JSONNull()
                        }
                }
                if var container = try? container.nestedUnkeyedContainer() {
                        return try decodeArray(from: &container)
                }
                if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                        return try decodeDictionary(from: &container)
                }
                throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
                if let value = try? container.decode(Bool.self, forKey: key) {
                        return value
                }
                if let value = try? container.decode(Int64.self, forKey: key) {
                        return value
                }
                if let value = try? container.decode(Double.self, forKey: key) {
                        return value
                }
                if let value = try? container.decode(String.self, forKey: key) {
                        return value
                }
                if let value = try? container.decodeNil(forKey: key) {
                        if value {
                                return JSONNull()
                        }
                }
                if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                        return try decodeArray(from: &container)
                }
                if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                        return try decodeDictionary(from: &container)
                }
                throw decodingError(forCodingPath: container.codingPath)
        }

        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
                var arr: [Any] = []
                while !container.isAtEnd {
                        let value = try decode(from: &container)
                        arr.append(value)
                }
                return arr
        }

        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
                var dict = [String: Any]()
                for key in container.allKeys {
                        let value = try decode(from: &container, forKey: key)
                        dict[key.stringValue] = value
                }
                return dict
        }

        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
                for value in array {
                        if let value = value as? Bool {
                                try container.encode(value)
                        } else if let value = value as? Int64 {
                                try container.encode(value)
                        } else if let value = value as? Double {
                                try container.encode(value)
                        } else if let value = value as? String {
                                try container.encode(value)
                        } else if value is JSONNull {
                                try container.encodeNil()
                        } else if let value = value as? [Any] {
                                var container = container.nestedUnkeyedContainer()
                                try encode(to: &container, array: value)
                        } else if let value = value as? [String: Any] {
                                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                                try encode(to: &container, dictionary: value)
                        } else {
                                throw encodingError(forValue: value, codingPath: container.codingPath)
                        }
                }
        }

        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
                for (key, value) in dictionary {
                        let key = JSONCodingKey(stringValue: key)!
                        if let value = value as? Bool {
                                try container.encode(value, forKey: key)
                        } else if let value = value as? Int64 {
                                try container.encode(value, forKey: key)
                        } else if let value = value as? Double {
                                try container.encode(value, forKey: key)
                        } else if let value = value as? String {
                                try container.encode(value, forKey: key)
                        } else if value is JSONNull {
                                try container.encodeNil(forKey: key)
                        } else if let value = value as? [Any] {
                                var container = container.nestedUnkeyedContainer(forKey: key)
                                try encode(to: &container, array: value)
                        } else if let value = value as? [String: Any] {
                                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                                try encode(to: &container, dictionary: value)
                        } else {
                                throw encodingError(forValue: value, codingPath: container.codingPath)
                        }
                }
        }

        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
                if let value = value as? Bool {
                        try container.encode(value)
                } else if let value = value as? Int64 {
                        try container.encode(value)
                } else if let value = value as? Double {
                        try container.encode(value)
                } else if let value = value as? String {
                        try container.encode(value)
                } else if value is JSONNull {
                        try container.encodeNil()
                } else {
                        throw encodingError(forValue: value, codingPath: container.codingPath)
                }
        }

        public required init(from decoder: Decoder) throws {
                if var arrayContainer = try? decoder.unkeyedContainer() {
                        self.value = try JSONAny.decodeArray(from: &arrayContainer)
                } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                        self.value = try JSONAny.decodeDictionary(from: &container)
                } else {
                        let container = try decoder.singleValueContainer()
                        self.value = try JSONAny.decode(from: container)
                }
        }

        public func encode(to encoder: Encoder) throws {
                if let arr = self.value as? [Any] {
                        var container = encoder.unkeyedContainer()
                        try JSONAny.encode(to: &container, array: arr)
                } else if let dict = self.value as? [String: Any] {
                        var container = encoder.container(keyedBy: JSONCodingKey.self)
                        try JSONAny.encode(to: &container, dictionary: dict)
                } else {
                        var container = encoder.singleValueContainer()
                        try JSONAny.encode(to: &container, value: self.value)
                }
        }
    }

}
