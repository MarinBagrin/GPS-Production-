import UIKit

class AppCoordinator:Coordinator {
    var childCoordinators = [Coordinator]()
    var navController = UINavigationController()
    var parrentCoordinator: Coordinator?
    let window: UIWindow
    var repositories = Repositories()
    init(window:UIWindow) {
        self.window = window
    }
    func start() {
        childCoordinators = []
        let mapCoordinator = MapCoordinator(navController: navController, parrentCoordinator: self, repositories: repositories)
        childCoordinators.append(mapCoordinator)
        print(repositories.settings)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        mapCoordinator.start()
        
    }
    func restart() {
        
    }
}

struct Repositories {
    var network = NetworkRepositoryImpl()
    var settings:SettingsRepositoryImpl
    init() {
        settings = SettingsRepositoryImpl(networkRepository: network)
    }
}
