//
//  SearchResultSubtitleTableViewCell.swift
//  spotify
//
//  Created by thunder on 16/03/21.
//

import UIKit
import SDWebImage



class SearchResultSubtitleTableViewCell: UITableViewCell {

    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subTitleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width:imageSize,
                                     height: imageSize
        )
        let labelHeight = contentView.height / 2
        
        label.frame = CGRect(x: iconImageView.right + 10,
                             y: 0,
                             width: contentView.width - iconImageView.right - 15,
                             height: labelHeight
        )
        
        subTitleLabel.frame = CGRect(x: iconImageView.right + 10,
                                     y: label.bottom,
                             width: contentView.width - iconImageView.right - 15,
                             height: labelHeight
        )
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTitleLabel.text = nil

    }
    
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
    
    
}
