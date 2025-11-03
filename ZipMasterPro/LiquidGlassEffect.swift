//
//  LiquidGlassEffect.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI

// LiquidGlass Background View
struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.5, blue: 0.9),
                    Color(red: 0.5, green: 0.3, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Glass effect overlay
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .background(
                    BackgroundBlurView()
                )
                .ignoresSafeArea()
        }
    }
}

// Background blur effect using UIVisualEffectView
struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// LiquidGlass Card Component
struct LiquidGlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 0
    
    init(cornerRadius: CGFloat = 16, padding: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    var body: some View {
        ZStack {
            // Glass background
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white.opacity(0.1))
                .background(
                    GlassEffectView(cornerRadius: cornerRadius)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            // Content
            content
                .padding(padding)
        }
    }
}

// Glass effect view with blur
struct GlassEffectView: UIViewRepresentable {
    let cornerRadius: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// LiquidGlass Button
struct LiquidGlassButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    init(title: String, icon: String? = nil, isLoading: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(isDisabled ? .white.opacity(0.5) : .white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                Group {
                    if !isDisabled {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.white.opacity(0.1)
                    }
                }
            )
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(isDisabled ? 0.1 : 0.3), lineWidth: 1)
            )
            .shadow(color: Color.pink.opacity(isDisabled ? 0 : 0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(isLoading ? 0.95 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// LiquidGlass Progress View
struct LiquidGlassProgressView: View {
    let progress: Double
    let title: String
    let showPercentage: Bool
    
    init(progress: Double, title: String = "", showPercentage: Bool = true) {
        self.progress = progress
        self.title = title
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 8) {
                if !title.isEmpty {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pink))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                if showPercentage {
                    HStack {
                        Text("处理中...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\\(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding()
        }
    }
}

// LiquidGlass Text Field
struct LiquidGlassTextField: View {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    @State private var isFocused = false
    
    init(text: Binding<String>, placeholder: String, isSecure: Bool = false) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.horizontal, 16)
            }
            
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isFocused ? Color.pink : Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .foregroundColor(.white)
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

// LiquidGlass Toggle
struct LiquidGlassToggle: View {
    @Binding var isOn: Bool
    let title: String
    let icon: String?
    
    var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isOn ? .pink : .white.opacity(0.7))
                }
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isOn ? Color.pink : Color.white.opacity(0.2))
                        .frame(width: 50, height: 30)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: isOn)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// LiquidGlass Slider
struct LiquidGlassSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Slider(value: $value, in: range, step: step) {
                Text(title)
            }
            .accentColor(.pink)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
}

// LiquidGlass Card with custom styling
struct LiquidGlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        GlassEffectView(cornerRadius: cornerRadius)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
    }
}

extension View {
    func liquidGlassCard(cornerRadius: CGFloat = 16, padding: CGFloat = 16) -> some View {
        modifier(LiquidGlassCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

// LiquidGlass Animation Effects
struct LiquidGlassAnimationEffects {
    static func pulseAnimation() -> Animation {
        Animation.easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
    }
    
    static func floatingAnimation() -> Animation {
        Animation.easeInOut(duration: 3.0)
            .repeatForever(autoreverses: true)
    }
    
    static func shimmerAnimation() -> Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
}

// LiquidGlass Color Extensions
extension Color {
    static var liquidGlassPrimary: Color {
        Color(red: 0.4, green: 0.5, blue: 0.9)
    }
    
    static var liquidGlassSecondary: Color {
        Color(red: 0.5, green: 0.3, blue: 0.8)
    }
    
    static var liquidGlassAccent: Color {
        Color(red: 0.9, green: 0.4, blue: 0.7)
    }
    
    static var liquidGlassBackground: Color {
        Color.white.opacity(0.1)
    }
    
    static var liquidGlassBorder: Color {
        Color.white.opacity(0.2)
    }
}

// Preview Providers
struct LiquidGlassEffects_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Background
            LiquidGlassBackground()
                .frame(height: 200)
            
            // Card
            LiquidGlassCard {
                Text("示例卡片")
                    .foregroundColor(.white)
            }
            
            // Button
            LiquidGlassButton(title: "示例按钮", icon: "star") {
                print("Button tapped")
            }
            
            // Progress View
            LiquidGlassProgressView(progress: 0.6, title: "进度示例")
            
            // Text Field
            LiquidGlassTextField(text: .constant(""), placeholder: "输入文本")
            
            // Toggle
            LiquidGlassToggle(isOn: .constant(true), title: "开关示例", icon: "power")
            
            // Slider
            LiquidGlassSlider(value: .constant(0.5), range: 0...1, step: 0.1, title: "滑块示例")
        }
        .padding()
    }
}