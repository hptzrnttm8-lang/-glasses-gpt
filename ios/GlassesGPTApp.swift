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
                .onOpenURL { url in
                    guard
                        let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                        components.queryItems?.contains(where: { $0.name == "metaWearablesAction" }) == true
                    else {
                        return
                    }

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
