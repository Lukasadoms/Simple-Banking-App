//
//  SelfSizingTableView.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/3/21.
//

import UIKit

// This table view has automatic height of its content height
class SelfSizingTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        // AutoLayout uses intrinsicContentSize.height
        // instead of heightConstraint to determine
        // element height in UI
        return contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            // When content size changes, force recalculation of
            // intristic content size
            invalidateIntrinsicContentSize()
        }
    }
}
