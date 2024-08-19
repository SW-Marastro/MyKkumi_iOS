//
//  PostTableCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit
import RxSwift

open class PostTableCell : UITableViewCell {
    public static let cellID = "PostTableCell"
    private let disposeBag = DisposeBag()
    private var viewModel : PostCellViewModelProtocol!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public func bind(viewModel : PostCellViewModelProtocol) {
        self.viewModel = viewModel
        
        self.viewModel.setPostData
            .drive(onNext: {[weak self] postVo in
                self?.setCellData(postVO: postVo)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showedImage
            .subscribe(onNext: {[weak self] idx in
                guard let self = self else { return }
                self.dotView.arrangedSubviews.forEach { dot in
                    dot.backgroundColor = AppColor.neutral50.color
                }
                
                if idx  < self.dotView.arrangedSubviews.count {
                    self.dotView.arrangedSubviews[idx].backgroundColor = AppColor.primary.color
                }
            })
            .disposed(by: disposeBag)
    }
    
    //관련 Data Binding
    public func setCellData(postVO : PostVO) {
        setupHierarchy()
        
        if let imageurl = postVO.writer.profileImage {
            profileImageView.load(url: URL(string: imageurl)!)
        } else {
            profileImageView.image = AppImage.appLogo.image
        }
        
        let category = postVO.category + " > \(postVO.subCategory)"
        
        nicknameLabel.attributedText = NSAttributedString(string : postVO.writer.nickname, attributes: Typography.body14SemiBold(color: AppColor.neutral900).attributes)
        
        categoryLabel.attributedText = NSAttributedString(string: category, attributes: Typography.body13Medium(color: AppColor.neutral500).attributes)
        
        postNameLabel.attributedText = NSAttributedString(string : postVO.writer.nickname, attributes: Typography.body14SemiBold(color: AppColor.neutral900).attributes)
        
        postContent.setTextWithMore(content: postVO.content)
        
        for post in postVO.images {
            let imageAndPinView : UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let imageView : UIImageView = {
                let image = UIImageView()
                image.contentMode = .scaleAspectFit
                image.translatesAutoresizingMaskIntoConstraints = false
                return image
            }()
            
            let dot : UIView = {
                let view  = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.layer.cornerRadius = 4
                view.backgroundColor = AppColor.neutral50.color
                return view
            }()
            
            imageAndPinView.addSubview(imageView)
            dotView.addArrangedSubview(dot)
            postImageStackView.addArrangedSubview(imageAndPinView)
            
            NSLayoutConstraint.activate([
                imageAndPinView.widthAnchor.constraint(equalTo: postImageScrollView.widthAnchor),
                imageAndPinView.heightAnchor.constraint(equalTo: postImageScrollView.heightAnchor)
            ])
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageAndPinView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: imageAndPinView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: imageAndPinView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageAndPinView.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
            
            imageView.load(url:URL(string: post.url)!) { _ in
                if let image = imageView.image {
                    let imageSize = image.size
                    let imageViewSize = imageView.bounds.size
                    
                    let scaleWidth = imageViewSize.width / imageSize.width
                    let scaleHeight = imageViewSize.height / imageSize.height
                    
                    var aspectRatio: CGFloat = 1.0
                    var scaledImageSize: CGSize = .zero
                    
                    aspectRatio = min(scaleWidth, scaleHeight)
                    scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
                    
                    let imageX = (imageViewSize.width - scaledImageSize.width) / 2
                    let imageY = (imageViewSize.height - scaledImageSize.height) / 2
                    
                    for pin in post.pins {
                        let x = scaledImageSize.width * pin.positionX + imageX
                        let y = scaledImageSize.height * pin.positionY + imageY
                        
                        let pinImageView : UIImageView = {
                            let image = UIImageView()
                            image.translatesAutoresizingMaskIntoConstraints = false
                            image.image = AppImage.pin.image
                            return image
                        }()
                        
                        imageAndPinView.addSubview(pinImageView)
                        
                        NSLayoutConstraint.activate([
                            pinImageView.heightAnchor.constraint(equalToConstant: 24),
                            pinImageView.widthAnchor.constraint(equalTo: pinImageView.heightAnchor),
                            pinImageView.leadingAnchor.constraint(equalTo: imageAndPinView.leadingAnchor, constant: x - 12),
                            pinImageView.topAnchor.constraint(equalTo: imageAndPinView.topAnchor, constant: y - 12)
                        ])
                    }
                }
            }
        }
        
        setupLayout()
        setupDelegate()
    }
    
    func setupDelegate() {
        self.postImageScrollView.delegate = self
    }
    
    func setupHierarchy() {
        self.contentView.addSubview(profileView)
        self.contentView.addSubview(postImageScrollView)
        self.contentView.addSubview(dotView)
        self.contentView.addSubview(buttonStack)
        self.contentView.addSubview(reportPostButton)
        self.contentView.addSubview(postNameLabel)
        self.contentView.addSubview(postContent)
        self.contentView.addSubview(writeComment)
        
        self.profileView.addSubview(profileImageView)
        self.profileView.addSubview(nicknameLabel)
        self.profileView.addSubview(categoryLabel)
        self.profileView.addSubview(followButton)
        
        self.postImageScrollView.addSubview(postImageStackView)
        self.buttonStack.addArrangedSubview(likeButton)
        self.buttonStack.addArrangedSubview(commentButton)
        self.buttonStack.addArrangedSubview(shareButton)
        self.buttonStack.addArrangedSubview(scrapButton)
    }
    
    func setupLayout() {
        //MARK: Profile
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 24),
            profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 27),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 13),
            categoryLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 13)
        ])
        
        NSLayoutConstraint.activate([
            followButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 27),
            followButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 28),
            followButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            postImageScrollView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            postImageScrollView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            postImageScrollView.heightAnchor.constraint(equalTo: postImageScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            postImageStackView.topAnchor.constraint(equalTo: postImageScrollView.topAnchor),
            postImageStackView.leadingAnchor.constraint(equalTo: postImageScrollView.leadingAnchor),
            postImageStackView.trailingAnchor.constraint(equalTo: postImageScrollView.trailingAnchor),
            postImageStackView.bottomAnchor.constraint(equalTo: postImageScrollView.bottomAnchor),
            postImageStackView.heightAnchor.constraint(equalTo: postImageScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: postImageScrollView.bottomAnchor, constant: 10),
            dotView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            dotView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: dotView.bottomAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            commentButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            commentButton.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
            shareButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            shareButton.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
            scrapButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            scrapButton.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            reportPostButton.topAnchor.constraint(equalTo: dotView.bottomAnchor, constant: 12),
            reportPostButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            reportPostButton.heightAnchor.constraint(equalToConstant: 32),
            reportPostButton.widthAnchor.constraint(equalToConstant: 65)
        ])
        
        NSLayoutConstraint.activate([
            postNameLabel.topAnchor.constraint(equalTo: reportPostButton.bottomAnchor, constant: 12),
            postNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            postNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            postContent.topAnchor.constraint(equalTo: postNameLabel.bottomAnchor, constant: 8),
            postContent.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            postContent.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            writeComment.topAnchor.constraint(equalTo: postContent.bottomAnchor, constant: 16),
            writeComment.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            writeComment.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -32),
            writeComment.heightAnchor.constraint(equalToConstant: 28),
            writeComment.widthAnchor.constraint(equalToConstant: 73)
        ])
    }
    
    private let profileView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()
    
    private let nicknameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typography.body14SemiBold(color: AppColor.neutral900).font()
        return label
    }()
    
    private let categoryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typography.body13Medium(color: AppColor.neutral900).font()
        return label
    }()
    
    private let followButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.setAttributedTitle(NSAttributedString(string: "팔로우", attributes: Typography.body13Medium(color: AppColor.white).attributes), for: .normal)
        button.backgroundColor = AppColor.primary.color
        return button
    }()
    
    private let postImageScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = AppColor.neutral50.color
        return scroll
    }()
    
    private let postImageStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private let dotView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.favoritButton.image, for: .normal)
        return button
    }()
    
    private let commentButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.commentButton.image, for: .normal)
        return button
    }()
    
    private let shareButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.shareButton.image, for: .normal)
        return button
    }()
    
    private let scrapButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(AppImage.scrapButton.image, for: .normal)
        return button
    }()
    
    private let reportPostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("신고하기", for: .normal)
        button.titleLabel?.font = Typography.body13SemiBold(color: AppColor.neutral900).font()
        button.setTitleColor(AppColor.neutral400.color, for: .normal)
        return button
    }()
    
    private let postNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postContent : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeComment : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("댓글 작성", for: .normal)
        button.titleLabel?.font = Typography.body13SemiBold(color: AppColor.neutral900).font()
        button.backgroundColor = AppColor.secondary.color
        button.layer.cornerRadius = 8
        return button
    }()
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostTableCell : UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nowPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        self.viewModel.showedImage.accept(nowPage)
    }

}

//
//@available(iOS 17, *)
//#Preview(traits: .defaultLayout, body: {
//    let cell = PostTableCell()
//    
//    return cell
//})
