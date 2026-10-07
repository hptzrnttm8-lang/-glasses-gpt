import Foundation
import MWDATCore

@MainActor
final class MetaWearablesBridge {
    private var voiceStream: VoiceInvocationsStream?
    private var invocationToken: AnyListenerToken?
    private var errorToken: AnyListenerToken?
    private var deviceTask: Task<Void, Never>?

    func register() async throws {
        try await Wearables.shared.startRegistration()
    }

    func startVoiceInvocationTest(
        onReady: @escaping @MainActor (DeviceIdentifier) -> Void,
        onLaunch: @escaping @MainActor (Bool) -> Void,
        onError: @escaping @MainActor (String) -> Void
    ) async throws {
        stopVoiceInvocationTest()

        let stream = try VoiceInvocationsStream(wearables: Wearables.shared)
        voiceStream = stream

        invocationToken = stream.invocationsPublisher.listen { invocation in
            guard let launch = invocation as? LaunchApp else { return }
            Task { @MainActor in
                let delivered = await launch.responseHandle.sendSuccess(actionOutput: nil)
                onLaunch(delivered)
            }
        }

        errorToken = stream.errorPublisher.listen { error in
            Task { @MainActor in
                onError(String(describing: error))
            }
        }

        deviceTask = Task { @MainActor [weak self] in
            for await identifiers in Wearables.shared.devicesStream() {
                guard !Task.isCancelled else { return }
                guard let identifier = identifiers.first else { continue }
                guard let self, let stream = self.voiceStream else { return }

                do {
                    try stream.start(deviceIdentifier: identifier)
                    onReady(identifier)
                    return
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
    }

    func stopVoiceInvocationTest() {
        deviceTask?.cancel()
        deviceTask = nil
        voiceStream?.stop()
        voiceStream = nil
        invocationToken = nil
        errorToken = nil
    }
}
