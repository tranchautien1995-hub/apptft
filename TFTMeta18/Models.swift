import Foundation
import SwiftUI

struct ItemBuild: Identifiable, Hashable { let id = UUID(); let name: String; let imageURL: String }

struct UnitBuild: Identifiable, Hashable { let id = UUID(); let name: String; let imageURL: String; let cost: Int; let items: [ItemBuild] }

struct TFTComp: Identifiable, Hashable {
    let id: String
    let family: String
    let title: String
    let subtitle: String
    let sourceRanks: [String]
    let dataWindow: String
    let sourceKind: String
    let avgPlace: Double
    let playRate: Double
    let top4: Double
    let winRate: Double
    let units: [UnitBuild]
    let notes: [String]

    var coreUnits: [UnitBuild] {
        let equipped = units.filter { !$0.items.isEmpty }
        return equipped.isEmpty ? Array(units.prefix(3)) : equipped
    }

    var flexUnits: [UnitBuild] {
        let coreNames = Set(coreUnits.map { $0.name })
        return units.filter { !coreNames.contains($0.name) }
    }

    var tier: String {
        if avgPlace <= 4.05 { return "S" }
        if avgPlace <= 4.30 { return "A" }
        if avgPlace <= 4.50 { return "B" }
        return "C"
    }
}

enum TFTSort: String, CaseIterable, Identifiable {
    case avg = "Hạng TB"
    case win = "Tỷ lệ thắng"
    case top4 = "Top 4"
    case pick = "Tỷ lệ chọn"
    var id: String { rawValue }
}
enum TFTRank: String, CaseIterable, Identifiable {
    case all = "Tất cả"
    case platinum = "Platinum+"
    case diamond = "Diamond+"
    case master = "Master+"
    case gm = "GM+"
    var id: String { rawValue }
}

