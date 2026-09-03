import SwiftUI

struct CompGroup: Identifiable {
    let id: String
    let main: TFTComp
    let variants: [TFTComp]
}

struct ContentView: View {
    @Environment(\.openURL) private var openURL

    @State private var selectedRank: TFTRank = .all
    @State private var selectedTimeMode: String = "Last 2 Days"
    @State private var selectedScope: String = "All Comps"
    @State private var selectedSort: TFTSort = .top4
    @State private var selectedChampion: String?
    @State private var searchText = ""
    @State private var showFilter = false
    @State private var expandedGroups: Set<String> = []

    private let scopeOptions = ["All Comps", "Only Main Comps", "Has Variants"]
    private let timeModes = ["Last 2 Days", "Patch 18.1d"]

    private var runtimeComps: [TFTComp] {
        TFTData.comps
    }

    private func familyID(for comp: TFTComp) -> String {
        comp.family
    }

    private var allChampions: [String] {
        var values = runtimeComps.filter { $0.dataWindow == selectedTimeMode }
        if selectedRank != .all {
            values = values.filter { $0.sourceRanks.contains(selectedRank.rawValue) }
        }
        return Array(Set(values.flatMap { $0.units.map(\.name) })).sorted()
    }
    private var filteredComps: [TFTComp] {
        var values = runtimeComps.filter { $0.dataWindow == selectedTimeMode }

        if selectedRank != .all {
            values = values.filter { $0.sourceRanks.contains(selectedRank.rawValue) }
        }

        if let champion = selectedChampion {
            values = values.filter { $0.units.contains { $0.name == champion } }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            values = values.filter {
                $0.title.localizedCaseInsensitiveContains(query)
                || $0.units.contains { $0.name.localizedCaseInsensitiveContains(query) }
            }
        }

        return values
    }
    private func sorted(_ list: [TFTComp]) -> [TFTComp] { switch selectedSort { case .avg: return list.sorted { $0.avgPlace < $1.avgPlace }; case .win: return list.sorted { $0.winRate > $1.winRate }; case .top4: return list.sorted { $0.top4 > $1.top4 }; case .pick: return list.sorted { $0.playRate > $1.playRate } } }
    private var displayGroups: [CompGroup] {
        let grouped = Dictionary(grouping: filteredComps, by: familyID)
        var values: [CompGroup] = grouped.compactMap { key, comps in let s = sorted(comps); guard let main = s.first else { return nil }; return CompGroup(id: key, main: main, variants: Array(s.dropFirst())) }
        if selectedScope == "Only Main Comps" {
            values = values.map { CompGroup(id: $0.id, main: $0.main, variants: []) }
        } else if selectedScope == "Has Variants" {
            values = values.filter { !$0.variants.isEmpty }
        }
        values.sort { lhs, rhs in switch selectedSort { case .avg: return lhs.main.avgPlace < rhs.main.avgPlace; case .win: return lhs.main.winRate > rhs.main.winRate; case .top4: return lhs.main.top4 > rhs.main.top4; case .pick: return lhs.main.playRate > rhs.main.playRate } }
        return values
    }

