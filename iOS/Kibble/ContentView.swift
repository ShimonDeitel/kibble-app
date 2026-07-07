import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: KibbleStore
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.feedings) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.foodType).font(Theme.headlineFont)
                        Text("\(entry.portion)")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { store.remove(at: $0) }
            }
            .navigationTitle("Kibble")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("main.settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("main.addButton")
                }
            }
            .sheet(isPresented: $showingAdd) { AddFeedingView() }
            .sheet(isPresented: $showingPaywall) { PaywallView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
        }
    }
}

struct AddFeedingView: View {
    @EnvironmentObject var store: KibbleStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var foodType = ""
    @State private var portion = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Food Type", text: $foodType)
                        .accessibilityIdentifier("addFeeding.foodTypeField")
                    TextField("Portion", text: $portion)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = Feeding(foodType: foodType.isEmpty ? "Food Type" : foodType, portion: portion.isEmpty ? "Portion" : portion)
                        _ = store.add(entry, isPro: purchases.isPro)
                        dismiss()
                    }
                    .accessibilityIdentifier("addFeeding.saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
