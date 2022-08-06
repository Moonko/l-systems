import UIKit

class LSystemViewController: UIViewController {
    private let example: SystemExample
    private let renderer: TurtleGraphicsRenderer

    init(
        example: SystemExample,
        renderer: TurtleGraphicsRenderer
    ) {
        self.example = example
        self.renderer = renderer

        super.init(nibName: nil, bundle: nil)

        title = example.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(renderer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        renderer.frame = view.bounds

        let system = example.systemMaker()
        let pattern = system.gen(example.gen)
        var commands = [Turtle.Command]()
        system.turtle.executeCommands([
            .setPosition(
                CGPoint(
                    x: view.bounds.width * example.initialPosition.x,
                    y: view.bounds.height * example.initialPosition.y
                )
            ),
            .setAngle(example.initialAngle)
        ])
        system.turtle.executeCommand(.penDown)
        pattern.forEach { char in
            commands.append(contentsOf: system.commands["\(char)"]!)
        }
        system.turtle.executeCommands(commands)
        renderer.drawHistory(system.turtle.history, duration: 5.0)
    }
}
