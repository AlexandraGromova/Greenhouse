import Foundation

class Pagination {
    
    private let repository: PlantsRepository
    
    init(repository: PlantsRepository) {
        self.repository = repository
        getTotalPages()
    }
    var totalPages = 1
    var page = 0
    
    func getTotalPages() {
        Task {
            let bufferValue = await repository.getTotalPages()
            DispatchQueue.main.async {
                self.totalPages = bufferValue
            }
        }
    }
    
    func getNewValuesPage() -> Int {
        if (page + 1) <= totalPages {
            page += 1
            return page
        }
        else {
            return page
        }
    }
}
