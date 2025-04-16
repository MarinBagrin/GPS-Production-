import UIKit

protocol Coordinator {
    var childCoordinators:[Coordinator] {get set}
    var navController:UINavigationController {get}
    var parrentCoordinator: Coordinator? {get set}
    var repositories:Repositories {get set}
    func start()
}

class MapCoordinator:Coordinator {
    var childCoordinators = [Coordinator]()
    var navController:UINavigationController
    var parrentCoordinator: Coordinator?
    var repositories:Repositories
    init(navController:UINavigationController, parrentCoordinator:Coordinator,repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
        
    }
    func removeFromSuperCoordinator() {
        parrentCoordinator?.start()
    }
    func start() {
        let mapVC = MapViewController(coordinator: self)
        navController.pushViewController(mapVC, animated: false)
    }
    
    func showSettingVC() {
        var settingsCoordinator = SettingsCoordinator(navController: navController, parrentCoordinator: self,repositories:repositories)
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
}

class SettingsCoordinator:Coordinator {
    var childCoordinators = [Coordinator]()
    var navController:UINavigationController
    var parrentCoordinator: Coordinator?
    var repositories: Repositories
    init(navController:UINavigationController, parrentCoordinator:Coordinator, repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
    }
    func removeFromSuperCoordinator() {
        for i in 0..<(parrentCoordinator?.childCoordinators.count ?? 0) {
            if parrentCoordinator?.childCoordinators[i] is SettingsCoordinator {
                parrentCoordinator?.childCoordinators.remove(at: i)
            }
        }
    }
    func start() {
        let settingsVC = SettingsViewController(coordinator: self)
        navController.pushViewController(settingsVC, animated: true)
    }
    func restartFlow() {
        navController.setViewControllers([], animated: true)
    }
    func popSettingsVC() {
        navController.popViewController(animated: true)
    }
}
