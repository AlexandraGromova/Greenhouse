import Foundation
import Combine

class GetPlantsUC {
    
    private let plantsRepository: PlantsRepository
    private let pagination: Pagination
    
    init(plantsRepository: PlantsRepository, pagination: Pagination) {
        self.plantsRepository = plantsRepository
        self.pagination = pagination
    }
    
    func execute() -> AnyPublisher<[UIPlant], Never> {
        return plantsRepository.getPlantsFromStorage()
    }
    
    func tryUpdatePlants() async -> Bool  {
        let error = await plantsRepository.tryUpdatePlants(currentPage: pagination.getNewValuesPage())
        if error != nil {
            return false
        }
        else {
            return true
        }
    }
}
