import AVFoundation

@MainActor
final class SpeechOutput {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playback,
            mode: .spokenAudio,
            options: [.allowBluetoothA2DP]
        )
        try session.setActive(true)

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice =
            AVSpeechSynthesisVoice(language: Locale.current.language.languageCode?.identifier)
            ?? AVSpeechSynthesisVoice(language: "ru-RU")

        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
