//
//  AlertMessages.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 31.05.2023.
//

import Foundation

public enum AlertMessage: String {
    case ifNoSearchedWordTitle = "Sorry"
    case ifNoSearchedWordMessage = "The word you are looking for does not exist in the dictionary."
    case ifSearchTextIsEmpty = "Please enter the word you want to search"
    case noInternetAlertTitle = "Error"
    case noInternetAlertMessage = "There is no internet connection, please try again"
}
