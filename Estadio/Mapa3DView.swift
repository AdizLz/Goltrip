import SwiftUI
import SceneKit

struct Mapa3DView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: String = "Todos"
    @State private var showInfo = false
    @State private var selectedLocation: StadiumLocate?
    
    let categories = ["Todos", "Asientos", "Restaurantes", "Tiendas", "Baños", "Estacionamiento"]
    
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.11, blue: 0.17)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("Mapa 3D Interactivo")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Estadio BBVA")
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                .padding()
                .background(Color(red: 0.15, green: 0.17, blue: 0.22))
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == category ?
                                        Color.blue : Color(red: 0.2, green: 0.23, blue: 0.3)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(red: 0.12, green: 0.14, blue: 0.19))
                
                // 3D Scene
                ZStack {
                    StadiumSceneView(selectedCategory: $selectedCategory, selectedLocation: $selectedLocation)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    // Controls Overlay
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 20) {
                            ControlButton(icon: "minus.magnifyingglass", label: "Alejar")
                            ControlButton(icon: "arrow.clockwise", label: "Rotar")
                            ControlButton(icon: "plus.magnifyingglass", label: "Acercar")
                        }
                        .padding()
                        .background(Color(red: 0.15, green: 0.17, blue: 0.22).opacity(0.9))
                        .cornerRadius(16)
                        .padding()
                    }
                }
            }
            
            // Info Panel
            if showInfo {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showInfo = false
                    }
                
                VStack {
                    Spacer()
                    InfoPanel(isShowing: $showInfo)
                        .transition(.move(edge: .bottom))
                }
            }
            
            // Location Detail
            if let location = selectedLocation {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedLocation = nil
                    }
                
                VStack {
                    Spacer()
                    LocationDetailPanel(location: location, isShowing: $selectedLocation)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.spring(), value: showInfo) // ✅ animación corregida
    }
}

struct StadiumSceneView: UIViewRepresentable {
    @Binding var selectedCategory: String
    @Binding var selectedLocation: StadiumLocate?
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = createStadiumScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor(red: 0.09, green: 0.11, blue: 0.17, alpha: 1.0)
        scnView.showsStatistics = false
        
