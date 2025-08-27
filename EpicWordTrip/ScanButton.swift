import SwiftUI

struct ScanButton: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UIButton {
        let textFromCamera = UIAction.captureTextFromCamera(
            responder: context.coordinator,
            identifier: nil)
        let button = UIButton()

        button.setTitle("get new letters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.addAction(textFromCamera, for: .touchUpInside)

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: UIResponder, UIKeyInput {
        let parent: ScanButton
        init(_ parent: ScanButton) { self.parent = parent }

        var hasText = false

        func insertText(_ text: String) {
            parent.text = text
        }

        func deleteBackward() { }
    }

}