    var body: some View {
        NavigationView {
            ZStack {
                TFTTheme.background.ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 12) {
                        header
                        topControls
                        sortFilterControls
                        if displayGroups.isEmpty {
                            VStack(spacing: 10) { Image(systemName: "magnifyingglass").font(.title2).foregroundColor(TFTTheme.text2); Text("Không có đội hình phù hợp").font(.subheadline.bold()).foregroundColor(.white); Text("Thử đổi Rank hoặc xóa Filter.").font(.caption).foregroundColor(TFTTheme.text2) }.frame(maxWidth: .infinity).padding(.vertical, 40)
                        } else {
                            ForEach(Array(displayGroups.enumerated()), id: \.element.id) { index, group in
                                VStack(spacing: 8) {
                                    NavigationLink(destination: CompDetailView(comp: group.main, siblings: group.variants)) {
                                        CompRow(rank: index + 1, comp: group.main, variantCount: group.variants.count, onToggleVariants: { if expandedGroups.contains(group.id) { expandedGroups.remove(group.id) } else { expandedGroups.insert(group.id) } })
                                    }.buttonStyle(PlainButtonStyle())
                                    if expandedGroups.contains(group.id) {
                                        ForEach(group.variants) { variant in
                                            NavigationLink(destination: CompDetailView(comp: variant, siblings: group.variants.filter { $0.id != variant.id } + [group.main])) { CompRow(rank: nil, comp: variant, variantCount: 0, compact: true) }
                                                .buttonStyle(PlainButtonStyle()).padding(.leading, 18)
                                        }
                                    }
                                }
                            }
                        }
                        Text("Snapshot tactics.tools · \(TFTData.snapshot) · 47 cấu hình · 2 bộ dữ liệu").font(.caption2).foregroundColor(TFTTheme.text2).multilineTextAlignment(.center).padding(.vertical, 8)
                    }.padding(.horizontal, 12).padding(.bottom, 28)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilter) { CompFilterSheet(champions: allChampions, comps: filteredComps, selectedChampion: $selectedChampion, searchText: $searchText) }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private var header: some View {
        HStack { VStack(alignment: .leading, spacing: 2) { Text("ĐTCL MÙA 18").font(.caption.bold()).foregroundColor(TFTTheme.goldSoft); Text("Đội hình meta").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.white) }; Spacer(); Button(action: { openURL(TFTData.sourceURL) }) { Image(systemName: "arrow.up.right.square").font(.title3).foregroundColor(.white).frame(width: 40, height: 40).background(TFTTheme.goldButton).clipShape(Circle()).overlay(Circle().stroke(TFTTheme.goldBorder, lineWidth: 1)) } }.padding(.top, 14)
    }
    private var topControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                StaticGoldControl(text: "Ranked")
                Menu { ForEach(TFTRank.allCases) { rank in Button(rank.rawValue) { selectedRank = rank } } } label: { GoldControlLabel(text: selectedRank == .all ? "Tất cả rank" : selectedRank.rawValue) }
                Menu { ForEach(timeModes, id: \.self) { value in Button(value) { selectedTimeMode = value } } } label: { GoldControlLabel(text: selectedTimeMode) }
                Menu { ForEach(scopeOptions, id: \.self) { value in Button(value) { selectedScope = value } } } label: { GoldControlLabel(text: selectedScope) }
            }
            Text("Snapshot 04/09/2026 · 47 cấu hình từ Platinum+/Diamond+/Master+/GM+").font(.system(size: 9)).foregroundColor(TFTTheme.text2).frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    private var sortFilterControls: some View {
        HStack(spacing: 8) {
            Menu { ForEach(TFTSort.allCases) { sort in Button(sortDisplayName(of: sort)) { selectedSort = sort } } } label: { GoldControlLabel(text: sortDisplayName(of: selectedSort)) }
            Button(action: { showFilter = true }) { GoldControlLabel(text: filterDisplayName, trailing: "magnifyingglass", emphasized: selectedChampion != nil || !searchText.isEmpty) }.buttonStyle(PlainButtonStyle())
        }
    }
    private func sortDisplayName(of sort: TFTSort) -> String { switch sort { case .avg: return "Avg. Place"; case .win: return "Win %"; case .top4: return "Top 4 %"; case .pick: return "Play Rate" } }
    private var filterDisplayName: String { if let champion = selectedChampion { return champion }; if !searchText.isEmpty { return searchText }; return "Add Filter" }
}

