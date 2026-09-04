import SwiftUI
import Foundation
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var failed = false
    private static let cache = NSCache<NSString, UIImage>()
    private var task: URLSessionDataTask?

    func load(_ urls: [String]) {
        task?.cancel()
        image = nil
        failed = false
        tryURL(urls, index: 0)
    }

    private func tryURL(_ urls: [String], index: Int) {
        guard index < urls.count else {
            DispatchQueue.main.async { self.failed = true }
            return
        }
        let key = urls[index] as NSString
        if let cached = Self.cache.object(forKey: key) {
            DispatchQueue.main.async { self.image = cached }
            return
        }
        guard let url = URL(string: urls[index]) else {
            tryURL(urls, index: index + 1)
            return
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 12
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, _ in
            guard let self = self else { return }
            if let http = response as? HTTPURLResponse,
               (200...299).contains(http.statusCode),
               let data = data,
               let loaded = UIImage(data: data) {
                Self.cache.setObject(loaded, forKey: key)
                DispatchQueue.main.async { self.image = loaded }
            } else {
                self.tryURL(urls, index: index + 1)
            }
        }
        task?.resume()
    }

    deinit { task?.cancel() }
}

struct RemoteImage: View {
    let url: String
    let cornerRadius: CGFloat
    let fallbackText: String
    @StateObject private var loader = ImageLoader()

    init(url: String, cornerRadius: CGFloat = 8, fallbackText: String = "") {
        self.url = url
        self.cornerRadius = cornerRadius
        self.fallbackText = fallbackText
    }

    private var candidates: [String] {
        var values = [url]
        if url.contains("da_18_fiddlesticks") {
            values.append(url.replacingOccurrences(of: "da_18_fiddlesticks", with: "da_fiddlesticks18"))
        }
        if url.contains("da_fiddlesticks18") {
            values.append(url.replacingOccurrences(of: "da_fiddlesticks18", with: "fiddlesticks18"))
        }
        var seen = Set<String>()
        return values.filter { seen.insert($0).inserted }
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image).resizable().scaledToFill()
            } else if loader.failed {
                ZStack {
                    LinearGradient(colors: [TFTTheme.panel2, TFTTheme.panel], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Text(fallbackText.isEmpty ? "?" : String(fallbackText.prefix(2)).uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.72))
                }
            } else {
                ZStack {
                    TFTTheme.panel2
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: TFTTheme.text2)).scaleEffect(0.65)
                }
            }
        }
        .clipped()
        .cornerRadius(cornerRadius)
        .onAppear { loader.load(candidates) }
        .onChange(of: url) { _ in loader.load(candidates) }
    }
}
