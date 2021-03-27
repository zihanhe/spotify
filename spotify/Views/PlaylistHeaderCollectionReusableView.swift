//
//  PlaylistHeaderCollectionReusableView.swift
//  spotify
//
//  Created by thunder on 12/03/21.
//

import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}


final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 22, weight: .semibold)
        return lable
    }()

    private let descriptionLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = .secondaryLabel
        lable.font = .systemFont(ofSize: 18, weight: .regular)
        lable.numberOfLines = 0
        return lable
    }()

    private let ownerLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = .secondaryLabel
        lable.font = .systemFont(ofSize: 18, weight: .light)
        return lable
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        return button
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayAll(){
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        imageView.frame = CGRect(x: (width-imageSize)/2,
                                 y: 20,
                                 width: imageSize,
                                 height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width-20, height: 44)
        
        playAllButton.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        
        imageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
