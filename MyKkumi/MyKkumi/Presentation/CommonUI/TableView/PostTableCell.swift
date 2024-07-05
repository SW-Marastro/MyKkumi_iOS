//
//  PostTableCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostTableCell : UITableViewCell {
    public static let cellID = "PostTableCell"
    private var images : [String] = []
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initAttribute()
        setupHierarchy()
        setupLayout()
    }
    
    //관련 Data Binding
    public func bind(postVO : PostVO) {
        if let urlString = postVO.writer?.profileImage {
            profileImageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
        }
        self.images = postVO.imageURL!
        postImageCollection.reloadData()
        updateCountLabel()
        categoryLabel.text = postVO.category! + "-" + postVO.subCategory!
    }
    
    func initAttribute() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        countImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        nicknameLabel.font = UIFont.boldSystemFont(ofSize:17)
        categoryLabel.font = UIFont.systemFont(ofSize: 17)
        
        optionButton.setBackgroundImage(UIImage(named: "threePoint"), for: .normal)
        
        postImageCollection.delegate = self
        postImageCollection.dataSource = self
    }
    
    func setupHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(optionButton)
        contentView.addSubview(postImageCollection)
        contentView.addSubview(countImageLabel)
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nicknameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            optionButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            optionButton.heightAnchor.constraint(equalToConstant: 24),
            optionButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            postImageCollection.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            postImageCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageCollection.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            countImageLabel.topAnchor.constraint(equalTo: postImageCollection.topAnchor, constant: 5),
            countImageLabel.trailingAnchor.constraint(equalTo: postImageCollection.trailingAnchor, constant: -5)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let categoryLabel = UILabel()
    let optionButton = UIButton()
    let postImageCollection = PostImageCollectionView(frame: CGRect.zero, collectionViewLayout: PostImageCollectionViewFlowLayout())
    let countImageLabel = UILabel()
}


open class PostTableCellOption : UITableViewCell {
    public static let cellID = "PostTableCellOption"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initAttribute()
        setupHierarchy()
        setupLayout()
    }
    
    public func bind(postVO : PostVO) {
        contentLabel.text = postVO.content!
    }
    
    func initAttribute() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        commentCount.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        bookMarkCount.translatesAutoresizingMaskIntoConstraints = false
        bookMarkButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.textColor = .gray
    }
    
    func setupHierarchy() {
        contentView.addSubview(likeButton)
        contentView.addSubview(likeCount)
        contentView.addSubview(commentCount)
        contentView.addSubview(commentButton)
        contentView.addSubview(bookMarkCount)
        contentView.addSubview(bookMarkButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(contentLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            likeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            likeCount.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 3)
        ])
        
        NSLayoutConstraint.activate([
            commentButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            commentButton.leadingAnchor.constraint(equalTo: likeCount.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            commentCount.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 3)
        ])
        
        NSLayoutConstraint.activate([
            bookMarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookMarkButton.leadingAnchor.constraint(equalTo: commentCount.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            bookMarkCount.leadingAnchor.constraint(equalTo: bookMarkButton.trailingAnchor, constant: 3)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let likeButton = UIButton()
    let likeCount = UILabel()
    let commentButton = UIButton()
    let commentCount = UILabel()
    let bookMarkButton = UIButton()
    let bookMarkCount = UILabel()
    let shareButton = UIButton()
    let nickNameLabel = UILabel()
    let contentLabel = UILabel()
}

extension PostTableCell : UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCollectionViewCell.cellID, for: indexPath) as! PostImageCollectionViewCell
        cell.imageView.load(url: URL(string: images[indexPath.item])!, placeholder: "placeholder")
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCountLabel()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        let visibleCells = postImageCollection.visibleCells
        guard let visibleCell = visibleCells.first else { return }
        guard let indexPath = postImageCollection.indexPath(for: visibleCell) else { return }
        
        let currentItem = indexPath.item + 1
        let totalItems = postImageCollection.numberOfItems(inSection: 0)
        countImageLabel.text = "\(currentItem) / \(totalItems)"
    }
}
