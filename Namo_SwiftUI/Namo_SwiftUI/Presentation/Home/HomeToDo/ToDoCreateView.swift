//
//  ToDoCreateView.swift
//  Namo_SwiftUI
//
//  Created by 박민서 on 1/24/24.
//

import SwiftUI
import Factory

/// 알림 시각 설정을 위한 enum입니다.
/// 임시 세팅입니다.
enum NotificationSetting: CaseIterable {
    case none
    case oneHour
    case thirtyMin
    case tenMin
    case fiveMin
    case exactTime
    
    var toString: String {
        switch self {
        case .none:
            return "없음"
        case .oneHour:
            return "1시간 전"
        case .thirtyMin:
            return "30분 전"
        case .tenMin:
            return "10분 전"
        case .fiveMin:
            return "5분 전"
        case .exactTime:
            return "정시"
        }
    }
    
    var toInt: Int {
        switch self {
        case .none:
            return -1
        case .oneHour:
            return 60
        case .thirtyMin:
            return 30
        case .tenMin:
            return 10
        case .fiveMin:
            return 5
        case .exactTime:
            return 0
        }
    }
    
    static func getValueFromInt(_ int: Int) -> NotificationSetting{
        switch int {
        case -1:
            return .none
        case 60:
            return .oneHour
        case 30:
            return .thirtyMin
        case 10:
            return .tenMin
        case 5:
            return .fiveMin
        case 0:
            return .exactTime
        default:
            return .none
        }
    }
}


struct ToDoCreateView: View {
    
    @EnvironmentObject var appState: AppState
    @Injected(\.scheduleInteractor) var schduleInteractor
    @Injected(\.categoryInteractor) var categoryInteractor
    
    /// 시작 날짜 + 시각 Picker Show value
    @State private var showStartTimePicker: Bool = false
    /// 종료 날짜 + 시각 Picker Show value
    @State private var showEndTimePicker: Bool = false
    /// 알림 선택란 Show value
    @State private var showNotificationSetting: Bool = false
    
    // KakaoMapView draw State
    @State var draw: Bool = false
    
    // 취소 확인 버튼 Show State
    @State var showDeleteBtn: Bool = false
    
//    @Environment(\.dismiss) private var dismiss
    /// 날짜 포매터
    private let dateFormatter = DateFormatter()
    
    init(schedule: Schedule?) {
        // SwiftUI의 NavigationTitle는 Font가 적용되지 않습니다.
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Pretendard-Bold", size: 15)!]
        UINavigationBar.appearance().barTintColor = .white
        self.dateFormatter.dateFormat = "yyyy.MM.dd (E) hh:mm a"
    
//        if let schedule = schedule {
//            toDoTitle = schedule.name
//            if let paletteId = appState.categoryPalette[schedule.categoryId] {
//                categoryColor = categoryInteractor.getColorWithPaletteId(id: paletteId)
//            }
//            categoryName = appState.categoryName[schedule.categoryId] ?? "카테고리 없음"
//            startDateTime = schedule.startDate
//            endDateTime = schedule.endDate
//            notificationList = schedule.alarmDate.map { NotificationSetting.getValueFromInt($0) }
//            pinList = [Place(id: 0, x: schedule.x ?? 0, y: schedule.y ?? 0, name: schedule.locationName, address: "", rodeAddress: "")]
//              self.showDeleteBtn = true
//        }
    }
    
