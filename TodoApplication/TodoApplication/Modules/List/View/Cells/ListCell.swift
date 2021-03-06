import UIKit

class ListCell: BaseCell {}

extension ListCell: ConfigurableCell {
    func configure(_ viewModel: ListViewModel) {
        self.onTextDidEndEditing = viewModel.onTextDidEndEditing
        textField.text = viewModel.name
    }
}

extension ListCell: AccessibleCell {
    func setAccessibilityIdentifierIndex(index: Int) {
        textField.qaAccessibilityIdentifier = CellAccessibilityIdentifierBuilder.build(
            identifier: ListDataFlow.AccessibilityIdentifiers.listTextField,
            index: index
        )
    }
}
