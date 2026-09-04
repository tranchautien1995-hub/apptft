import SwiftUI

struct CompGroup: Identifiable {
    let id: String
    let main: TFTComp
    let variants: [TFTComp]
}

struct ContentView: View {
    @Environment(\.openURL) private var openURL
    @State private var selectedRank: TFTRank = .all
    @State private var selectedTimeMode = "Last 2 Days"
    @State private var selectedSort: TFTSort = .avg
    @State private var selectedChampion: String?
    @State private var searchText = ""
    @State private var showFilter = false
    @State private var variantGroup: CompGroup?
    @State private var showLowPlay = true

    private let timeModes = ["Last 2 Days", "Patch 18.1d"]

    private var filteredMains: [TFTComp] {
        var values = TFTData.comps.filter { $0.dataWindow == selectedTimeMode && ($0.sourceKind == "main" || (showLowPlay && $0.sourceKind == "lowplay")) }

        if selectedRank != .all {
            values = values.filter { $0.sourceRanks.contains(selectedRank.rawValue) }
        } else {
            let grouped = Dictionary(grouping: values, by: { $0.title })
            values = grouped.values.compactMap { sorted(Array($0)).first }
        }

        if let champion = selectedChampion {
            values = values.filter { $0.units.contains { $0.name == champion } }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            values = values.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.units.contains { $0.name.localizedCaseInsensitiveContains(query) }
            }
        }

