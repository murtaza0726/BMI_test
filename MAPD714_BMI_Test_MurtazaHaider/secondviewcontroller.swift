//
//  secondviewcontroller.swift
//  MAPD714_BMI_Test_MurtazaHaider
//
//  Created by Murtaza Haider Naqvi on 2022-12-14.
//

import UIKit
import FirebaseFirestore

class secondviewcontroller: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var dictionary = [[String:AnyObject]]()
    var index = [String:AnyObject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell")! as? cell)!
        index = dictionary[indexPath.row]
        cell.weight.text = index["weight"] as! String
        cell.date.text = index["date"] as! String
        cell.bmi.text = index["bmi"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = dictionary[indexPath.row]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        retrievedata()
    }
    
    //button to delete the data from database
    @IBAction func deleteBtn(_ sender: UIButton) {
        var db = Firestore.firestore()
        db.collection("entry").document(String(index["timestamp"] as! String)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
            }
        }
    }
    
    //function to retrieve the data from database
    func retrievedata(){
        var db = Firestore.firestore()
        db.collection("entry").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.dictionary.removeAll()
                for document in querySnapshot!.documents {
                    self.dictionary.append(document.data() as [String : AnyObject])
                }
                let count = self.dictionary.count
                if(count == 0){
                    db.collection("BMI").document("data").delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            self.performSegue(withIdentifier: "main", sender: nil)
                        }
                    }
                }
                self.table.reloadData()
            }
        }
    }
}
