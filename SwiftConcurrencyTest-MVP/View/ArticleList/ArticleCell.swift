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
    var lgtmUsers = [User]()
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellables = [AnyCancellable]()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: LgtmUserListCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: LgtmUserListCell.reusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
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

extension ArticleCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ArticleCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lgtmUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default)
        let placeHolderImage = UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig)
        
        let user = lgtmUsers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LgtmUserListCell.reusableIdentifier, for: indexPath) as! LgtmUserListCell
        cell.imageView.image = placeHolderImage
        cell.imageView.kf.setImage(with: URL(string: user.profileImageUrl ?? ""), placeholder: placeHolderImage)
        return cell
    }
}
