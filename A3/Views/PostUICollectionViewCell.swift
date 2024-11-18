//
//  PostUICollectionViewCell.swift
//  A3
//
//  Created by Catherine Fang on 3/27/24.
//

import UIKit

class PostUICollectionViewCell: UICollectionViewCell {
    // MARK: - Properties (view)
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeSinceLabel = UILabel()
    private let likeButtonNumberLabel = UILabel()
    private let likeButton = UIButton()
    private let textBodyLabel = UILabel()
    
    static let reuse = "PostUICollectionViewCellReuse"
    
    // MARK: - Properties (data)
    var postID = ""
    var numLikes = [""]
    var free = 0
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.a3.white
        layer.cornerRadius = 16
        
        setupLogoImageView()
        setupNameLabel()
        setupTimeSinceLabel()
        setupLikeButton()
        setupLikeButtonNumberLabel()
        setupTextBodyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    func configure(post: Post) {
        timeSinceLabel.text = "\(post.time.convertToAgo()) ago"
        textBodyLabel.text = "\(post.message)"
        
        postID = post.id
        
        let likedPosts = post.likes
        self.free = likedPosts.count
        self.likeButtonNumberLabel.text = "\(self.free) likes"
        
        if !likedPosts.contains("cf533") {
            likeButton.setImage(UIImage (named: "heart"), for: .normal)
            likeButton.tintColor = UIColor.a3.silver
            
        } else {
            likeButton.setImage(UIImage (named: "filledHeart"), for: .normal)
            likeButton.tintColor = UIColor.a3.ruby
        }
    }
    
    // MARK: - Set Up Views
    
    private func setupTextBodyLabel() {
        textBodyLabel.text = "need to make it so it doesnt go off screen aaaaaaaaaaaa"
        textBodyLabel.numberOfLines = 3
        textBodyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textBodyLabel.textColor = UIColor.a3.black
        
        contentView.addSubview(textBodyLabel)
        textBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            textBodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textBodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            textBodyLabel.topAnchor.constraint(equalTo: timeSinceLabel.topAnchor, constant: 16),
            textBodyLabel.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupLogoImageView() {
        logoImageView.image = UIImage(named: "appdev_logo")
        
        logoImageView.layer.cornerRadius = 16
        logoImageView.layer.masksToBounds = true
        
        contentView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Anonymous"
        nameLabel.textColor = UIColor.a3.black
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.5),
        ])
    }
    
    private func setupTimeSinceLabel() {
        timeSinceLabel.text = "7 mins ago"
        timeSinceLabel.textColor = UIColor.a3.silver
        timeSinceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        contentView.addSubview(timeSinceLabel)
        timeSinceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            timeSinceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            timeSinceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 41.5),
        ])
    }
    
    private func setupLikeButtonNumberLabel() {
        likeButtonNumberLabel.text = "120 likes"
        likeButtonNumberLabel.textColor = UIColor.a3.black
        likeButtonNumberLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        contentView.addSubview(likeButtonNumberLabel)
        likeButtonNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            likeButtonNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            likeButtonNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -29)
        ])
    }
    
    
    private func setupLikeButton() {
        likeButton.setImage(UIImage(named: "heart"), for: .normal)
        likeButton.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        likeButton.layer.masksToBounds = true
        
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    
    
    // MARK: - Button Helpers
    @objc private func likePost() {
        // TODO: Send a POST request to create a post
        if likeButton.tintColor != UIColor.a3.ruby {
            NetworkManager.shared.likePost(id: postID) { success in
                self.likeButton.setImage(UIImage (named: "filledHeart"), for: .normal)
                self.likeButton.tintColor = UIColor.a3.ruby
                self.likeButtonNumberLabel.text = "\(self.free + 1) likes"
            } 
        
        }
    }
}
