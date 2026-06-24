//
//  Asistente.swift
//  ArcaContinental
//
//  Created by Damaris B on 15/06/25.
//

import SwiftUI

// MARK: - 📝 BASE DE CONOCIMIENTOS (EDITA AQUÍ)
struct KnowledgeBase {
    
    // ✏️ AGREGA O EDITA TUS PREGUNTAS Y RESPUESTAS AQUÍ
    static let qaDatabase: [QAPair] = [
        // LUGARES TURÍSTICOS
        QAPair(
            keywords: ["macroplaza", "plaza", "gran plaza", "centro"],
            response: """
            📍 **MACROPLAZA (Gran Plaza)**
            
            • Una de las plazas más grandes del mundo
            • **Horario:** Abierto 24/7
            • **Costo:** GRATIS ✅
            • **Ubicación:** Centro de Monterrey (entre Zaragoza y 5 de Mayo)
            
            **Qué ver:**
            🗼 Faro del Comercio
            ⛪ Catedral Metropolitana
            🏛️ Palacio de Gobierno
            ⛲ Fuentes danzantes
            
            **Tips:**
            • Visita de tarde-noche cuando está iluminada
            • Eventos culturales gratuitos los fines de semana
            • **Cómo llegar:** Metro Línea 2 estación Zaragoza o Cuauhtémoc
            """
        ),
        
        QAPair(
            keywords: ["fundidora", "parque fundidora"],
            response: """
            🌳 **PARQUE FUNDIDORA**
            
            Antiguo complejo industrial ahora parque urbano de 142 hectáreas
            
            • **Horario:** 6:00 AM - 11:00 PM todos los días
            • **Costo:** Entrada GRATIS ✅
            • **Ubicación:** Av. Fundidora y Adolfo Prieto
            
            **Atracciones:**
            🚣 Paseo Santa Lucía
            🏭 Horno 3 (museo)
            🏞️ Lagos artificiales
            🚴 Ciclovía (14 km)
            🎨 Museo del Acero
            
            **Precios:**
            • Renta de bicicletas: $80/hora
            • Paseo en lancha: $80
            
            **Cómo llegar:** Metro Línea 2, estación Y Griega o Parque Fundidora
            """
        ),
        
        QAPair(
            keywords: ["cerro", "silla", "cerro de la silla", "montaña", "hiking"],
            response: """
            🏔️ **CERRO DE LA SILLA**
            
            Símbolo icónico de Monterrey con forma de silla de montar
            
            • **Horario recomendado:** 6:00-10:00 AM
            • **Costo:** GRATIS ✅
            • **Ubicación:** Guadalupe, NL (empieza en La Huasteca)
            • **Dificultad:** Media-Alta
            • **Tiempo de subida:** 2-3 horas
            • **Altura:** 1,820 metros
            
            **⚠️ Requisitos:**
            ✅ 2 litros de agua mínimo
            ✅ Bloqueador solar
            ✅ Tenis de montaña
            ✅ Snacks energéticos
            ✅ NO vayas solo
            
            **Vista:** Panorámica espectacular de toda la ciudad
            **Transporte:** Uber o auto hasta La Huasteca
            """
        ),
        
        QAPair(
            keywords: ["museo", "marco", "arte"],
            response: """
            🎨 **MUSEO MARCO (Arte Contemporáneo)**
            
            Principal museo de arte contemporáneo del noreste de México
            
            • **Horario:** Martes-Domingo 10:00 AM - 6:00 PM
            • **Cerrado:** Lunes
            • **Ubicación:** Zuazua y Jardón, Centro (junto a Macroplaza)
            
            **💰 Precios:**
            • General: $70
            • Estudiantes/Maestros: $35
            • **MIÉRCOLES GRATIS** ✅
            
            **Exposiciones:**
            • Arte contemporáneo internacional
            • Artistas mexicanos reconocidos
            • Exposiciones temporales
            
            **Tips:**
            • Visita el miércoles para entrada gratis
            • Hay café en el patio interior
            • **Cómo llegar:** Metro Zaragoza, camina 5 minutos
            """
        ),
        
        QAPair(
            keywords: ["cascada", "cola de caballo", "santiago", "naturaleza"],
            response: """
            💦 **CASCADA COLA DE CABALLO**
            
            Cascada natural de 25 metros en el Parque Nacional Cumbres de Monterrey
            
            • **Horario:** 9:00 AM - 6:00 PM
            • **Costo:** $50 entrada del parque
            • **Ubicación:** Villa de Santiago (45 min-1 hora del centro)
            
            **🎯 Actividades:**
            🚶 Senderismo
            🐴 Paseo a caballo ($200)
            🪂 Zip-line
            📸 Fotografía
            
            **Tips:**
            • Llega temprano (9-10 AM) para evitar multitudes
            • **Mejor época:** Julio-Septiembre (temporada de lluvias, más caudalosa)
            • Lleva efectivo, NO hay cajeros
            • Ropa cómoda y tenis
            
            **Transporte:** Auto propio o tour organizado
            """
        ),
        
        QAPair(
            keywords: ["paseo santa lucia", "lancha", "canal"],
            response: """
            🚣 **PASEO SANTA LUCÍA**
            
            Canal artificial navegable de 2.5 km que conecta dos puntos icónicos de Monterrey
            
            • **Horario:** 10:00 AM - 10:00 PM
            • **Costo:** $70-80 por persona (40 minutos)
            • **Ruta:** Parque Fundidora ↔ Macroplaza
            
            **🌟 Experiencia:**
            • Paseo en lancha con guía
            • Vista de fuentes y jardines
            • Música ambiental
            • Ideal para parejas y familias
            
            **Tips:**
            • Paseo romántico al atardecer 🌅
            • Hay restaurantes a lo largo del canal
            • Compra boletos en taquillas de ambos extremos
            
            **Cómo llegar:** Metro Fundidora o Zaragoza
            """
        ),
        
        // ESTADIO BBVA
        QAPair(
            keywords: ["estadio", "bbva", "rayados", "futbol", "fútbol", "partido"],
            response: """
            🏟️ **ESTADIO BBVA - GUÍA COMPLETA**
            
            📍 **Ubicación:** Ave. Pablo Livas 2011, Col. La Pastora, Guadalupe, NL
            
            **🎫 SECCIONES:**
            
            **1️⃣ PALCOS** (Mejor vista)
            • Nivel intermedio, vista central
            • Acceso: Puertas 5 y 6
            • Incluye: Baños privados, buffet, A/C
            
            **2️⃣ PREFERENTE** (Recomendado)
            • Nivel inferior, cerca del campo
            • Acceso: Puertas 1, 2, 3, 4
            • Secciones: 100-130
            
            **3️⃣ GENERAL** (Económico)
            • Nivel superior, vista panorámica
            • Acceso: Puertas 7, 8, 9, 10
            • Secciones: 200-230
            
            **4️⃣ TRIBUNA SUR** - Furia Azul (Porra)
            • Extremo sur del estadio
            • Acceso: Puerta 11
            • Solo afición Rayados
            
            **🚗 Estacionamiento:** $100-200 (llega 1-2 hrs antes)
            **🚇 Metro:** Línea 2, Estación "Estadio" (5 min caminando)
            **🍔 Comida:** 4 Food Courts (Puertas 2, 4, 7, 9)
            **📶 WiFi:** Gratis en todo el estadio
            """
        ),
        
        // RESTAURANTES
        QAPair(
            keywords: ["comer", "comida", "restaurante", "tacos", "donde comer"],
            response: """
            🌮 **MEJORES TACOS DE MONTERREY**
            
            **Taquería Orinoco**
            • Especialidad: Cabrito y machaca
            • Precio: $$
            • Ubicación: Av. Lázaro Cárdenas
            
            **Tacos El Gordo**
            • Especialidad: Adobada estilo Tijuana
            • Abierto 24 horas
            • Precio: $
            
            **El Gran Pastor**
            • Especialidad: Pastor al carbón
            • Famosa salsa de aguacate
            • Precio: $
            
            **Tacos Don Poncho**
            • Clásico regio
            • Bistek y pastor
            • Precio: $
            
            💰 Precio promedio por taco: $15-25
            """
        ),
        
        QAPair(
            keywords: ["cabrito", "carne tipica", "comida típica", "tradicional"],
            response: """
            🐐 **CABRITO - PLATILLO TRADICIONAL REGIO**
            
            **El Rey del Cabrito** ⭐ (El más famoso)
            • Desde 1952
            • Cabrito al pastor
            • Precio: $$$
            • Dr. Coss 817, Centro
            
            **Los Arcos**
            • Ambiente familiar
            • Cabrito al pastor
            • Precio: $$
            
            **Monterrey Palace Hotel**
            • Buffet de cabrito los domingos
            • All you can eat
            • Precio: $$$
            
            **El Lingote**
            • Moderno y limpio
            • Buenas porciones
            • Precio: $$
            
            💡 **¿Qué es el cabrito?**
            Cría de cabra asada al carbón, platillo emblemático de Nuevo León
            """
        ),
        
        QAPair(
            keywords: ["carne asada", "asado", "parrilla"],
            response: """
            🥩 **CARNE ASADA ESTILO REGIO**
            
            **Los Cavazos** (Institución regia)
            • Desde 1956
            • Clásica carne asada norteña
            • Precio: $$
            • Hidalgo 430, Centro
            
            **Mochomos**
            • Cortes premium
            • Ambiente elegante
            • Precio: $$$
            
            **El Tío**
            • Clásico norteño
            • Buenas fajitas
            • Precio: $$
            
            **Tips:**
            • La carne asada se sirve con tortillas de harina, frijoles charros y guacamole
            • Ideal para compartir en familia
            """
        ),
        
        QAPair(
            keywords: ["económico", "barato", "comida barata", "presupuesto"],
            response: """
            💰 **OPCIONES ECONÓMICAS Y BUENAS**
            
            **Tortas Washmobile**
            • Tortas gigantes
            • Precio: $60-80
            • Porciones abundantes
            
            **Jugos Treviño**
            • Jugos naturales
            • Molletes deliciosos
            • Desayunos
            • Precio: $40-70
            
            **La Embajada**
            • Desayunos regios
            • Machaca con huevo
            • Precio: $70-100
            
            **Mercado Juárez**
            • Varios puestos de comida
            • Tacos, gorditas, quesadillas
            • Precio: $30-60
            """
        ),
        
        // TRANSPORTE
        QAPair(
            keywords: ["metro", "transporte", "como llegar", "llegar"],
            response: """
            🚇 **SISTEMA DE METRO DE MONTERREY**
            
            **Líneas:**
            • **Línea 1:** (Verde) Norte-Sur
            • **Línea 2:** (Naranja) Este-Oeste
            • **Línea 3:** (Morada) En construcción
            
            **💰 Precio:** $6 por viaje
            **⏰ Horario:** 5:00 AM - 12:00 AM
            
            **Estaciones principales:**
            • **Zaragoza:** Centro/Macroplaza
            • **Cuauhtémoc:** Barrio Antiguo
            • **Y Griega:** Parque Fundidora
            • **Estadio:** Estadio BBVA
            
            **Tips:**
            • Compra tarjeta FERIA (recargable)
            • Evita horas pico: 7-9 AM y 6-8 PM
            • Es limpio, seguro y puntual
            """
        ),
        
        QAPair(
            keywords: ["uber", "taxi", "didi", "app"],
            response: """
            🚗 **TRANSPORTE PRIVADO (Apps)**
            
            **Uber** ✅ (Más común)
            • Disponible en toda la zona metropolitana
            • Pago con tarjeta o efectivo
            • Precios promedio:
              - Centro a Fundidora: $60-80
              - Centro a San Pedro: $80-120
              - Aeropuerto a Centro: $200-250
            
            **Didi** ✅
            • Similar a Uber
            • A veces más económico
            • Buenas promociones
            
            **InDriver** ✅
            • Negocias el precio con el conductor
            • Puede ser más barato
            
            **Taxis tradicionales:**
            • Sitios de taxis: Seguros pero más caros
            • No pares taxis en la calle
            """
        ),
        
        // CLIMA
        QAPair(
            keywords: ["clima", "temperatura", "calor", "lluvia", "cuando viajar"],
            response: """
            🌡️ **CLIMA EN MONTERREY**
            
            **Primavera (Mar-May)** 🌸
            • Temperatura: 20-30°C
            • Clima agradable
            • Ideal para visitar
            
            **Verano (Jun-Ago)** ☀️
            • Temperatura: 30-40°C
            • MUY caluroso
            • Temporada de lluvias (Jul-Ago)
            • Hidratación importante
            
            **Otoño (Sep-Nov)** 🍂
            • Temperatura: 20-28°C
            • Excelente clima
            • Mejor época para visitar
            
            **Invierno (Dic-Feb)** ❄️
            • Temperatura: 10-20°C
            • Frío moderado
            • Rara vez nieva
            
            **💡 Mejor época:** Octubre-Noviembre y Marzo-Abril
            """
        ),
        
        // SEGURIDAD
        QAPair(
            keywords: ["seguridad", "seguro", "peligroso", "zona segura"],
            response: """
            🛡️ **SEGURIDAD EN MONTERREY**
            
            **Zonas seguras:**
            ✅ San Pedro Garza García (muy seguro)
            ✅ Centro (Macroplaza) - día
            ✅ Parque Fundidora
            ✅ Valle Oriente
            ✅ Zona Tec
            
            **Tips de seguridad:**
            • Usa Uber/Didi en lugar de taxis de calle
            • No camines solo de noche en el Centro
            • Guarda tus pertenencias en lugares concurridos
            • No muestres objetos de valor
            • Centro histórico: seguro de día, precaución de noche
            
            **En general:**
            Monterrey es relativamente segura para turistas en zonas turísticas durante el día. Usa sentido común.
            """
        ),
        
        // PREGUNTAS GENERALES
        QAPair(
            keywords: ["hola", "hi", "buenos dias", "buenas tardes"],
            response: """
            ¡Hola! 👋 Bienvenido a Monterrey
            
            Soy tu guía turístico virtual. Puedo ayudarte con:
            
            🏛️ **Lugares turísticos**
            • Macroplaza
            • Parque Fundidora
            • Cerro de la Silla
            • Museos
            • Cascadas
            
            🏟️ **Estadio BBVA**
            • Cómo llegar
            • Secciones
            • Servicios
            
            🍴 **Restaurantes**
            • Tacos
            • Cabrito
            • Carne asada
            • Opciones económicas
            
            🚇 **Transporte**
            • Metro
            • Uber/Didi
            • Cómo llegar a lugares
            
            **¿Sobre qué te gustaría saber?**
            """
        ),
        
        QAPair(
            keywords: ["gracias", "thank you", "excelente"],
            response: """
            ¡Con gusto! 😊
            
            Si necesitas más información sobre Monterrey, no dudes en preguntar.
            
            **Algunos temas que puedo ayudarte:**
            • Lugares para visitar
            • Dónde comer
            • Cómo transportarte
            • Información del Estadio BBVA
            • Clima y mejor época para visitar
            
            ¡Disfruta tu visita a Monterrey! 🏔️
            """
        ),
        
        QAPair(
            keywords: ["ayuda", "help", "no entiendo"],
            response: """
            ¡Claro! Estoy aquí para ayudarte 🙂
            
            **Puedes preguntarme sobre:**
            
            📍 Lugares turísticos:
            • "¿Qué lugares visitar?"
            • "¿Cómo llego a Fundidora?"
            • "Información del Cerro de la Silla"
            
            🍽️ Comida:
            • "¿Dónde comer tacos?"
            • "Restaurantes de cabrito"
            • "Opciones económicas"
            
            🏟️ Estadio:
            • "¿Cómo llego al Estadio BBVA?"
            • "Secciones del estadio"
            
            🚇 Transporte:
            • "¿Cómo funciona el metro?"
            • "Precio de Uber"
            
            **Prueba escribiendo algo como:**
            "¿Qué lugares visitar?" o "¿Dónde comer?"
            """
        ),
    ]
    
