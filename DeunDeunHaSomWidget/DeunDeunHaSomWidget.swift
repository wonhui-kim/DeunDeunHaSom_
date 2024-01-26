//
//  DeunDeunHaSomWidget.swift
//  DeunDeunHaSomWidget
//
//  Created by 김원희 on 2022/08/17.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let networkManager = NetworkManager.shared
    let dateManager = DateManager.shared
    
    let url = APIConstants.baseURL + APIConstants.cafeteriaEndpoint
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), staffMeal: [String](), studentMeal: [String]())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let startEndDate = dateManager.startEndDate()

        networkManager.todayMenus(url: url, parameters: startEndDate) { result in
            switch result {
            case .success(let menus):
                var entries: [SimpleEntry] = []
                let entry = Entry(date: Date(), staffMeal: menus.staff, studentMeal: menus.student)
                entries.append(entry)
                completion(entry)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let startEndDate = dateManager.startEndDate()
        
        networkManager.todayMenus(url: url, parameters: startEndDate) { result in
            switch result {
            case .success(let menus):
                var entries: [SimpleEntry] = []
                let entry = Entry(date: Date(), staffMeal: menus.staff, studentMeal: menus.student)
                entries.append(entry)
                
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
                let timeline = Timeline(entries: entries, policy: .after(entryDate!))
                completion(timeline)
            case .failure(let error):
                print(error) //17부터는 위젯 버튼 추가 가능해서 새로고침 가능할지 몰라도 그 전엔 기다리는 수 밖에 없음
                
                var entries: [SimpleEntry] = []
                let entry = Entry(date: Date(), staffMeal: ["\(error)", "위젯 갱신 실패"], studentMeal: ["\(error)", "위젯 갱신 실패"])
                entries.append(entry)
                
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
                let timeline = Timeline(entries: entries, policy: .after(entryDate!))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var staffMeal: [String]
    var studentMeal: [String]
}

struct DeunDeunHaSomWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry
    
    var body: some View {
        sizeBody()
    }
    
    @ViewBuilder
    func sizeBody() -> some View {
        switch family {
        case .systemSmall:
            SmallWidget(entry: entry)
        case .systemMedium:
            MediumWidget(entry: entry)
        default:
            EmptyView()
        }
    }
}

@main
struct DeunDeunHaSomWidget: Widget {
    let kind: String = "com.wonhui.DeunDeunHaSom.DeunDeunHaSomWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeunDeunHaSomWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("든든하솜")
        .description("든든하솜 위젯")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct SmallWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            HStack {
                Text("교직원 식당")
                    .font(.system(size: 15, weight: .bold))
                Text("(~13:00)")
                    .font(.system(size: 12))
            }
            .frame(width: 169, height: 20, alignment: .center)
            VStack {
                ForEach(entry.staffMeal, id: \.self) {
                    Text($0)
                        .font(.system(size: 13))
                }
            }
        }
        .frame(width: 169, height: 169)
    }
}

struct MediumWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("교직원 식당")
                        .font(.system(size: 15, weight: .bold))
                    Text("(~13:00)")
                        .font(.system(size: 12))
                }
                .frame(width: 169, height: 20, alignment: .center)
                VStack {
                    ForEach(entry.staffMeal, id: \.self) {
                        Text($0)
                            .font(.system(size: 13))
                    }
                }
            }
            .frame(width: 169, height: 169)
            Divider()
            VStack {
                HStack {
                    Text("학생 식당")
                        .font(.system(size: 15, weight: .bold))
                    Text("(~14:00)")
                        .font(.system(size: 12, weight: .medium))
                }
                .frame(width: 169, height: 20, alignment: .center)
                VStack {
                    ForEach(entry.studentMeal, id: \.self) {
                        Text($0)
                            .font(.system(size: 11))
                    }
                }
            }
            .frame(width: 169, height: 169)
        }
        .frame(width: 360, height: 169)
    }
}
