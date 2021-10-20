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

        getData()
    }
    
    func getData(){
        let tasks = DataBaseHelper.shareInstance.fetch()
        taskStore = [tasks.filter{$0.isdone == false} , tasks.filter{$0.isdone == true}]
        tableView.reloadData()
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else {return}
            if name != "" {
                DataBaseHelper.shareInstance.save(name: name, isdone: false)
            }
            self.getData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter task here..."
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore[indexPath.section][indexPath.row].name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.count // 2 Dönüyor
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do" : "Done"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore[section].count
    }
    
    //right to left swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (aciton, sourceView, completionHandler) in
            let row = self.taskStore[0][indexPath.row]
            DataBaseHelper.shareInstance.update(name: row.name!, isdone: true)
            self.getData()
        }
        doneAction.backgroundColor = .green
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
    
    // left to right swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (aciton, sourceView, completionHandler) in
            let row = self.taskStore[indexPath.section][indexPath.row]
            DataBaseHelper.shareInstance.delete(name: row.name!)
            self.getData()
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
