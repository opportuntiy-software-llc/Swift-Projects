//
//  NYCSchoolsPickerViewController.swift
//  20190315-JamesStacy-NYCSchools
//
//  Created by James Stacy on 3/15/19.
//  Copyright © 2019 James Stacy. All rights reserved.
//

import UIKit

struct returnDataStruct {
    var sat_writing_avg_score = ""
    var sat_math_avg_score = ""
    var school_name = ""
    var dbn = ""
    var sat_critical_reading_avg_score = ""
    var num_of_sat_test_takers = ""
}
struct SchoolDataStruct {
    var nameOfSchool = String()
    var dbnNumberOfSchool = String()
}

var resultsForSearch = returnDataStruct()
var resultsForSearchArray = [returnDataStruct]()
var saveToUserdefaults = UserDefaults.standard
var schoolNames = [SchoolDataStruct()]
var schoolDataHolder = SchoolDataStruct()
var RetreaveDataState = 0
var schoolNameHolder = [String()]
var allNamesHolder = [SchoolDataStruct()]
var reasultsAreFromASearch = false
let nc = NotificationCenter()

class NYCSchoolsPickerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    @IBOutlet weak var NYCSchoolsListTableView: UITableView!
    
    
    @IBOutlet weak var searchField: UITextField!
    
    let NYCURL = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$select=school_name")
    let NYCURL2 = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$select=dbn")
    let NYCSchoolURLResults = URL(string: "https://data.cityofnewyork.us/Education/SAT-Results/f9bf-2cp4")
    let NYCSchoolResultsString = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    
    var showInfoAboutReset = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolNameHolder .removeAll()
        NYCSchoolsListTableView.delegate = self
        NYCSchoolsListTableView.dataSource = self
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        showInfoAboutReset = saveToUserdefaults.object(forKey:"showInfoAboutReset") as? Bool ?? true
        reasultsAreFromASearch = false
        loadStartData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nc.addObserver(self, selector: #selector(NYCSchoolsPickerViewController.showResultsScreen), name: NSNotification.Name(rawValue: "ShowResults"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        nc.removeObserver(self, name: NSNotification.Name(rawValue: "ShowResults"), object: nil)
    }
    
    
    @objc func showResultsScreen() {
        performSegue(withIdentifier: "results", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath)
        
        cell.textLabel?.text = schoolNames[indexPath.row].nameOfSchool
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        
        var modifiedNYCSchoolResults = NYCSchoolResultsString
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if schoolNames.count > indexPath.row {
                modifiedNYCSchoolResults  += "?dbn=\(schoolNames[indexPath.row].dbnNumberOfSchool)"
            }
            let resultsURL = URL(string: modifiedNYCSchoolResults)
            if let url = resultsURL {
                if let this = try? String(contentsOf: url) {
                    print("this \(this)")
                    DispatchQueue.main.async {
                        print("Data \(this)")
                        RetreaveDataState = 2
                        self!.activityIndecator.stopAnimating()
                        self!.activityIndecator.isHidden = true
                        doTHis(string: this)
                        self!.activityIndecator.stopAnimating()
                        self!.activityIndecator.isHidden = true
                        print("this \(this.count)")
                        if this.count < 4 {
                            self!.SayWhat(say: "Failed to get data.", and: "Try again", buttonMessage: "")
                        }
                    }
                }else{
                    print("try again")
                    
                }
                
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.contents as? ShowResultsViewController {
            vc.resultsData = resultsForSearch
        }
    }
    
    
    func stopMessage(alert:UIAlertAction) {
        showInfoAboutReset = false
        saveToUserdefaults.set(false, forKey: "showInfoAboutReset")
    }
    
    func  showReminderMessage() {
        let alert = UIAlertController(title: "Use the NYC Logo to reset the list.", message: "Do want want to see this message again?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: stopMessage))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SayWhat(say:String,and:String,buttonMessage:String) {
        let alert = UIAlertController(title: say, message: and, preferredStyle: UIAlertController.Style.alert)
        
        
        if buttonMessage != "" {
            alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertAction.Style.default, handler: nil))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func searchAction() {
        var schoolNameHolder = [SchoolDataStruct()]
        schoolNameHolder.removeAll()
        reasultsAreFromASearch = true
        if schoolNames.count > 0 {
            if searchField.text!.count >= 3 {
                var c1 = 0
                for check in schoolNames {
                    if check.nameOfSchool.lowercased().contains(searchField.text!.lowercased()) {
                        schoolNameHolder.append(check)
                    }else{
                        
                    }
                    c1 += 1
                }
                
                searchField.resignFirstResponder()
                schoolNames = schoolNameHolder
                NYCSchoolsListTableView.reloadData()
                searchField.text = ""
                if  showInfoAboutReset {
                    showReminderMessage()
                }
            }else{
                SayWhat(say: "Pleae enter at least 3 Letters", and: "", buttonMessage: "")
            }
        }else{
            
        }
    }
    
    func showResetMessage() {
        if showInfoAboutReset {
            print("message")
        }else{
            
        }
    }
    
    func loadStartData() {
        schoolNames.removeAll()
        if let url = NYCURL {
            if let this = try? String(contentsOf: url) {
                RetreaveDataState = 0
                doTHis(string: this)
            }else{
                SayWhat(say: "Problem Nothing Found", and: "", buttonMessage: "")
            }
        }
        
        if let url = NYCURL2 {
            if let this = try? String(contentsOf: url) {
                RetreaveDataState = 1
                doTHis(string: this)
            }else{
                SayWhat(say: "Problem Nothing Found", and: "", buttonMessage: "")
            }
        }
    }
    
    
    @IBAction func restoreAction() {
        schoolNames =  allNamesHolder
        reasultsAreFromASearch = false
        NYCSchoolsListTableView.reloadData()
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        }else{
            return self
        }
    }
}
