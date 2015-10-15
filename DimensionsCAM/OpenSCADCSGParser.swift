
struct OpenSCADCSGParser {
    var grammar: OpenSCADCSGGrammar


    init(text: String, filename: String) {
        grammar = OpenSCADCSGGrammar(text: text, filename: filename)
    }


}
