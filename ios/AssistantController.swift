import Foundation

@MainActor
final class AssistantController: ObservableObject {
    @Published var metaStatus = "Not registered"
    @Published var assistantStatus = "Voice test stopped"
    @Published var lastHeard = ""
    @Published var lastAnswer = ""
    @Published var lastError: String?

    private let meta = MetaWearablesBridge()

    func registerWithMeta() async {
        do {
            lastError = nil
            metaStatus = "Opening Meta AI…"
            try await meta.register()
            metaStatus = "Registration requested"
        } catch {
            await report(error)
        }
    }

    func startVoiceInvocationTest() async {
        do {
            lastError = nil
            assistantStatus = "Waiting for glasses…"

            try await meta.startVoiceInvocationTest(
                onReady: { [weak self] deviceIdentifier in
                    self?.assistantStatus = "Listening on \(deviceIdentifier)"
                },
                onLaunch: { [weak self] delivered in
                    guard let self else { return }
                    self.lastAnswer = delivered
                        ? "✅ Hey Meta launched GlassesGPT"
                        : "⚠️ Launch arrived, but acknowledgement failed"
                    self.assistantStatus = "Invocation received"
                },
                onError: { [weak self] message in
                    self?.lastError = message
                    self?.assistantStatus = "Voice invocation error"
                }
            )
        } catch {
            await report(error)
        }
    }

    func stopVoiceInvocationTest() {
        meta.stopVoiceInvocationTest()
        assistantStatus = "Voice test stopped"
    }

    func report(_ error: Error) async {
        lastError = error.localizedDescription
        assistantStatus = "Error"
    }
}