enum TFTData {
    static let patch = "18.1d"
    static let snapshot = "04/09/2026"
    static let sourceURL = URL(string: "https://tactics.tools/team-compositions/latest")!
    static func face(_ slug: String) -> String {
        let fixed = slug == "da_fiddlesticks18" ? "da_18_fiddlesticks" : slug
        return "https://ap.tft.tools/img/gg17/face/\(fixed).jpg?w=160"
    }
    static func item(_ slug: String) -> String { "https://ap.tft.tools/img/items_s14/\(slug).png?w=96" }
    static func it(_ name: String, _ slug: String) -> ItemBuild { ItemBuild(name: name, imageURL: item(slug)) }
    static func set18Cost(_ name: String, fallback: Int) -> Int {
        let c1: Set<String> = ["Akali","Camille","Mầm Non","Karma","Kobuko","Leona","Ornn","Sỏi","Rakan","Rek'Sai","Varus","Veigar","Xayah","Yorick"]
        let c2: Set<String> = ["Alistar","Caitlyn","Elise","Cóc Thành Tinh Gromp","Kayle","LeBlanc","Sói Hắc Ám","Cua Kỳ Cục","Sejuani","Shen","Teemo","Warwick","Yunara","Ashe"]
        let c3: Set<String> = ["Azir","Cassiopeia","Diana","Fiddlesticks","Hecarim","Kha'Zix","Kog'Maw","Quái Đá Krug","Master Yi","Rammus","Chim Mẹ","Mama Beak","Rengar","Tristana","Vi"]
        let c4: Set<String> = ["Ahri","Aphelios","Ezreal","Lillia","Malphite","Morgana","Sett","Sivir","Soraka","Zyra","Amumu","Bụi Gai Đỏ","Nidalee","Vệ Binh"]
        let c5: Set<String> = ["Alune","Draven","Rồng Ngàn Tuổi","Elder Dragon","Gnar","Ivern","Kennen","Maokai","Taric","Lux Thần Rừng","Lux Hoa Linh","Lux Mặt Trời","Lux Hỏa Ngục","Lux Nguyệt","Lux Tiên Linh","Lux Hắc Ám","Lux Nguyên Thủy"]
        if c1.contains(name) { return 1 }; if c2.contains(name) { return 2 }; if c3.contains(name) { return 3 }; if c4.contains(name) { return 4 }; if c5.contains(name) { return 5 }
        return fallback
    }
    static func u(_ name: String, _ slug: String, _ cost: Int, _ items: [ItemBuild] = []) -> UnitBuild { UnitBuild(name: name, imageURL: face(slug), cost: set18Cost(name, fallback: cost), items: items) }
    private static let compsChunk01: [TFTComp] = [
        TFTComp(
            id: "blossom_l_diamond_0",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 3.99,
            playRate: 0.42,
            top4: 58.9,
            winRate: 16.2,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "juggernaut_l_diamond_1",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.19,
            playRate: 0.07,
            top4: 58.0,
            winRate: 10.2,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "elderwood_l_diamond_2",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.31,
            playRate: 0.13,
            top4: 50.4,
            winRate: 23.3,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "riftbeast_l_diamond_3",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.4,
            playRate: 0.25,
            top4: 52.7,
            winRate: 9.67,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Găng Bảo Thạch","DA_JeweledGauntlet")]),
                u("Mầm Non","da_18_cinderling",1,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk02: [TFTComp] = [
        TFTComp(
            id: "fae_l_diamond_4",
            family: "fae",
            title: "Tiên Linh Tristana & Rammus",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.42,
            playRate: 0.16,
            top4: 51.0,
            winRate: 19.4,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Rammus","da_18_rammus",3,[it("Áo Choàng Tĩnh Lặng","DA_Evenshroud"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Trái Tim Kiên Định","DA_SteadfastHeart")]),
                u("Tristana","da_18_tristana",3,[it("Cung Xanh","DA_LastWhisper"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Vi","da_vi18",3,[]),
                u("Lillia","da_18_lillia",4,[]),
                u("Rengar","da_18_rengar",3,[]),
                u("Sett","da_18_sett",4,[]),
                u("Gnar","da_18_gnarsmall",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_l_platinum_5",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.19,
            playRate: 0.37,
            top4: 56.1,
            winRate: 14.6,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "sprykin_l_platinum_6",
            family: "sprykin",
            title: "Tinh Nghịch Veigar & Rek'Sai",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.24,
            playRate: 0.2,
            top4: 55.4,
            winRate: 12.0,
            units: [
                u("Kobuko","da_18_kobuko",1,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Rek'Sai","da_18_reksai",1,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Veigar","da_18_veigar",1,[it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Teemo","da_18_teemo",2,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon")]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Sivir","da_18_sivir",4,[]),
                u("Gnar","da_18_gnarsmall",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "elderwood_l_platinum_7",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.27,
            playRate: 0.21,
            top4: 51.0,
            winRate: 22.8,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk03: [TFTComp] = [
        TFTComp(
            id: "riftbeast_l_platinum_8",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.28,
            playRate: 0.3,
            top4: 54.4,
            winRate: 12.0,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Găng Bảo Thạch","DA_JeweledGauntlet")]),
                u("Mầm Non","da_18_cinderling",1,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "summoner_l_platinum_9",
            family: "summoner",
            title: "Triệu Hồi Malphite & Soraka",
            subtitle: "Fast Level 8",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.29,
            playRate: 0.8,
            top4: 54.9,
            winRate: 10.9,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Azir","da_18_azir",3,[]),
                u("Fiddlesticks","da_fiddlesticks18",3,[]),
                u("Malphite","da_18_malphite",4,[it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Soraka","da_18_soraka",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Amumu","da_amumu18",4,[it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Shen","da_18_shen",2,[]),
                u("Zyra","da_18_zyra",4,[it("Trượng Hư Vô","DA_VoidStaff")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_l_master_10",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 3.71,
            playRate: 0.37,
            top4: 63.2,
            winRate: 18.4,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "juggernaut_l_master_11",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 3.84,
            playRate: 0.06,
            top4: 73.3,
            winRate: 6.67,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk04: [TFTComp] = [
        TFTComp(
            id: "elderwood_l_master_12",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8+",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.22,
            playRate: 0.07,
            top4: 52.6,
            winRate: 28.9,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "solar_l_master_13",
            family: "solar",
            title: "Thái Dương Kayle & Xayah",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.28,
            playRate: 0.47,
            top4: 54.5,
            winRate: 19.4,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",2,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "riftbeast_l_master_14",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.32,
            playRate: 0.11,
            top4: 58.9,
            winRate: 3.57,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Găng Bảo Thạch","DA_JeweledGauntlet")]),
                u("Mầm Non","da_18_cinderling",1,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_l_gm_15",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 3.71,
            playRate: 0.37,
            top4: 63.2,
            winRate: 18.4,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk05: [TFTComp] = [
        TFTComp(
            id: "juggernaut_l_gm_16",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 3.84,
            playRate: 0.06,
            top4: 73.3,
            winRate: 6.67,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "elderwood_l_gm_17",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8+",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.22,
            playRate: 0.07,
            top4: 52.6,
            winRate: 28.9,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "solar_l_gm_18",
            family: "solar",
            title: "Thái Dương Kayle & Xayah",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.28,
            playRate: 0.47,
            top4: 54.5,
            winRate: 19.4,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",2,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "riftbeast_l_gm_19",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "main",
            avgPlace: 4.32,
            playRate: 0.11,
            top4: 58.9,
            winRate: 3.57,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Găng Bảo Thạch","DA_JeweledGauntlet")]),
                u("Mầm Non","da_18_cinderling",1,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk06: [TFTComp] = [
        TFTComp(
            id: "juggernaut_p_diamond_20",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.82,
            playRate: 0.06,
            top4: 67.0,
            winRate: 13.2,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_p_diamond_21",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.88,
            playRate: 0.39,
            top4: 59.7,
            winRate: 19.9,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "elderwood_p_diamond_22",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8+",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.27,
            playRate: 0.09,
            top4: 49.6,
            winRate: 25.9,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "defender_p_diamond_23",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Fiddlesticks",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.41,
            playRate: 0.24,
            top4: 52.5,
            winRate: 9.73,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",1,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk07: [TFTComp] = [
        TFTComp(
            id: "solar_p_diamond_24",
            family: "solar",
            title: "Thái Dương Kayle & Xayah",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.41,
            playRate: 0.5,
            top4: 53.2,
            winRate: 18.9,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",2,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "riftbeast_p_platinum_25",
            family: "riftbeast",
            title: "Quái Rừng Vệ Binh & Rồng Ngàn Tuổi",
            subtitle: "Fast Level 8",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.0,
            playRate: 0.09,
            top4: 58.8,
            winRate: 15.7,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Mầm Non","da_18_cinderling",1,[it("Bùa Xanh","DA_BlueBuff")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow"), it("Áo Choàng Lửa","DA_SunfireCape"), it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Taric","da_taric18",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_p_platinum_26",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.19,
            playRate: 0.37,
            top4: 56.1,
            winRate: 14.6,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "sprykin_p_platinum_27",
            family: "sprykin",
            title: "Tinh Nghịch Veigar & Rek'Sai",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.24,
            playRate: 0.2,
            top4: 55.5,
            winRate: 12.0,
            units: [
                u("Kobuko","da_18_kobuko",1,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Rek'Sai","da_18_reksai",1,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Veigar","da_18_veigar",1,[it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Teemo","da_18_teemo",2,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon")]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Sivir","da_18_sivir",4,[]),
                u("Gnar","da_18_gnarsmall",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk08: [TFTComp] = [
        TFTComp(
            id: "summoner_p_platinum_28",
            family: "summoner",
            title: "Triệu Hồi Malphite & Soraka",
            subtitle: "Fast Level 8",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.29,
            playRate: 0.8,
            top4: 54.9,
            winRate: 10.9,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Azir","da_18_azir",3,[]),
                u("Fiddlesticks","da_fiddlesticks18",3,[]),
                u("Malphite","da_18_malphite",4,[it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Soraka","da_18_soraka",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Amumu","da_amumu18",4,[it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Shen","da_18_shen",2,[]),
                u("Zyra","da_18_zyra",4,[it("Trượng Hư Vô","DA_VoidStaff")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "riftbeast_p_platinum_29",
            family: "riftbeast",
            title: "Quái Rừng Ahri & Morgana",
            subtitle: "Fast Level 8",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.3,
            playRate: 0.44,
            top4: 54.2,
            winRate: 11.1,
            units: [
                u("Sỏi","da_18_pebbles",1,[]),
                u("Karma","da_18_karma",1,[]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Ahri","da_18_ahri",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Trượng Hư Vô","DA_VoidStaff")]),
                u("Morgana","da_18_morgana",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Sett","da_18_sett",4,[it("Giáp Máu Warmog","DA_WarmogsArmor"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "blossom_p_master_30",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.74,
            playRate: 0.37,
            top4: 62.3,
            winRate: 19.4,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "juggernaut_p_master_31",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.84,
            playRate: 0.06,
            top4: 73.3,
            winRate: 6.67,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk09: [TFTComp] = [
        TFTComp(
            id: "elderwood_p_master_32",
            family: "elderwood",
            title: "Thần Rừng Ezreal",
            subtitle: "Fast Level 8",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.09,
            playRate: 0.11,
            top4: 52.9,
            winRate: 23.5,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Xayah","da_18_xayah",1,[]),
                u("Alistar","da_18_alistar",2,[]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Lux Thần Rừng","da_18_luxelderwood",5,[it("Ngọn Giáo Shojin","DA_SpearOfShojin")])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "defender_p_master_33",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Fiddlesticks",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.2,
            playRate: 0.19,
            top4: 60.2,
            winRate: 7.95,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",1,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "solar_p_master_34",
            family: "solar",
            title: "Thái Dương Kayle & Xayah",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.33,
            playRate: 0.47,
            top4: 53.7,
            winRate: 19.7,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",2,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "elderwood_p_gm_35",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.52,
            playRate: 0.09,
            top4: 65.0,
            winRate: 32.5,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",3,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk10: [TFTComp] = [
        TFTComp(
            id: "blossom_p_gm_36",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.6,
            playRate: 0.36,
            top4: 64.6,
            winRate: 21.3,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "juggernaut_p_gm_37",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 3.9,
            playRate: 0.07,
            top4: 66.7,
            winRate: 6.67,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Trái Tim Kiên Định","DA_SteadfastHeart"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Akali","da_18_akali",1,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "solar_p_gm_38",
            family: "solar",
            title: "Thái Dương Kayle & Xayah",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.29,
            playRate: 0.47,
            top4: 54.7,
            winRate: 20.1,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",2,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",2,[]),
                u("Hecarim","da_18_hecarim",3,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

        TFTComp(
            id: "defender_p_gm_39",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Fiddlesticks",
            subtitle: "Level 7 Reroll",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "main",
            avgPlace: 4.29,
            playRate: 0.18,
            top4: 59.3,
            winRate: 8.64,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",1,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        )
    ]

    private static let compsChunk11: [TFTComp] = [
        TFTComp(
            id: "blossom_p_gm_40",
            family: "blossom",
            title: "Hoa Linh Master Yi & Rengar",
            subtitle: "Level 7 Reroll · High Win %",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 2.97,
            playRate: 0.41,
            top4: 77.8,
            winRate: 38.9,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vi","da_vi18",3,[it("Mũ Thích Nghi","DA_AdaptiveHelm"), it("Trái Tim Kiên Định","DA_SteadfastHeart")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Azir","da_18_azir",3,[]),
                u("Quái Đá Krug","da_krug18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Rengar","da_18_rengar",3,[it("Móng Vuốt Sterak","DA_SteraksGage"), it("Quyền Năng Khổng Lồ","DA_TitansResolve"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "blossom_p_master_41",
            family: "blossom",
            title: "Hoa Linh Master Yi & Rengar",
            subtitle: "Level 7 Reroll · High Win %",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 3.28,
            playRate: 0.38,
            top4: 66.7,
            winRate: 25.6,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vi","da_vi18",3,[it("Mũ Thích Nghi","DA_AdaptiveHelm"), it("Trái Tim Kiên Định","DA_SteadfastHeart")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Azir","da_18_azir",3,[]),
                u("Quái Đá Krug","da_krug18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Rengar","da_18_rengar",3,[it("Móng Vuốt Sterak","DA_SteraksGage"), it("Quyền Năng Khổng Lồ","DA_TitansResolve"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "blossom_p_gm_42",
            family: "blossom",
            title: "Hoa Linh Master Yi & Rengar",
            subtitle: "Subcomp · High Win %",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 3.58,
            playRate: 0.25,
            top4: 65.0,
            winRate: 23.6,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vi","da_vi18",3,[it("Mũ Thích Nghi","DA_AdaptiveHelm"), it("Trái Tim Kiên Định","DA_SteadfastHeart")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Azir","da_18_azir",3,[]),
                u("Quái Đá Krug","da_krug18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Rengar","da_18_rengar",3,[it("Móng Vuốt Sterak","DA_SteraksGage"), it("Quyền Năng Khổng Lồ","DA_TitansResolve"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "blossom_p_gm_43",
            family: "blossom",
            title: "Hoa Linh Master Yi & Vi",
            subtitle: "Subcomp · Consistent",
            sourceRanks: ["GM+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 3.91,
            playRate: 0.12,
            top4: 58.3,
            winRate: 10.0,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Khăn Giải Thuật","DA_Quicksilver"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Vi","da_vi18",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Sett","da_18_sett",4,[it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Zyra","da_18_zyra",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        )
    ]

    private static let compsChunk12: [TFTComp] = [
        TFTComp(
            id: "sprykin_p_master_44",
            family: "sprykin",
            title: "Tinh Nghịch Tristana & Rammus",
            subtitle: "Level 7 Reroll · High Win %",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 2.68,
            playRate: 0.11,
            top4: 81.8,
            winRate: 18.2,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Rammus","da_18_rammus",3,[]),
                u("Tristana","da_18_tristana",3,[it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Vi","da_vi18",3,[]),
                u("Sivir","da_18_sivir",4,[]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kobuko","da_18_kobuko",1,[]),
                u("Teemo","da_18_teemo",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "defender_p_master_45",
            family: "defender",
            title: "Vệ Quân Fiddlesticks & Cassiopeia",
            subtitle: "Level 7 Reroll · Consistent",
            sourceRanks: ["Master+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 2.56,
            playRate: 0.06,
            top4: 90.0,
            winRate: 0.0,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_fiddlesticks18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",1,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "defender_l_gm_46",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Rammus",
            subtitle: "Level 7 Reroll · Consistent",
            sourceRanks: ["GM+"],
            dataWindow: "Last 2 Days",
            sourceKind: "subcomp",
            avgPlace: 2.25,
            playRate: 0.05,
            top4: 100.0,
            winRate: 0.0,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_fiddlesticks18",3,[]),
                u("Lillia","da_18_lillia",4,[]),
                u("Soraka","da_18_soraka",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_latest_defender",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Fiddlesticks",
            subtitle: "Level 7 Reroll · Consistent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 3.91,
            playRate: 0.09,
            top4: 61.5,
            winRate: 12.4,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Trượng Hư Vô","DA_VoidStaff")]),
                u("Rammus","da_18_rammus",3,[it("Găng Đạo Tặc","DA_ThiefsGloves"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Fiddlesticks","da_18_fiddlesticks",3,[it("Vuốt Rồng","DA_DragonsClaw"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét","DA_IonicSpark")]),
                u("Lillia","da_18_lillia",4,[]),
                u("Soraka","da_18_soraka",4,[it("Diệt Khổng Lồ","DA_GiantSlayer")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        )
    ]

    private static let compsChunk13: [TFTComp] = [
        TFTComp(
            id: "full_plat_latest_juggernaut",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Cua Kỳ Cục",
            subtitle: "Level 6 Reroll · Consistent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.03,
            playRate: 0.09,
            top4: 63.9,
            winRate: 6.5,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sejuani","da_18_sejuani",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Áo Choàng Tĩnh Lặng","DA_Evenshroud"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Áo Choàng Gai","DA_BrambleVest")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sivir","da_18_sivir",4,[it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Ashe","da_18_ashe",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_latest_blossom_kog",
            family: "blossom",
            title: "Hoa Linh Master Yi & Kog'Maw",
            subtitle: "Level 7 Reroll · Emblems Dependent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.19,
            playRate: 0.26,
            top4: 55.3,
            winRate: 13.2,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Đỏ","DA_RedBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Quái Đá Krug","da_krug18",3,[it("Găng Đạo Tặc","DA_ThiefsGloves"), it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sett","da_18_sett",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Cóc Thành Tinh Gromp","da_18_gromp",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_latest_elderdragon",
            family: "riftbeast",
            title: "Quái Rừng Rồng Ngàn Tuổi & Vệ Binh",
            subtitle: "Fast Level 8 · High Win %",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.23,
            playRate: 0.16,
            top4: 51.6,
            winRate: 19.9,
            units: [
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Quái Đá Krug","da_krug18",3,[it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[]),
                u("Vệ Binh","da_18_sentinel",4,[it("Áo Choàng Gai","DA_BrambleVest"), it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Cóc Thành Tinh Gromp","da_18_gromp",2,[it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Chim Mẹ","da_18_mamabeak",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Rồng Ngàn Tuổi","da_18_elderdragon",5,[it("Vô Cực Kiếm","DA_InfinityEdge")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_diamond_patch_fae",
            family: "fae",
            title: "Tiên Linh Tristana & Rengar",
            subtitle: "Level 7 Reroll · High Win %",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "lowplay",
            avgPlace: 4.38,
            playRate: 0.14,
            top4: 52.1,
            winRate: 19.7,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Rammus","da_18_rammus",3,[it("Áo Choàng Tĩnh Lặng","DA_Evenshroud"), it("Găng Đạo Tặc","DA_ThiefsGloves")]),
                u("Tristana","da_18_tristana",3,[it("Cung Xanh","DA_LastWhisper"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Vi","da_vi18",3,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Lillia","da_18_lillia",4,[]),
                u("Rengar","da_18_rengar",3,[it("Ấn Tiên Linh","DA_18_EmblemFae"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sett","da_18_sett",4,[]),
                u("Gnar","da_18_gnarsmall",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        )
    ]

    private static let compsChunk14: [TFTComp] = [
        TFTComp(
            id: "full_diamond_patch_rift",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "lowplay",
            avgPlace: 4.36,
            playRate: 0.27,
            top4: 53.8,
            winRate: 10.8,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Bùa Xanh","DA_BlueBuff"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Mầm Non","da_18_cinderling",1,[it("Cung Xanh","DA_LastWhisper"), it("Mũ Thích Nghi","DA_AdaptiveHelm"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler")]),
                u("Quái Đá Krug","da_krug18",3,[it("Nỏ Sét","DA_IonicSpark"), it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Cung Xanh","DA_LastWhisper")]),
                u("Vệ Binh","da_18_sentinel",4,[]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_patch_elderwood",
            family: "elderwood",
            title: "Thần Rừng Ezreal & Draven",
            subtitle: "Fast Level 8 · Items Dependent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "lowplay",
            avgPlace: 4.35,
            playRate: 0.15,
            top4: 50.1,
            winRate: 23.1,
            units: [
                u("Ezreal","da_18_ezreal",4,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Kiếm Tử Thần","DA_Deathblade")]),
                u("Amumu","da_amumu18",4,[]),
                u("Kennen","da_18_kennen",5,[it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Maokai","da_18_maokai",5,[it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Draven","da_draven18",5,[it("Ấn Đao Phủ","DA_18_EmblemExecutioner"), it("Thịnh Nộ Thủy Quái","DA_KrakensFury"), it("Kiếm Tử Thần","DA_Deathblade")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Ivern","da_18_ivern",5,[it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Taric","da_taric18",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_patch_rift",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll · Items Dependent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "lowplay",
            avgPlace: 4.37,
            playRate: 0.32,
            top4: 52.7,
            winRate: 10.3,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Bùa Xanh","DA_BlueBuff"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Mầm Non","da_18_cinderling",1,[it("Bùa Xanh","DA_BlueBuff"), it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Móng Vuốt Sterak","DA_SteraksGage")]),
                u("Vệ Binh","da_18_sentinel",4,[]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_plat_patch_elderdragon",
            family: "riftbeast",
            title: "Quái Rừng Rồng Ngàn Tuổi & Vệ Binh",
            subtitle: "Fast Level 8 · High Win %",
            sourceRanks: ["Platinum+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "lowplay",
            avgPlace: 3.85,
            playRate: 0.06,
            top4: 61.7,
            winRate: 18.1,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Móng Vuốt Sterak","DA_SteraksGage")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow"), it("Áo Choàng Tĩnh Lặng","DA_Evenshroud"), it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Chim Mẹ","da_18_mamabeak",3,[]),
                u("Taric","da_taric18",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        )
    ]

    private static let compsChunk15: [TFTComp] = [
        TFTComp(
            id: "full_master_latest_defender",
            family: "defender",
            title: "Vệ Quân Cassiopeia & Fiddlesticks",
            subtitle: "Level 7 Reroll · Consistent",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.25,
            playRate: 0.2,
            top4: 57.6,
            winRate: 14.4,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[]),
                u("Shen","da_18_shen",2,[]),
                u("Cassiopeia","da_18_cassiopeia",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Rammus","da_18_rammus",3,[it("Nỏ Sét","DA_IonicSpark"), it("Vuốt Rồng","DA_DragonsClaw")]),
                u("Fiddlesticks","da_18_fiddlesticks",3,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Mũ Thích Nghi","DA_AdaptiveHelm"), it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Akali","da_18_akali",1,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_master_latest_rift",
            family: "riftbeast",
            title: "Quái Rừng Sỏi & Mầm Non",
            subtitle: "Level 5 Reroll · Consistent",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.34,
            playRate: 0.11,
            top4: 55.6,
            winRate: 2.78,
            units: [
                u("Sỏi","da_18_pebbles",1,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Bùa Xanh","DA_BlueBuff"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Mầm Non","da_18_cinderling",1,[it("Bùa Xanh","DA_BlueBuff"), it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Giáp Máu Warmog","DA_WarmogsArmor"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Amumu","da_amumu18",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_master_latest_solarakali",
            family: "solar",
            title: "Mặt Trời Akali & Camille",
            subtitle: "Level 5 Reroll · Consistent",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.38,
            playRate: 0.07,
            top4: 60.9,
            winRate: 8.7,
            units: [
                u("Akali","da_18_akali",1,[it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Bàn Tay Công Lý","DA_HandOfJustice"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Camille","da_18_camille",1,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Áo Choàng Thủy Ngân","DA_Quicksilver"), it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Leona","da_18_leona",1,[]),
                u("Varus","da_18_varus",1,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Cung Xanh","DA_LastWhisper")]),
                u("Kayle","da_18_kayle",2,[]),
                u("Sejuani","da_18_sejuani",2,[]),
                u("Shen","da_18_shen",2,[]),
                u("Kennen","da_18_kennen",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        ),

        TFTComp(
            id: "full_diamond_latest_solar",
            family: "solar",
            title: "Mặt Trời Kayle & Xayah",
            subtitle: "Level 5 Reroll · High Win %",
            sourceRanks: ["Diamond+"],
            dataWindow: "Last 2 Days",
            sourceKind: "lowplay",
            avgPlace: 4.4,
            playRate: 0.49,
            top4: 53.0,
            winRate: 18.9,
            units: [
                u("Leona","da_18_leona",1,[]),
                u("Ornn","da_18_ornn",1,[it("Áo Choàng Lửa","DA_SunfireCape"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[]),
                u("Xayah","da_18_xayah",1,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Thịnh Nộ Thủy Quái","DA_KrakensFury")]),
                u("Kayle","da_18_kayle",2,[it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Sejuani","da_18_sejuani",2,[it("Móng Vuốt Sterak","DA_SteraksGage")]),
                u("Elise","da_18_elise",2,[]),
                u("LeBlanc","da_18_leblanc",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Bổ sung từ mục Show low play rate compositions / các bản ghi công khai của Team Compositions."]
        )
    ]

    private static let compsChunk16: [TFTComp] = [
        TFTComp(
            id: "variant_diamond_patch_jug_sivir",
            family: "juggernaut",
            title: "Dũng Sĩ Caitlyn & Sivir",
            subtitle: "Level 6 Reroll · Consistent",
            sourceRanks: ["Diamond+"],
            dataWindow: "Patch 18.1d",
            sourceKind: "subcomp",
            avgPlace: 4.11,
            playRate: 0.06,
            top4: 61.7,
            winRate: 9.74,
            units: [
                u("Rakan","da_18_rakan",1,[]),
                u("Caitlyn","da_18_caitlyn",2,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Thịnh Nộ Thủy Quái","DA_KrakensFury"), it("Kiếm Súng Hextech","DA_HextechGunblade")]),
                u("Sejuani","da_18_sejuani",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Áo Choàng Gai","DA_BrambleVest"), it("Áo Choàng Tĩnh Lặng","DA_Evenshroud")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Tĩnh Lặng","DA_Evenshroud")]),
                u("Sivir","da_18_sivir",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Tristana","da_18_tristana",3,[]),
                u("Vệ Binh","da_18_sentinel",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Biến thể/subcomp công khai của Dũng Sĩ trong snapshot hiện tại."]
        ),

        TFTComp(
            id: "variant_plat_latest_blossom_kog",
            family: "blossom",
            title: "Hoa Linh Master Yi & Kog'Maw",
            subtitle: "Level 7 Reroll · Emblems Dependent",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "subcomp",
            avgPlace: 4.19,
            playRate: 0.26,
            top4: 55.3,
            winRate: 13.2,
            units: [
                u("Yorick","da_18_yorick",1,[]),
                u("Master Yi","da_18_masteryi_ad",3,[it("Ấn Đấu Sĩ","DA_18_EmblemBrawler"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Quyền Năng Khổng Lồ","DA_TitansResolve")]),
                u("Kog'Maw","da_kogmaw18_ad",3,[it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Đỏ","DA_RedBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Quái Đá Krug","da_krug18",3,[it("Găng Đạo Tặc","DA_ThiefsGloves"), it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Vi","da_vi18",3,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Sett","da_18_sett",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Nidalee","da_nidalee18_ap",4,[]),
                u("Cóc Thành Tinh Gromp","da_18_gromp",2,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Biến thể cùng family được đưa vào màn Variants riêng."]
        ),

        TFTComp(
            id: "variant_plat_latest_elderdragon",
            family: "riftbeast",
            title: "Quái Rừng Rồng Ngàn Tuổi & Vệ Binh",
            subtitle: "Fast Level 8 · High Win %",
            sourceRanks: ["Platinum+"],
            dataWindow: "Last 2 Days",
            sourceKind: "subcomp",
            avgPlace: 4.23,
            playRate: 0.16,
            top4: 51.6,
            winRate: 19.9,
            units: [
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Mũ Thích Nghi","DA_AdaptiveHelm")]),
                u("Quái Đá Krug","da_krug18",3,[it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Bụi Gai Đỏ","da_18_brambleback",4,[]),
                u("Vệ Binh","da_18_sentinel",4,[it("Áo Choàng Gai","DA_BrambleVest"), it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Cóc Thành Tinh Gromp","da_18_gromp",2,[it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Chim Mẹ","da_18_mamabeak",3,[it("Bùa Đỏ","DA_RedBuff")]),
                u("Rồng Ngàn Tuổi","da_18_elderdragon",5,[it("Vô Cực Kiếm","DA_InfinityEdge")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Biến thể cùng family được đưa vào màn Variants riêng."]
        ),

        TFTComp(
            id: "variant_master_latest_solarakali",
            family: "solar",
            title: "Mặt Trời Akali & Camille",
            subtitle: "Level 5 Reroll · Consistent",
            sourceRanks: ["Master+"],
            dataWindow: "Last 2 Days",
            sourceKind: "subcomp",
            avgPlace: 4.38,
            playRate: 0.07,
            top4: 60.9,
            winRate: 8.7,
            units: [
                u("Akali","da_18_akali",1,[it("Áo Choàng Bóng Tối","DA_EdgeOfNight"), it("Bàn Tay Công Lý","DA_HandOfJustice"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Camille","da_18_camille",1,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Áo Choàng Thủy Ngân","DA_Quicksilver"), it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Leona","da_18_leona",1,[]),
                u("Varus","da_18_varus",1,[it("Vô Cực Kiếm","DA_InfinityEdge"), it("Cung Xanh","DA_LastWhisper")]),
                u("Kayle","da_18_kayle",2,[]),
                u("Sejuani","da_18_sejuani",2,[]),
                u("Shen","da_18_shen",2,[]),
                u("Kennen","da_18_kennen",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Biến thể cùng family được đưa vào màn Variants riêng."]
        )
    ]

    static var comps: [TFTComp] {
        var values: [TFTComp] = []
        values.append(contentsOf: compsChunk01)
        values.append(contentsOf: compsChunk02)
        values.append(contentsOf: compsChunk03)
        values.append(contentsOf: compsChunk04)
        values.append(contentsOf: compsChunk05)
        values.append(contentsOf: compsChunk06)
        values.append(contentsOf: compsChunk07)
        values.append(contentsOf: compsChunk08)
        values.append(contentsOf: compsChunk09)
        values.append(contentsOf: compsChunk10)
        values.append(contentsOf: compsChunk11)
        values.append(contentsOf: compsChunk12)
        values.append(contentsOf: compsChunk13)
        values.append(contentsOf: compsChunk14)
        values.append(contentsOf: compsChunk15)
        values.append(contentsOf: compsChunk16)
        return values
    }
}

enum TFTTheme {
    static let background = Color(red: 0.043, green: 0.047, blue: 0.058)
    static let surface = Color(red: 0.082, green: 0.088, blue: 0.104)
    static let surfaceRaised = Color(red: 0.108, green: 0.115, blue: 0.133)
    static let surfaceSoft = Color(red: 0.126, green: 0.132, blue: 0.150)
    static let border = Color.white.opacity(0.08)
    static let text2 = Color.white.opacity(0.62)
    static let text3 = Color.white.opacity(0.40)
    static let gold = Color(red: 0.88, green: 0.66, blue: 0.25)
    static let goldSoft = Color(red: 0.96, green: 0.79, blue: 0.43)
    static let goldButton = Color(red: 0.31, green: 0.22, blue: 0.07)
    static let goldButtonPressed = Color(red: 0.39, green: 0.28, blue: 0.09)
    static let goldBorder = Color(red: 0.58, green: 0.42, blue: 0.13)
    static let green = Color(red: 0.62, green: 0.96, blue: 0.36)
    static let cyan = Color(red: 0.42, green: 0.76, blue: 0.95)

    static func tierColor(_ tier: String) -> Color {
        switch tier {
        case "S": return Color(red: 1.0, green: 0.43, blue: 0.48)
        case "A": return goldSoft
        case "B": return Color(red: 0.44, green: 0.81, blue: 0.50)
        default: return Color(red: 0.39, green: 0.64, blue: 0.94)
        }
    }

    static func costColor(_ cost: Int) -> Color {
        switch cost {
        case 1: return .gray
        case 2: return Color(red: 0.22, green: 0.72, blue: 0.38)
        case 3: return Color(red: 0.28, green: 0.52, blue: 0.96)
        case 4: return Color(red: 0.75, green: 0.28, blue: 0.90)
        default: return Color(red: 0.96, green: 0.76, blue: 0.20)
        }
    }
}
