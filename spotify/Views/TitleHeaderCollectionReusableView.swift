//
//  TitleHeaderCollectionReusableView.swift
//  spotify
//
//  Created by thunder on 12/03/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"

    private let label: UILabel = {
        let lable = UILabel()
        lable.textColor = .label
        lable.numberOfLines = 1
        lable.font = .systemFont(ofSize: 22, weight:.regular)
        return lable
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(label)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width-30, height: height)
        
    }

    func configure(with title: String) {
        label.text = title
        
    }
}
