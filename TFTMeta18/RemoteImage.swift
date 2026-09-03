import SwiftUI
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let cache = NSCache<NSString, UIImage>()
    private var task: URLSessionDataTask?

    func load(_ urlString: String) {
        if let cached = Self.cache.object(forKey: urlString as NSString) {
            image = cached
            return
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let loaded = UIImage(data: data) else { return }
            Self.cache.setObject(loaded, forKey: urlString as NSString)
            DispatchQueue.main.async { self.image = loaded }
        }
        task?.resume()
    }

    deinit { task?.cancel() }
}

struct RemoteImage: View {
    let url: String
    let cornerRadius: CGFloat
    @StateObject private var loader = ImageLoader()

    init(url: String, cornerRadius: CGFloat = 8) {
        self.url = url
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    TFTTheme.panel2
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: TFTTheme.text2))
                        .scaleEffect(0.7)
                }
            }
        }
        .clipped()
        .cornerRadius(cornerRadius)
        .onAppear { loader.load(url) }
    }
}
