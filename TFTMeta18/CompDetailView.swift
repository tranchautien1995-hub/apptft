import SwiftUI

enum DetailTab: String, CaseIterable, Identifiable {
    case overview = "OVERVIEW"
    case units = "UNITS"
    case items = "ITEMS"
    case variants = "VARIANTS"
    case traits = "TRAITS"
    case other = "OTHER"
    var id: String { rawValue }
}

enum LevelMode: String, CaseIterable, Identifiable {
    case level8 = "LVL 8"
    case emblem = "EMBLEM"
    case level9 = "LVL 9"
    case level9Emblem = "LVL 9 + EMBLEM"
    var id: String { rawValue }
}

struct CompDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    let comp: TFTComp
    var siblings: [TFTComp] = []
    @State private var selectedTab: DetailTab = .overview
    @State private var selectedLevel: LevelMode = .level8

    var body: some View {
        ZStack {
            TFTTheme.background.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 12) {
                    detailHeader
                    tabBar
                    tabContent
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(true)
    }

    private var detailHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(TFTTheme.goldSoft)
                        .frame(width: 40, height: 40)
                        .background(TFTTheme.surfaceRaised)
                        .overlay(Circle().stroke(TFTTheme.goldBorder, lineWidth: 1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("ĐỘI HÌNH")
                        .font(.caption.bold())
                        .foregroundColor(TFTTheme.goldSoft)
                    Text(comp.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(comp.subtitle + " · " + comp.sourceRanks.joined(separator: "/"))
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(TFTTheme.cyan)
                }

                Spacer(minLength: 4)

                Text(comp.tier)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(TFTTheme.tierColor(comp.tier))
                    .cornerRadius(10)
            }
            .padding(.top, 14)

            AppCard {
                HStack(spacing: 0) {
                    StatCell(value: String(format: "%.2f", comp.avgPlace), label: "Place", accent: TFTTheme.green)
                    StatCell(value: String(format: "%.2f", comp.playRate), label: "Play Rate", accent: .white)
                    StatCell(value: String(format: "%.1f%%", comp.top4), label: "Top 4", accent: TFTTheme.green)
                    StatCell(value: String(format: "%.1f%%", comp.winRate), label: "Win %", accent: TFTTheme.goldSoft)
                }
            }

            HStack {
                Spacer()
                PlannerCopyButton(comp: comp)
            }
        }
    }

    private var tabBar: some View {
        AppCard {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(DetailTab.allCases) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(selectedTab == tab ? .black : .white.opacity(0.72))
                                .padding(.horizontal, 11)
                                .frame(minHeight: 42)
                                .fixedSize(horizontal: true, vertical: false)
                                .background(selectedTab == tab ? TFTTheme.goldSoft : TFTTheme.surfaceRaised)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedTab == tab ? TFTTheme.goldSoft : TFTTheme.border, lineWidth: 1)
                                )
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .overview: overviewTab
        case .units: unitsTab
        case .items: itemsTab
        case .variants: variantsTab
        case .traits: traitsTab
        case .other: otherTab
        }
    }

    private var overviewTab: some View {
        VStack(spacing: 12) {
            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionLabel(text: "Core")
                    horizontalUnits(comp.coreUnits)
                    if !comp.flexUnits.isEmpty {
                        SectionLabel(text: "Flex")
                        horizontalUnits(comp.flexUnits)
                    }
                }
            }

            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionLabel(text: "Level Plan")
                    levelSelector
                    Text(levelPlanDescription)
                        .font(.caption)
                        .foregroundColor(TFTTheme.text2)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, minHeight: 38, alignment: .leading)
                        .background(TFTTheme.surfaceRaised)
                        .cornerRadius(9)
                    levelLineup
                    if selectedLevel == .emblem || selectedLevel == .level9Emblem {
                        Text(emblemText)
                            .font(.caption)
                            .foregroundColor(TFTTheme.goldSoft)
                    }
                }
            }

            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionLabel(text: "Itemization")
                    itemizationRows
                }
            }

            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionLabel(text: "Win Conditions")
                    horizontalUnits(Array(comp.coreUnits.prefix(6)))
                }
            }

            if !siblings.isEmpty {
                AppCard {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionLabel(text: "Variants")
                        NavigationLink(destination: variantsTab) {
                            UnifiedActionButton(
                                text: "Xem \(siblings.count) biến thể",
                                icon: "hexagon.fill",
                                compact: true
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }

    private var levelSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(LevelMode.allCases) { mode in
                    Button(action: { selectedLevel = mode }) {
                        Text(mode.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(selectedLevel == mode ? .black : .white.opacity(0.72))
                            .padding(.horizontal, 11)
                            .frame(minHeight: 42)
                            .fixedSize(horizontal: true, vertical: false)
                            .background(selectedLevel == mode ? TFTTheme.goldSoft : TFTTheme.surfaceRaised)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedLevel == mode ? TFTTheme.goldSoft : TFTTheme.border, lineWidth: 1)
                            )
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var levelPlanUnits: [UnitBuild] {
        switch selectedLevel {
        case .level8, .emblem:
            return Array(comp.units.prefix(min(8, comp.units.count)))
        case .level9, .level9Emblem:
            return Array(comp.units.prefix(min(9, comp.units.count)))
        }
    }

    private var levelPlanDescription: String {
        switch selectedLevel {
        case .level8:
            return "LVL 8 · Khung hoàn thiện ở cấp 8. Hiển thị tối đa 8 tướng từ snapshot."
        case .emblem:
            return "EMBLEM · Giữ khung cấp 8 và ưu tiên Ấn/Emblem được ghi nhận trong trang bị của đội hình."
        case .level9:
            return "LVL 9 · Khung cấp 9. Nếu snapshot chỉ có 8 tướng, ô Flex sẽ hiện để bạn thêm quân thứ 9."
        case .level9Emblem:
            return "LVL 9 + EMBLEM · Khung cấp 9 kết hợp Ấn/Emblem; có ô Flex nếu snapshot chưa ghi quân thứ 9."
        }
    }

    private var levelLineup: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(levelPlanUnits) { unit in
                    DetailUnitCard(unit: unit)
                }

                if (selectedLevel == .level9 || selectedLevel == .level9Emblem) && comp.units.count < 9 {
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(TFTTheme.goldBorder, style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundColor(TFTTheme.goldSoft)
                            )
                        Text("Flex")
                            .font(.system(size: 8))
                            .foregroundColor(TFTTheme.text2)
                    }
                }
            }
            .padding(.horizontal, 1)
        }
    }

    private var emblemText: String {
        let emblems = comp.units.flatMap { $0.items }.filter {
            $0.name.localizedCaseInsensitiveContains("Ấn") ||
            $0.name.localizedCaseInsensitiveContains("Emblem")
        }
        return emblems.isEmpty
            ? "Snapshot không ghi nhận ấn bắt buộc cho đội hình này."
            : "Emblem: " + emblems.map { $0.name }.joined(separator: ", ")
    }

    private var itemizationRows: some View {
        VStack(spacing: 10) {
            ForEach(Array(comp.coreUnits.enumerated()), id: \.element.id) { index, unit in
                HStack(spacing: 10) {
                    Text(index == 0 ? "S" : (index < 3 ? "A" : "B"))
                        .font(.title3.bold())
                        .foregroundColor(index == 0 ? TFTTheme.goldSoft : (index < 3 ? .pink : TFTTheme.cyan))
                        .frame(width: 22)
                    DetailUnitCard(unit: unit)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(unit.items) { item in
                                RemoteImage(url: item.imageURL, cornerRadius: 5, fallbackText: "I")
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(9)
                .background(TFTTheme.surfaceRaised)
                .cornerRadius(10)
            }
        }
    }

    private var unitsTab: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel(text: "Units")
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 10)], spacing: 12) {
                    ForEach(comp.units) { unit in
                        VStack(spacing: 5) {
                            DetailUnitCard(unit: unit)
                            Text("\(unit.cost) vàng")
                                .font(.caption2)
                                .foregroundColor(TFTTheme.text2)
                        }
                    }
                }
            }
        }
    }

    private var itemsTab: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel(text: "Items")
                ForEach(comp.units.filter { !$0.items.isEmpty }) { unit in
                    HStack(spacing: 10) {
                        DetailUnitCard(unit: unit)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(unit.name)
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 7) {
                                    ForEach(unit.items) { item in
                                        HStack(spacing: 5) {
                                            RemoteImage(url: item.imageURL, cornerRadius: 4, fallbackText: "I")
                                                .frame(width: 30, height: 30)
                                            Text(item.name)
                                                .font(.caption2)
                                                .foregroundColor(TFTTheme.text2)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(9)
                    .background(TFTTheme.surfaceRaised)
                    .cornerRadius(10)
                }
            }
        }
    }

    private var variantsTab: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel(text: "Variants")
                if siblings.isEmpty {
                    Text("Không có subcomp riêng trong snapshot này.")
                        .foregroundColor(TFTTheme.text2)
                        .padding(.vertical, 18)
                } else {
                    ForEach(siblings) { variant in
                        LinkedCompCard(
                            rank: nil,
                            comp: variant,
                            siblings: siblings.filter { $0.id != variant.id }
                        )
                    }
                }
            }
        }
    }

    private var traitsTab: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel(text: "Traits")
                FlowTags(tags: [comp.family.capitalized, comp.subtitle])
            }
        }
    }

    private var otherTab: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel(text: "Other")
                ForEach(comp.notes, id: \.self) { note in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(TFTTheme.goldSoft)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        Text(note)
                            .font(.footnote)
                            .foregroundColor(TFTTheme.text2)
                    }
                }
            }
        }
    }

    private func horizontalUnits(_ units: [UnitBuild]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(units) { unit in DetailUnitCard(unit: unit) }
            }
        }
    }
}

struct DetailUnitCard: View {
    let unit: UnitBuild

    var body: some View {
        VStack(spacing: 4) {
            RemoteImage(url: unit.imageURL, cornerRadius: 6, fallbackText: unit.name)
                .frame(width: 50, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(TFTTheme.costColor(unit.cost), lineWidth: 2)
                )
            Text(unit.name)
                .font(.system(size: 8))
                .foregroundColor(TFTTheme.text2)
                .lineLimit(1)
                .frame(width: 56)
        }
    }
}

struct FlowTags: View {
    let tags: [String]

    var body: some View {
        HStack(spacing: 7) {
            ForEach(tags, id: \.self) { text in
                Text(text)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(TFTTheme.goldButton)
                    .overlay(Capsule().stroke(TFTTheme.goldBorder, lineWidth: 1))
                    .clipShape(Capsule())
            }
        }
    }
}
