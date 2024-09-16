//
//  ImageEditorView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 15.09.2024.
//

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageEditorView: View {
    @EnvironmentObject var model: ImageViewModel
    @State private var isFilterPickerPresented = false
    @State private var isShareSheetPresented = false
    @Binding var image: UIImage?

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let size = proxy.frame(in: .global)

                Color.clear
                    .onAppear {
                        model.rect = size
                    }
                    .onChange(of: size) { newSize in
                        model.rect = size
                    }

                ZStack {
                    CanvasView(canvas: $model.canvas, image: $image, toolPicker: $model.toolPicker, rect: size.size)

                    ForEach(model.textList) { text in
                        Text(model.textList[model.currentIndex].id == text.id && model.addNewText ? "" : text.text)
                            .font(.custom(text.font, size: CGFloat(text.size)))
                            .foregroundColor(text.swiftUIColor)
                            .offset(text.offset)
                            .gesture(DragGesture()
                                .onChanged { value in
                                    let current = value.translation
                                    let lastOffset = text.lastOffset
                                    let newTranslation = CGSize(
                                        width: lastOffset.width + current.width,
                                        height: lastOffset.height + current.height
                                    )
                                    model.textList[getIndex(text: text)].offset = newTranslation
                                }
                                .onEnded { value in
                                    model.textList[getIndex(text: text)].lastOffset = value.translation
                                })
                            .onLongPressGesture {
                                model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                model.canvas.becomeFirstResponder()
                                model.currentIndex = getIndex(text: text)
                                withAnimation {
                                    model.addNewText = true
                                }
                            }
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    model.cancelImage()
                }) {
                    Text("Отмена")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filters") {
                    isFilterPickerPresented.toggle()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    model.textList.append(TextModel())
                    model.currentIndex = model.textList.count - 1

                    withAnimation {
                        model.addNewText.toggle()
                    }
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                }) {
                    Text("+")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    model.saveImage()
                }) {
                    Text("Сохранить")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShareSheetPresented = true
                }) {
                    Text("Поделиться")
                }
            }
        })
        .sheet(isPresented: $isFilterPickerPresented) {
            Picker("Выберите фильтр", selection: $model.selectedFilter) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: model.selectedFilter) { _ in
                applyFilter()
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
                 ShareSheet(activityItems: [image!]) { success in
                     if success {
                         print("Share successful")
                     } else {
                         print("Share failed")
                     }
                 }
             }
    }

    func getIndex(text: TextModel) -> Int {
        let index = model.textList.firstIndex { (textIn) -> Bool in
            return text.id == textIn.id
        } ?? 0
        return index
    }

    func applyFilter() {
        model.applyFilter()
        image = model.imageModel.image
    }
}


struct CanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @Binding var image: UIImage?
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize
    
    func makeUIView(context: Context) ->  PKCanvasView {
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        updateImageInCanvas(canvas)
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        updateImageInCanvas(uiView)
    }
    
    private func updateImageInCanvas(_ canvas: PKCanvasView) {
        canvas.subviews.forEach { subview in
            if let imageView = subview as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            canvas.insertSubview(imageView, at: 0)
        }
    }
}



