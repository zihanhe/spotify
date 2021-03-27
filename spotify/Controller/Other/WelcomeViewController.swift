//
//  WelcomeViewController.swift
//  spotify
//
//  Created by thunder on 3/03/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "album_background")
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let lable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.textColor = .white
        lable.textAlignment = .center
        lable.font = .systemFont(ofSize: 32, weight: .semibold)
        lable.text = "Listen to Millions\nof Songs on\nthe go."
        
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
        view.addSubview(overlayView)
        
        title = "Spotify"
        view.backgroundColor = .systemBackground
        
        view.addSubview(lable)
        
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        
        
        logoImageView.frame = CGRect(x: (view.width - 120)/2,
                                     y: (view.height - 350)/2,
                                     width: 120,
                                     height: 120
        )
        
        lable.frame = CGRect(x: 30,
                             y: logoImageView.bottom+30,
                             width: view.width-60,
                             height: 150
        )

        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 44
        )
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewViewController()
        
        vc.completionHander = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
            
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func handleSignIn(success: Bool) {
        
        guard success else {
            let alert = UIAlertController(title: "Error",
                                           message: "something went wrong when signing in.",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
        
    }

}
