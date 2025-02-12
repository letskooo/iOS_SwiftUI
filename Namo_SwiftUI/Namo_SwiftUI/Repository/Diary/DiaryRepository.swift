//
//  DiaryRepository.swift
//  Namo_SwiftUI
//
//  Created by 서은수 on 3/16/24.
//

import Foundation

protocol DiaryRepository {
    func createDiary(scheduleId: Int, content: String, images: [Data?]) async -> CreateDiaryResponseDTO?
    func getMonthDiary(request: GetDiaryRequestDTO) async -> GetDiaryResponseDTO?
    func getOneDiary(scheduleId: Int) async -> GetOneDiaryResponseDTO?
    func changeDiary(scheduleId: Int, content: String, images: [Data?]) async -> Bool
    func deleteDiary(scheduleId: Int) async -> Bool
}
