import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: AssistantController

    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    LabeledContent("Meta", value: controller.metaStatus)
                    LabeledContent("Assistant", value: controller.assistantStatus)
                }

                Section("One-time setup") {
                    Button("Register with Meta") {
                        Task { await controller.registerWithMeta() }
                    }

                    Button("Grant microphone permission") {
                        Task { await controller.requestMicrophonePermission() }
                    }
                }

                if !controller.lastHeard.isEmpty {
                    Section("Last heard") {
                        Text(controller.lastHeard)
                    }
                }

                if !controller.lastAnswer.isEmpty {
                    Section("Last answer") {
                        Text(controller.lastAnswer)
                    }
                }

                if let error = controller.lastError {
                    Section("Error") {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Glasses GPT")
        }
    }
}
