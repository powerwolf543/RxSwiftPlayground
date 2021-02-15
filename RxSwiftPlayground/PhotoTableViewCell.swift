//
//  PhotoTableViewCell.swift
//
//  Created by Nixon Shih on 2020/8/26.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import RxSwift
import UIKit

internal final class PhotoTableViewCell: UITableViewCell {
    internal let contentImageView: UIImageView = UIImageView()
    
    internal let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal var bag = DisposeBag()
    
    private let padding: CGFloat = 13
    
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        contentImageView.image = nil
    }
    
    private func setup() {
        separatorInset = .zero
        backgroundColor = .clear
        selectionStyle = .none
        
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentImageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            contentImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: padding),
            contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: padding)
        ])
    }
}
