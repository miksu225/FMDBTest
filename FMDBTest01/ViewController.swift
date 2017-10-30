//
//  ViewController.swift
//  FMDBTest01
//
//  Created by Koulutus on 4.10.2017.
//  Copyright © 2017 MikkoS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var familyname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var dbpath : String = ""
    
    @IBAction func RESETaction(_ sender: UIButton) {
        
        firstname?.text = ""
        familyname?.text = ""
        phone.text = ""
    }
    @IBAction func SAVEaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath){
            
            //No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open()){
                let sqlstatement = "insert into person (firstname, familyname, phone) values ('\(self.firstname.text!)','\(self.familyname.text!)','\(self.phone.text!)');"
                
                let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                NSLog(connectiontoFMDB.debugDescription)
                
                if result {
                    self.status.text = "SAVE SUCCESFUL!!"
                }
                else{
                    self.status.text = "SAVE FAILURE!"
                }
            }
            connectiontoFMDB.close()
        }
    }
    
    @IBAction func LOADaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath){
            
            //No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open()){
                var sqlstatement = "select firstname, familyname, phone from person where "
                var sqlfirstname = ""
                var sqlfamilyname = ""
                var sqlphone = ""
                
                //is firstname empty?
                if self.firstname.text != ""{
                    sqlfirstname = "firstname = '\(self.firstname.text!)'"
                }
                //is familyname empty?
                if self.familyname.text != ""{
                    if self.firstname.text != ""{
                        sqlfamilyname += " and "
                    }
                    sqlfamilyname += "familyname = '\(self.familyname.text!)'"
                }
                //is phone empty?
                if self.phone.text != ""{
                    if self.firstname.text != "" || self.familyname.text != ""{
                        sqlphone += " and "
                    }
                    sqlphone += "phone = '\(self.phone.text!)'"
                }
                
                sqlstatement += sqlfirstname + sqlfamilyname + sqlphone
                //let sqlstatement = "select familyname, phone from person where firstname = '\(self.firstname.text!)';"
                NSLog("sqlstatement: " + sqlstatement)
                let resultset : FMResultSet = connectiontoFMDB.executeQuery(sqlstatement, withArgumentsIn: [])!
                if resultset.next() == true {
                    self.firstname.text = resultset.string(forColumn: "firstname")
                    self.familyname.text = resultset.string(forColumn: "familyname")
                    self.phone.text = resultset.string(forColumn: "phone")
                    
                    self.status.textColor = UIColor.green
                    self.status.text = "QUERY SUCCESSFUL!"
                    
                }
                else{
                    self.status.textColor = UIColor.red
                    self.status.text = "QUERY FAILURE!"
                }
                
                NSLog(connectiontoFMDB.debugDescription)
            }
            connectiontoFMDB.close()
        }
    }
    
    @IBAction func UPDATEaction(_ sender: UIButton) {
        
        
        if FileManager.default.fileExists(atPath: dbpath){
            
            //No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open()){
                
                let sqlstatement = "update person set familyname = '\(self.familyname.text!)', phone = '\(self.phone.text!)' where firstname =  '\(self.firstname.text!)';"
                
                let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                NSLog(connectiontoFMDB.debugDescription)
                
                if result {
                    self.status.textColor = UIColor.green
                    self.status.text = "UPDATE SUCCESSFUL!"
                }
                else {
                    self.status.textColor = UIColor.red
                    self.status.text = "UPDATE FAILURE!"
                }
            }
            connectiontoFMDB.close()
        }
        
    }
    
    
    @IBAction func DELETEaction(_ sender: UIButton) {
        
        if FileManager.default.fileExists(atPath: dbpath){
            
            //No DB connection to file so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be opened
            if (connectiontoFMDB.open()){
                var sqlstatement = "delete from person where "
                var sqlfirstname = ""
                var sqlfamilyname = ""
                var sqlphone = ""
                
                //is firstname empty?
                if self.firstname.text != ""{
                    sqlfirstname = "firstname = '\(self.firstname.text!)'"
                }
                //is familyname empty?
                if self.familyname.text != ""{
                    if self.firstname.text != "" || self.phone.text != ""{
                        sqlfamilyname += " and "
                    }
                    sqlfamilyname += "familyname = '\(self.familyname.text!)'"
                }
                //is phone empty?
                if self.phone.text != ""{
                    if self.firstname.text != "" || self.familyname.text != ""{
                        sqlphone += " and "
                    }
                    sqlphone += "phone = '\(self.phone.text!)'"
                }
                
                sqlstatement += sqlfirstname + sqlfamilyname + sqlphone
                NSLog("sqlstatement: " + sqlstatement)
                let result = connectiontoFMDB.executeUpdate(sqlstatement, withArgumentsIn: [])
                NSLog(connectiontoFMDB.debugDescription)
                
                if result {
                    self.status.textColor = UIColor.green
                    self.status.text = "DELETE SUCCESFUL!"
                }
                else{
                    self.status.textColor = UIColor.red
                    self.status.text = "DELETE FAILURE!"
                }
            }
            connectiontoFMDB.close()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //We use default filemanager in this exercise
        // It is FileManager.default
        
        //Find path to database
        let pathdummy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        
        
        //The path to DB location is set into document directory root
        // and name of DB is set as mydatabase.db
        dbpath = pathdummy[0].appendingPathComponent("mydatabase.db").path
        NSLog("dbpath: " + dbpath)
        if !FileManager.default.fileExists(atPath: dbpath){
            
            //No DB found so it must be created now
            let connectiontoFMDB = FMDatabase(path: dbpath)
            
            //connection to DB must be established if it is not working
            if (connectiontoFMDB.open()){
                let sqlstatement = "create table if not exists person (id integer primary key autoincrement, firstname text, familyname text, phone integer);"
                connectiontoFMDB.executeStatements(sqlstatement)
                NSLog(connectiontoFMDB.debugDescription)
               
            }
            
            connectiontoFMDB.close()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

