//
//  MyPageViewController.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 19/7/22.
//

import UIKit
import Instantiate
import InstantiateStandard
import Combine
import Kingfisher

class MyPageViewController: UIViewController, StoryboardInstantiatable {
    private var cancellables = [AnyCancellable]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = PlaceHolderImageUtil.userIconPlaceHolderImage()
        
        Store.shard.authorizedUserResponse
            .sink { [weak self] element in
                guard let self = self else { return }
                guard let user = element else { return }
                self.imageView.kf.setImage(with: URL(string: user.profileImageUrl ?? ""))
                self.userNameLabel.text = user.name
                self.userIdLabel.text = "@" + (user.id ?? "")
                self.descriptionLabel.text = user.description
            }.store(in: &cancellables)}

}
