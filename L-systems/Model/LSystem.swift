import Foundation

struct LSystem {
    let rules: [String: String]
    let axiom: String
    let turtle: Turtle
    let commands: [String: [Turtle.Command]]

    func gen(_ gen: Int) -> String {
        var result = axiom
        (1 ..< gen).forEach { _ in
            result = applyRules(toAxiom: result)
        }
        return result
    }

    private func applyRules(toAxiom axiom: String) -> String {
        var result = ""
        axiom.forEach { char in
            result += rules["\(char)"] ?? "\(char)"
        }
        return result
    }
}
