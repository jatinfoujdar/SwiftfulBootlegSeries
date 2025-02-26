import Foundation



struct DeviceData: Codable {
    
    let id: String
    let name: String
    let data: ItemData?
    
    
    struct ItemData: Codable{
        let color: String?
        let capacity: String?
        let price: Double?
        let capacityGB: Int?
        let screenSize: Double?
        let description: String?
        let generation: String?
        let strapColour: String?
        let caseSize: String?
        let cpuModel: String?
        let hardDiskSize: String?
        
        enum CodingKeys: String, CodingKey {
            case color
            case capacity
            case price
            case capacityGB = "capacity GB"
            case screenSize = "Screen size"
            case description = "Description"
            case generation = "Generation"
            case strapColour = "Strap Colour"
            case caseSize = "Case Size"
            case cpuModel = "CPU model"
            case hardDiskSize = "Hard disk size"
        }
    }
    
    static func SortById(devices: [DeviceData], ascending: Bool) -> [DeviceData]{
        return devices.sorted { ascending ?  $0.id < $1.id :  $0.id > $1.id }
    }
    
    
    static func Search(devices: [DeviceData], query: String, ascending: Bool) -> [DeviceData]{
        if query .isEmpty{
            return devices.sorted { ascending ?  $0.id < $1.id :  $0.id > $1.id }
        }else{
            let filteredDevices =  devices.filter{ device in
                device.name.lowercased().contains(query.lowercased())
            }
            return SortById(devices: filteredDevices, ascending: ascending)
        }
    }
    
}
