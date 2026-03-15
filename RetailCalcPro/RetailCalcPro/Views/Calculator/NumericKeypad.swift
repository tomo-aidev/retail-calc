import SwiftUI

struct NumericKeypad: View {
    let onDigit: (String) -> Void
    let onDoubleZero: () -> Void
    let onBackspace: () -> Void
    let onClear: () -> Void
    let onEquals: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            // Row 1: Backspace, C, %, ÷
            HStack(spacing: 14) {
                KeypadButton(
                    style: .function,
                    action: onBackspace
                ) {
                    Image(systemName: "delete.backward")
                        .font(.title2)
                }
                KeypadButton(label: "C", style: .function, action: onClear)
                KeypadButton(label: "00", style: .function) {
                    onDoubleZero()
                }
                KeypadButton(label: "÷", style: .primary, action: {})
            }

            // Row 2: 7, 8, 9, ×
            HStack(spacing: 14) {
                KeypadButton(label: "7", style: .digit) { onDigit("7") }
                KeypadButton(label: "8", style: .digit) { onDigit("8") }
                KeypadButton(label: "9", style: .digit) { onDigit("9") }
                KeypadButton(label: "×", style: .primary, action: {})
            }

            // Row 3: 4, 5, 6, -
            HStack(spacing: 14) {
                KeypadButton(label: "4", style: .digit) { onDigit("4") }
                KeypadButton(label: "5", style: .digit) { onDigit("5") }
                KeypadButton(label: "6", style: .digit) { onDigit("6") }
                KeypadButton(label: "-", style: .primary, action: {})
            }

            // Row 4: 1, 2, 3, +
            HStack(spacing: 14) {
                KeypadButton(label: "1", style: .digit) { onDigit("1") }
                KeypadButton(label: "2", style: .digit) { onDigit("2") }
                KeypadButton(label: "3", style: .digit) { onDigit("3") }
                KeypadButton(label: "+", style: .primary, action: {})
            }

            // Row 5: 0 (wide), ., =
            HStack(spacing: 14) {
                KeypadButton(label: "0", style: .digit, isWide: true) { onDigit("0") }
                KeypadButton(label: ".", style: .digit, action: {})
                KeypadButton(label: "=", style: .primary, action: onEquals)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Keypad Button

struct KeypadButton<Content: View>: View {
    enum Style {
        case digit
        case function
        case primary
    }

    let style: Style
    let isWide: Bool
    let action: () -> Void
    let content: Content

    init(label: String, style: Style, isWide: Bool = false, action: @escaping () -> Void) where Content == Text {
        self.style = style
        self.isWide = isWide
        self.action = action
        self.content = Text(label)
    }

    init(style: Style, isWide: Bool = false, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.style = style
        self.isWide = isWide
        self.action = action
        self.content = content()
    }

    private var backgroundColor: Color {
        switch style {
        case .digit: return AppTheme.keypadDark
        case .function: return AppTheme.keypadGray
        case .primary: return AppTheme.primary
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .digit: return .white
        case .function: return .black
        case .primary: return .white
        }
    }

    var body: some View {
        Button(action: action) {
            content
                .font(style == .function ? .title2.weight(.medium) : .title.weight(.regular))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(isWide ? 2.2 : 1.0, contentMode: .fit)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
        .buttonStyle(KeypadButtonStyle())
    }
}

struct KeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
