//
//  BaseViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/26/24.
//

import Foundation
import RxSwift

public protocol BaseViewItemProtocol : AnyObject {
    /// view property 설정 - ex ) view.backgroundColor = .white
    func setupViewProperty()
    
    /// 뷰 계층 구조 설정 - ex ) view.addSubview()
    func setupHierarchy()
    
    /// layout 설정 - ex ) snapkit
    func setupLayout()
}

public protocol BaseViewControllerProtocol : AnyObject, BaseViewItemProtocol {
    /// delegate 설정
    func setupDelegate()
    
    /// view binding 설정
    associatedtype T
    func setupBind(viewModel : T)
}

open class BaseViewController <ProtocolType> : UIViewController, BaseViewControllerProtocol {
    public var disposeBag = DisposeBag()
    
    public typealias T = ProtocolType
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "remove required init")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViewProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
    }
    
    open func setupViewProperty() { }
    open func setupDelegate() { }
    open func setupHierarchy() { }
    open func setupLayout() { }
    open func setupBind (viewModel : T) {
        self.disposeBag = DisposeBag()
    }
}
