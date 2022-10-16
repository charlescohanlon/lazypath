//
//  ContentView.swift
//  lazypath
//
//  Created by Jasper O'Hanlon on 10/16/22.
//

import SwiftUI
import CoreBluetooth
import CoreLocation


class BluetoothViewModal: NSObject {
    private var peripheral: CBPeripheralManager? = nil
    
    
    func broadcast() {
        
        // code to stop advertising
//        if peripheral?.isAdvertising == true {
//            print("Peripheral is advertising!")
//            peripheral?.stopAdvertising()
//        } else {
//            print("Peripheral is not advertising")
//        }
        
        let br = createBeaconRegion()
        advertiseDevice(region: br)
    }
    
    func createBeaconRegion() -> CLBeaconRegion {
        let uuid = UUID(uuidString: "FFAA0105-BBDD-EE0D-16ED-FE02000513B3")!
        let major: CLBeaconMajorValue = 100
        let beaconID = "com.example.myDeviceRegion"
        return CLBeaconRegion(uuid: uuid, major: major, identifier: beaconID)
    }
    
    func advertiseDevice(region : CLBeaconRegion) {
        let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
        if peripheral == nil {
            peripheral = CBPeripheralManager(delegate: self, queue: nil)
        } else if (peripheral?.state == .poweredOn) {
            let peripheralData = region.peripheralData(withMeasuredPower: nil)
            print(peripheralData)
            peripheral?.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
        }
    }
}

extension BluetoothViewModal: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("Peripheral state changed to ", peripheral.state)
    }
}

struct ContentView: View {
    private var bluetoothViewModel = BluetoothViewModal()

    var buttonText = "Start"
    var state = 0
    var body: some View {
        HStack {
            Button(action: () -> () {
                bluetoothViewModel.broadcast
    
            }
            ){
                Text(buttonText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