        return sorted(values)
    }

    private func variants(for main: TFTComp) -> [TFTComp] {
        TFTData.comps.filter { item in
            guard item.sourceKind == "subcomp",
                  item.family == main.family,
                  item.dataWindow == main.dataWindow else { return false }
            if selectedRank == .all { return true }
            if let rank = main.sourceRanks.first { return item.sourceRanks.contains(rank) }
            return true
        }
    }

    private func sorted(_ list: [TFTComp]) -> [TFTComp] {
        switch selectedSort {
        case .avg: return list.sorted { $0.avgPlace < $1.avgPlace }
        case .win: return list.sorted { $0.winRate > $1.winRate }
        case .top4: return list.sorted { $0.top4 > $1.top4 }
        case .pick: return list.sorted { $0.playRate > $1.playRate }
        }
    }

    private var allChampions: [String] {
        var values = TFTData.comps.filter { $0.dataWindow == selectedTimeMode }
        if selectedRank != .all {
            values = values.filter { $0.sourceRanks.contains(selectedRank.rawValue) }
        }
        return Array(Set(values.flatMap { $0.units.map(\.name) })).sorted()
    }

    var body: some View {
        NavigationView {
            ZStack {
                TFTTheme.background.ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 12) {
                        AppHeader(
                            eyebrow: "ĐTCL MÙA 18",
                            title: "Đội hình meta",
                            actionIcon: "arrow.up.right.square",
                            action: { openURL(TFTData.sourceURL) }
                        )

                        filterBar

                        if selectedChampion != nil || !searchText.isEmpty {
                            activeFilterRow
                        }

                        if filteredMains.isEmpty {
                            emptyState
                        } else {
                            ForEach(Array(filteredMains.enumerated()), id: \.element.id) { index, comp in
                                let subcomps = variants(for: comp)
                                VStack(spacing: 7) {
                                    LinkedCompCard(
                                        rank: index + 1,
                                        comp: comp,
                                        siblings: subcomps
                                    )

                                    if !subcomps.isEmpty {
                                        Button(action: {
                                            variantGroup = CompGroup(id: comp.id, main: comp, variants: subcomps)
                                        }) {
                                            UnifiedActionButton(
                                                text: "\(subcomps.count) biến thể",
                                                icon: "hexagon.fill",
                                                compact: true
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            }
                        }

                        Text("Snapshot tactics.tools · V3.4 Full Catalog · Low-play + Variants")
                            .font(.caption2)
                            .foregroundColor(TFTTheme.text3)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 28)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilter) {
                CompFilterSheet(
                    champions: allChampions,
                    comps: filteredMains,
                    selectedChampion: $selectedChampion,
                    searchText: $searchText
                )
            }
            .sheet(item: $variantGroup) { group in
                VariantsView(main: group.main, variants: group.variants)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var filterBar: some View {
        AppCard {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 8) {
                    Menu {
                        ForEach(TFTRank.allCases) { rank in
                            Button(rank.rawValue) { selectedRank = rank }
                        }
                    } label: {
                        UnifiedMenuLabel(
                            text: selectedRank == .all ? "Tất cả rank" : selectedRank.rawValue,
                            icon: "person.2.fill"
                        )
                    }

                    Menu {
                        ForEach(timeModes, id: \.self) { mode in
                            Button(mode) { selectedTimeMode = mode }
                        }
                    } label: {
                        UnifiedMenuLabel(text: selectedTimeMode, icon: "clock.fill")
                    }

                    Menu {
                        ForEach(TFTSort.allCases) { sort in
                            Button(sortName(sort)) { selectedSort = sort }
                        }
                    } label: {
                        UnifiedMenuLabel(text: sortName(selectedSort), icon: "arrow.up.arrow.down")
                    }

                    Button(action: { showFilter = true }) {
                        UnifiedActionButton(
                            text: filterName,
                            icon: "magnifyingglass",
                            compact: true,
                            emphasized: selectedChampion != nil || !searchText.isEmpty
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: { showLowPlay.toggle() }) {
                        UnifiedActionButton(
                            text: showLowPlay ? "Low play: ON" : "Low play: OFF",
                            icon: showLowPlay ? "eye.fill" : "eye.slash",
                            compact: true,
                            emphasized: showLowPlay
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var activeFilterRow: some View {
        HStack(spacing: 7) {
            if let champion = selectedChampion {
                FilterChip(text: champion) { selectedChampion = nil }
            }
            if !searchText.isEmpty {
                FilterChip(text: searchText) { searchText = "" }
            }
            Spacer(minLength: 0)
        }
    }

    private func sortName(_ sort: TFTSort) -> String {
        switch sort {
        case .avg: return "Avg. Place"
        case .win: return "Win %"
        case .top4: return "Top 4 %"
        case .pick: return "Play Rate"
        }
    }

    private var filterName: String {
        selectedChampion ?? (searchText.isEmpty ? "Filter" : searchText)
    }

    private var emptyState: some View {
        AppCard {
            VStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(TFTTheme.goldSoft)
                Text("Không có đội hình phù hợp")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("Đổi rank / thời gian hoặc xóa filter.")
                    .font(.caption)
                    .foregroundColor(TFTTheme.text2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
        }
    }
}

struct AppHeader: View {
    let eyebrow: String
    let title: String
    var actionIcon: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(eyebrow)
                    .font(.caption.bold())
                    .foregroundColor(TFTTheme.goldSoft)
                Text(title)
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            Spacer()
            if let actionIcon = actionIcon, let action = action {
                Button(action: action) {
                    Image(systemName: actionIcon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(TFTTheme.goldSoft)
                        .frame(width: 42, height: 42)
                        .background(TFTTheme.surfaceRaised)
                        .overlay(Circle().stroke(TFTTheme.goldBorder, lineWidth: 1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.top, 14)
    }
}

struct AppCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(12)
            .background(TFTTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(TFTTheme.border, lineWidth: 1)
            )
            .cornerRadius(14)
    }
}

struct UnifiedMenuLabel: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .lineLimit(1)
            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 11)
        .frame(minHeight: 42)
        .fixedSize(horizontal: true, vertical: false)
        .background(TFTTheme.goldButton)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(TFTTheme.goldBorder, lineWidth: 1)
        )
        .cornerRadius(11)
        .contentShape(Rectangle())
    }
}

struct UnifiedActionButton: View {
    let text: String
    let icon: String
    var compact: Bool = false
    var emphasized: Bool = false

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .lineLimit(1)
        }
        .foregroundColor(emphasized ? TFTTheme.goldSoft : .white)
        .padding(.horizontal, compact ? 11 : 13)
        .frame(minHeight: 42)
        .fixedSize(horizontal: true, vertical: false)
        .background(TFTTheme.goldButton)
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(TFTTheme.goldBorder, lineWidth: 1)
        )
        .cornerRadius(11)
        .contentShape(Rectangle())
    }
}

struct FilterChip: View {
    let text: String
    let remove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
            Button(action: remove) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(TFTTheme.surfaceRaised)
        .overlay(Capsule().stroke(TFTTheme.goldBorder.opacity(0.7), lineWidth: 1))
        .clipShape(Capsule())
    }
}

struct SectionLabel: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(TFTTheme.goldBorder).frame(height: 1)
            Text(text.uppercased())
                .font(.system(size: 10, weight: .bold))
                .tracking(0.7)
                .foregroundColor(TFTTheme.goldSoft)
            Rectangle().fill(TFTTheme.goldBorder).frame(height: 1)
        }
    }
}


struct LinkedCompCard: View {
    let rank: Int?
    let comp: TFTComp
    let siblings: [TFTComp]

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                NavigationLink(destination: CompDetailView(comp: comp, siblings: siblings)) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(comp.tier)
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)
                            .frame(width: 38, height: 38)
                            .background(TFTTheme.tierColor(comp.tier))
                            .cornerRadius(9)

                        VStack(alignment: .leading, spacing: 4) {
                            Text((rank.map { "#\($0)  " } ?? "") + comp.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                            Text(comp.subtitle + " · " + comp.sourceRanks.joined(separator: "/"))
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(TFTTheme.cyan)
                                .lineLimit(1)
                        }

                        Spacer(minLength: 6)
                        Image(systemName: "chevron.right")
                            .foregroundColor(TFTTheme.text3)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                // Kept outside NavigationLink so horizontal drag is never stolen by navigation.
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 8) {
                        ForEach(comp.units) { UnitMiniCard(unit: $0) }
                    }
                    .padding(.horizontal, 1)
                }

                Divider().background(TFTTheme.border)

                NavigationLink(destination: CompDetailView(comp: comp, siblings: siblings)) {
                    HStack(spacing: 0) {
                        StatCell(value: String(format: "%.2f", comp.avgPlace), label: "Place", accent: TFTTheme.green)
                        StatCell(value: String(format: "%.2f", comp.playRate), label: "Play Rate", accent: .white)
                        StatCell(value: String(format: "%.1f%%", comp.top4), label: "Top 4", accent: TFTTheme.green)
                        StatCell(value: String(format: "%.1f%%", comp.winRate), label: "Win %", accent: TFTTheme.goldSoft)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .overlay(
            Rectangle().fill(TFTTheme.tierColor(comp.tier)).frame(width: 4),
            alignment: .leading
        )
    }
}

