//
//  Singletons.swift
//  GPS
//
//  Created by Marin on 04.01.2025.
//

class STServer {
    //    static var login: String!
    //    static var password: String!
    static var trackers:[Tracker] = [Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker(),Tracker()]
    static var filteredTrackers:[Tracker] = trackers
    
    static func filterByTextField(inString:String) {
        if (inString.isEmpty) {
            filteredTrackers = trackers
            return
        }
        var filter:[Float] = Array(repeating: 0, count: STServer.trackers.count)
        var i = 0
        for tracker in STServer.trackers {
            
            for charIn in inString {
                var score:Float = 2.0
                
                for charName in tracker.name {
                    if (charIn == charName) {
                        filter[i] += score
                        break
                    }
                    score -= 0.1
                }
            }
            i += 1
        }
        for ind in 0..<STServer.trackers.count {
            print(filter[ind], "-", STServer.trackers[ind].name!)
        }
        print("-------------------------------------------0")
        STServer.filteredTrackers.removeAll()
        
        while(true) {
            
            var max:Float = 0
            var index = -1
            for i in 0..<filter.count {
                if (filter[i] > max) {
                    print(filter[i],">",max)
                    max = filter[i]
                    
                    index = i
                    print(index,filter[i])

                }
            }
            if (index == -1 || max == 0) {break}
            STServer.filteredTrackers.append(STServer.trackers[index])
            filter[index] = -1
        }
        print("-------------------------------------------1")
        for i in STServer.filteredTrackers {
            print(i.name!, terminator: " ")
        }

    }
    
}
