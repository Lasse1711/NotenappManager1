//
//  MainScreen.swift
//  SchülerManagerNotenappPrüfung
//
//  Created by Lasse von Pfeil on 01.06.22.
//

import SwiftUI


struct StudentView: View, Identifiable {
    
    let id = UUID().uuidString
    @State var name: String
    @State var averages: Double
    @State var grades: [Int] = []
    let getsheet: () -> Void
    
    var body: some View {
        VStack {
            Button(action: getsheet, label: {
                Text(name)
            })
        }
        .frame(width: 200, height: 100)
        .background(.cyan)
        .cornerRadius(20)
    }
}


class ArrayModificationViewModel: ObservableObject {
    @Published var dataArray: [StudentView] = []
    @Published var filteredArray: [StudentView] = []
    
    
    init() {
        getUsers()
        updateFilteredArray()
    }
    
    func updateFilteredArray() {
        filteredArray = dataArray.sorted(by: { (user1, user2) -> Bool in
            return user1.averages < user2.averages
        })
    }
    
    
    func getUsers() {
        let user1 = StudentView(name: "Nick", averages: 0.00, grades: [1, 2, 2, 5, 6], getsheet: {})
        let user2 = StudentView(name: "Tim", averages: 0.00, grades: [1, 2, 2, 5, 2], getsheet: {})
        let user3 = StudentView(name: "Lasse", averages: 0.00, grades: [1, 3, 1, 2, 1], getsheet: {})
        let user4 = StudentView(name: "Finn", averages: 0.00, grades: [4, 6, 6, 6, 6], getsheet: {})
        let user5 = StudentView(name: "Julia", averages: 0.00, grades: [3, 3, 2, 5, 4], getsheet: {})
        let user6 = StudentView(name: "Svea", averages: 0.00, grades: [2, 1, 2, 3, 4], getsheet: {})
        let user7 = StudentView(name: "Kevin", averages: 0.00, grades: [1, 2, 2, 5, 6], getsheet: {})
        let user8 = StudentView(name: "Schantal", averages: 0.00, grades: [1, 2, 2, 5, 6], getsheet: {})
        
        self.dataArray.append(contentsOf: [
            user1,
            user2,
            user3,
            user4,
            user5,
            user6,
            user7,
            user8
        ])
    }
}


struct MainScreen: View {
    @StateObject var vm = ArrayModificationViewModel()
    @State var sheetShow1 = false
    @State var sheetShow2 = false
    @State var studentName = ""
    @State var studentAverage: Double = 0.0
    @State var newname = ""
    @State var newgrade = ""
    @State var noten = [0, 0, 0, 0, 0]
    
    
    func toggling1() {
        sheetShow1.toggle()
    }
    
    func toggling2() {
        sheetShow2.toggle()
    }
    
    
    func removeStudents(at offsets: IndexSet) {
        vm.filteredArray.remove(atOffsets: offsets)
    }
    
    func addgrade() {
        self.noten.append(Int(self.newgrade)!)
    }
    
    
    func makenewaverage() {
        var gesamt = 0
        for quersumme in noten {
            gesamt += Int(quersumme)
        }
        var newaverage2: Double = 0.0
        
        if(noten.count == 0) {
            print("Failed2")
        } else {
            newaverage2 = Double(gesamt / noten.count)
        }
        
        studentAverage = newaverage2
        //print(newaverage2)
    }
    
    var body: some View {
        VStack {
            Text("Schüler")
                .fontWeight(.bold)
                .padding()
                .font(.title)
            
            Spacer()
            
            List {
                ForEach(vm.filteredArray) { student in
                    HStack {
                        StudentView(
                            name: student.name, averages: student.averages, grades: student.grades, getsheet: {
                                studentName = student.name
                                noten = student.grades
                                var gesamt = 0
                                for quersumme in student.grades {
                                    gesamt += Int(quersumme)
                                }
                            
                                var newaverage: Double = 0
                            
                                if(student.grades.count == 0) {
                                    print("Failed")
                                } else {
                                    newaverage = Double(gesamt / student.grades.count)
                                }
                                student.averages = Double(newaverage)
                                studentAverage = Double(newaverage)
                                toggling1()
                        })
                    }
                    
                }
                .onDelete(perform: removeStudents)
            }
            
            Button(action: {
                toggling2()
            }, label: {
                Text("New Student")
                    .fontWeight(.bold)
                    .padding()
                    .font(.title)
                    .background(.bar)
                    .cornerRadius(20)
            })
        }
        .sheet(isPresented: $sheetShow2, content: {
            Text("New Student")
                .fontWeight(.bold)
                .padding()
                .font(.title)
            
            Spacer()
            
            TextField(
                "Name",
                text: $newname
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .frame(width: 200)
            .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            
            Button(action: {
                print(newname)
                vm.filteredArray.append(contentsOf: [
                    StudentView(name: newname, averages: 0.00, getsheet: {})
                ])
                sheetShow2.toggle()
            }, label: {
                Text("Submit")
                    .fontWeight(.bold)
                    .padding()
                    .font(.title2)
                    .background(.bar)
                    .cornerRadius(20)
            })
            
            Spacer()
            
        })
        .sheet(isPresented: $sheetShow1, content: {
            Text(studentName)
                .fontWeight(.bold)
                .padding()
                .font(.title)
                
            Spacer()
            
            Text("\(studentAverage)")
                .fontWeight(.bold)
                .padding()
                .font(.title3)
            
            Spacer()
            
            
            List {
                ForEach(noten, id: \.self) { note in
                    Text("\(note)")
                }
            }
            
            TextField(
                "New grade",
                text: $newgrade
            )
            .padding()
            .textFieldStyle(.roundedBorder)
            
            Button(action: {
                self.addgrade()
                makenewaverage()
            }, label: {
                Text("New grade")
                    .fontWeight(.bold)
                    .padding()
                    .font(.title2)
                    .frame(width: 200)
                    .background(.cyan)
                    .cornerRadius(20)
            })
            .padding()
        })
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