struct CompRow: View {
    let rank: Int?
    let comp: TFTComp

    init(rank: Int?, comp: TFTComp) {
        self.rank = rank
        self.comp = comp
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    Text(comp.tier)
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 38, height: 38)
                        .background(TFTTheme.tierColor(comp.tier))
                        .cornerRadius(9)

                    VStack(alignment: .leading, spacing: 4) {
                        Text((rank.map { "#\($0)  " } ?? "") + comp.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        Text(comp.subtitle + " · " + comp.sourceRanks.joined(separator: "/"))
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(TFTTheme.cyan)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 6)
                    Image(systemName: "chevron.right")
                        .foregroundColor(TFTTheme.text3)
                }

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 8) {
                        ForEach(comp.units) { UnitMiniCard(unit: $0) }
                    }
                }

                Divider().background(TFTTheme.border)

                HStack(spacing: 0) {
                    StatCell(value: String(format: "%.2f", comp.avgPlace), label: "Place", accent: TFTTheme.green)
                    StatCell(value: String(format: "%.2f", comp.playRate), label: "Play Rate", accent: .white)
                    StatCell(value: String(format: "%.1f%%", comp.top4), label: "Top 4", accent: TFTTheme.green)
                    StatCell(value: String(format: "%.1f%%", comp.winRate), label: "Win %", accent: TFTTheme.goldSoft)
                }
            }
        }
        .overlay(
            Rectangle().fill(TFTTheme.tierColor(comp.tier)).frame(width: 4),
            alignment: .leading
        )
    }
}

struct UnitMiniCard: View {
    let unit: UnitBuild

    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottom) {
                RemoteImage(url: unit.imageURL, cornerRadius: 6, fallbackText: unit.name)
                    .frame(width: 52, height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(TFTTheme.costColor(unit.cost), lineWidth: 2)
                    )

                if !unit.items.isEmpty {
                    HStack(spacing: 1) {
                        ForEach(unit.items.prefix(3)) { item in
                            RemoteImage(url: item.imageURL, cornerRadius: 2, fallbackText: "I")
                                .frame(width: 15, height: 15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.black.opacity(0.8), lineWidth: 0.7)
                                )
                        }
                    }
                    .offset(y: 8)
                }
            }
            .padding(.bottom, unit.items.isEmpty ? 0 : 7)

            Text(unit.name)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.78))
                .lineLimit(1)
                .frame(width: 58)
        }
    }
}

