import UIKit

class AuthenticateCoordinator:Coordinator {
    var childCoordinators:[Coordinator] = []
    var navController:UINavigationController
    var parrentCoordinator: Coordinator?
    var repositories:Repositories
    
    init(navController: UINavigationController, parrentCoordinator:Coordinator, repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
        
        bind()
    }
    
    private func bind() {

        repositories.network.stateAuthenticated.bind { [weak self] stateAuthenticated in
            guard let self = self else {return}
            if stateAuthenticated == .yes {
                removeFromSuperCoordinator()
            }
        }
    }
    func start() {
        print("start coordinator auth")
        let authenticateController = AuthenticateController(MapViewModel(repositories: repositories), coordinator: self)
        authenticateController.modalPresentationStyle = .overCurrentContext
        navController.present(authenticateController, animated: true)
        
    }
    func restart() {
        
    }
    private func removeFromSuperCoordinator() {
        for i in 0..<(parrentCoordinator?.childCoordinators.count ?? 0) {
            if let coord = parrentCoordinator?.childCoordinators[i] as? AuthenticateCoordinator, coord === self {
                parrentCoordinator?.childCoordinators.remove(at: i)
            }
        }
    }
}

