//
//  NetworkConfiguration.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

enum NetworkConfiguration {
    static let baseUrl = "https://dev-api.mykkumi.com/api/v1"
    
    //MARK: banners
    static let banners = "/banners"
    static let banner = "/banners/"
    
    //MARK: Post
    static let getPost = "/posts"
    
    //MARK: Auth
    static let signinKakao = "/signin/kakao"
    static let signinApple = "/signin/apple"
    static let getToken = "/signin/token"
    static let patchUser = "/signin/users"
    static let getUserData = "/signin/users/me"
}
