import AppKit
import SwiftUI

// MARK: - CmdNSScrollView: intercepts Cmd+scroll for window scrolling

class CmdNSScrollView: NSScrollView {
    private var eventMonitor: Any?

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window != nil && eventMonitor == nil {
            eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] event in
                guard let self = self,
                      event.modifierFlags.contains(.command),
                      let window = self.window,
                      window == event.window else {
                    return event
                }
                // Perform the scroll on this NSScrollView
                let clipView = self.contentView
                var newOrigin = clipView.bounds.origin
                newOrigin.y -= event.scrollingDeltaY
                // Clamp
                let maxY = max(0, (clipView.documentView?.frame.height ?? 0) - clipView.bounds.height)
                newOrigin.y = min(max(0, newOrigin.y), maxY)
                clipView.setBoundsOrigin(newOrigin)
                self.reflectScrolledClipView(clipView)
                return nil // consume the event
            }
        }
    }

    override func removeFromSuperview() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        super.removeFromSuperview()
    }

    // Don't scroll on normal scroll events — let terminals handle them
    override func scrollWheel(with event: NSEvent) {
        if event.modifierFlags.contains(.command) {
            super.scrollWheel(with: event)
        }
        // Non-Cmd scroll events fall through to subviews naturally
    }
}

// MARK: - CmdScrollView: SwiftUI wrapper

struct CmdScrollView<Content: View>: NSViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeNSView(context: Context) -> CmdNSScrollView {
        let scrollView = CmdNSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false
        scrollView.automaticallyAdjustsContentInsets = false

        let hostingView = NSHostingView(rootView: content)
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        let clipView = NSClipView()
        clipView.drawsBackground = false
        clipView.documentView = hostingView
        scrollView.contentView = clipView

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: clipView.topAnchor),
        ])

        return scrollView
    }

    func updateNSView(_ nsView: CmdNSScrollView, context: Context) {
        guard let hostingView = nsView.contentView.documentView as? NSHostingView<Content> else { return }
        hostingView.rootView = content
    }
}
