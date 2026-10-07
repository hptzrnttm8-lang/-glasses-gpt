import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: AssistantController

    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    LabeledContent("Meta", value: controller.metaStatus)
                    LabeledContent("Voice invocation", value: controller.assistantStatus)
                }

                Section("Step 1") {
                    Button("Register with Meta AI") {
                        Task { await controller.registerWithMeta() }
                    }
                }

                Section("Step 2") {
                    Button("Start Hey Meta test") {
                        Task { await controller.startVoiceInvocationTest() }
                    }

                    Button("Stop test", role: .destructive) {
                        controller.stopVoiceInvocationTest()
                    }
                }

                Section("Say to the glasses") {
                    Text("“Hey Meta, start GlassesGPT”")
                        .font(.headline)
                }

                if !controller.lastAnswer.isEmpty {
                    Section("Result") {
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
            .navigationTitle("GlassesGPT Test")
        }
    }
}
