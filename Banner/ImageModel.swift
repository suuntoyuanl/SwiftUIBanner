import Foundation

struct imageModel: Identifiable {
    var id = UUID()
        var image: String
        var imageName: String
}

#if DEBUG
let imageModels = [
        imageModel(image: "banner001", imageName: "图片01"),
        imageModel(image: "banner002", imageName: "图片02"),
        imageModel(image: "banner003", imageName: "图片03"),
        imageModel(image: "banner004", imageName: "图片04"),
        imageModel(image: "banner005", imageName: "图片05"),
        imageModel(image: "banner006", imageName: "图片06"),
]
#endif
