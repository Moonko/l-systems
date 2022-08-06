import UIKit

final class CoreAnimationRenderer: UIView, TurtleGraphicsRenderer {
    private var currentLayer: CAShapeLayer!
    private var currentPath: UIBezierPath!

    func drawHistory(_ history: [Turtle.State], duration: CGFloat) {
        var lastPoint: CGPoint?
        history.forEach { state in
            if state.thickness != currentLayer?.lineWidth {
                if let currentPath = currentPath {
                    currentLayer?.path = currentPath.cgPath
                }

                currentLayer = CAShapeLayer()
                currentLayer.drawsAsynchronously = true
                currentLayer.strokeColor = UIColor.label.cgColor
                currentLayer.lineWidth = state.thickness
                currentLayer.lineCap = .round
                currentLayer.lineJoin = .round
                currentLayer.backgroundColor = UIColor.clear.cgColor
                currentLayer.fillColor = UIColor.clear.cgColor
                currentLayer.frame = bounds
                currentLayer.masksToBounds = true
                layer.addSublayer(currentLayer)

                currentPath = UIBezierPath()
                currentPath.move(to: state.position)
            }
            if state.position != lastPoint {
                if state.penDown {
                    currentPath.addLine(to: state.position)
                } else {
                    currentPath.move(to: state.position)
                }
                lastPoint = state.position
            }
        }
        currentLayer?.path = currentPath.cgPath
    }
}
