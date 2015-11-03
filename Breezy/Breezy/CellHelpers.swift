//
//  CellHelpers.swift
//  Breezy
//
//  Created by Matthew Goo on 11/2/15.
//  Copyright © 2015 TeamNAM. All rights reserved.
//

import Foundation

class CellHelpers {
    
    static func drawCellBackground(cell: UITableViewCell, fillColor: UIColor, backgroundImage: UIImage?) -> Void {
        let bgView = UIView(frame: cell.frame)
        let cellMargin: CGFloat = 10.0
        let fillColorRect = CGRect(x: cell.bounds.origin.x + cellMargin, y: cell.bounds.origin.y + cellMargin, width: cell.bounds.width - (cellMargin * 2), height: cell.bounds.height - cellMargin)
        let fillColorView = UIView(frame: fillColorRect)
        fillColorView.backgroundColor = fillColor
        fillColorView.alpha = 0.7
        fillColorView.layer.cornerRadius = 10
        let imgView = UIImageView(frame: fillColorRect)
        imgView.image = backgroundImage
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        bgView.addSubview(imgView)
        bgView.addSubview(fillColorView)
        cell.backgroundView = bgView
    }
}