//
//  EditTableViewController.swift
//  ToDoApp
//
//  Created by 蔡尚諺 on 2022/1/26.
//

import UIKit

enum DataStatus {
    case insert , update , read
}

class EditTableViewController: UITableViewController {
    
    internal init?(status: DataStatus? = nil, todoData: ToDoData? = nil, coder: NSCoder) {
        
        self.status = status
        self.todoData = todoData
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    var todoData: ToDoData?
    var status: DataStatus!
    let listCoreData = ListCoreData()
    
    /* datePicker 的狀態： true開、false關 */
    var datePickerStatus = false {
        //值改變以後要讓tableView產生動畫
        didSet{
            /* 使用此method會讓tableView有動畫 */
            tableView.performBatchUpdates{
                tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //改變desTextView的外框
        desTextView.layer.borderColor = UIColor.systemGray.cgColor
        desTextView.layer.borderWidth = 0.3
        
        //最小日期為今天
        if let todoData = todoData {
            nameTextField.text = todoData.name
            desTextView.text = todoData.descript
            datePicker.date = todoData.date!
            datePicker.minimumDate = todoData.date!
        }else{
            datePicker.minimumDate = Date()
        }
        
        //更新畫面
        updateUI()
        
        
        if status == .read {
            self.tableView.isUserInteractionEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.tableView.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        view.endEditing(true)
        
        if nameTextField.text == "" {
            showAlert(message: "事項名稱不可為空")
            return false
        }else{
            
            switch status {
            case .insert:
                
                do {
                    try listCoreData.insertData(name: nameTextField.text! , descript: desTextView.text! , date: datePicker.date)
                } catch let error {
                    showAlert(message: error.localizedDescription)
                    return false
                }
                
                
                
            case .update:
                
                todoData?.name = nameTextField.text
                todoData?.descript = desTextView.text
                todoData?.date = datePicker.date
                
                do {
                    try listCoreData.updateData(todoData: todoData!)
                } catch let error {
                    showAlert(message: error.localizedDescription)
                    return false
                }
                
                
            case .read:
                
                return true
                
            case .none:
                return false
            }
            
            
            return true
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        //設定圓角
        desTextView.layer.cornerRadius = desTextView.bounds.width / 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            /* true變false；false變true */
            datePickerStatus.toggle()
        }
        //馬上取消選擇欄位
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 ,
           indexPath.row == 1{
            if datePickerStatus {
                return UITableView.automaticDimension
            }else{
                return 0
            }
        }else {
            return UITableView.automaticDimension
        }
        
    }

    
    @IBAction func datePickerValueChanged(_ picker: UIDatePicker) {
        updateUI()
    }
    
    func updateUI(){
        //設定dateLabel
        dateLabel.text = ListCoreData.shared.fomatingDate(date: datePicker.date)
    }
    
    @IBAction func didEndOnExitTextField(_ sender: UITextField) {}
    
    
    func showAlert(message: String ){
        
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

