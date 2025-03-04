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
        id: 3,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Jitter%20Exported%20Poster.mp4")!,
        defaultPos: VideoFrame.Position(x: 8, y: 0, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/3d36d1e0dba2476c/3_Corner_update.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/3d36d1e0dba2476c/3_hori_update.png",
        edgeVertical: "https://static.cdn-luma.com/files/3d36d1e0dba2476c/3_Vert_update.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 4,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Exported%20Web%20Video.mp4")!,
        defaultPos: VideoFrame.Position(x: 0, y: 4, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/9e67e05f37e52522/4_corner_update.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/9e67e05f37e52522/4_hori_update.png",
        edgeVertical: "https://static.cdn-luma.com/files/9e67e05f37e52522/4_vert_update.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 5,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Logo%20Exported.mp4")!,
        defaultPos: VideoFrame.Position(x: 4, y: 4, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/9e67e05f37e52522/5_corner_update.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/9e67e05f37e52522/5_hori_update.png",
        edgeVertical: "https://static.cdn-luma.com/files/9e67e05f37e52522/5_verti_update.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 6,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Animation%20Exported%20(4).mp4")!,
        defaultPos: VideoFrame.Position(x: 8, y: 4, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/1199340587e8da1d/6_corner.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/1199340587e8da1d/6_corner-1.png",
        edgeVertical: "https://static.cdn-luma.com/files/1199340587e8da1d/6_vert.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 7,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Illustration%20Exported%20(1).mp4")!,
        defaultPos: VideoFrame.Position(x: 0, y: 8, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/b80b5aa00ccc33bd/7_corner.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/b80b5aa00ccc33bd/7_hori.png",
        edgeVertical: "https://static.cdn-luma.com/files/b80b5aa00ccc33bd/7_vert.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
    VideoFrame(
        id: 8,
        video: URL(string: "https://static.cdn-luma.com/files/58ab7363888153e3/Art%20Direction%20Exported.mp4")!,
        defaultPos: VideoFrame.Position(x: 4, y: 8, w: 4, h: 4),
        corner: "https://static.cdn-luma.com/files/981e483f71aa764b/8_corner.png",
        edgeHorizontal: "https://static.cdn-luma.com/files/981e483f71aa764b/8_hori.png",
        edgeVertical: "https://static.cdn-luma.com/files/981e483f71aa764b/8_verticle.png",
        mediaSize: 1,
        borderThickness: 0,
        borderSize: 80
    ),
 

]
