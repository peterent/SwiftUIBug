//
//  CategoryView.swift
//  AwesomeOne
//
//  Created by Peter Ent on 11/10/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @State private var newCategory: String = ""
    @State private var pickerId = 0
    @State private var pickerIndex = 0
    
    @ObservedObject var viewModel: SessionModel
    @ObservedObject var editableRecord: EditableRecord
    
    var onApply: (_ category: Category) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // Use this TextField to enter a new Category. The "return" key on the keyboard
            // triggers the commit function which transfers the state newCategory into the
            // editable record (you could also invoke onApply) and adds the newCategory
            // to the viewModel.
            TextField("home, etc", text: self.$newCategory, onEditingChanged: { (success) in
                // ignore for now
            }) {
                self.editableRecord.category = self.newCategory
                self.viewModel.addCategory(self.newCategory)
                self.pickerId = self.pickerId + 1 // update the ID so picker refreshes (hack)
                self.newCategory = ""
            }
            
            // The picker displays the list of existing viewModel.categories. Selecting one will
            // set the bound pickerIndex. Note the .id() viewModifier which is required to get
            // the Picker to refresh so it picks up the change to the viewModel.
            Picker(
                selection: self.$pickerIndex, // using self.$viewModel.categoryIndex does not work
                label: Text("Colors")
            ) {
                ForEach(0..<self.viewModel.categories.count) { index in
                    Text(self.viewModel.categories[index].label).tag(index) // .tag is necessary
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .id(self.pickerId) // use a unique var so Picker is refreshed when ID changes (hack)
            
            // The Cancel (to dismiss if using this View as a popover, remove it not) and Apply buttons.
            // The apply button invokes the onApply callback to transfer the selected category
            // back to the parent View. You could also just send the index back. Be sure to use
            // onTapGesture and not the button action due to (bug??) which causes both buttons'
            // actions to be triggered.
            HStack {
                Button("Cancel") { }.onTapGesture { self.onCancel() }
                Spacer()
                Button("Apply") { }.onTapGesture {
                    self.onApply(self.viewModel.categories[self.pickerIndex])
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    @State static var viewModel = SessionModel()
    @State static var record = EditableRecord()
    static var previews: some View {
        CategoryView(
            viewModel: viewModel,
            editableRecord: record,
            onApply: { category in
                
        }, onCancel: {} )
    }
}
