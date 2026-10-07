import SwiftUI
import MWDATCore

@main
struct GlassesGPTApp: App {
    @StateObject private var controller = AssistantController()

    init() {
        do {
            try Wearables.configure()
        } catch {
            assertionFailure("Wearables.configure failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
                .task {
                    await controller.start()
                }
                .onOpenURL { url in
                    Task {
                        do {
                            _ = try await Wearables.shared.handleUrl(url)
                        } catch {
                            await controller.report(error)
                        }
                    }
                }
        }
    }
}
