import SwiftUI


struct ToastView: View {
    let message: String
    let type: ToastType

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding()
            .background(type.backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .transition(.opacity.combined(with: .scale))
    }
}


enum ToastType {
    case success
    case error
    case info

    var backgroundColor: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        case .info: return Color.blue
        }
    }
}


