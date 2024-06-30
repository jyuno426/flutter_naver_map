import Flutter
import NMapsMap

internal struct NOverlayImage {
    let path: String
    let data: [UInt8]
    let mode: NOverlayImageMode

    var overlayImage: NMFOverlayImage {
        switch mode {
        case .file, .temp, .widget: return makeOverlayImageWithPath()
        case .asset: return makeOverlayImageWithAssetPath()
        case .data: return makeOverlayImageWithData()
        }
    }

    private func makeOverlayImageWithPath() -> NMFOverlayImage {
        let image = UIImage(contentsOfFile: path)
        let scaledImage = UIImage(data: image!.pngData()!, scale: UIScreen.main.scale)
        let overlayImg = NMFOverlayImage(image: scaledImage!)
        return overlayImg
    }

    private func makeOverlayImageWithAssetPath() -> NMFOverlayImage {
        let key = SwiftFlutterNaverMapPlugin.getAssets(path: path)
        let assetPath = Bundle.main.path(forResource: key, ofType: nil) ?? ""
        let image = UIImage(contentsOfFile: assetPath)
        let scaledImage = UIImage(data: image!.pngData()!, scale: UIScreen.main.scale)
        let overlayImg = NMFOverlayImage(image: scaledImage!, reuseIdentifier: assetPath)
        return overlayImg
    }

    private func makeOverlayImageWithData() -> NMFOverlayImage {
        let image = UIImage(data: Data(data))
        let scaledImage = UIImage(data: image!.pngData()!, scale: UIScreen.main.scale)
        let overlayImg = NMFOverlayImage(image: scaledImage!)
        return overlayImg
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "path": path,
            "data": data,
            "mode": mode.rawValue
        ]
    }

    static func fromMessageable(_ v: Any) -> NOverlayImage {
        let d = asDict(v)
        return NOverlayImage(
                path: asString(d["path"]!),
                data: asUint8Arr(d["data"]!),
                mode: NOverlayImageMode(rawValue: asString(d["mode"]!))!
        )
    }

    static let none = NOverlayImage(path: "", data: [UInt8](), mode: .temp)
}
