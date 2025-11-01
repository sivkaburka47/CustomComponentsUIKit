//
//  RemoteDataSource.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 01.11.2025.
//

import Foundation
import UIKit

final class RemoteDataSource {
    
    static let shared = RemoteDataSource()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private var loadingTasks: [String: Task<UIImage?, Never>] = [:]
    private let loadingQueue = DispatchQueue(label: "com.customcomponents.imageloading", attributes: .concurrent)
    
    private init() {
        // Настройка кэша
        imageCache.countLimit = 50
        imageCache.totalCostLimit = 50 * 1024 * 1024
    }

    func fetchShows() async throws -> [Show] {
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 100_000_000)

        return [
            Show(title: "Люцифер", year: 2016, country: "США", rating: 8.1, genres: ["фэнтези", "драма", "комедия"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Игра престолов", year: 2011, country: "США", rating: 9.3, genres: ["фэнтези", "драма", "боевик"], imageName: "filmCover_3"),
            Show(title: "Очень странные дела", year: 2016, country: "США", rating: 8.7, genres: ["фантастика", "ужасы", "драма"], imageName: "filmCover_4"),
            Show(title: "Дом карт", year: 2013, country: "США", rating: 8.7, genres: ["политика", "драма", "триллер"], imageName: "filmCover_5"),
            Show(title: "Черное зеркало", year: 2011, country: "Великобритания", rating: 8.8, genres: ["фантастика", "триллер", "драма"], imageName: "filmCover_6"),
            Show(title: "Друзья", year: 1994, country: "США", rating: 8.9, genres: ["комедия", "романтика"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Ход королевы", year: 2020, country: "США", rating: 8.6, genres: ["драма", "спорт"], imageName: "filmCover_3"),
            Show(title: "Мандалорец", year: 2019, country: "США", rating: 8.7, genres: ["фантастика", "боевик", "приключения"], imageName: "filmCover_4"),
            Show(title: "Люцифер", year: 2016, country: "США", rating: 8.1, genres: ["фэнтези", "драма", "комедия"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Игра престолов", year: 2011, country: "США", rating: 9.3, genres: ["фэнтези", "драма", "боевик"], imageName: "filmCover_3"),
            Show(title: "Очень странные дела", year: 2016, country: "США", rating: 8.7, genres: ["фантастика", "ужасы", "драма"], imageName: "filmCover_4"),
            Show(title: "Дом карт", year: 2013, country: "США", rating: 8.7, genres: ["политика", "драма", "триллер"], imageName: "filmCover_5"),
            Show(title: "Черное зеркало", year: 2011, country: "Великобритания", rating: 8.8, genres: ["фантастика", "триллер", "драма"], imageName: "filmCover_6"),
            Show(title: "Друзья", year: 1994, country: "США", rating: 8.9, genres: ["комедия", "романтика"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Люцифер", year: 2016, country: "США", rating: 8.1, genres: ["фэнтези", "драма", "комедия"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Игра престолов", year: 2011, country: "США", rating: 9.3, genres: ["фэнтези", "драма", "боевик"], imageName: "filmCover_3"),
            Show(title: "Очень странные дела", year: 2016, country: "США", rating: 8.7, genres: ["фантастика", "ужасы", "драма"], imageName: "filmCover_4"),
            Show(title: "Дом карт", year: 2013, country: "США", rating: 8.7, genres: ["политика", "драма", "триллер"], imageName: "filmCover_5"),
            Show(title: "Черное зеркало", year: 2011, country: "Великобритания", rating: 8.8, genres: ["фантастика", "триллер", "драма"], imageName: "filmCover_6"),
            Show(title: "Друзья", year: 1994, country: "США", rating: 8.9, genres: ["комедия", "романтика"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Люцифер", year: 2016, country: "США", rating: 8.1, genres: ["фэнтези", "драма", "комедия"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Игра престолов", year: 2011, country: "США", rating: 9.3, genres: ["фэнтези", "драма", "боевик"], imageName: "filmCover_3"),
            Show(title: "Очень странные дела", year: 2016, country: "США", rating: 8.7, genres: ["фантастика", "ужасы", "драма"], imageName: "filmCover_4"),
            Show(title: "Дом карт", year: 2013, country: "США", rating: 8.7, genres: ["политика", "драма", "триллер"], imageName: "filmCover_5"),
            Show(title: "Черное зеркало", year: 2011, country: "Великобритания", rating: 8.8, genres: ["фантастика", "триллер", "драма"], imageName: "filmCover_6"),
            Show(title: "Друзья", year: 1994, country: "США", rating: 8.9, genres: ["комедия", "романтика"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Люцифер", year: 2016, country: "США", rating: 8.1, genres: ["фэнтези", "драма", "комедия"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Игра престолов", year: 2011, country: "США", rating: 9.3, genres: ["фэнтези", "драма", "боевик"], imageName: "filmCover_3"),
            Show(title: "Очень странные дела", year: 2016, country: "США", rating: 8.7, genres: ["фантастика", "ужасы", "драма"], imageName: "filmCover_4"),
            Show(title: "Дом карт", year: 2013, country: "США", rating: 8.7, genres: ["политика", "драма", "триллер"], imageName: "filmCover_5"),
            Show(title: "Черное зеркало", year: 2011, country: "Великобритания", rating: 8.8, genres: ["фантастика", "триллер", "драма"], imageName: "filmCover_6"),
            Show(title: "Друзья", year: 1994, country: "США", rating: 8.9, genres: ["комедия", "романтика"], imageName: "filmCover_1"),
            Show(title: "Во все тяжкие", year: 2008, country: "США", rating: 9.5, genres: ["криминал", "драма", "триллер"], imageName: "filmCover_2"),
            Show(title: "Кремниевая долина", year: 2014, country: "США", rating: 8.5, genres: ["комедия"], imageName: "filmCover_5"),
            Show(title: "Шерлок", year: 2010, country: "Великобритания", rating: 9.1, genres: ["детектив", "драма", "криминал"], imageName: "filmCover_6")
        ]
    }

    func loadImage(imageName: String) async -> UIImage? {
        let cacheKey = NSString(string: imageName)
        
        // Проверяем кэш
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Проверяем загружается ли уже это изображение
        if let existingTask = loadingQueue.sync(execute: { loadingTasks[imageName] }) {
            return await existingTask.value
        }
        
        // Создаем новую задачу загрузки
        let task = Task<UIImage?, Never> {
            // Имитация задержки загрузки изображения
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard let image = UIImage(named: imageName) else {
                loadingQueue.async(flags: .barrier) {
                    self.loadingTasks.removeValue(forKey: imageName)
                }
                return nil
            }
            
            // Сохраняем в кэш
            let cost = Int(image.size.width * image.size.height * 4)
            imageCache.setObject(image, forKey: cacheKey, cost: cost)
            
            // Удаляем задачу из словаря загрузок
            loadingQueue.async(flags: .barrier) {
                self.loadingTasks.removeValue(forKey: imageName)
            }
            
            return image
        }

        loadingQueue.async(flags: .barrier) {
            self.loadingTasks[imageName] = task
        }
        
        return await task.value
    }
    
    // Предзагрузка изображения
    func prefetchImage(imageName: String) {
        Task {
            _ = await loadImage(imageName: imageName)
        }
    }
    
    // Отмена предзагрузки
    func cancelPrefetch(imageName: String) {
        loadingQueue.async(flags: .barrier) {
            self.loadingTasks[imageName]?.cancel()
            self.loadingTasks.removeValue(forKey: imageName)
        }
    }
}
