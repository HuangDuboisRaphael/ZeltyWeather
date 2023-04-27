//
//  CoreDataService.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import CoreData

// CoreDataService protocol to conform for better flexibility and modularity since not tightly coupled to a specific type, also for mocking purposes.
protocol CoreDataServiceType {
    var viewContext: NSManagedObjectContext { get }
    
    func addWeatherEntity(weather: Weather)
    func retrieveWeatherEntities() -> [WeatherEntity]
    func deleteWeatherEntities()
}

final class CoreDataService: CoreDataServiceType {
    
    // Configure persistent container to create an instance of our CoreData database.
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZeltyWeather")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        }
        return container
    }()
    
    // Computed property to return container view context which allows us to manipulate CoreData data.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Add a weather entity mapped with weather object in database.
    func addWeatherEntity(weather: Weather) {
        /// Create the entity.
        let weatherEntity = WeatherEntity(context: viewContext)
        weatherEntity.cloud = weather.cloud
        weatherEntity.date = weather.date
        weatherEntity.detailedWeatherDescription = weather.detailedDecription
        weatherEntity.weatherDescription = weather.description
        weatherEntity.feelsLike = weather.feelsLike
        weatherEntity.hour = weather.hour
        weatherEntity.humidity = weather.humidity
        weatherEntity.image = weather.image
        weatherEntity.name = weather.city.name
        weatherEntity.population = weather.city.population
        weatherEntity.pressure = weather.pressure
        weatherEntity.sunrise = weather.city.sunset
        weatherEntity.sunset = weather.city.sunset
        weatherEntity.temperature = weather.temperature
        weatherEntity.wind = weather.wind
        
        /// Save the entity in database.
        do {
            try viewContext.save()
            print("Saved")
        } catch {
            fatalError("Failed to save context: \(error)")
        }
    }
    
    // Retrieve all the weather entities saved in databse.
    func retrieveWeatherEntities() -> [WeatherEntity] {
        var weatherEntities: [WeatherEntity] = []
        
        /// Create request.
        let fetchRequest = NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
        
        /// Fetch request and obtained entities from database.
        do {
            weatherEntities = try viewContext.fetch(fetchRequest)
            print(weatherEntities.count)
        } catch {
            print("Error fetching entities: \(error)")
        }
        return weatherEntities
    }
    
    // Delete all the weather entites.
    func deleteWeatherEntities() {
        /// Create request.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WeatherEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        /// Execute request to delete all the entites from database.
        do {
            try viewContext.execute(deleteRequest)
        } catch {
            print("Error deleting entities: \(error)")
        }
    }
}
