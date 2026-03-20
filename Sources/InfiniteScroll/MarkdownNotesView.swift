import AppKit
import SwiftUI

class NotesTextView: NSTextView {}

enum NotesKeyMonitor {
    private static var monitor: Any?

    static func install() {
        guard monitor == nil else { return }
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Cmd+Backspace (keyCode 51)
            guard event.keyCode == 51,
                  event.modifierFlags.contains(.command),
                  let responder = event.window?.firstResponder as? NotesTextView else {
                return event
            }
            responder.deleteToBeginningOfLine(nil)
            return nil
        }
    }
}

struct MarkdownNotesView: NSViewRepresentable {
    let notesID: UUID
    @Binding var text: String
    var fontSize: CGFloat

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NotesTextView()

        textView.isRichText = false
        textView.allowsUndo = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.usesFindBar = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false

        // Dark theme
        textView.backgroundColor = NSColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0)
        textView.textColor = NSColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0)
        textView.insertionPointColor = NSColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0)
        textView.selectedTextAttributes = [
            .backgroundColor: NSColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 0.5),
            .foregroundColor: NSColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0),
        ]

        // Monospaced font
        textView.font = NSFont(name: "Menlo", size: fontSize) ?? NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        if let font = textView.font, let color = textView.textColor {
            textView.typingAttributes = [.font: font, .foregroundColor: color]
        }

        // Layout
        textView.autoresizingMask = [.width]
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true
        textView.textContainerInset = NSSize(width: 8, height: 8)

        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false

        textView.string = text
        textView.delegate = context.coordinator
        context.coordinator.textView = textView

        NotesViewRegistry.shared.register(id: notesID, view: textView)
        context.coordinator.notesID = notesID

        NotesKeyMonitor.install()

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NotesTextView else { return }
        if textView.string != text {
            let selection = textView.selectedRange()
            textView.string = text
            textView.setSelectedRange(selection)
        }
        let font = NSFont(name: "Menlo", size: fontSize) ?? NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        if textView.font?.pointSize != fontSize {
            textView.font = font
            if let color = textView.textColor {
                textView.typingAttributes = [.font: font, .foregroundColor: color]
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>
        weak var textView: NSTextView?
        var notesID: UUID?

        init(text: Binding<String>) {
            self.text = text
        }

        deinit {
            if let id = notesID {
                NotesViewRegistry.shared.unregister(id: id)
            }
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text.wrappedValue = textView.string
        }
    }
}
