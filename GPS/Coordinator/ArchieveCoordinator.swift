
import UIKit

class ArchieveCoordinator:Coordinator {
    var childCoordinators =  [Coordinator]()
    
    var navController: UINavigationController
    
    var parrentCoordinator: Coordinator?
    
    var repositories: Repositories
    
    private var archiveVC:ArchiveViewController?

    
    init(navController:UINavigationController, parrentCoordinator:Coordinator, repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
    }
    
    func start() {
        
    }
    func startWithViewModel(viewModel:MapViewModel) {
        archiveVC = ArchiveViewController(viewModel,coordinator: self)
        archiveVC?.coordinator = self
        archiveVC?.modalPresentationStyle = .overCurrentContext
        navController.present(archiveVC!, animated: true)
    }
    func closeArchiveVC() {
        archiveVC?.dismiss(animated: true)
        
    }
    func removeFromParrentCoordinator() {
        for i in 0..<(parrentCoordinator?.childCoordinators.count ?? 0) {
            if(parrentCoordinator?.childCoordinators[i] is ArchieveCoordinator) {
                parrentCoordinator?.childCoordinators.remove(at: i)
            }
        }
    }
    func restart() {
        
    }
    
    
}
