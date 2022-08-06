import CoreGraphics

final class Turtle {
    private(set) var history = [State]()
    private(set) var state: State {
        didSet {
            history.append(state)
        }
    }

    private var statesStack = [State]()
    private var turnAngle: CGFloat
    private var thinPoints: CGFloat

    init(
        drawingDistance: CGFloat,
        turnAngle: CGFloat,
        thickness: CGFloat,
        thinPoints: CGFloat
    ) {
        self.turnAngle = turnAngle
        self.thinPoints = thinPoints
        self.state = State(
            position: .zero,
            angle: 0,
            distance: drawingDistance,
            thickness: thickness,
            penDown: false
        )
    }

    func executeCommand(_ command: Command) {
        switch command {
        case .turnRight:
            state = state.turnedBy(turnAngle)
        case .turnLeft:
            state = state.turnedBy(-turnAngle)
        case .move:
            state = state.movedBy(state.distance)
        case .penDown:
            state = state.drawing(true)
        case .penUp:
            state = state.drawing(false)
        case .save:
            statesStack.append(state)
        case .load:
            state = statesStack.removeLast()
        case .thin:
            state = state.thinnedBy(thinPoints)
        case .setRandomTurnAngle(let maxAngle):
            turnAngle = maxAngle * (CGFloat(arc4random_uniform(100)) / 100)
        case .changeDrawingDistance(let distance):
            let newDistance = state.distance + distance
            state = state.withDistance(max(1.0, newDistance))
        case .setPosition(let position):
            state = state.withPosition(position)
        case .setAngle(let angle):
            state = state.withAngle(angle)
        }
    }

    func executeCommands(_ commands: [Command], duration: Int = 0) {
        commands.enumerated().forEach { index, command in
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay * index)) {
                self.executeCommand(command)
//            }
        }
    }
}

extension Turtle {
    enum Command {
        case turnRight
        case turnLeft
        case move
        case penDown
        case penUp
        case save
        case load
        case thin
        case setRandomTurnAngle(CGFloat)
        case setPosition(CGPoint)
        case setAngle(CGFloat)
        case changeDrawingDistance(CGFloat)
    }

    struct State {
        let position: CGPoint
        let angle: CGFloat
        let distance: CGFloat
        let thickness: CGFloat
        let penDown: Bool

        func drawing(_ isDrawing: Bool) -> State {
            State(
                position: position,
                angle: angle,
                distance: distance,
                thickness: thickness,
                penDown: isDrawing
            )
        }

        func movedBy(_ points: CGFloat) -> State {
            State(
                position: CGPoint(
                    x: position.x + points * cos(angle),
                    y: position.y + points * sin(angle)
                ),
                angle: angle,
                distance: distance,
                thickness: thickness,
                penDown: penDown
            )
        }

        func turnedBy(_ turnAngle: CGFloat) -> State {
            State(
                position: position,
                angle: angle + turnAngle,
                distance: distance,
                thickness: thickness,
                penDown: penDown
            )
        }

        func thinnedBy(_ points: CGFloat) -> State {
            State(
                position: position,
                angle: angle,
                distance: distance,
                thickness: max(0.5, thickness - points),
                penDown: penDown
            )
        }

        func withPosition(_ newPosition: CGPoint) -> State {
            State(
                position: newPosition,
                angle: angle,
                distance: distance,
                thickness: thickness,
                penDown: penDown
            )
        }

        func withAngle(_ newAngle: CGFloat) -> State {
            State(
                position: position,
                angle: newAngle,
                distance: distance,
                thickness: thickness,
                penDown: penDown
            )
        }

        func withDistance(_ newDistance: CGFloat) -> State {
            State(
                position: position,
                angle: angle,
                distance: newDistance,
                thickness: thickness,
                penDown: penDown
            )
        }
    }
}
