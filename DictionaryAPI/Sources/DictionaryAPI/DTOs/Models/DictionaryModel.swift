//
//  DictionaryModel.swift
//  
//
//  Created by Noyan Çepikkurt on 27.05.2023.
//

import Foundation

// MARK: - DictionaryModelElement
public struct DictionaryModel: Codable {
    public let word, phonetic: String?
    public let phonetics: [Phonetic]?
    public let meanings: [Meaning]?
    public let license: License?
    public let sourceUrls: [String]?
}

// MARK: - License
public struct License: Codable {
    public let name: String?
    public let url: String?
}

// MARK: - Meaning
public struct Meaning: Codable {
    public let partOfSpeech: String?
    public let definitions: [Definition]?
    public let synonyms, antonyms: [String]?
}

// MARK: - Definition
public struct Definition: Codable {
    public let definition: String?
//    public let synonyms: [JSONAny]?
    public let antonyms: [String]?
    public let example: String?
}

// MARK: - Phonetic
public struct Phonetic: Codable {
    public let text: String?
    public let audio: String?
    public let sourceURL: String?
    public let license: License?

    enum CodingKeys: String, CodingKey {
        case text, audio
        case sourceURL = "sourceUrl"
        case license
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

