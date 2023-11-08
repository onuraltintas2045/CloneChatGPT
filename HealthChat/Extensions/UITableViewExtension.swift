//
//  UITableViewExtension.swift
//  HealthChat
//
//  Created by Onur on 19.09.2023.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let lastSection = self.numberOfSections - 1
        guard lastSection >= 0 else {
            return
        }
        
        let lastRow = self.numberOfRows(inSection: lastSection) - 1
        guard lastRow >= 0 else {
            return
        }
        
        let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
        self.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
    }
}
