import SwiftUI
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message, type: type)
                        .padding(.bottom, 50)
                        .onAppear {
                            startDismissTimer()
                        }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private func startDismissTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isPresented = false
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, type: ToastType) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, type: type))
    }
}

