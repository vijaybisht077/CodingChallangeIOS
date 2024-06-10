//
//  CommentTableViewCell.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with comment: Comment) {
        nameLabel.text = comment.name
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
    }
}
