//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by 蔡尚諺 on 2022/1/26.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var toDoButton: UIButton!
    @IBOutlet weak var toDoNameLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toDoButton.imageView?.contentMode = .scaleAspectFit
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
