//
//  UIViewController+Extension.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import UIKit
import Combine

extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
    
    func setEdgeSwipeBack(vc: UIGestureRecognizerDelegate) {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIScreenEdgePanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        recognizer.edges = .left
        recognizer.delegate = vc
        self.view.addGestureRecognizer(recognizer)
    }
        
    func dismissCellHighlight(tableView: UITableView) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            UIView.animate(withDuration: 0.4, animations: {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            })
        }
    }
    
    //MEMO: - フィルターとして使う時はweak selfを忘れずに　→ .filter({ [weak self] _ in self?.isVisible() ?? false })
    func isVisible() -> Bool {
        if self.viewIfLoaded?.window != nil {
            return true
        } else {
            return false
        }
    }
    
//    func setFaqButton(cancellables: [AnyCancellable]) {
//        let faqButton = UIButton(frame: CGRect(x: .zero, y: .zero, width: 40, height: 40))
//        faqButton.setImage(UIImage(named: "kurasel_icon_FAQ"), for: .normal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: faqButton)
//
//        let _ = faqButton.tap
////            .subscribe(onNext:{ [weak self] _ in
////            guard let self = self else {return}
////            let url = "https://mec-c.zendesk.com/hc/ja/categories/360004705894-FAQ"
////            let vc = SFSafariViewController(url: URL(string: url)!)
////            vc.dismissButtonStyle = .close
////            self.present(vc, animated: true, completion: nil)
////        }).disposed(by: disposeBag)
//            .sink { [weak self] element in
//                guard let self = self else { return }
//
//            }.store(in: &cancellables)
//    }
    
}
