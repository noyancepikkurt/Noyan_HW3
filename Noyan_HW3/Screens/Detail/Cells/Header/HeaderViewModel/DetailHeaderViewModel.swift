//
//  DetailHeaderViewModel.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 1.06.2023.
//

import Foundation
import DictionaryAPI
import AVFoundation

protocol HeaderViewModelDelegate: AnyObject {
    func didNotFoundAudioURL()
}

final class DetailHeaderViewModel {
    var meaningModel: [Meaning]
    var phoneticModel: [Phonetic]
    var audioURL: URL?
    var audioPlayer = AVAudioPlayer()
    weak var delegate: HeaderViewModelDelegate?
    
    init(meaningModel: [Meaning],phoneticModel: [Phonetic]) {
        self.meaningModel = meaningModel
        self.phoneticModel = phoneticModel
    }
    
    func requestForAudio(_ url: URL) {
        NetworkService.shared.requestAudio(url: url) {[weak self] audioPlay in
            guard let self else { return }
            self.audioPlayer = audioPlay
            self.audioPlayer.play()
        }
    }
    
    func findValidAudioURL() {
        if let firstNonEmptyAudio = phoneticModel.first(where: { !$0.audio.isNilOrEmpty() }) {
            audioURL = URL(string: firstNonEmptyAudio.audio ?? "")
        } else if !phoneticModel.isEmpty && phoneticModel.contains(where: {!$0.audio.isNilOrEmpty()}) {
            audioURL = URL(string: phoneticModel[0].audio ?? "")
        } else {
            self.delegate?.didNotFoundAudioURL()
        }
    }
    
    func numberOfItems() -> Int {
        var partOfSpeechs: [String] = []
        meaningModel.forEach({ meaning in
            guard let partOfSpeech = meaning.partOfSpeech else { return }
            partOfSpeechs.append(partOfSpeech)
        })
        return Set(partOfSpeechs).count
    }
}
