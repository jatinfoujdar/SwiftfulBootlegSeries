import SwiftUI

enum AutoplayMode {
    case all
    case hover
}

struct VideoFrame: Identifiable {
    let id: Int
    let video: URL
    var defaultPos: Position
    let corner: String
    let edgeHorizontal: String
    let edgeVertical: String
    var mediaSize: CGFloat
    var borderThickness: CGFloat
    var borderSize: CGFloat
    
    struct Position {
        let x: Int
        let y: Int
        let w: Int
        let h: Int
    }
}

// Initial frames data
let initialFrames: [VideoFrame] = [
    VideoFrame(
        id: 1,
        video: URL(string: "https://static.cdn-luma.com/files/981e483f71aa764b/Company%20Thing%20Exported.mp4")!,
        defaultPos: VideoFrame.Position(x: 0, y: 0, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/bcf576df9c38b05f/1_corner_update.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/bcf576df9c38b05f/1_vert_update.png",
        edgeVertical: "https://static.cdn-luma.com/files/bcf576df9c38b05f/1_hori_update.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 2,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/WebGL%20Exported%20(1).mp4")!,
        defaultPos: VideoFrame.Position(x: 4, y: 0, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/bcf576df9c38b05f/2_corner_update.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/bcf576df9c38b05f/2_vert_update.png",
        edgeVertical: "https://static.cdn-luma.com/files/bcf576df9c38b05f/2_hori_update.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    // Add remaining frames here...
] 