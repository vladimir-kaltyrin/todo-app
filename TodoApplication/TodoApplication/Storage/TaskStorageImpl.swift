import Foundation
import RealmSwift

final class TaskStorageImpl: TaskStorage {

    // MARK: - Private
    private let queue = DispatchQueue(label: "com.vkaltyrin.TaskStorageImpl.queue")

    // MARK: - TaskStorage
    func fetchTasks(listId: Identifier, _ completion: @escaping OnFetchTasks) {
        queue.async {
            let realm = try? Realm()
            let tasks = realm?.objects(RealmTask.self)
                .sorted(byKeyPath: "creationDate", ascending: false)
                .filter { $0.owner.first?.identifier == listId } ?? []

            if !tasks.isEmpty {
                completion(.success(tasks.map { $0.toTask() }))
            } else {
                completion(.failure(.cannotFetch))
            }
        }
    }

    func deleteTask(taskId: Identifier, _ completion: @escaping OnStorageResult) {
        queue.async {
            let realm = try? Realm()
            guard let taskForDelete = realm?.objects(RealmTask.self).first(where: { task in
                task.identifier == taskId
            }) else {
                completion(.failure(.cannotDelete))
                return
            }
            do {
                try realm?.write {
                    realm?.delete(taskForDelete)
                }
                completion(.success(()))
            } catch {
                completion(.failure(.internalError))
            }
        }
    }

    func createTask(_ task: Task, _ completion: @escaping OnStorageResult) {
        queue.async {
            let realm = try? Realm()
            let realmTask = task.toRealm()
            do {
                try realm?.write {
                    realm?.add(realmTask)
                }
                completion(.success(()))
            } catch {
                completion(.failure(.internalError))
            }
        }
    }

    func updateTask(_ task: Task, _ completion: @escaping OnStorageResult) {
        queue.async {
            let realm = try? Realm()
            guard let taskForUpdate = realm?.objects(RealmTask.self).first(where: { realmTask in
                realmTask.identifier == task.identifier
            }) else {
                completion(.failure(.cannotUpdate))
                return
            }
            do {
                try realm?.write {
                    taskForUpdate.name = task.name
                    taskForUpdate.status = task.status
                    taskForUpdate.creationDate = task.creationDate
                }
                completion(.success(()))
            } catch {
                completion(.failure(.internalError))
            }
        }
    }
}
