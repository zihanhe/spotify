//
//  ActionLabelView.swift
//  spotify
//
//  Created by thunder on 18/03/21.
//

import UIKit

struct ActionlabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {
    weak var delegate: ActionLabelViewDelegate?
    
    private let lable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.numberOfLines = 0
        lable.textColor = .secondaryLabel
        return lable
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true

        addSubview(button)
        addSubview(lable)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        lable.frame = CGRect(x: 0, y: 0, width: width, height: height-40)
    }
    
    func configure(with viewModel: ActionlabelViewViewModel){
        lable.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    @objc func didTapButton(){
        delegate?.actionLabelViewDidTapButton(self)
        
    }
}
