//
//  UIViewController+Extension.swift
//  SwiftConcurrencyTest-MVP
//
//  Created by ウルトラ深瀬 on 8/7/22.
//

import UIKit

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
}
