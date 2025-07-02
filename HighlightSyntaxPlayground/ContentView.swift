import SwiftUI
import HighlightSwift

struct ContentView: View {
    @State private var code: String = """
    struct Example {
        var text = "Hello, world!"
        func greet() {
            print(text)
        }
    }
    """

    var body: some View {
        SyntaxTextView(code: $code)
            .font(.system(.body, design: .monospaced))
            .padding()
    }
}

struct SyntaxTextView: UIViewRepresentable {
    @Binding var code: String
    let highlighter = Highlight()

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.backgroundColor = .white
        textView.textColor = .label
        textView.font = UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular)
        textView.delegate = context.coordinator
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        Task {
            let attributed = try await highlighter.attributedText(code, language: "swift")
            await MainActor.run {
                uiView.attributedText = NSAttributedString(attributed)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: SyntaxTextView
        init(_ parent: SyntaxTextView) {
            self.parent = parent
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.code = textView.text
            // Capture the current cursor offset
            guard let selectedRange = textView.selectedTextRange else { return }
            let cursorOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)

            Task { @MainActor in
                let attributed = try await parent.highlighter.attributedText(parent.code, language: "swift")
                textView.attributedText = NSAttributedString(attributed)
                // Restore cursor position at the same offset
                if let newPosition = textView.position(from: textView.beginningOfDocument, offset: cursorOffset) {
                    textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
