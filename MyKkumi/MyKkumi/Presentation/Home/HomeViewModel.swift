//
//  HomeViewModel.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import UIKit
import RxCocoa
import Moya
import RxSwift

private let disposeBag = DisposeBag()

public protocol HomeViewModelProtocol {
    var images : BehaviorRelay<[String]> { get }
}

public class HomeViewModel : HomeViewModelProtocol {
    init() {
        self.images = BehaviorRelay(value: ["image1", "image2", "image3"])
    }
    
    public var images: BehaviorRelay<[String]>
}
