//
//  PeripheralCommunication.swift
//  OpenCloudChamber
//
//  Created by Jakob Bauer on 28.04.24.
//

import Foundation
import CoreBluetooth

import Foundation


class PeripheralCommunication: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    public static let shared = PeripheralCommunication()
    
    private let serviceUUID = CBUUID(string: "4DA3EDDD-048E-43E5-B6E0-FDD27CE3766B")
    private let coolerCharacteristicUUID = CBUUID(string: "05FE4E37-7332-48B2-BF94-19F13CC7FBC9")
    private let lightCharacteristicUUID = CBUUID(string: "31C855AF-CF65-4920-A1CD-8D510827389B")
    
    private var centralManager: CBCentralManager!
    private var peripheralESP: CBPeripheral?

    private var coolerCharacteristic: CBCharacteristic?
    private var lightCharacteristic: CBCharacteristic?

    @Published public var isPoweredOn = false
    @Published public var connected = false
    @Published public var connecting = false
    @Published public var connectedPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    func changeCooler(value: Int) {
        guard let coolerCharacteristic = self.coolerCharacteristic else {
            return
        }
        
        var state = value
        let stateData = Data(bytes: &state, count: MemoryLayout.size(ofValue: state))
        
        connectedPeripheral?.writeValue(stateData, for: coolerCharacteristic, type: .withResponse)
    }
    
    func changeLight(value: Int) {
        guard let coolerCharacteristic = self.coolerCharacteristic else {
            return
        }
        
        var state = value
        let stateData = Data(bytes: &state, count: MemoryLayout.size(ofValue: state))
        
        connectedPeripheral?.writeValue(stateData, for: coolerCharacteristic, type: .withResponse)
    }
    
    
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
        
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if connectedPeripheral == nil {
            connectedPeripheral = peripheral
            connecting = true
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager.stopScan()
        connected = true
        connecting = false
        connectedPeripheral?.delegate = self
        connectedPeripheral?.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics([coolerCharacteristicUUID, lightCharacteristicUUID], for: service)
        }
        
        print("Discovered Services: \(services)")
    }
        
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (error != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
            
        for characteristic in characteristics {
            if characteristic.uuid == coolerCharacteristicUUID {
                coolerCharacteristic = characteristic
            }
            else if characteristic.uuid == lightCharacteristicUUID {
                lightCharacteristic = characteristic
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        print(error ?? "Failed to connect to device")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = false
        connectedPeripheral = nil
        startScanning()
    }
        
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isPoweredOn = true
            startScanning()
        }
        else {
            isPoweredOn = false
        }
    }
}
