//
//  ViewController.swift
//  TodoApp
//
//  Created by Ömer Faruk KÖSE on 19.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskStore = [[TaskEntity]() ,[TaskEntity]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getData()
    }
    
    func getData(){
        let tasks = DataBaseHelper.shareInstance.fetch()
        
        taskStore = [tasks.filter{$0.isdone == false} , tasks.filter{$0.isdone == true}]
        
        tableView.reloadData()
    }

    @IBAction func addButtonClicked(_ sender: Any) {
    }
    
}

extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-Do" : "Done"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.count // 2 Dönüyor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore[indexPath.section][indexPath.row].name
        
        return cell
    }
 
}
