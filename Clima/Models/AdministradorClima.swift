//
//  AdministradorClima.swift
//  Clima
//
//  Created by Victor Tejeda on 3/9/22.
//

import UIKit
import CoreLocation

protocol AdministradorClimaDelegate  {
    func didUpdateWeather(_ administradorClima: AdministradorClima, weather: ModeloMeteorológico)
    func didFailWithError(error: Error)
}

struct AdministradorClima {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=5c10294bc1162152d52ad42b7e2d1274&units=metric"
    
    var delegate: AdministradorClimaDelegate?
    
    func tiempoReal(nombreCiudad: String) {
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        realizarSolicitud(with: urlString)
    }
    
    func tiempoReal(latitude: CLLocationDegrees, longitude: CLLocationDegrees)  {
        let urlString = "\(climaURL)&q=\(latitude)&lon=\(longitude)"
        realizarSolicitud(with: urlString)
        
    }
    
    func realizarSolicitud(with urlString: String) {
        //paso 1 crear una URLSession
        if let url = URL(string: urlString) {
            //paso 2 crear una URLSession
            let session = URLSession(configuration: .default)
            //paso 3 dar a una seccion una tarea
            //el dataTasks crea una tarea que recupera el contenido de la URL especificado y luego llama a un controlador o metodo una vez que se completa.
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let datoSeguro = data {
                    if let weather = self.analizadorJSON(datoSeguro) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    // el String(data.....) toma un objecto de datos como entrada. y el .utf8 es un protocolo estandirizado para codificar texto en sitios web.
                    //                    let dataString = String(data: datoSeguro, encoding: .utf8)
                    //                    print(dataString)
                    // arecordar que siempre se revisa todo me entendiste victor jjj
                }
            }
            
            //paso 4 comenzar la tarea.
            task.resume()
            
        }
    }
    //creare una funcion llamada indentificador
    //    func handle(data: Data?, response: URLResponse?, error: Error?) {
    //
    //
    //    }
    func analizadorJSON(_ climaData: Data) -> ModeloMeteorológico? {
        let decoder = JSONDecoder()
        do {
             let decodedData = try decoder.decode(ClimaDatos.self, from: climaData)
             let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = ModeloMeteorológico(conditionId: id, cityName: name, temperature: temp)
            return weather
            
    
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


