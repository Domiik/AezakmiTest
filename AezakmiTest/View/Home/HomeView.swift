//
//  HomeView.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = ImageViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if viewModel.imageModel.image != nil {
                        ImageEditorView(image: $viewModel.imageModel.image)
                            .environmentObject(viewModel)
                            .padding()
                    } else {
                        Button(action: {
                            viewModel.addImage()
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 75, height: 75)
                                .background(Color.white)
                                .shadow(color: .black, radius: 5)
                        }
                    }
                }
                .navigationTitle("Image Editor")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            authViewModel.signOut()
                            dismiss()
                        }) {
                            Text("Выйти")
                        }
                    }
                })
            }
            
            
            
            if viewModel.addNewText {
                
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("Введите текст", text: $viewModel.textList[viewModel.currentIndex].text)
                    .font(.custom(viewModel.textList[viewModel.currentIndex].font, size: CGFloat(viewModel.textList[viewModel.currentIndex].size)))
                    .colorScheme(.dark)
                    .foregroundColor(viewModel.textList[viewModel.currentIndex].swiftUIColor)
                    .padding()
                
                HStack {
                    Button(action: {
                        viewModel.textList[viewModel.currentIndex].isAdded = true
                        viewModel.toolPicker.setVisible(true, forFirstResponder: viewModel.canvas)
                        viewModel.canvas.becomeFirstResponder()
                        withAnimation {
                            viewModel.addNewText = false
                        }
                    } , label: {
                        Text("Добавить")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: viewModel.cancelTextView ) {
                        Text("Отмена")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                .overlay(content: {
                    HStack {
                        ColorPicker("", selection: $viewModel.textList[viewModel.currentIndex].swiftUIColor)
                            .labelsHidden()
                        Picker("", selection: $viewModel.textList[viewModel.currentIndex].size) {
                            ForEach([14, 18, 24, 30, 36, 48, 60], id: \.self) { size in
                                Text("\(size)").tag(CGFloat(size))
                            }
                        }
                        .colorScheme(.dark)
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker("Font", selection: $viewModel.textList[viewModel.currentIndex].font) {
                            ForEach(["Arial", "Helvetica", "Times New Roman", "Courier", "Verdana"], id: \.self) { font in
                                Text(font).tag(font)
                            }
                        }
                        .colorScheme(.dark)
                        .pickerStyle(MenuPickerStyle())

                    }
                    .padding(.top, 50)
                    
                })
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
       
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(sourceType: viewModel.imageSource == .camera ? .camera : .photoLibrary, selectedImage: { image in
                viewModel.handleImageSelection(image: image)
            })
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Сообщение"), message: Text(viewModel.alertMassage), dismissButton: .destructive(Text("OK")))
        }
    }
}


#Preview {
    HomeView(authViewModel: AuthenticationViewModel(authService: AuthenticationService()))
}
