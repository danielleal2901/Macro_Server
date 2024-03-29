//
//  CodableAlias.swift
//  Server
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/09/20.
//  Copyright © 2020 Daniel Leal. All rights reserved.
//

import Foundation

class  CoderHelper{
    
    /// MARK : Shared
    static let shared:CoderHelper = {
        let coder = CoderHelper()
        return coder
    }()
    
    // !! Change to accordingly to Intended Return Type !!
    /// Encode the Parameter Data to String
    /// - Parameter valueToDecode: Value that needs to be encoded
    /// - Returns: The value encoded in String
    func encodeDataToString<ValueType>(valueToEncode: ValueType) -> String where ValueType: Codable{
        do{
            let data = try JSONEncoder().encode(valueToEncode)
            //let message = URLSessionWebSocketTask.Message.data(data)
            let message = String(data: data, encoding: .utf8)
            return message!
        } catch(let error){
            print(error)
            return ""
        }
    }
    
    
    func encodeGenericToData<ValueType>(valueToEncode: ValueType) -> Data? where ValueType: Codable{
        do{
            let data = try JSONEncoder().encode(valueToEncode)
            return data
        } catch(let error){
            print(error)
            return nil
        }
    }
    
    // !! Change Datatype to Enum DataTypes and ValueToDecode to a generic relative !!
    
    /// Decode the Data Value to a intended Type passed as parameter
    /// - Parameters:
    ///   - valueToDecode: Value that needs to be decoded
    ///   - intendedType: Type to decode the passed value
    /// - Returns: Value decoded
    func decodeDataArray<Datatype>(valueToDecode: Data,intendedType: Datatype.Type) -> [Datatype]? where Datatype: Decodable{
        do{
            let data = try JSONDecoder().decode([Datatype].self, from: valueToDecode)
            return data
        } catch(let error){
            print(error)
            return nil
        }
    }
    
    // @gui
    // Vou mudar para uma simples função
    
    /// Decode the Data Value to a intended Type passed as parameter
    /// - Parameters:
    ///   - valueToDecode: Value that needs to be decoded
    ///   - intendedType: Type to decode the passed value
    /// - Returns: Value decoded
    func decodeDataSingle<Datatype>(valueToDecode: Data,intendedType: Datatype.Type) -> Datatype? where Datatype: Decodable{
        do{
            let data = try JSONDecoder().decode(Datatype.self, from: valueToDecode)
            return data
        } catch(let error){
            print(error)
            return nil
        }
    }
    
}
