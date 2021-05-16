//
//  Dice.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-14.
//

import SwiftUI
import CoreHaptics

struct Dice: View {
    
    //Haptics
    @State private var engine: CHHapticEngine?
    
    @State private var animationDegrees = 0.0
    @State private var animationNumber = 1
    
    @State private var finishedNumber = 0

    @Binding var numberOfSides: Int
    @Binding var isRollingAll: Bool
    @Binding var rollArray: [DiceResult]
    @Binding var saveRolls: Bool
    
    @State private var timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    //change timer to update another value to fix roll
    
    var body: some View {
        Rectangle()
            .frame(width: 50, height: 50)
            .mask(Text("\(animationNumber)"))
            .foregroundColor(Color.white)
            .background(Color.black)
            .padding()

            //.foregroundColor(Color.white)
            .onTapGesture {

                withAnimation(.linear(duration: 3)) {
                    
                    self.animationDegrees += 720
                    self.startTimer()
                    
                    //Add haptic feedback
                    self.customHaptic()
                    
                }
            }
            .onAppear {
                self.stopTimer()
                
                
                if isRollingAll{
                    self.animationDegrees += 720
                    self.startTimer()
                }
            }
            .onChange(of: isRollingAll){ _ in
                
                withAnimation() {
                    
                    self.animationDegrees += 720
                    self.startTimer()
                    
                    //Add haptic feedback
                    self.customHaptic()
                }
            }
            .onChange(of: saveRolls){ _ in
                if saveRolls == true {
                    self.addResult()
                }
            }
            .rotation3DEffect(.degrees(animationDegrees), axis: (x: 5, y: 5, z: 5))
            .onReceive(timer){ time in
                withAnimation(.linear(duration: 3)){
                    self.animationNumber = Int.random(in: 1...numberOfSides)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                        self.stopTimer()
                        self.isRollingAll = false
                        
                        
                    })
                }
            }
            .onAppear(perform: prepareHaptics)
    }
    
    func stopTimer(){
        self.timer.upstream.connect().cancel()
        //self.prepareHaptics()
    }
    
    func startTimer(){
        self.timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
        //self.prepareHaptics()
    }
    
    func addResult(){
            
        self.finishedNumber = self.animationNumber
            
        let newDice = DiceResult(id: UUID(), roll: self.finishedNumber, sides: self.numberOfSides)
        rollArray.append(newDice)
        print(newDice)
        
    }
    
    //: MARK--HAPTICS
    func prepareHaptics(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error starting the haptics engine \(error.localizedDescription)")
        }
    }
    func customHaptic(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        var events = [CHHapticEvent]()
            
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1)
        
        //Buzz 2 times
        //Add different events to customize haptic
        events.append(event)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("failed to play patter \(error.localizedDescription)")
        }
            
    }
}

//struct Dice_Previews: PreviewProvider {
//    
//    let newDegrees = 5.0
//    let newNumber = 5
//    
//    static var previews: some View {
//        Dice(animationDegrees: $newDegrees, animationNumber: $newNumber)
//    }
//}
