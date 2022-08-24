//
//  Presenter.swift
//  IOS6-HW26-AlekseiKudinov
//
//  Created by Алексей Кудинов on 24.08.2022.
//

import CoreData

protocol PresenterInput {
    var numberOfProducts: Int { get }
    func loadUsers()
    func user(forRow row: Int) -> NSManagedObject?
    func addObject(name: String, birthday: String?, gender: String?)
    func updateInfoObject(row: Int, name: String, birthday: String?, gender: String?)
    func deleteObject(row: Int)
}

protocol PresenterOutput: AnyObject {
    func updateUsers()
}

class Presenter: PresenterInput {

    weak var view: PresenterOutput?
    private var users: [NSManagedObject] = []
    private var model: ModelInput

    init(view: PresenterOutput) {
        self.view = view
        self.model = Model()
    }

    var numberOfProducts: Int {
        users.count
    }

    func loadUsers() {
        model.fetchAllUsers { [weak self] peoples in
            self?.users = peoples ?? []
            self?.view?.updateUsers()
        }
    }

    func user(forRow row: Int) -> NSManagedObject? {
        guard row < users.count else { return nil }
        return users[row]
    }

    func addObject(name: String, birthday: String?, gender: String?) {
        model.addObject(name: name,
                        birthday: birthday ?? "",
                        gender: gender ?? ""
        )
        loadUsers()
    }

    func updateInfoObject(row: Int, name: String, birthday: String?, gender: String?) {
        model.updateInfoObject(row: row,
                               name: name,
                               birthday: birthday ?? "",
                               gender: gender ?? ""
        )
        loadUsers()
    }

    func deleteObject(row: Int) {
        model.deleteObject(row: row)
        loadUsers()
    }
}
