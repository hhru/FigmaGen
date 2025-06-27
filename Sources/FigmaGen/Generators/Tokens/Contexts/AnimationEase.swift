import Foundation

struct AnimationEase {

    struct Base {
        let path: [String]
        let x1: String
        let y1: String
        let x2: String
        let y2: String
    }

    struct Spring {
        let path: [String]
        let stiffness: String
        let damping: String
        let mass: String
    }

    let base: Base?
    let spring: Spring?
}