struct GoldControlLabel: View { let text: String; var trailing: String = "chevron.down"; var emphasized: Bool = false; var body: some View { HStack(spacing: 6) { Text(text).font(.system(size: 12, weight: .semibold)).lineLimit(1).minimumScaleFactor(0.72).foregroundColor(emphasized ? TFTTheme.goldSoft : .white); Spacer(minLength: 2); Image(systemName: trailing).font(.system(size: 9, weight: .bold)).foregroundColor(.white.opacity(0.95)) }.padding(.horizontal, 12).frame(height: 40).frame(maxWidth: .infinity).background(TFTTheme.goldButton).overlay(RoundedRectangle(cornerRadius: 12).stroke(TFTTheme.goldBorder, lineWidth: 1)).cornerRadius(12) } }
struct StaticGoldControl: View { let text: String; var body: some View { HStack(spacing: 6) { Text(text).font(.system(size: 12, weight: .semibold)).lineLimit(1).minimumScaleFactor(0.72); Spacer(minLength: 2); Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold)) }.foregroundColor(.white).padding(.horizontal, 12).frame(height: 40).frame(maxWidth: .infinity).background(TFTTheme.goldButton).overlay(RoundedRectangle(cornerRadius: 12).stroke(TFTTheme.goldBorder, lineWidth: 1)).cornerRadius(12) } }
struct VariantBadge: View { let count: Int; let action: () -> Void; var body: some View { Button(action: action) { HStack(spacing: 5) { Text("⬢").font(.system(size: 10, weight: .bold)); Text("\(count)").font(.system(size: 11, weight: .heavy)) }.foregroundColor(.white).padding(.horizontal, 10).frame(height: 30).background(LinearGradient(colors: [Color(red: 0.62, green: 0.52, blue: 1.0), Color(red: 0.46, green: 0.35, blue: 0.95)], startPoint: .top, endPoint: .bottom)).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.40, green: 0.32, blue: 0.80), lineWidth: 1)).cornerRadius(10) }.buttonStyle(PlainButtonStyle()) } }
struct CompRow: View { let rank: Int?; let comp: TFTComp; let variantCount: Int; var compact: Bool = false; var onToggleVariants: (() -> Void)? = nil; var body: some View { VStack(alignment: .leading, spacing: 12) { HStack(alignment: .center, spacing: 10) { Text(comp.tier).font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundColor(.black).frame(width: 38, height: 38).background(TFTTheme.tierColor(comp.tier)).cornerRadius(9); VStack(alignment: .leading, spacing: 4) { Text((rank != nil ? "#\(rank!)  " : "") + comp.title).font(.system(size: compact ? 14 : 16, weight: .bold)).foregroundColor(.white).lineLimit(2); HStack(spacing: 5) { Text(comp.subtitle).font(.caption2.weight(.semibold)).foregroundColor(TFTTheme.cyan).lineLimit(1); Text("· " + comp.sourceRanks.joined(separator: "/")).font(.caption2).foregroundColor(TFTTheme.text2).lineLimit(1) } }; Spacer(minLength: 6); if variantCount > 0, let onToggleVariants { VariantBadge(count: variantCount, action: onToggleVariants) }; Image(systemName: "chevron.right").foregroundColor(TFTTheme.text2) }; ScrollView(.horizontal, showsIndicators: false) { HStack(spacing: 8) { ForEach(comp.units) { UnitMiniCard(unit: $0) } } }; HStack(spacing: 0) { StatCell(value: String(format: "%.2f", comp.avgPlace), label: "Place", accent: TFTTheme.green); StatCell(value: String(format: "%.2f", comp.playRate), label: "Play Rate", accent: .white); StatCell(value: String(format: "%.1f%%", comp.top4), label: "Top 4", accent: TFTTheme.green); StatCell(value: String(format: "%.1f%%", comp.winRate), label: "Win %", accent: TFTTheme.goldSoft) } }.padding(12).background(compact ? TFTTheme.panel2 : TFTTheme.panel).overlay(Rectangle().fill(TFTTheme.tierColor(comp.tier)).frame(width: 4), alignment: .leading).cornerRadius(14) } }
struct UnitMiniCard: View { let unit: UnitBuild; var body: some View { VStack(spacing: 4) { ZStack(alignment: .bottom) { RemoteImage(url: unit.imageURL, cornerRadius: 6).frame(width: 52, height: 52).overlay(RoundedRectangle(cornerRadius: 6).stroke(borderColor, lineWidth: 2)); if !unit.items.isEmpty { HStack(spacing: 1) { ForEach(unit.items.prefix(3)) { item in RemoteImage(url: item.imageURL, cornerRadius: 2).frame(width: 15, height: 15).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.black.opacity(0.8), lineWidth: 0.7)) } }.offset(y: 8) } }.padding(.bottom, unit.items.isEmpty ? 0 : 7); Text(unit.name).font(.system(size: 9, weight: .medium)).foregroundColor(.white.opacity(0.78)).lineLimit(1).frame(width: 58) } } private var borderColor: Color { switch unit.cost { case 1: return .gray; case 2: return Color(red: 0.22, green: 0.72, blue: 0.38); case 3: return Color(red: 0.28, green: 0.52, blue: 0.96); case 4: return Color(red: 0.75, green: 0.28, blue: 0.90); default: return Color(red: 0.96, green: 0.76, blue: 0.20) } } }
struct StatCell: View { let value: String; let label: String; let accent: Color; var body: some View { VStack(spacing: 2) { Text(value).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(accent); Text(label).font(.system(size: 9)).foregroundColor(TFTTheme.text2).lineLimit(1).minimumScaleFactor(0.7) }.frame(maxWidth: .infinity) } }
struct CompFilterSheet: View { @Environment(\.dismiss) private var dismiss; let champions: [String]; let comps: [TFTComp]; @Binding var selectedChampion: String?; @Binding var searchText: String; @State private var draft = ""; private var filteredChampions: [String] { draft.isEmpty ? champions : champions.filter { $0.localizedCaseInsensitiveContains(draft) } }; private var matchedComps: [TFTComp] { draft.isEmpty ? comps : comps.filter { $0.title.localizedCaseInsensitiveContains(draft) || $0.units.contains { $0.name.localizedCaseInsensitiveContains(draft) } } }; var body: some View { NavigationView { ZStack { TFTTheme.background.ignoresSafeArea(); ScrollView { VStack(alignment: .leading, spacing: 14) { HStack(spacing: 8) { Image(systemName: "magnifyingglass").foregroundColor(TFTTheme.text2); TextField("Tìm tên đội hình hoặc tướng...", text: $draft).foregroundColor(.white).disableAutocorrection(true).autocapitalization(.none); if !draft.isEmpty { Button(action: { draft = "" }) { Image(systemName: "xmark.circle.fill").foregroundColor(TFTTheme.text2) } } }.padding(.horizontal, 11).frame(height: 42).background(TFTTheme.panel2).cornerRadius(10); HStack { Text("TƯỚNG").font(.caption2.bold()).foregroundColor(TFTTheme.goldSoft); Spacer(); Button("Xóa filter") { selectedChampion = nil; searchText = ""; dismiss() }.font(.caption2).foregroundColor(TFTTheme.text2) }; LazyVGrid(columns: [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)], spacing: 7) { ForEach(filteredChampions, id: \.self) { champion in Button(action: { selectedChampion = champion; searchText = ""; dismiss() }) { Text(champion).font(.system(size: 10, weight: .medium)).foregroundColor(.white).lineLimit(1).minimumScaleFactor(0.65).frame(maxWidth: .infinity, minHeight: 38).padding(.horizontal, 5).background(TFTTheme.panel2).cornerRadius(8) }.buttonStyle(PlainButtonStyle()) } }; Text("ĐỘI HÌNH").font(.caption2.bold()).foregroundColor(TFTTheme.goldSoft).padding(.top, 4); ForEach(matchedComps) { comp in Button(action: { selectedChampion = nil; searchText = comp.title; dismiss() }) { HStack { Text(comp.title).font(.subheadline.weight(.semibold)).foregroundColor(.white).lineLimit(1); Spacer(); Image(systemName: "chevron.right").font(.caption).foregroundColor(TFTTheme.text2) }.padding(.vertical, 9) }.buttonStyle(PlainButtonStyle()); Divider().background(Color.white.opacity(0.08)) } }.padding(14) } } .navigationTitle("Filter").navigationBarTitleDisplayMode(.inline).toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Đóng") { dismiss() } } }.onAppear { draft = searchText } } } }
