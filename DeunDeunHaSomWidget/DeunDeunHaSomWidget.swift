//
//  DeunDeunHaSomWidget.swift
//  DeunDeunHaSomWidget
//
//  Created by 김원희 on 2022/08/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let networkManager = NetworkManager.shared
    let dateManager = DateManager.shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), staffMeal: [String](), studentMeal: [String]())
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        networkManager.TwoRestaurant(day: dateManager.fetchTodayEn().lowercased()) { results in
            switch results {
            case .success(var info):
                if info.staff.isEmpty {
                    info.staff.append(contentsOf: ["", "", "", "오늘은 운영하지 않아요 🥲", "", "", ""])
                }
                if info.student.isEmpty {
                    info.student.append(contentsOf: ["", "", "", "오늘은 운영하지 않아요 🥲", "", "", ""])
                }
                var entries: [SimpleEntry] = []
                let entry = Entry(date: Date(), staffMeal: info.staff, studentMeal: info.student)
                entries.append(entry)
                completion(entry)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        networkManager.TwoRestaurant(day: dateManager.fetchTodayEn().lowercased()) { results in
            switch results {
            case .success(var info):
                if info.staff.isEmpty {
                    info.staff.append(contentsOf: ["", "", "", "오늘은 운영하지 않아요 🥲", "", "", ""])
                }
                if info.student.isEmpty {
                    info.student.append(contentsOf: ["", "", "", "오늘은 운영하지 않아요 🥲", "", "", ""])
                }
                var entries: [SimpleEntry] = []
                let entry = Entry(date: Date(), staffMeal: info.staff, studentMeal: info.student)
                entries.append(entry)
                
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
                let timeline = Timeline(entries: entries, policy: .after(entryDate!))
                completion(timeline)
            case .failure(let error):
                print(error)
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
        Text(entry.date, style: .time)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
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
                .frame(width: 160, height: 20, alignment: .center)
                VStack {
                    ForEach(entry.staffMeal, id: \.self) {
                        Text($0)
                            .font(.system(size: 13))
                    }
                }
            }
            .frame(width: 160, height: 160)
            .background(Color.gray)
            Divider()
            VStack {
                HStack {
                    Text("학생 식당")
                        .font(.system(size: 15, weight: .bold))
                    Text("(~14:00)")
                        .font(.system(size: 12))
                }
                .frame(width: 160, height: 20, alignment: .center)
                VStack {
                    ForEach(entry.studentMeal, id: \.self) {
                        Text($0)
                            .font(.system(size: 13))
                    }
                }
            }
            .frame(width: 160, height: 160)
        }
        .frame(width: 320, height: 160)
    }
}
