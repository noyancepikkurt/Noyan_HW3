//
//  DetailTableViewCell.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 27.05.2023.
//

import UIKit
import DictionaryAPI

class DetailTableViewCell: UITableViewCell {
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var partOfSpeechLabel: UILabel!
    @IBOutlet private var definitionsLabel: UILabel!
    @IBOutlet private var exampleLabel: UILabel!
    @IBOutlet private var example: UILabel!
    
    func setup(_ model: [Meaning], index: Int) {
        var partOfSpeechArray = [String]()
        var definitions = [Definition]()
        var exampleArray = [String]()
        var numberArray = [Int]()
        var number = 0
        
        for meaning in model {
            number = 0
            if let meaningDefinitions = meaning.definitions {
                partOfSpeechArray.append(contentsOf: meaningDefinitions.compactMap { _ in
                    number += 1
                    numberArray.append(number)
                    return meaning.partOfSpeech
                })
                definitions.append(contentsOf: meaningDefinitions)
                exampleArray.append(contentsOf: meaningDefinitions.map { $0.example ?? "" })
            }
        }
        
        if exampleArray[index].isEmpty {
            example.removeFromSuperview()
        }
        
        definitionsLabel.text = definitions[index].definition
        partOfSpeechLabel.text = partOfSpeechArray[index].capitalized
        exampleLabel.text = exampleArray[index]
        numberLabel.text = "\(numberArray[index]) -"
    }

    
}
