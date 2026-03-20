import Foundation

enum TmuxManager {
    /// Tmux session name prefix for Infinite Scroll
    static let prefix = "is-"

    /// Find tmux binary — prefer the bundled copy inside the .app
    static func findTmux() -> String? {
        // 1. Bundled tmux inside the app
        if let bundlePath = Bundle.main.executableURL?
            .deletingLastPathComponent()
            .appendingPathComponent("tmux").path,
           FileManager.default.isExecutableFile(atPath: bundlePath) {
            return bundlePath
        }
        // 2. System tmux
        let candidates = [
            "/opt/homebrew/bin/tmux",
            "/usr/local/bin/tmux",
            "/usr/bin/tmux",
        ]
        for path in candidates {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }
        return nil
    }

    /// Session name for a cell UUID
    static func sessionName(for id: UUID) -> String {
        return "\(prefix)\(id.uuidString)"
    }

    /// Check if a tmux session exists
    static func sessionExists(_ name: String) -> Bool {
        guard let tmux = findTmux() else { return false }
        let task = Process()
        task.executableURL = URL(fileURLWithPath: tmux)
        task.arguments = ["has-session", "-t", name]
        task.standardOutput = FileHandle.nullDevice
        task.standardError = FileHandle.nullDevice
        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus == 0
        } catch {
            return false
        }
    }

    /// Kill a tmux session
    static func killSession(_ name: String) {
        guard let tmux = findTmux() else { return }
        let task = Process()
        task.executableURL = URL(fileURLWithPath: tmux)
        task.arguments = ["kill-session", "-t", name]
        task.standardOutput = FileHandle.nullDevice
        task.standardError = FileHandle.nullDevice
        try? task.run()
        task.waitUntilExit()
    }

    /// List all Infinite Scroll tmux sessions
    static func listSessions() -> [String] {
        guard let tmux = findTmux() else { return [] }
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: tmux)
        task.arguments = ["list-sessions", "-F", "#{session_name}"]
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        do {
            try task.run()
            task.waitUntilExit()
        } catch { return [] }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return [] }
        return output.components(separatedBy: "\n")
            .filter { $0.hasPrefix(prefix) }
    }

    /// Clean up orphaned sessions (sessions not in the given set of active cell IDs)
    static func cleanupOrphans(activeCellIDs: Set<UUID>) {
        let activeNames = Set(activeCellIDs.map { sessionName(for: $0) })
        for session in listSessions() {
            if !activeNames.contains(session) {
                killSession(session)
            }
        }
    }
}