struct StatCell: View {
    let value: String
    let label: String
    let accent: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(accent)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(TFTTheme.text2)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
}

struct VariantsView: View {
    @Environment(\.dismiss) private var dismiss
    let main: TFTComp
    let variants: [TFTComp]

    var body: some View {
        NavigationView {
            ZStack {
                TFTTheme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("BIẾN THỂ")
                                    .font(.caption.bold())
                                    .foregroundColor(TFTTheme.goldSoft)
                                Text(main.title)
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                Text("\(main.sourceRanks.first ?? "") · \(main.dataWindow)")
                                    .font(.caption)
                                    .foregroundColor(TFTTheme.text2)
                            }
                            Spacer()
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(TFTTheme.goldSoft)
                                    .frame(width: 40, height: 40)
                                    .background(TFTTheme.surfaceRaised)
                                    .overlay(Circle().stroke(TFTTheme.goldBorder, lineWidth: 1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 14)

                        if variants.isEmpty {
                            AppCard {
                                Text("Snapshot này không có subcomp riêng.")
                                    .foregroundColor(TFTTheme.text2)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                            }
                        } else {
                            ForEach(variants) { variant in
                                LinkedCompCard(
                                    rank: nil,
                                    comp: variant,
                                    siblings: variants.filter { $0.id != variant.id }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 28)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CompFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    let champions: [String]
    let comps: [TFTComp]
    @Binding var selectedChampion: String?
    @Binding var searchText: String
    @State private var draft = ""

    private var filteredChampions: [String] {
        draft.isEmpty ? champions : champions.filter { $0.localizedCaseInsensitiveContains(draft) }
    }

    private var matchedComps: [TFTComp] {
        draft.isEmpty ? comps : comps.filter {
            $0.title.localizedCaseInsensitiveContains(draft) ||
            $0.units.contains { $0.name.localizedCaseInsensitiveContains(draft) }
        }
    }

    var body: some View {
        ZStack {
            TFTTheme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("FILTER")
                                .font(.caption.bold())
                                .foregroundColor(TFTTheme.goldSoft)
                            Text("Tìm đội hình")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(TFTTheme.goldSoft)
                                .frame(width: 40, height: 40)
                                .background(TFTTheme.surfaceRaised)
                                .overlay(Circle().stroke(TFTTheme.goldBorder, lineWidth: 1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 14)

                    AppCard {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(TFTTheme.goldSoft)
                            TextField("Tên đội hình hoặc tướng...", text: $draft)
                                .foregroundColor(.white)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }
                        .frame(minHeight: 40)
                    }

                    HStack {
                        SectionLabel(text: "Tướng")
                        Button("Xóa lọc") {
                            selectedChampion = nil
                            searchText = ""
                            dismiss()
                        }
                        .font(.caption2.bold())
                        .foregroundColor(TFTTheme.goldSoft)
                    }

                    Text("Chạm vào tên tướng để lọc các đội hình có tướng đó")
                        .font(.caption2)
                        .foregroundColor(TFTTheme.text3)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 8
                    ) {
                        ForEach(filteredChampions, id: \.self) { champion in
                            Button(action: {
                                selectedChampion = champion
                                searchText = ""
                                dismiss()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "person.crop.square")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(TFTTheme.goldSoft)
                                    Text(champion)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.72)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 10)
                                .frame(maxWidth: .infinity, minHeight: 42)
                                .background(TFTTheme.surfaceRaised)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9)
                                        .stroke(TFTTheme.border, lineWidth: 1)
                                )
                                .cornerRadius(9)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    SectionLabel(text: "Đội hình")

                    ForEach(matchedComps) { comp in
                        Button(action: {
                            selectedChampion = nil
                            searchText = comp.title
                            dismiss()
                        }) {
                            HStack {
                                Text(comp.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(TFTTheme.text3)
                            }
                            .padding(.horizontal, 12)
                            .frame(minHeight: 46)
                            .background(TFTTheme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 11)
                                    .stroke(TFTTheme.border, lineWidth: 1)
                            )
                            .cornerRadius(11)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 28)
            }
        }
        .onAppear { draft = searchText }
    }
}
