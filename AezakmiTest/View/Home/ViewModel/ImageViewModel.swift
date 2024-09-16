//
//  ImageViewModel.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 15.09.2024.
//

import SwiftUI
import PencilKit

enum ImageSource {
    case library
    case camera
}

enum FilterType: String, CaseIterable {
    case none = "Без фильтра"
    case sepia = "Сепия"
    case blur = "Размытие"
}

class ImageViewModel: ObservableObject {
    @Published var imageModel = ImageModel()
    @Published var isImagePickerPresented = false
    @Published var imageSource: ImageSource = .library
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    @Published var textList: [TextModel] = []
    @Published var addNewText = false
    
    @Published var currentIndex: Int = 0
    
    @Published var rect: CGRect = .zero
    
    @Published var showAlert = false
    
    @Published var alertMassage = ""
    
    @Published var selectedFilter: FilterType = .none
    private let context = CIContext()
    
    func addImage() {
        isImagePickerPresented = true
    }
    
    func handleImageSelection(image: UIImage?) {
        imageModel.image = image
    }
    
    func cancelImage() {
        imageModel.image = nil
        canvas = PKCanvasView()
        textList.removeAll()
    }
    
    func cancelTextView() {
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            addNewText = false
        }
        
        if !textList[currentIndex].isAdded {
            textList.removeLast()
        }
        
    }
    
    
    func applyFilter() {
        guard let inputImage = imageModel.image else { return }
        let beginImage = CIImage(image: inputImage)
        
        var filter: CIFilter?
        
        switch selectedFilter {
        case .sepia:
            let sepiaFilter = CIFilter.sepiaTone()
            sepiaFilter.inputImage = beginImage
            sepiaFilter.intensity = 0.8
            filter = sepiaFilter
        case .blur:
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = beginImage
            blurFilter.radius = 10.0
            filter = blurFilter
        case .none:
            imageModel.image = inputImage
            return
        }
        
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                self.imageModel.image = processedImage
            }
        }
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        let textBox = ZStack {
            ForEach(textList) { [self] text in
                Text(textList[currentIndex].id == text.id && addNewText ? "" : text.text)
                    .font(.custom(text.font, size: CGFloat(text.size)))
                    .foregroundColor(text.swiftUIColor)
                    .offset(text.offset)
            }
        }
        
        let controller = UIHostingController(rootView: textBox).view!
        controller.frame = rect
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.alertMassage = "Успешно сохранено"
            self.showAlert.toggle()
        }
    }
}

