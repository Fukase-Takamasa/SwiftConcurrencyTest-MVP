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

protocol MyPageView: AnyObject {
    func showUserInformation(user: UserEntity)
}

class MyPageViewController: UIViewController, StoryboardInstantiatable {
    var presenter: MyPagePresentation?
    private var cancellables = [AnyCancellable]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
}

extension MyPageViewController: MyPageView {
    func showUserInformation(user: UserEntity) {
        self.imageView.kf.setImage(with: URL(string: user.profileImageUrl ?? ""))
        self.userNameLabel.text = user.name
        self.userIdLabel.text = "@" + (user.id ?? "")
        self.descriptionLabel.text = user.description
    }
}
