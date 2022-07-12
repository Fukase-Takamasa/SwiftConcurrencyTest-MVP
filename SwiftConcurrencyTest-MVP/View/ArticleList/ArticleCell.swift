//
//  ArticleCell.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 4/7/22.
//

import UIKit
import Instantiate
import InstantiateStandard
import Combine

class ArticleCell: UITableViewCell, Reusable {
    var cancellables = [AnyCancellable]()
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cancellables = [AnyCancellable]()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                
        if selected {
            baseView.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 214/255, alpha: 1)
        } else {
            baseView.backgroundColor = .white
        }
    }
}
