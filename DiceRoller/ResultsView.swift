//
//  ResultsView.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-14.
//

import SwiftUI

struct ResultsView: View {
    
    @EnvironmentObject var resultsList: ResultsList
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CoreDataResult.entity(), sortDescriptors: []) var results: FetchedResults<CoreDataResult>
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Results")
                    .font(.largeTitle)
                
                List{
                    ForEach(resultsList.results, id: \.self){ result in
                        Text("total: \(result.result)")
                
                
                        ScrollView{
                            LazyVGrid(columns: gridItemLayout){
                                ForEach(result.allResults, id: \.self){ dice in
                
                                    Rectangle()
                                        .frame(width: 20, height: 20)
                                        .mask(Text("\(dice.roll)"))
                                        .font(.caption)
                                        .background(Color.black)
                                        .foregroundColor(Color.white)
                                        
                
                                }
                                .padding(10)
                            }
                        }
                    }
                    .onDelete(perform: deleteRoll)
                }
                .onAppear{
                    self.loadResults()
                    print(resultsList.results)
                }
            }
        }
    }
    func deleteRoll(at offsets: IndexSet){
        
        for offset in offsets{
            let roll = results[offset]
            moc.delete(roll)
            resultsList.results.remove(at: offset)
        }
        try? moc.save()
    }
    
    func loadResults(){
        let newArray = results.map({Result.init(coreDataResult: $0)})
        self.resultsList.results = newArray
        
    }
    
    //func to delete row of result
    //func to populate rows
    func seedResults(){
        for i in 0...10{
            let newResult = Result(id: UUID(), result: i * 2, allResults: [DiceResult]())
            resultsList.results.append(newResult)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}


//