    var body: some View {
        
//        ZStack(alignment: .top) {
//            
//            Color.black.opacity(0.5)
//            
//            if showDeleteBtn {
//                CircleItemView(content: {
//                    Image("ic_delete_schedule")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                })
//                .offset(y: 90)
//            }
            
            NavigationStack {
                ScrollView {
                    VStack {
                        TextField("일정 이름", text: $appState.scheduleState.scheduleTemp.name)
                            .font(.pretendard(.bold, size: 22))
                            .padding(EdgeInsets(top: 18, leading: 30, bottom: 15, trailing: 30))
                        
                        VStack(alignment: .center, spacing: 20) {
                            ListItem(listTitle: "카테고리") {
                                NavigationLink(destination: ToDoSelectCategoryView()) {
                                    HStack {
                                        ColorCircleView(color: categoryInteractor.getColorWithPaletteId(id: appState.categoryState.categoryList.first(where: {$0.categoryId == appState.scheduleState.scheduleTemp.categoryId})?.paletteId ?? -1))
                                            .frame(width: 13, height: 13)
                                        Text(appState.categoryState.categoryList.first(where: {$0.categoryId == appState.scheduleState.scheduleTemp.categoryId})?.name ?? "카테고리 없음")
                                            .font(.pretendard(.regular, size: 15))
                                            .foregroundStyle(.mainText)
                                        Image("vector3")
                                            .renderingMode(.template)
                                            .foregroundStyle(.mainText)
                                    }
                                    .lineSpacing(12)
                                }
                            }
                            .padding(.vertical, 14)

                            ListItem(listTitle: "시작") {
                                Text(dateFormatter.string(from: appState.scheduleState.scheduleTemp.startDate))
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(.mainText)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.showStartTimePicker.toggle()
                                        }
                                    }
                            }
                            
                            
                            if (showStartTimePicker) {
                                DatePicker("StartTimePicker", selection: $appState.scheduleState.scheduleTemp.startDate)
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .tint(.mainOrange)
                            }
                            
                            ListItem(listTitle: "종료") {
                                Text(dateFormatter.string(from: appState.scheduleState.scheduleTemp.endDate))
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(.mainText)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.showEndTimePicker.toggle()
                                        }
                                    }
                            }
                            
                            if (showEndTimePicker) {
                                DatePicker("EndTimePicker", selection: $appState.scheduleState.scheduleTemp.endDate, in: appState.scheduleState.scheduleTemp.startDate...)
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .tint(.mainOrange)
                            }
                            
                            
                            
                            ListItem(listTitle: "알림") {
                                HStack {
                                    Text(appState.scheduleState.scheduleTemp.alarmDate.isEmpty
                                                          ? "없음"
                                                          : notiListInString(appState.scheduleState.scheduleTemp.alarmDate.sorted(by: { $0 > $1 })
                                        .map { NotificationSetting.getValueFromInt($0) })
                                    )
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(.mainText)
                                    
                                    Image(showNotificationSetting == true ? "upChevron" : "downChevron")
                                        .renderingMode(.template)
                                        .foregroundStyle(.mainText)
                                }
                                .lineSpacing(12)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        self.showNotificationSetting.toggle()
                                    }
                                }
                            }
                            
                            if (showNotificationSetting) {
                                let notificationsList = NotificationSetting.allCases
                                
                                let rows = [
                                    GridItem(.fixed(35), spacing: 15, alignment: .topLeading),
                                    GridItem(.fixed(35), spacing: 15, alignment: .bottomTrailing)
                                    ]
                                
                                LazyHGrid(rows: rows) {
                                    ForEach(notificationsList, id: \.self) { item in
                                        ColorToggleButton(
                                            isOn: Binding(get: {
                                                if item == .none { appState.scheduleState.scheduleTemp.alarmDate.isEmpty }
                                                else { appState.scheduleState.scheduleTemp.alarmDate.contains(item.toInt) }
                                            },set: {_ in }),
                                            buttonText: item.toString,
                                            action: {
                                                if item == .none {
                                                    appState.scheduleState.scheduleTemp.alarmDate = []
                                                }
                                                else {
                                                    if let index = appState.scheduleState.scheduleTemp.alarmDate.firstIndex(of: item.toInt) {
                                                        appState.scheduleState.scheduleTemp.alarmDate.remove(at: index)
                                                    }
                                                    else {
                                                        appState.scheduleState.scheduleTemp.alarmDate.append(item.toInt)
                                                    }
                                                }
                                            })
                                    }
                                }
                               
                            }
                            
                            ListItem(listTitle: "장소") {
                                NavigationLink(destination: ToDoSelectPlaceView()) {
                                    HStack {
                                        Text(appState.scheduleState.scheduleTemp.locationName.isEmpty ? "위치명" : appState.scheduleState.scheduleTemp.locationName)
                                            .font(.pretendard(.regular, size: 15))
                                            .foregroundStyle(.mainText)
                                        Image("vector3")
                                            .renderingMode(.template)
                                            .foregroundStyle(.mainText)
                                    }
                                    .lineSpacing(12)
                                }
                            }
                            .padding(.vertical, 14)
                        }
                        .padding(.horizontal, 30)
                        
                        KakaoMapView(draw: $draw, pinList: $appState.placeState.placeList).onAppear(perform: {
                            self.draw = true
                        }).onDisappear(perform: {
                            self.draw = false
                        })
                        .frame(width: 330, height:200)
                        .border(Color.init(hex: 0xD9D9D9), width: 1)
                        
                        Spacer()
                    }
                    .navigationTitle("새 일정")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                // 닫기
//                                dismiss()
                            }, label: {
                                Text("닫기")
                                    .font(.pretendard(.regular, size: 15))
                            })
                            .foregroundStyle(.mainText)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                // 저장
                                print(appState.scheduleState.scheduleTemp)
                            }, label: {
                                Text("저장")
                                    .font(.pretendard(.regular, size: 15))
                            })
                            .foregroundStyle(.mainText)
                        }
                    }//: VStack - toolbar
                }//: ScrollView
            }//: NavigationStack
//            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
//                topLeading: 15,
//                topTrailing: 15)))
//            .shadow(radius: 10)
//            .offset(y: 150)
//        }
//        .ignoresSafeArea(.all)
        
    
        
        
    }
    
    private struct ListItem<Content: View>: View {
        
        var listTitle: String
        var content: () -> Content
        
        var body: some View {
            HStack {
                Text(listTitle)
                    .font(.pretendard(.bold, size: 15))
                Spacer()
                content()
            }
        }
    }
    
    
    private struct ColorToggleButton: View {
        
        @Binding var isOn: Bool
        let buttonText: String
        let action: () -> Void
        
        var body: some View {
            Button(action: {
                self.action()
            }) {
                Text(buttonText)
                    .font(.pretendard(self.isOn ? .bold : .regular, size: 15))
                    .lineLimit(1)
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                    .foregroundStyle(self.isOn ? .mainOrange : .mainText)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                        .stroke(self.isOn ? .mainOrange : .mainText, lineWidth: self.isOn ? 2 : 1)
                    )
            }
        }
    }
    
    /// 알림 리스트 값을 문자열로 반환해주는 함수 입니다.
    private func notiListInString(_ notifications: [NotificationSetting]) -> String {
        let returnString = notifications.reduce(into: ""){ $0 += $1.toString+", " }
        return String(returnString.dropLast(2))
    }
}



#Preview {
    ToDoCreateView(schedule: nil)
        .environmentObject(AppState())
}
