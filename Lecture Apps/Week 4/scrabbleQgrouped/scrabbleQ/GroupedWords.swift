//
//  GroupedWords.swift
//  scrabbleQ
//
//  Created by Aileen Pierce
//

import Foundation

struct GroupedWords: Decodable { //Adopt the decodable protocol
    //Make sure these variable names match the ones in the plist!
    let letter : String
    let words : [String]
}
