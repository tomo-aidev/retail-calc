import SwiftUI

struct CustomDiscountEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = AppSettings.shared
    @State private var newPercentage = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(settings.customDiscountPercentages.enumerated()), id: \.offset) { index, value in
                        HStack {
                            Text("\(value)%")
                                .font(.body.weight(.medium))
                            Spacer()
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                settings.customDiscountPercentages.remove(at: index)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }

                    HStack {
                        TextField("新しい割引率", text: $newPercentage)
                            .keyboardType(.numberPad)
                        Text("%")
                            .foregroundStyle(.secondary)
                        Button {
                            if let value = Int(newPercentage), value > 0, value <= 100 {
                                settings.customDiscountPercentages.append(value)
                                settings.customDiscountPercentages.sort()
                                newPercentage = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(AppTheme.exclusivePrimary)
                        }
                        .disabled(Int(newPercentage) == nil)
                    }
                } header: {
                    Text("パーセント割引")
                }
            }
            .navigationTitle("カスタム割引")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                    .font(.body.weight(.semibold))
                }
            }
        }
    }
}
