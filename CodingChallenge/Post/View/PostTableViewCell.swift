//
//  PostTableViewCell.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var commentButton: UIButton! {
        didSet {
            commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        }
    }
    var favoriteAction: (() -> Void)?
    var commentAction: (() -> Void)?
    var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isFavorite = false
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        favoriteAction?()
    }
    
    @IBAction func commentButtonTap(_ sender: Any) {
        commentAction?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
