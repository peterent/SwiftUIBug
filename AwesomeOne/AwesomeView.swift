//
//  AwesomeView.swift
//  AwesomeOne
//
//  Created by Peter Ent on 11/1/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI
import Combine

// May be overkill, but I wanted to make sure having each
// item in the model conformed to Identifiable. Using a struct
// or a class did not make a difference.
class Category: Identifiable {
    var id: UUID
    let label: String
    init (_ label: String) {
        id = UUID()
        self.label = label
    }
}

class SessionModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var categories: [Category] = [Category("Home"), Category("Work"), Category("Financial"), Category("Entertainment")]
    //@Published var categoryIndex = 0 // no longer used
    
    func selectedCategory(_ index: Int) -> String {
        categories[index].label
    }
    
    func addCategory(_ newCategory: String) {
        categories.append(Category(newCategory))
        didChange.send()
    }
}

// There would be a collection of instances of this class in
// the data model.
class EditableRecord: ObservableObject {
    @Published var category: String?
    // other properties
}

struct AwesomeView: View {
    
    @ObservedObject var viewModel = SessionModel()
    @ObservedObject var editableRecord = EditableRecord()
    
    @State var newCategory: String = ""
    @State var pickerIndex = 0
    @State var pickerId = 0
    
    var body: some View {
        Form {
            // This illustrates the Form/Section bug: clicking anywhere
            // on the field triggers both buttons' actions to fire.
            Section(header: Text("Category")) {
                HStack {
                    Button("Create New") {
                        print("New picked")
                    }
                    Spacer()
                    Button("Remove") {
                        print("Remove picked")
                    }
                }
            }
            Section(header: Text("Category")) {
                Text(self.editableRecord.category ?? "None")
            }
            Section(header: Text("Picker Problems")) {
                TextField("home, etc", text: self.$newCategory, onEditingChanged: { (success) in
                    // ignore for now
                }) {
                    self.editableRecord.category = self.newCategory
                    self.viewModel.addCategory(self.newCategory)
                    self.pickerId = self.pickerId + 1 // update the ID so picker refreshes (hack)
                    self.newCategory = ""
                }
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
                Text("Selected: \(self.viewModel.categories[self.pickerIndex].label)")
            }
            // Ideally, simply scrolling the Picker's wheel would
            // set the value in the editableRecord - still cannot
            // figure out how to make that happen.
            Section(header: Text("Save")) {
                Button("Save") {
                    self.editableRecord.category = self.viewModel.selectedCategory(self.pickerIndex)
                }
            }
        }
    }
}

#if DEBUG
struct AwesomeView_Previews: PreviewProvider {
    static var previews: some View {
        AwesomeView()
    }
}
#endif
