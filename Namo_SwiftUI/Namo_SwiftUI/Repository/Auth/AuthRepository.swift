//
//  AuthRepository.swift
//  Namo_SwiftUI
//
//  Created by 고성민 on 2/4/24.
//

import Foundation

protocol AuthRepository {
    
    // 카카오 소셜 로그인. 오버로드
    func signIn(kakaoToken: SocialSignInRequestDTO) async  -> SignInResponseDTO?
    
    // 네이버 소셜 로그인. 오버로드
    func signIn(naverToken: SocialSignInRequestDTO) async -> SignInResponseDTO?
    
    // 애플 소셜 로그인. 오버로드
    func signIn(appleToken: AppleSignInRequestDTO) async -> SignInResponseDTO?
    
    // 로그아웃. 토큰 삭제
    func removeToken<T:Decodable>(serverAccessToken: LogoutRequestDTO) async -> BaseResponse<T>?
    
    // 카카오 회원 탈퇴
    func withdrawMemberKakao<T:Decodable>() async -> BaseResponse<T>?
    
    // 네이버 회원 탈퇴
    func withdrawMemberNaver<T:Decodable>() async -> BaseResponse<T>?
    
    // 애플 회원 탈퇴
    func withdrawMemberApple<T:Decodable>() async -> BaseResponse<T>?
}
