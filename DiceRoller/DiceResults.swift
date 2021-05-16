//
//  DiceResults.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-15.
//

import Foundation

class ResultsList: ObservableObject {
    
    @Published var results: [Result]
    
    init(){
        self.results = [Result]()
    }
    
}

struct Result: Codable, Hashable {
    var id: UUID
    var result: Int
    
    var allResults: [DiceResult]
    
}

extension Result {
    init(coreDataResult: CoreDataResult){
        self.id = coreDataResult.id ?? UUID()
        self.result = Int(coreDataResult.result )
        
        //self.allResults = coreDataResult.diceArray
        var diceArray = [DiceResult]()
        for i in coreDataResult.diceArray {
            let newDice = DiceResult(id: i.id ?? UUID(), roll: Int(i.roll), sides: Int(i.sides))
            diceArray.append(newDice)
        }
        self.allResults = diceArray
        
    }
}

struct DiceResult: Codable, Hashable {
    var id: UUID
    var roll: Int
    var sides: Int
}

