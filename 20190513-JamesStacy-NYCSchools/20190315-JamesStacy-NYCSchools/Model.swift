//
//  Model.swift
//  20190315-JamesStacy-NYCSchools
//
//  Created by James Stacy on 5/13/19.
//  Copyright © 2019 James Stacy. All rights reserved.
//

import Foundation



func doTHis(string:String) {
    
    
    let data = string.data(using: .utf8)!
    do {
        
        
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
        {
            
            for name in jsonArray {
                var makeItBetter = "\(name.values)"
                var keysForData = "\(name.keys)"
                
                makeItBetter.removeFirst()
                makeItBetter.removeLast()
                
                keysForData.removeFirst()
                keysForData.removeLast()
                
                switch RetreaveDataState {
                case 0 :
                    schoolNameHolder.append(makeItBetter)
                    
                case 1 :
                    if schoolNames.count < schoolNameHolder.count {
                        schoolDataHolder.nameOfSchool = schoolNameHolder[schoolNames.count]
                    }else{
                        print("Error in system \(schoolNames.count) \(schoolNameHolder.count)")
                    }
                    schoolDataHolder.dbnNumberOfSchool = makeItBetter
                    schoolNames.append(schoolDataHolder)
                    if !reasultsAreFromASearch {
                        allNamesHolder = schoolNames
                    }
                case 2:
                    let holderArray = makeItBetter.components(separatedBy: ", ")
                    let holderArray2 = keysForData.components(separatedBy: ", ")
                    for index in holderArray.indices {
                        if holderArray2.count > index {
                            switch holderArray2[index] {
                            case "\"sat_writing_avg_score\"":
                                resultsForSearch.sat_writing_avg_score = holderArray[index]
                            case "\"sat_math_avg_score\"":
                                resultsForSearch.sat_math_avg_score  = holderArray[index]
                            case "\"school_name\"":
                                resultsForSearch.school_name = holderArray[index]
                            case "\"dbn\"":
                                resultsForSearch.dbn = holderArray[index]
                            case "\"sat_critical_reading_avg_score\"":
                                resultsForSearch.sat_critical_reading_avg_score = holderArray[index]
                            case "\"num_of_sat_test_takers\"":
                                resultsForSearch.num_of_sat_test_takers = holderArray[index]
                            default:
                                print("More thaan you added \(holderArray2[index])")
                            }
                        }else{
                            print("Arrays out of sequence")
                        }
                        
                    }
                    
                    nc.post(name: NSNotification.Name(rawValue: "ShowResults"), object: nil)
                    
                default:
                    print("Problem with switch \(RetreaveDataState)  max 2")
                }
                
            }
        } else {
            print("bad json")
        }
    } catch let error as NSError {
        print(error)
    }
}
