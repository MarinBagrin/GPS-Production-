
import UIKit

class ArchieveCoordinator:Coordinator {
    var childCoordinators =  [Coordinator]()
    
    var navController: UINavigationController
    
    var parrentCoordinator: Coordinator?
    
    var repositories: Repositories
    
    
    init(navController:UINavigationController, parrentCoordinator:Coordinator, repositories:Repositories) {
        self.navController = navController
        self.parrentCoordinator = parrentCoordinator
        self.repositories = repositories
    }
    
    func start() {
        
    }
    func startWithViewModel(viewModel:MapViewModel) {
        var archiveVC = ArchiveViewController(viewModel,coordinator: self)
        archiveVC.modalPresentationStyle = .overCurrentContext
        navController.present(archiveVC, animated: true)
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
