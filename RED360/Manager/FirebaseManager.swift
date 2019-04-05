//
//  FirebaseManager.swift
//  RED360
//
//  Created by Argo Solucoes on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import HandyJSON
import FirebaseFirestore
import PromiseKit

struct FirebaseManager<Model: HandyJSON & ModelType> {
    
    var model: Model?
    typealias SubCollection = SubCollectionType
    
    static var reference: Firestore {
        return Firestore.firestore()
    }
    
    static func get(uid: String, completion: @escaping (_ modelType: Model) -> Void) {
        
        let referenceModel = reference.collection("\(Model.modelName)".lowercased()).document(uid)
        
        referenceModel.getDocument { snapshot, error in
            guard let snapshot = snapshot else { return }
            if snapshot.exists {
                if let error = error {
                    return print(error.localizedDescription)
                }
                guard let model = Model.deserialize(from: snapshot.data()) else { return }
                completion(model)
            }
        }
    }
    
    static func get<T:SubCollectionType & HandyJSON>(uid: String, uidSubCollection: String, completion: @escaping (_ modelType: T) -> Void) {
        
        let referenceModel = reference.collection("\(Model.modelName)".lowercased())
            .document(uid)
            .collection("\(T.entitySubCollectionName)".lowercased())
            .document(uidSubCollection)
        
        referenceModel.getDocument { snapshot, error in
            
            if let error = error {
                return print(error.localizedDescription)
            }
            guard let model = T.deserialize(from: snapshot?.data()) else { return }
            completion(model)
        }
    }
    enum EnabledRealTime {
        case tour
        case attraction
    }
    
    static func allSubCollections<SubModel: SubCollectionType & HandyJSON>(uid: String, enabledRealTime: EnabledRealTime = .attraction, completion: @escaping (_ models: [SubModel]) -> Void) {
        
        if enabledRealTime == .tour {
            
            let referenceModel = reference.collection("\(Model.modelName)".lowercased()).document(uid)
            referenceModel.collection("\(SubModel.entitySubCollectionName.lowercased())").addSnapshotListener { (snapshot, error) in
                guard let documents = snapshot?.documents else { return }
                let datas = documents.map { $0.data() }
                let models = datas.compactMap { SubModel.deserialize(from: $0)}
                completion(models)
            }
        } else {
            
            let referenceModel = reference.collection("\(Model.modelName)".lowercased()).document(uid)
            referenceModel.collection("\(SubModel.entitySubCollectionName.lowercased())").getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else { return }
                let datas = documents.map { $0.data() }
                let models = datas.compactMap { SubModel.deserialize(from: $0)}
                completion(models)
            }
        }
    }
    
    static func allSubCollections<SubModel: SubCollectionType & HandyJSON, T: ModelType>(rootId: String, subCollectionId: String, type: T.Type, completion: @escaping (_ models: [SubModel]) -> Void) {
        
        print(Model.modelName.lowercased())
        print(T.modelName.lowercased())
        print(SubModel.entitySubCollectionName.lowercased())
        let referenceModel = reference.collection("\(Model.modelName.lowercased())".lowercased())
            .document(rootId)
            .collection("\(T.modelName.lowercased())")
            .document(subCollectionId)
        
        referenceModel.collection("\(SubModel.entitySubCollectionName.lowercased())").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            let datas = documents.map { $0.data() }
            let models = datas.compactMap { SubModel.deserialize(from: $0)}
            completion(models)
        }
    }
}



