import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                RoundedRectangle(cornerRadius: 28)
                    .fill(AppTheme.primary)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "plus.forwardslash.minus")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.white)
                    )

                Text("消費税電卓・割引計算")
                    .font(.system(size: 28, weight: .bold))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeOut(duration: 0.25)) {
                    showSplash = false
                }
            }
        }
    }
}
