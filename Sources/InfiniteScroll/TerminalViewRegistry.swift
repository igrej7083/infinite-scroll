import AppKit
import SwiftTerm

class TerminalViewRegistry {
    static let shared = TerminalViewRegistry()
    private var views: [UUID: LocalProcessTerminalView] = [:]
    private let lock = NSLock()

    private init() {}

    func register(id: UUID, view: LocalProcessTerminalView) {
        lock.lock()
        views[id] = view
        lock.unlock()
    }

    func unregister(id: UUID) {
        lock.lock()
        views.removeValue(forKey: id)
        lock.unlock()
    }

    func view(for id: UUID) -> LocalProcessTerminalView? {
        lock.lock()
        defer { lock.unlock() }
        return views[id]
    }

    func focus(id: UUID) {
        if let view = view(for: id) {
            DispatchQueue.main.async {
                view.window?.makeFirstResponder(view)
                scrollRowToVisible(view)
            }
        }
    }
}

/// Scroll the entire row (including header) into the viewport
private func scrollRowToVisible(_ view: NSView) {
    var current: NSView? = view.superview
    while let parent = current {
        if let scrollView = parent as? CmdNSScrollView {
            guard let docView = scrollView.contentView.documentView else { return }
            // Find the row-level ancestor: walk up from the cell view
            // to find the view whose parent is the VStack hosting view
            var rowView: NSView = view
            while let sv = rowView.superview, sv !== docView {
                rowView = sv
            }
            // Convert the row's full frame (including header) to document coordinates
            let rect = rowView.convert(rowView.bounds, to: docView)
            // Add padding above so the header is visible
            let paddedRect = NSRect(
                x: rect.origin.x,
                y: rect.origin.y - Theme.panelSpacingValue,
                width: rect.width,
                height: rect.height + Theme.panelSpacingValue
            )
            docView.scrollToVisible(paddedRect)
            scrollView.reflectScrolledClipView(scrollView.contentView)
            return
        }
        current = parent.superview
    }
}

class NotesViewRegistry {
    static let shared = NotesViewRegistry()
    private var views: [UUID: NSTextView] = [:]
    private let lock = NSLock()

    private init() {}

    func register(id: UUID, view: NSTextView) {
        lock.lock()
        views[id] = view
        lock.unlock()
    }

    func unregister(id: UUID) {
        lock.lock()
        views.removeValue(forKey: id)
        lock.unlock()
    }

    func view(for id: UUID) -> NSTextView? {
        lock.lock()
        defer { lock.unlock() }
        return views[id]
    }

    func focus(id: UUID) {
        lock.lock()
        let view = views[id]
        lock.unlock()
        if let view = view {
            DispatchQueue.main.async {
                view.window?.makeFirstResponder(view)
                scrollRowToVisible(view)
            }
        }
    }
}
