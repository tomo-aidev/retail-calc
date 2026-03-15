import SwiftUI

struct SplashView: View {
    @State private var progress: Double = 0
    @State private var isFinished = false
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()

            // Decorative blurs
            Circle()
                .fill(AppTheme.primary.opacity(0.05))
                .frame(width: 260, height: 260)
                .blur(radius: 60)
                .offset(x: -100, y: -200)

            Circle()
                .fill(AppTheme.primary.opacity(0.1))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: 120, y: 250)

            VStack(spacing: 0) {
                Spacer()

                // App Icon
                VStack(spacing: 32) {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(AppTheme.primary)
                        .frame(width: 128, height: 128)
                        .shadow(color: AppTheme.primary.opacity(0.3), radius: 20, y: 10)
                        .overlay(
                            Image(systemName: "plus.forwardslash.minus")
                                .font(.system(size: 56, weight: .medium))
                                .foregroundStyle(.white)
                        )

                    // App Title
                    VStack(spacing: 8) {
                        Text("小売計算Pro")
                            .font(.system(size: 36, weight: .bold))

                        Text("RETAIL CALC PRO")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppTheme.primary)
                            .tracking(4)
                    }

                    // Tagline
                    Text("スマートな買い物、\n瞬時に計算")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                Spacer()

                // Loading Bar
                VStack(spacing: 12) {
                    HStack {
                        Text("起動中...")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.primary)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.primary.opacity(0.1))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.primary)
                                .frame(width: geo.size.width * progress)
                        }
                    }
                    .frame(height: 6)

                    // Footer badges
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.caption2)
                            Text("Secure")
                                .font(.caption2)
                        }
                        .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.caption2)
                            Text("Fast")
                                .font(.caption2)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSplash = false
                }
            }
        }
    }
}
