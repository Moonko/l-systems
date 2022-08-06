import UIKit

final class SystemsListViewController: UITableViewController {
    private let examples: [SystemExample] = [
        SystemExample(
            title: "Honeycomb",
            systemMaker: .honeycomb,
            gen: 10,
            initialPosition: CGPoint(x: 0.5, y: 0.5),
            initialAngle: .pi / 2
        ),
        SystemExample(
            title: "Triangles",
            systemMaker: .triangles,
            gen: 8,
            initialPosition: CGPoint(x: 0.0, y: 0.6),
            initialAngle: 0
        ),
        SystemExample(
            title: "Dragon",
            systemMaker: .dragon,
            gen: 14,
            initialPosition: CGPoint(x: 0.5, y: 0.5),
            initialAngle: .pi / 2
        ),
        SystemExample(
            title: "Snowflake",
            systemMaker: .snowflake,
            gen: 7,
            initialPosition: CGPoint(x: 0.2, y: 0.0),
            initialAngle: .pi / 2
        ),
        SystemExample(
            title: "Plant",
            systemMaker: .plant,
            gen: 9,
            initialPosition: CGPoint(x: 0.5, y: 1.0),
            initialAngle: -.pi / 2
        ),
        SystemExample(
            title: "Tree",
            systemMaker: .tree,
            gen: 10,
            initialPosition: CGPoint(x: 0.5, y: 1.0),
            initialAngle: -.pi / 2
        )
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "L-Systems"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = examples[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        let systemController = LSystemViewController(
            example: example,
            renderer: CoreGraphicsRenderer()
        )
        navigationController?.pushViewController(systemController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
}

struct SystemExample {
    let title: String
    let systemMaker: () -> LSystem
    let gen: Int
    let initialPosition: CGPoint // (0 ... 1)
    let initialAngle: CGFloat // radians

    init(
        title: String,
        systemMaker: @autoclosure @escaping () -> LSystem,
        gen: Int,
        initialPosition: CGPoint,
        initialAngle: CGFloat
    ) {
        self.title = title
        self.systemMaker = systemMaker
        self.gen = gen
        self.initialPosition = initialPosition
        self.initialAngle = initialAngle
    }
}
