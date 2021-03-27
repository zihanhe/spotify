//
//  LibraryAlbumsViewController.swift
//  spotify
//
//  Created by thunder on 18/03/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    var albums = [Album]()
    
    private var observer: NSObjectProtocol?
    
    private var noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        setupNoAlbumsView()
        fetchData()
        
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main
                                                          , using: { [weak self] _ in
                                                            self?.fetchData()
                                                          })
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUI() {
        if albums.isEmpty {
            // show empty label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            tableView.isHidden = false
            noAlbumsView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noAlbumsView.frame = CGRect(x: (view.width-150)/2,
                                    y: (view.height-150)/2,
                                    width: 150,
                                    height: 150
        )
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
    }

    private func setupNoAlbumsView(){
        view.addSubview(noAlbumsView)
        noAlbumsView.isHidden = false
        noAlbumsView.delegate = self
        
        noAlbumsView.configure(
            with: ActionlabelViewViewModel(text: "You have not saved any albums yet",
                                           actionTitle: "Browse"
            )
        )
    }
    
    private func fetchData() {
        albums.removeAll()
        
        APICaller.shared.getCurrentUserAlbums {[weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
    }
}




extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subTitle: album.artists.first?.name ?? "-",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()

        tableView.deselectRow(at: indexPath, animated: true)
      
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
