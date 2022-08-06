import UIKit

protocol TurtleGraphicsRenderer: UIView {
    func drawHistory(_ history: [Turtle.State], duration: CGFloat)
}
