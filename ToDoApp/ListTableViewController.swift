//
//  ListTableViewController.swift
//  ToDoApp
//
//  Created by 蔡尚諺 on 2022/1/26.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var todoDataList: [ToDoData]?
    var status = DataStatus.insert
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //抓資料
        todoDataList = ListCoreData.shared.fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoDataList?.count ?? 0
    }
    //從第二頁回來
    @IBAction func unwindToListTableViewController(_ unwindSegue: UIStoryboardSegue) {
        //可能有新增或修改資料，所以要重抓
        todoDataList = ListCoreData.shared.fetchData()
        tableView.reloadData()
        
    }
    //點擊+去下一頁
    @IBSegueAction func clickAddToEditController(_ coder: NSCoder) -> EditTableViewController? {
        
        return EditTableViewController(status: .insert, coder: coder)
    }
    //點擊編輯去下一頁
    @IBSegueAction func clickSwipeEditToEditController(_ coder: NSCoder, sender: Any?) -> EditTableViewController? {
        
        guard let todoData = sender as? ToDoData else {
            return EditTableViewController(status: .insert, coder: coder) }
        
        return EditTableViewController(status: status, todoData: todoData, coder: coder)
        
    }
                                       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoTableViewCell.self)", for: indexPath) as! ToDoTableViewCell
        
        if let todoData = todoDataList?[indexPath.row]{
            //系統圖片要用 systemName
            if todoData.done {
                cell.toDoButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                cell.contentView.alpha = 0.5
            }else{
                cell.toDoButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                cell.contentView.alpha = 1
            }
            cell.toDoButton.tag = indexPath.row
            cell.toDoButton.addTarget(self, action: #selector(selectTodoButton), for: .touchUpInside)
            
            cell.toDoNameLabel.text = todoData.name
            cell.todoDateLabel.text = ListCoreData.shared.fomatingDate(date: todoData.date!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        status = .read
        
        let todoData = todoDataList![indexPath.row]
        
        self.performSegue(withIdentifier: "clickSwipeEditToEditController", sender: todoData)
        
//        todoData.done.toggle()
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        do {
//            try ListCoreData.shared.updateData(todoData: todoData)
//        } catch let error {
//            showAlert(message: error.localizedDescription)
//            return
//        }
//
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //當筆coreData的資料
        let todoData = self.todoDataList![indexPath.row]
        
        //delete按鈕
        let delete = UIContextualAction(style: .normal, title: "") { action, view, bool in
            
            do {
                //刪除CoreData的當筆資料
                try ListCoreData.shared.deleteData(todoData: todoData)
                //刪除儲存todo的當筆資料
                self.todoDataList?.remove(at: indexPath.row)
                //刪除tableView上顯示的當筆資料
                tableView.deleteRows(at: [indexPath], with: .left)
                
                
            } catch let error {
                self.showAlert(message: error.localizedDescription)
                
            }
            
            bool(true)
            
        }
        //edit按鈕
        let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, bool in
            
            self.status = .update
            
            self.performSegue(withIdentifier: "clickSwipeEditToEditController", sender: todoData)
            
            bool(true)
        }
        
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash")
        
        edit.backgroundColor = .systemOrange
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [delete,edit])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
    
    func showAlert(message: String ){
        
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func selectTodoButton(sender: UIButton){
        
        let todoData = todoDataList![sender.tag]
        todoData.done.toggle()
        
        do {
            try ListCoreData.shared.updateData(todoData: todoData)
        } catch let error {
            showAlert(message: error.localizedDescription)
            return
        }
        
        tableView.reloadData()
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
