//
//  WSPackageData.swift
//
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/20.
//

import Foundation

internal struct WSDataPackage: Codable{
    
    // MARK - Variables
    internal private(set) var packageID: UUID
    
    internal private(set) var content: Data
    internal private(set) var dataType: DataTypes
    internal private(set) var containerID: UUID
    internal private(set) var destTeamID: UUID
    internal private(set) var respUserID: UUID
    internal private(set) var containerID: UUID
    internal private(set) var operation: Operations.RawValue
        
    // In doubt if using this type or another encoder
    private enum CodingKeys: String, CodingKey{
        case packageID
        case content
        case dataType
        case operation
        case containerID
        case destTeamID = "destination"
        case respUserID = "user"
    }
    
    // MARK - Initializer
    init(packageID: UUID,content: Data,dataType: DataTypes,destTeamID: UUID,respUserID: UUID,operation: Int,containerID: UUID){
        self.packageID = packageID
        self.content = content
        self.dataType = dataType
        self.destTeamID = destTeamID
        self.respUserID = respUserID
        self.operation = operation
        self.containerID = containerID
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        packageID = try values.decode(UUID.self,forKey: .packageID)
        content = try values.decode(Data.self,forKey:  .content)
        dataType = try values.decode(DataTypes.self,forKey: .dataType)
        destTeamID = try values.decode(UUID.self,forKey: .destTeamID)
        respUserID = try values.decode(UUID.self,forKey: .respUserID)
        operation = try values.decode(Int.self, forKey: .operation)
        containerID = try values.decode(UUID.self,forKey: .containerID)
    }
    
}