        // Configurar cámara
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 30)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
        scnView.scene?.rootNode.addChildNode(cameraNode)
        
        // Agregar gesture recognizer para tap
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        updateNodeVisibility(in: uiView.scene, for: selectedCategory)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: StadiumSceneView
        
        init(_ parent: StadiumSceneView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let scnView = gestureRecognizer.view as! SCNView
            let location = gestureRecognizer.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [:])
            
            if let result = hitResults.first,
               let name = result.node.name,
               name.starts(with: "marker_") {
                let parts = name.components(separatedBy: "_")
                if parts.count >= 3 {
                    parent.selectedLocation = StadiumLocate(
                        name: parts[1],
                        type: parts[2],
                        description: "Información detallada sobre \(parts[1])"
                    )
                }
            }
        }
    }
    
    func createStadiumScene() -> SCNScene {
        let scene = SCNScene()
        
        // Campo de fútbol
        let fieldGeometry = SCNBox(width: 20, height: 0.2, length: 30, chamferRadius: 0)
        fieldGeometry.firstMaterial?.diffuse.contents = UIColor.systemGreen
        let fieldNode = SCNNode(geometry: fieldGeometry)
        fieldNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(fieldNode)
        
        // Líneas del campo
        let lineGeometry = SCNBox(width: 20, height: 0.21, length: 0.2, chamferRadius: 0)
        lineGeometry.firstMaterial?.diffuse.contents = UIColor.white
        let centerLine = SCNNode(geometry: lineGeometry)
        centerLine.position = SCNVector3(x: 0, y: 0.1, z: 0)
        scene.rootNode.addChildNode(centerLine)
        
        // Gradas
        createStands(scene: scene, x: 0, z: 17, width: 24, name: "Norte")
        createStands(scene: scene, x: 0, z: -17, width: 24, name: "Sur")
        let eastStands = createStands(scene: scene, x: 12, z: 0, width: 30, name: "Este")
        eastStands.eulerAngles.y = .pi / 2
        let westStands = createStands(scene: scene, x: -12, z: 0, width: 30, name: "Oeste")
        westStands.eulerAngles.y = .pi / 2
        
        // Marcadores
        addLocationMarker(to: scene, position: SCNVector3(x: 8, y: 2, z: 15), name: "Restaurante_1", type: "Restaurantes", color: .systemOrange)
        addLocationMarker(to: scene, position: SCNVector3(x: -8, y: 2, z: 15), name: "Tienda_1", type: "Tiendas", color: .systemPurple)
        addLocationMarker(to: scene, position: SCNVector3(x: 10, y: 1, z: 0), name: "Baños_1", type: "Baños", color: .systemCyan)
        addLocationMarker(to: scene, position: SCNVector3(x: -10, y: 1, z: 0), name: "Baños_2", type: "Baños", color: .systemCyan)
        addLocationMarker(to: scene, position: SCNVector3(x: 0, y: 2, z: -15), name: "Estacionamiento", type: "Estacionamiento", color: .systemGreen)
        
        return scene
    }
    
    @discardableResult
    func createStands(scene: SCNScene, x: Float, z: Float, width: Float, name: String) -> SCNNode {
        let standsNode = SCNNode()
        standsNode.position = SCNVector3(x: x, y: 0, z: z)
        standsNode.name = "stands_\(name)"
        
        for i in 0..<5 {
            let level = SCNBox(width: CGFloat(width), height: 1.5, length: 2, chamferRadius: 0)
            level.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.4, blue: 0.8, alpha: 1.0)
            let levelNode = SCNNode(geometry: level)
            levelNode.position = SCNVector3(x: 0, y: Float(i) * 2, z: Float(i) * -1.5)
            standsNode.addChildNode(levelNode)
        }
        
        scene.rootNode.addChildNode(standsNode)
        return standsNode
    }
    
    func addLocationMarker(to scene: SCNScene, position: SCNVector3, name: String, type: String, color: UIColor) {
        let sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial?.diffuse.contents = color
        sphere.firstMaterial?.emission.contents = color
        
        let markerNode = SCNNode(geometry: sphere)
        markerNode.position = position
        markerNode.name = "marker_\(name)_\(type)"
        
        let scaleUp = SCNAction.scale(to: 1.2, duration: 0.8)
        let scaleDown = SCNAction.scale(to: 1.0, duration: 0.8)
        let pulse = SCNAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SCNAction.repeatForever(pulse)
        markerNode.runAction(repeatPulse)
        
        scene.rootNode.addChildNode(markerNode)
        
        let iconPlane = SCNPlane(width: 1, height: 1)
        iconPlane.firstMaterial?.diffuse.contents = color
        iconPlane.firstMaterial?.lightingModel = .constant
        
        let iconNode = SCNNode(geometry: iconPlane)
        iconNode.position = SCNVector3(x: 0, y: 1.5, z: 0)
        iconNode.constraints = [SCNBillboardConstraint()]
        markerNode.addChildNode(iconNode)
    }
    
    func updateNodeVisibility(in scene: SCNScene?, for category: String) {
        guard let scene = scene else { return }
        
        scene.rootNode.enumerateChildNodes { node, _ in
            if let name = node.name, name.starts(with: "marker_") {
                if category == "Todos" {
                    node.opacity = 1.0
                } else {
                    node.opacity = name.contains(category) ? 1.0 : 0.3
                }
            }
        }
    }
}

struct StadiumLocate: Identifiable, Equatable { // ✅ agregado Equatable
    let id = UUID()
    let name: String
    let type: String
    let description: String
}

struct ControlButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
        .background(Color(red: 0.2, green: 0.23, blue: 0.3))
        .cornerRadius(12)
    }
}

struct InfoPanel: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Guía de Uso")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(Color(red: 0.2, green: 0.23, blue: 0.3))
                        .clipShape(Circle())
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                InfoRows(icon: "hand.point.up.left.fill", text: "Toca y arrastra para rotar el estadio")
                InfoRows(icon: "arrow.up.left.and.arrow.down.right", text: "Pellizca para hacer zoom")
                InfoRows(icon: "hand.tap.fill", text: "Toca los marcadores para ver más información")
                InfoRows(icon: "line.3.horizontal.decrease.circle", text: "Usa los filtros para ver categorías específicas")
            }
            
            Spacer()
        }
        .padding()
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding()
    }
}

struct InfoRows: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
    }
}

struct LocationDetailPanel: View {
    let location: StadiumLocate
    @Binding var isShowing: StadiumLocate?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(location.type)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: {
                    isShowing = nil
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(Color(red: 0.2, green: 0.23, blue: 0.3))
                        .clipShape(Circle())
                }
            }
            
            Text(location.description)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("Cómo llegar")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Más info")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.2, green: 0.23, blue: 0.3))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding()
    }
}

struct Mapa3DView_Previews: PreviewProvider {
    static var previews: some View {
        Mapa3DView()
    }
}
