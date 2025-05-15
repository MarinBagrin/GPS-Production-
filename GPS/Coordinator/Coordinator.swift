import UIKit

protocol Coordinator {
    var childCoordinators:[Coordinator] {get set}
    var navController:UINavigationController {get}
    var parrentCoordinator: Coordinator? {get set}
    var repositories:Repositories {get set}
    func start()
    func restart()
}

class MapCoordinator:Coordinator {
    var childCoordinators = [Coordinator]()
    var navController:UINavigationController
    var parrentCoordinator: Coordinator?
    var repositories:Repositories
    var isStarted = false
    init(navController:UINavigationController, parrentCoordinator:Coordinator,repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
        bind()
    }
    private func bind() {
        self.repositories.network.stateAuthenticated.bind { [weak self] stateAuth in
            guard let self = self else {print("returnMCBind");return;}
            start()
            if stateAuth == .no  {
                var isContainAuthCoord = false
                for coord in childCoordinators {
                    if coord is AuthenticateCoordinator {
                        isContainAuthCoord = true
                        break
                    }
                }
                if !isContainAuthCoord {
                    showAuthenticateVC()
                }
            }
        }
    }
    func removeFromSuperCoordinator() {
        parrentCoordinator?.restart()
    }
    func start() {
        if !isStarted {
            let mapVC = MapViewController(coordinator: self)
            navController.pushViewController(mapVC, animated: false)
            isStarted = true
        }
    }
    func restart(){
        
    }
    func showArchieveVC(viewModel:MapViewModel) {
        let archieveCoordinator = ArchieveCoordinator(navController: navController, parrentCoordinator: self, repositories: repositories)
        childCoordinators.append(archieveCoordinator)
        archieveCoordinator.startWithViewModel(viewModel: viewModel)
        
    }
    func showSettingVC() {
        let settingsCoordinator = SettingsCoordinator(navController: navController, parrentCoordinator: self,repositories:repositories)
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
    func showAuthenticateVC() {
        if repositories.network.stateAuthenticated.value == .no {
            let authenticateCoordinator = AuthenticateCoordinator(navController: navController, parrentCoordinator: self, repositories: repositories)
            childCoordinators.append(authenticateCoordinator)
            authenticateCoordinator.start()
        }
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
        //parrentCoordinator = nil
    }
    func start() {
        let settingsVC = SettingsViewController(coordinator: self)
        navController.pushViewController(settingsVC, animated: true)
    }
    func restart(){}
    func restartFlow() {
        print("SettingsCoordinator.restart() запущен.")
        navController.viewControllers.removeAll()
    }
    
    func popSettingsVC() {
        navController.popViewController(animated: true)
    }
    
}