    // 🔍 Función para buscar respuesta
    static func findAnswer(for query: String) -> String {
        let queryLower = query.lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
        
        // Buscar coincidencia en keywords
        for qa in qaDatabase {
            for keyword in qa.keywords {
                if queryLower.contains(keyword.lowercased()) {
                    return qa.response
                }
            }
        }
        
        // Respuesta por defecto
        return """
        Lo siento, no tengo información específica sobre eso 😅
        
        **Puedo ayudarte con:**
        
        🏛️ Lugares turísticos (Macroplaza, Fundidora, Cerro de la Silla, etc.)
        🍴 Restaurantes (tacos, cabrito, carne asada)
        🏟️ Estadio BBVA (cómo llegar, secciones)
        🚇 Transporte (metro, Uber, cómo llegar)
        🌡️ Clima y mejor época para visitar
        
        **Intenta preguntar algo como:**
        • "¿Qué lugares turísticos me recomiendas?"
        • "¿Dónde puedo comer tacos?"
        • "¿Cómo llego al Estadio BBVA?"
        """
    }
}

// MARK: - Modelo de Pregunta-Respuesta
struct QAPair {
    let keywords: [String]
    let response: String
}

// MARK: - Message Model
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}

// MARK: - Main Chat View
struct ChatBotView: View {
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "message.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GoBot")
                            .font(.headline)
                        Text("Guía Turístico de Monterrey")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Text("ONLINE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
                
                // Quick actions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        QuickActionButton(icon: "building.2", text: "Lugares", color: .blue) {
                            inputText = "¿Qué lugares turísticos me recomiendas?"
                            sendMessage()
                        }
                        QuickActionButton(icon: "sportscourt", text: "Estadio", color: .orange) {
                            inputText = "¿Cómo llego al Estadio BBVA?"
                            sendMessage()
                        }
                        QuickActionButton(icon: "fork.knife", text: "Comida", color: .red) {
                            inputText = "¿Dónde puedo comer tacos?"
                            sendMessage()
                        }
                        QuickActionButton(icon: "map", text: "Transporte", color: .purple) {
                            inputText = "¿Cómo funciona el metro?"
                            sendMessage()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isProcessing {
                            TypingIndicator()
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }
            
            // Input
            HStack(spacing: 12) {
                TextField("Pregunta sobre Monterrey...", text: $inputText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1...5)
                    .disabled(isProcessing)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(inputText.isEmpty || isProcessing)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .onAppear {
            addWelcomeMessage()
        }
    }
    
    func addWelcomeMessage() {
        let welcome = Message(
            text: "¡Hola! 👋 Soy GoBot, tu guía turístico de Monterrey.\n\n¿Te gustaría saber sobre:\n🏛️ Lugares turísticos\n🏟️ Estadio BBVA\n🍴 Restaurantes\n🚇 Transporte\n\n¡Pregúntame lo que quieras!",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcome)
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(
            text: inputText,
            isUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let query = inputText
        inputText = ""
        isProcessing = true
        
        // Simular delay de respuesta (más natural)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let answer = KnowledgeBase.findAnswer(for: query)
            
            let botMessage = Message(
                text: answer,
                isUser: false,
                timestamp: Date()
            )
            messages.append(botMessage)
            isProcessing = false
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(text)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(20)
        }
    }
}

// MARK: - Messaage Bubble
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser { Spacer(minLength: 60) }
            
            if !message.isUser {
                Image(systemName: "message.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if message.isUser {
                Image(systemName: "person.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
            
            if !message.isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    ChatBotView()
}
