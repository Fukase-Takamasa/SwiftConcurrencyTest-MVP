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
    var lgtmUsersModel: LgtmUsersModel?
    
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
        
        collectionView.register(UINib(nibName: LgtmUserIconCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: LgtmUserIconCell.reusableIdentifier)
        collectionView.register(UINib(nibName: LgtmCountCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: LgtmCountCell.reusableIdentifier)

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
        if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1) {
            return CGSize(width: 60, height: 32)
        }else {
            return CGSize(width: 32, height: 32)
        }
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
        return (lgtmUsersModel?.lgtms.count ?? 0 + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //一番最後のセルの場合
        if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1) {
            let lgtmCountCell = collectionView.dequeueReusableCell(withReuseIdentifier: LgtmCountCell.reusableIdentifier, for: indexPath) as! LgtmCountCell
            if let lgtmUsersModel = lgtmUsersModel {
                lgtmCountCell.lgtmCountLabel.text = "+\((lgtmUsersModel.totalLgtmCount - 10))件"
            }
            return lgtmCountCell
            
        }else {
            let systemImageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default)
            let placeHolderImage = UIImage(systemName: "person.crop.circle", withConfiguration: systemImageConfig)
            
            let lgtm = lgtmUsersModel?.lgtms[indexPath.row]
            let lgtmUserIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: LgtmUserIconCell.reusableIdentifier, for: indexPath) as! LgtmUserIconCell
            lgtmUserIconCell.imageView.image = placeHolderImage
            lgtmUserIconCell.imageView.kf.setImage(with: URL(string: lgtm?.user.profileImageUrl ?? ""), placeholder: placeHolderImage)
            return lgtmUserIconCell
        }
    }
}
