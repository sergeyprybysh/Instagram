//
//  PostCell.swift
//  Instagram
//
//  Created by Sergey Prybysh on 10/22/20.
//

import UIKit

class PostCell: UITableViewCell {    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
