//
//  AppState.swift
//  Namo_SwiftUI
//
//  Created by 고성민 on 2/4/24.
//

import Foundation
import SwiftUICalendar

//struct ScheduleState {
//    var currentSchedule: Schedule
//    var scheduleTemp: ScheduleTemplate
//}

struct CategoryState {
    var categoryList: [ScheduleCategory]
}

struct PlaceState {
    var placeList: [Place]
    var selectedPlace: Place?
}

class ScheduleState: ObservableObject {
	@Published var currentSchedule: Schedule = Schedule(
		scheduleId: -1,
		   name: "",
		   startDate: Date(),
		   endDate: Date(),
		   alarmDate: [],
		   interval: -1,
		   x: nil,
		   y: nil,
		   locationName: "",
		   categoryId: -1,
		   hasDiary: false,
		   moimSchedule: false
	   )
	@Published var scheduleTemp: ScheduleTemplate = ScheduleTemplate()
	
	/// calendar에 보여지기 위한 스케쥴들
	@Published var calendarSchedules: [YearMonthDay: [CalendarSchedule]] = [:]
}

class AppState: ObservableObject {
	
	// Tabbar
	@Published var isTabbarHidden: Bool = false
	@Published var isTabbarOpaque: Bool = false
    
    @Published var currentTab: Tab = .home
	
	// Alert
	@Published var showAlert: Bool = false
	@Published var alertMessage: String = ""
    
	// Category(key - categoryId, value - paletteId)
	@Published var categoryPalette: [Int: Int] = [:]
	
    // Schedule
//	@Published var scheduleState: ScheduleState = ScheduleState(
//		currentSchedule: Schedule(
//			scheduleId: -1,
//			name: "",
//			startDate: Date(),
//			endDate: Date(),
//			alarmDate: [],
//			interval: -1,
//			x: nil,
//			y: nil,
//			locationName: "",
//			categoryId: -1,
//			hasDiary: false,
//			moimSchedule: false
//		),
//		scheduleTemp: ScheduleTemplate()
//	)
    
    // Category
    @Published var categoryState: CategoryState = CategoryState(
        categoryList: []
    )
    
    // Place
    @Published var placeState: PlaceState = PlaceState(
        placeList: [], selectedPlace: nil
    )

    // categoryId : name
//    @Published var categoryName: [Int: String] = [:]
    
//    @Published var categoryList: [CategoryDTO] = []
}
