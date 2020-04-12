//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by Alenazi F (FCES) on 13/03/2020.
//  Copyright © 2020 Alenazi F (FCES). All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
