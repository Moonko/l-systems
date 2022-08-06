import UIKit

private struct LineSegment: Equatable {
    let point: CGPoint
    let lineWidth: CGFloat
}

final class CoreGraphicsRenderer: UIView, TurtleGraphicsRenderer {
    var displayLink: CADisplayLink?

    private var duration: CGFloat = 0
    private var segments = [LineSegment]()

    private var currentDuration: CGFloat = 0
    private var animatedSegments = [LineSegment]()
    private var lastDrawnIndex: Int = 0
    private var startTime: TimeInterval!

    func drawHistory(_ history: [Turtle.State], duration: CGFloat) {
        self.duration = duration

        var lastSegment: LineSegment?
        history.forEach { state in
            let newSegment = LineSegment(point: state.position, lineWidth: state.thickness)
            if newSegment != lastSegment {
                segments.append(newSegment)
                lastSegment = newSegment
            }
        }

        displayLink = CADisplayLink(target: self, selector: #selector(updateDrawings))
        displayLink?.add(to: .current, forMode: .common)
        startTime = CACurrentMediaTime()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(UIColor.label.cgColor)

        var lineWidth: CGFloat?

        animatedSegments.forEach { segment in
            if segment.lineWidth != lineWidth {
                if !context.isPathEmpty {
                    context.strokePath()
                }
                context.setLineWidth(segment.lineWidth)
                lineWidth = segment.lineWidth
                context.move(to: segment.point)
            } else {
                context.addLine(to: segment.point)
            }
        }

//        var lineWidth: CGFloat?
//        var lastPoint: CGPoint?
//
//        history.forEach { state in
//            if state.thickness != lineWidth {
//                if !context.isPathEmpty {
//                    context.strokePath()
//                }
//                lineWidth = state.thickness
//                context.setLineWidth(state.thickness)
//                context.move(to: state.position)
//            }
//            if lastPoint != state.position {
//                if state.penDown {
//                    context.addLine(to: state.position)
//                } else {
//                    context.move(to: state.position)
//                }
//                lastPoint = state.position
//            }
//        }
        if !context.isPathEmpty {
            context.strokePath()
        }
    }

    @objc
    private func updateDrawings() {
        let currentTime = CACurrentMediaTime()
        guard currentTime <= displayLink!.targetTimestamp else {
            return
        }

        currentDuration = currentTime - startTime
        var progress = currentDuration / duration

        if currentDuration >= duration {
            displayLink?.invalidate()
            progress = 1.0
        }

        let lastIndex = Int(floor(CGFloat(segments.count) * progress))
        animatedSegments = (0 ..< lastIndex).map { segments[$0] }

        guard animatedSegments.count > 1 else { return }
        guard lastDrawnIndex < lastIndex else { return }

        let segmentsToUpdate = segments[lastDrawnIndex ..< lastIndex]

        let minX = segmentsToUpdate.map { $0.point.x }.reduce(0, min)
        let minY = segmentsToUpdate.map { $0.point.y }.reduce(0, min)
        let maxX = segmentsToUpdate.map { $0.point.x }.reduce(0, max)
        let maxY = segmentsToUpdate.map { $0.point.y }.reduce(0, max)
        let maxLineWidth = segmentsToUpdate.map { $0.lineWidth }.reduce(0, max)

        lastDrawnIndex = lastIndex

        let rectToUpdate = CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        ).insetBy(dx: -maxLineWidth, dy: -maxLineWidth)
        setNeedsDisplay(rectToUpdate)
    }
}
