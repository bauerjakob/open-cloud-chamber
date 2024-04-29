//
//  3dModelView.swift
//  OpenCloudChamber
//
//  Created by Jakob Bauer on 28.04.24.
//

import Foundation

//
//  CarModelView.swift
//  RemoteCarSteering
//
//  Created by Julian Baumann on 29.03.23.
//

import SwiftUI
import SceneKit

struct CloudChamberModelView: UIViewRepresentable {
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
    
    @Binding var rotation: Double
    
    @State var cameraNode = SCNNode()
    @State var scene = SCNScene.init(named: "CloudChamber.usdz")
    @State var modelNode: SCNNode?
    

    func makeUIView(context: Context) -> SCNView {
        cameraNode.camera = SCNCamera()
        scene?.rootNode.addChildNode(cameraNode)

        cameraNode.position = SCNVector3(x: 0, y: -0.5, z: 1.4)
        cameraNode.rotation.y = 100
        //cameraNode.camera?.zNear = 0.1
        //cameraNode.camera?.zFar =
        //cameraNode.eulerAngles.x = 220
        //cameraNode.eulerAngles.z = 90
        //cameraNode.camera?.automaticallyAdjustsZRange = true

        
        
        let view = SCNView()
        //view.allowsCameraControl = true
        view.isTemporalAntialiasingEnabled = true
        view.autoenablesDefaultLighting = true
        //view.antialiasingMode = .multisampling4X
        view.scene = scene
        //view.backgroundColor = .systemBackground
        view.allowsCameraControl = true
//        view.defaultCameraController.automaticTarget = true
//        view.defaultCameraController.minimumVerticalAngle = 90
//        view.defaultCameraController.maximumVerticalAngle = 90
//        view.defaultCameraController.minimumHorizontalAngle = 90
//        view.defaultCameraController.maximumHorizontalAngle = 90
        // view.defaultCameraController.interactionMode = .orbitTurntable
    
        let rootNode = scene?.rootNode.childNode(withName: "root", recursively: true)
        //rootNode?.eulerAngles.y = 4.6
        rootNode?.eulerAngles.y = (.pi / 2) * 3
        rootNode?.eulerAngles.x = (.pi / 2) * 3
        return view;
    }
    
    /*func updateUIView(_ uiView: UIViewType, context: Context) {
        var rotation = ((self.rotation) * 1.50) / 100
        rotation = Double(round(rotation * 1000) / 1000)
        let rootNode = scene?.rootNode.childNode(withName: "root", recursively: true)
        
        guard let rootNode = rootNode else {
            return;
        }
        print(rotation)
        
        rootNode.eulerAngles.y = Float(rotation)
    }*/
}

struct CloudChamberModelView_Previews: PreviewProvider {
    @State static var test = 90.0
    
    static var previews: some View {
        CloudChamberModelView(rotation: $test)
    }
}
