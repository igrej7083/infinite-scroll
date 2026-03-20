import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: PanelStore

    var body: some View {
        CmdScrollView {
            VStack(spacing: Theme.panelSpacing) {
                ForEach(Array(store.panels.enumerated()), id: \.element.id) { index, panel in
                    RowView(
                        panel: panel,
                        index: index + 1,
                        fontSize: store.fontSize,
                        focusedCellID: store.focusedCellID,
                        onClose: { store.removePanel(id: panel.id) }
                    )
                }
            }
            .padding(Theme.panelSpacing)
        }
        .background(Theme.background)
    }
}
