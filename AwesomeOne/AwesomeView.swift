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
                CategoryView(
                    viewModel: self.viewModel,
                    editableRecord: self.editableRecord,
                    onApply: { newCategory in self.editableRecord.category = newCategory.label},
                    onCancel: { print("Cancel happened")} )
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
