import Foundation
import MWDATCore
import MWDATSpeech

final class MetaWearablesBridge: @unchecked Sendable {
    typealias FinalTranscriptHandler = @Sendable (String) async -> Void

    private var transcriptHandler: FinalTranscriptHandler?
    private var retainedTokens: [Any] = []

    func register() async throws {
        try await Wearables.shared.startRegistration()
    }

    func requestMicrophonePermission() async throws {
        throw BridgeError.finishDATPermissionBinding
    }

    func start(onFinalTranscript: @escaping FinalTranscriptHandler) async throws {
        self.transcriptHandler = onFinalTranscript
        throw BridgeError.finishDATVoiceInvocationBinding
    }
}

enum BridgeError: LocalizedError {
    case microphoneDenied
    case finishDATPermissionBinding
    case finishDATVoiceInvocationBinding

    var errorDescription: String? {
        switch self {
        case .microphoneDenied:
            return "Meta glasses microphone permission was denied."
        case .finishDATPermissionBinding:
            return "Bind requestMicrophonePermission() to the exact DAT permission API installed in Xcode."
        case .finishDATVoiceInvocationBinding:
            return "Bind VoiceInvocationsStream + MWDATSpeech to the exact DAT symbols installed in Xcode."
        }
    }
}
