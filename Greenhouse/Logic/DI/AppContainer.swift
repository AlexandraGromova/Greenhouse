import Foundation
import Swinject

class AppContainer {
    
    static private let container = Container()
    
    static func setup() {
        container.register(RemouteSource.self) { r in
            RemouteSource()
        }
        container.register(LocalSource.self) { r in
            LocalSource()
        }.inObjectScope(.container)
//        container.register(Pagination.self) { r in
//            Pagination(repository: r.resolve(PlantsRepository.self)!, searchRepository: r.resolve(SearchPlantsRepository.self)!)
//        }
        container.register(PlantsRepository.self) { r in
            PlantsRepository(remouteSource: r.resolve(RemouteSource.self)!, localSource: r.resolve(LocalSource.self)!)
        }
        container.register(SearchPlantsRepository.self) { r in
            SearchPlantsRepository(remouteSource: r.resolve(RemouteSource.self)!)
        }
        container.register(FavoriteListRepository.self) { r in
            FavoriteListRepository(localSourse: r.resolve(LocalSource.self)!, remouteSource: r.resolve(RemouteSource.self)!)
        }
        container.register(FavoriteListVM.self) { r in
            FavoriteListVM(repository: r.resolve(FavoriteListRepository.self)!)
        }
        container.register(GetPlantsUC.self) { r in
            GetPlantsUC(plantsRepository: r.resolve(PlantsRepository.self)! )
        }
        container.register(GetFavPlantsUC.self) { r in
            GetFavPlantsUC(repository: r.resolve(FavoriteListRepository.self)!)
        }
        container.register(GetSearchPlantsUC.self) { r in
            GetSearchPlantsUC(plantsRepository: r.resolve(SearchPlantsRepository.self)!)
        }
        container.register(GetPlantDetailsUC.self) { r in
            GetPlantDetailsUC(plantRepository: r.resolve(PlantDetailsRepository.self)!)
        }
        container.register(PlantDetailsRepository.self) { r in
            PlantDetailsRepository(remouteSource: r.resolve(RemouteSource.self)!, localSource: r.resolve(LocalSource.self)!)
        }
        
        container.register(PlantsListVM.self) { r in
            PlantsListVM(getPlantsUC: r.resolve(GetPlantsUC.self)!, getSearchPlantsUC: r.resolve(GetSearchPlantsUC.self)!, getFavPlantsUC: r.resolve(GetFavPlantsUC.self)!, getPlantDetailsUC: r.resolve(GetPlantDetailsUC.self)!)
        }
        container.register(PlantDetailsVM.self) { r in
            PlantDetailsVM(getPlantDetailsUC: r.resolve(GetPlantDetailsUC.self)!)
        }
    }
    
    static func resolve<T>(_ serviceType: T.Type) -> T {
        return container.resolve(serviceType)!
    }
}
