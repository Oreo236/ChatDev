//
//  FeedVC.swift
//  A3
//
//  Created by Vin Bui on 10/31/23.
//

import UIKit

class FeedVC: UIViewController {

    // MARK: - Properties (view)

    private var collectionView: UICollectionView!

    // MARK: - Properties (data)
    private var posts: [Post] = []

    // MARK: - View Cycles
    // 1. Create a UIRefreshControl view property
    private let refreshControl = UIRefreshControl()

//    // 2. Add a function to be called as a target
//    refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
//
//    // 3. Assign the collection view’s refresh control
//    collectionView.refreshControl = refreshControl


    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ChatDev"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.a3.offWhite

        setupCollectionView()
        fetchPosts()
    }
    
    // MARK: - Networking
    
    @objc private func fetchPosts()  {
        NetworkManager.shared.getPosts { [weak self] posts in
            guard let self = self else { return }
            self.posts = posts
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }


    // MARK: - Set Up Views

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.a3.offWhite
        collectionView.register(PostUICollectionViewCell.self, forCellWithReuseIdentifier: PostUICollectionViewCell.reuse)
        collectionView.register(CreatePostCollectionViewCell.self, forCellWithReuseIdentifier: CreatePostCollectionViewCell.reuse)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 24   // Use this constant when configuring constraints
        NSLayoutConstraint.activate ([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}

// MARK: - UICollectionViewDelegate

extension FeedVC: UICollectionViewDelegate { 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        
        var likedPosts = UserDefaults.standard.array(forKey: "liked") as? [String] ?? []
        if likedPosts.contains(post.id) {
            likedPosts.removeAll { id in
                id == post.id
            }
        } else {
            likedPosts.append(post.id)
        }
        UserDefaults.standard.setValue(likedPosts, forKey: "liked")
    }
}

// MARK: - UICollectionViewDataSource

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: Return the number of rows for each section
        // HINT: Use `section` with an if statement
        if section == 0 {
            return 1
        }
        return self.posts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: Return the number of sections in this table view
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: Return the cells for each section
        // HINT: Use `indexPath.section` with an if statement
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePostCollectionViewCell.reuse, for: indexPath) as? CreatePostCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostUICollectionViewCell.reuse, for: indexPath) as? PostUICollectionViewCell else { return UICollectionViewCell() }
        
        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
        
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // TODO: Return the inset for the spacing between the two sections
        
        return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    } // need to fix spacing between sections
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    extension FeedVC: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // TODO: Return the size for each cell per section
            // HINT: Use `indexPath.section` with an if statement
            if indexPath.section == 0 {
                return CGSize(width: 345, height: 131)
            }
            
            return CGSize(width: 345, height: 184)
        }
    }
