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
    static func face(_ slug: String) -> String { "https://ap.tft.tools/img/gg17/face/\(slug).jpg?w=160" }
    static func item(_ slug: String) -> String { "https://ap.tft.tools/img/items_s14/\(slug).png?w=96" }
    static func it(_ name: String, _ slug: String) -> ItemBuild { ItemBuild(name: name, imageURL: item(slug)) }
    static func u(_ name: String, _ slug: String, _ cost: Int, _ items: [ItemBuild] = []) -> UnitBuild { UnitBuild(name: name, imageURL: face(slug), cost: cost, items: items) }
    static let comps: [TFTComp] = [

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
                u("Akali","da_18_akali",4,[]),
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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Mầm Non","da_18_cinderling",2,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",3,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Kobuko","da_18_kobuko",2,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Rek'Sai","da_18_reksai",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Veigar","da_18_veigar",3,[it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Teemo","da_18_teemo",2,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon")]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Mầm Non","da_18_cinderling",2,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",3,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
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
                u("Azir","da_18_azir",4,[]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[]),
                u("Malphite","da_18_malphite",4,[it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Soraka","da_18_soraka",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Amumu","da_amumu18",4,[it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Shen","da_18_shen",4,[]),
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
                u("Akali","da_18_akali",4,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[])
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
                u("Mầm Non","da_18_cinderling",2,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",3,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
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
        ),

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
                u("Akali","da_18_akali",4,[]),
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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[])
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
                u("Mầm Non","da_18_cinderling",2,[it("Cung Xanh","DA_LastWhisper"), it("Bùa Xanh","DA_BlueBuff"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Bụi Gai Đỏ","da_18_brambleback",3,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Rakan","da_18_rakan",1,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Akali","da_18_akali",4,[]),
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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Shen","da_18_shen",4,[]),
                u("Cassiopeia","da_18_cassiopeia",4,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",4,[]),
                u("LeBlanc","da_18_leblanc",4,[])
            ],
            notes: ["Nguồn: tactics.tools · Diamond+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[])
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
                u("Mầm Non","da_18_cinderling",2,[it("Bùa Xanh","DA_BlueBuff")]),
                u("Sói Hắc Ám","da_18_murkwolf",2,[it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Cua Kỳ Cục","da_scuttlecrab18",2,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Quái Đá Krug","da_krug18",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Bụi Gai Đỏ","da_18_brambleback",3,[it("Diệt Khổng Lồ","DA_GiantSlayer"), it("Áo Choàng Bóng Tối","DA_EdgeOfNight")]),
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
                u("Kobuko","da_18_kobuko",2,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Rek'Sai","da_18_reksai",3,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage"), it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Veigar","da_18_veigar",3,[it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Bùa Xanh","DA_BlueBuff")]),
                u("Teemo","da_18_teemo",2,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon")]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Sivir","da_18_sivir",4,[]),
                u("Gnar","da_18_gnarsmall",5,[])
            ],
            notes: ["Nguồn: tactics.tools · Platinum+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Azir","da_18_azir",4,[]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[]),
                u("Malphite","da_18_malphite",4,[it("Vương Miện Hoàng Gia","DA_Crownguard"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Giáp Tâm Linh","DA_SpiritVisage")]),
                u("Soraka","da_18_soraka",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Ngọn Giáo Shojin","DA_SpearOfShojin"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff")]),
                u("Amumu","da_amumu18",4,[it("Giáp Máu Warmog","DA_WarmogsArmor")]),
                u("Shen","da_18_shen",4,[]),
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
                u("Karma","da_18_karma",3,[]),
                u("Quái Đá Krug","da_krug18",3,[]),
                u("Ahri","da_18_ahri",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Trượng Hư Vô","DA_VoidStaff")]),
                u("Morgana","da_18_morgana",4,[it("Trượng Hư Vô","DA_VoidStaff"), it("Quỷ Thư Morello","DA_Morellonomicon"), it("Bùa Đỏ","DA_RedBuff")]),
                u("Vệ Binh","da_18_sentinel",4,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Akali","da_18_akali",4,[]),
                u("Sejuani","da_18_sejuani",2,[it("Lời Thề Hộ Vệ","DA_ProtectorsVow")]),
                u("Tristana","da_18_tristana",3,[])
            ],
            notes: ["Nguồn: tactics.tools · Master+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Ezreal","da_18_ezreal",2,[it("Kiếm Tử Thần","DA_Deathblade"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Diệt Khổng Lồ","DA_GiantSlayer")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Xayah","da_18_xayah",4,[]),
                u("Alistar","da_18_alistar",2,[]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Shen","da_18_shen",4,[]),
                u("Cassiopeia","da_18_cassiopeia",4,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",4,[]),
                u("LeBlanc","da_18_leblanc",4,[])
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[])
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
                u("Ezreal","da_18_ezreal",2,[it("Cung Xanh","DA_LastWhisper"), it("Vô Cực Kiếm","DA_InfinityEdge"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Alistar","da_18_alistar",2,[]),
                u("Hecarim","da_18_hecarim",4,[]),
                u("Amumu","da_amumu18",4,[]),
                u("Draven","da_draven18",5,[it("Cơn Thịnh Nộ Kraken","DA_KrakensFury"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Vô Cực Kiếm","DA_InfinityEdge")]),
                u("Gnar","da_18_gnarsmall",5,[]),
                u("Kennen","da_18_kennen",5,[it("Trượng Hư Vô","DA_VoidStaff"), it("Nanh Nashor","DA_NashorsTooth")]),
                u("Taric","da_taric18",5,[it("Áo Choàng Lửa","DA_SunfireCape")])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Akali","da_18_akali",4,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate")]),
                u("Rakan","da_18_rakan",1,[it("Áo Choàng Lửa","DA_SunfireCape")]),
                u("Xayah","da_18_xayah",4,[it("Bùa Đỏ","DA_RedBuff"), it("Cung Xanh","DA_LastWhisper"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade")]),
                u("Kayle","da_18_kayle",4,[it("Găng Bảo Thạch","DA_JeweledGauntlet"), it("Cuồng Đao Guinsoo","DA_GuinsoosRageblade"), it("Mũ Phù Thủy Rabadon","DA_RabadonsDeathcap")]),
                u("Sejuani","da_18_sejuani",2,[it("Vuốt Rồng","DA_DragonsClaw")]),
                u("LeBlanc","da_18_leblanc",4,[]),
                u("Hecarim","da_18_hecarim",4,[])
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Shen","da_18_shen",4,[]),
                u("Cassiopeia","da_18_cassiopeia",4,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",4,[]),
                u("LeBlanc","da_18_leblanc",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Patch 18.1d.", "Snapshot tĩnh để app mở ngay, không cần server."]
        ),

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
                u("Azir","da_18_azir",4,[]),
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
                u("Azir","da_18_azir",4,[]),
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
                u("Azir","da_18_azir",4,[]),
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
        ),

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
                u("Kobuko","da_18_kobuko",2,[]),
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Shen","da_18_shen",4,[]),
                u("Cassiopeia","da_18_cassiopeia",4,[it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Kiếm Súng Hextech","DA_HextechGunblade"), it("Ngọn Giáo Shojin","DA_SpearOfShojin")]),
                u("Rammus","da_18_rammus",3,[it("Giáp Tâm Linh","DA_SpiritVisage"), it("Nỏ Sét Ionic","DA_IonicSpark")]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[it("Thú Tượng Thạch Giáp","DA_GargoyleStoneplate"), it("Quyền Trượng Thiên Thần","DA_ArchangelsStaff"), it("Vương Miện Hoàng Gia","DA_Crownguard")]),
                u("Akali","da_18_akali",4,[]),
                u("LeBlanc","da_18_leblanc",4,[])
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
                u("Leona","da_18_leona",2,[]),
                u("Ornn","da_18_ornn",5,[]),
                u("Shen","da_18_shen",4,[]),
                u("Cassiopeia","da_18_cassiopeia",4,[]),
                u("Rammus","da_18_rammus",3,[]),
                u("Fiddlesticks","da_18_fiddlesticks",4,[]),
                u("Lillia","da_18_lillia",4,[]),
                u("Soraka","da_18_soraka",4,[])
            ],
            notes: ["Nguồn: tactics.tools · GM+ · Last 2 Days.", "Snapshot tĩnh để app mở ngay, không cần server.", "Đây là biến thể/subcomp được ghi nhận từ trang Team Compositions."]
        ),

    ]
}

enum TFTTheme {
    static let background = Color(red: 0.052, green: 0.057, blue: 0.071)
    static let panel = Color(red: 0.100, green: 0.108, blue: 0.126)
    static let panel2 = Color(red: 0.132, green: 0.140, blue: 0.160)
    static let green = Color(red: 0.62, green: 0.96, blue: 0.36)
    static let cyan = Color(red: 0.29, green: 0.78, blue: 0.96)
    static let text2 = Color.white.opacity(0.60)
    static let goldSoft = Color(red: 0.95, green: 0.78, blue: 0.43)
    static let goldButton = Color(red: 0.47, green: 0.33, blue: 0.09)
    static let goldBorder = Color(red: 0.68, green: 0.50, blue: 0.17)
    static func tierColor(_ tier: String) -> Color {
        switch tier {
        case "S": return Color(red: 1.0, green: 0.43, blue: 0.48)
        case "A": return goldSoft
        case "B": return Color(red: 0.44, green: 0.81, blue: 0.50)
        default: return Color(red: 0.39, green: 0.64, blue: 0.94)
        }
    }
}
