import Foundation

@MainActor
final class AssistantController: ObservableObject {
    @Published var metaStatus = "Starting…"
    @Published var assistantStatus = "Idle"
    @Published var lastHeard = ""
    @Published var lastAnswer = ""
    @Published var lastError: String?

    private let meta = MetaWearablesBridge()
    private let backend = OpenAIBackendClient()
    private let speechOutput = SpeechOutput()

    func start() async {
        do {
            metaStatus = "Watching for glasses"
            try await meta.start { [weak self] text in
                guard let self else { return }
                await self.handleFinalTranscript(text)
            }
            metaStatus = "Ready"
        } catch {
            await report(error)
        }
    }

    func registerWithMeta() async {
        do {
            try await meta.register()
            metaStatus = "Registered"
        } catch {
            await report(error)
        }
    }

    func requestMicrophonePermission() async {
        do {
            try await meta.requestMicrophonePermission()
            metaStatus = "Microphone granted"
        } catch {
            await report(error)
        }
    }

    private func handleFinalTranscript(_ text: String) async {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }

        lastHeard = cleaned
        assistantStatus = "Thinking…"

        do {
            let answer = try await backend.ask(cleaned)
            lastAnswer = answer
            assistantStatus = "Speaking"
            try speechOutput.speak(answer)
            assistantStatus = "Ready"
        } catch {
            await report(error)
        }
    }

    func report(_ error: Error) async {
        lastError = error.localizedDescription
        assistantStatus = "Error"
    }
}
