import Foundation

protocol ListRouter: class {
    func openTasks()
}

final class ListRouterImpl: ListRouter {
    private unowned let transitionHandler: TransitionHandler

    init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }

    func openTasks() {

    }
}