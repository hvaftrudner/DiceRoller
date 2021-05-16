//
//  DiceView.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-14.
//

import SwiftUI

struct DiceView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CoreDataResult.entity(), sortDescriptors: []) var results: FetchedResults<CoreDataResult>
    
    @State private var numberOfDice = 0
    @State private var numberOfSides = 6
    
    @State private var rollingAll = false
    
    @EnvironmentObject var resultsList: ResultsList
    
    //temp array
    @State private var saveResults = [DiceResult]()
    @State private var saveResult = false
    
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var allSides = [4, 6, 8, 10, 12, 20, 100]
    
    //Should have used Result type here
    var total: Int {
        var newTotal = 0
        
        for i in 0..<saveResults.count {
            print(saveResults.count)
            newTotal += saveResults[i].roll
        }
        
        return newTotal
    }
    
    var body: some View {
        VStack {
            
            //clear out coredatamodels
            Button("Delete"){
                for result in results {
                    self.moc.delete(result)
                }
            }
            
            Text("DiCE")
                .font(.largeTitle)
            
            Stepper("How many dices?:  \(numberOfDice)", value: $numberOfDice, in: 0...100)
            
            VStack{
                
                Text("Dice sides")
                    .font(.caption)
                
                Picker("Dice Sides", selection: $numberOfSides) {
                    ForEach(allSides, id: \.self){
                        Text("\($0)") //.tag(self.allSides[$0 + 1])
                        //.tag is needed or else it doesnt register
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
            }
            
            ScrollView{
                LazyVGrid(columns: gridItemLayout){
                    ForEach(0..<numberOfDice, id: \.self){ dice in
                        Dice(numberOfSides: $numberOfSides, isRollingAll: $rollingAll, rollArray: $saveResults, saveRolls: $saveResult)
                        
                    }
                }
            }
            
            HStack{
                Button("Roll all", action: {
                    //print
                    if numberOfDice > 0 {
                        self.rollingAll = true
                    }
                   
                })
                .frame(width: 100, height: 40)
                
                Text("Total: \(total)")
                    .font(.title)
                
                Button("Save Rolls", action: {
                    
                    self.saveResult = true
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        
                        self.saveRolls()
                    }
                    
                })
            }
        }
    }
    
    func saveRolls(){
        
        let arrayForSaving = saveResults
        let newArray = Result(id: UUID(), result: total, allResults: arrayForSaving)
        resultsList.results.append(newArray)
        
        let newResult = CoreDataResult(context: self.moc)
        newResult.id = newArray.id
        newResult.result = Int16(newArray.result)

        for i in arrayForSaving {
            let newDice = CoreDataDice(context: self.moc)
            newDice.id = i.id
            newDice.roll = Int16(i.roll)
            newDice.sides = Int16(i.sides)
            
            //got error here, didnt set newDice.result "to many" in coredata
            newDice.result = newResult
            //newResult.dice = newDice
            
            try? self.moc.save()
        }
        
        try? self.moc.save()
        
        
        //reset game
        self.saveResult = false
        self.numberOfDice = 0
        self.saveResults.removeAll()
        
        print(arrayForSaving)
    }
    
    func loadResults(){
        
        if resultsList.results.isEmpty {
            print("has stored info")
            
            let newArray = results.map({Result.init(coreDataResult: $0)})
            self.resultsList.results = newArray
        }
    }
}

//struct DiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiceView()
//    }
//}
