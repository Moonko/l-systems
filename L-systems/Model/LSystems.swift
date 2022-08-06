import CoreGraphics

extension LSystem {
    static var honeycomb: LSystem {
        LSystem(
            rules: [
                "A": "AB",
                "B": "A"
            ],
            axiom: "ABAABABAABAAB",
            turtle: Turtle(
                drawingDistance: 10,
                turnAngle: .pi / 3,
                thickness: 1,
                thinPoints: 0
            ),
            commands: [
                "A": [.turnLeft, .move],
                "B": [.turnRight, .move]
            ]
        )
    }

    static var triangles: LSystem {
        LSystem(
            rules: [
                "F": "F-G+F+G-F",
                "G": "GG"
            ],
            axiom: "F-G-G",
            turtle: Turtle(
                drawingDistance: 3,
                turnAngle: .pi / 1.5,
                thickness: 0.5,
                thinPoints: 0
            ),
            commands: [
                "F": [.move],
                "G": [.move],
                "+": [.turnRight],
                "-": [.turnLeft]
            ]
        )
    }

    static var dragon: LSystem {
        LSystem(
            rules: [
                "X": "X+YF+",
                "Y": "-FX-Y"
            ],
            axiom: "FX",
            turtle: Turtle(
                drawingDistance: 1,
                turnAngle: .pi / 2,
                thickness: 0.5,
                thinPoints: 0
            ),
            commands: [
                "X": [.move],
                "Y": [.move],
                "F": [.move],
                "+": [.turnRight],
                "-": [.turnLeft]
            ]
        )
    }

    static var snowflake: LSystem {
        LSystem(
            rules: [
                "F": "F-F++F-F"
            ],
            axiom: "F++F++F",
            turtle: Turtle(
                drawingDistance: 2,
                turnAngle: .pi / 3,
                thickness: 1,
                thinPoints: 0
            ),
            commands: [
                "F": [.move],
                "+": [.turnRight],
                "-": [.turnLeft]
            ]
        )
    }

    static var plant: LSystem {
        LSystem(
            rules: [
                "X": "F[+X]F[-X]+X",
                "F": "FF"
            ],
            axiom: "X",
            turtle: Turtle(
                drawingDistance: 1,
                turnAngle: .pi / 8,
                thickness: 0.5,
                thinPoints: 0
            ),
            commands: [
                "F": [.move],
                "X": [.move],
                "+": [.turnRight],
                "-": [.turnLeft],
                "[": [.save],
                "]": [.load]
            ]
        )
    }

    static var tree: LSystem {
        LSystem(
            rules: [
                "X": "F[@[-X]+X]",
            ],
            axiom: "X",
            turtle: Turtle(
                drawingDistance: 100,
                turnAngle: .pi / 4,
                thickness: 8,
                thinPoints: 1.0
            ),
            commands: [
                "F": [.move],
                "X": [.move],
                "+": [.turnRight],
                "-": [.turnLeft],
                "[": [.save],
                "]": [.load],
                "@": [
                    .thin,
                    .setRandomTurnAngle(.pi / 4),
                    .changeDrawingDistance(-8)
                ]
            ]
        )
    }
}
