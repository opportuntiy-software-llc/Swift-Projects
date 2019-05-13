//
//  ShowResultsViewController.swift
//  20190315-JamesStacy-NYCSchools
//
//  Created by James Stacy on 3/15/19.
//  Copyright © 2019 James Stacy. All rights reserved.
//

import UIKit

class ShowResultsViewController: UIViewController {
    
    
    @IBOutlet weak var SchoolNameLabel: UILabel!
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Label2: UILabel!
    
    @IBOutlet weak var Label3: UILabel!
    
    @IBOutlet weak var Label4: UILabel!
    
    @IBOutlet weak var Label5: UILabel!
    
    @IBOutlet weak var Label6: UILabel!
    
    var resultsData = returnDataStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetLabel()
        
    }
    
    func SetLabel() {
        
        
        if resultsData.school_name != "" {
            SchoolNameLabel.text = resultsData.school_name
        }else{
            SchoolNameLabel.text = "No School Found"
        }
        if resultsData.dbn != "" {
            Label1.text = "DBN \(resultsData.dbn)"
        }else{
            Label1.text = "No School Found"
        }
        
        if resultsData.sat_writing_avg_score != "" {
            Label2.text = "SAT Writing Adverage Score \(resultsData.sat_writing_avg_score)"
        }else{
            Label2.text = "No Data Found"
        }
        if resultsData.sat_math_avg_score != "" {
            Label3.text = "SAT Math Adverage Score \(resultsData.sat_math_avg_score)"
        }else{
            Label3.text = "No Data Found"
        }
        if resultsData.sat_critical_reading_avg_score != "" {
            Label4.text = "Reading Critical Thinking Adverage \(resultsData.sat_critical_reading_avg_score)"
        }else{
            Label4.text = "No Data Found"
        }
        if resultsData.school_name != "" {
            Label5.text = "School Name \(resultsData.school_name)"
        }else{
            Label5.text = "No School Found"
        }
        if resultsData.num_of_sat_test_takers != "" {
            Label6.text = "Number of Testers \(resultsData.num_of_sat_test_takers)"
        }else{
            Label6.text = "No School Found"
        }
    }
    
}
