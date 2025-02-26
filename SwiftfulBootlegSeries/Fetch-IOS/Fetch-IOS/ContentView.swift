import SwiftUI

struct ContentView: View {
    @State private var deviceData: [DeviceData] = []
    @State private var filteredDeviceData: [DeviceData] = [] // Filtered data based on search
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    @State private var isAscending = true
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                VStack {
                    // Search bar to filter the list
                    TextField("Search", text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: searchText) { newQuery in
                            // Filter devices based on the search query and sort
                            filteredDeviceData = DeviceData.Search(devices: deviceData, query: newQuery, ascending: isAscending)
                        }
                    
                    // Sort button to toggle ascending/descending order
                    Image(systemName: "a.book.closed")
                        .onTapGesture {
                            isAscending.toggle()
                            // Reapply sorting after changing the sort order
                            filteredDeviceData = DeviceData.SortById(devices: filteredDeviceData, ascending: isAscending)
                        }
                        .padding()
                    
                    // List displaying filtered and sorted device data
                    List(filteredDeviceData, id: \.id) { device in
                        Text(device.name)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                do {
                    let fetchedData = try await NetworkManager.shared.ApiService()
                    deviceData = fetchedData
                    filteredDeviceData = DeviceData.SortById(devices: fetchedData, ascending: isAscending)
                    isLoading = false
                } catch {
                    errorMessage = "Failed to fetch device data: \(error)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
