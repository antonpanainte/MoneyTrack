//
//  ContentView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import SwiftUI
import Charts
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @StateObject var store = TransactionListViewModel()
    @State private var showingAddTransaction = false
    
    
    @AppStorage("preferredAmount") private var savedAmount: Double = 0
    @AppStorage("userName") private var username: String = ""
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    
    @State private var currentHover: (Date, Double)? = nil
    @State private var audioPlayer: AVAudioPlayer?
    
    
    var body: some View {
        
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text("Welcome back, \(username)!")
                            .font(.title2)
                            .bold()
                        
                        //Line Chart
                        let data = transactionListVM.accumulateTransaction(Date())
                        
                        let today = Date().getDay()
                        let endOfMonth = Date().lastDay()
                        
                        let ratio = savedAmount * Double(today)/Double(endOfMonth)
                        
                        if !data.isEmpty {
                            let totalExpenses = data.last?.1 ?? 0
                            
                            VStack(alignment: .leading) {
                                Text("Total expenses : \(totalExpenses.formatted(.currency(code: selectedCurrency)))")
                                    .font(.title2.bold())
                                
                                Spacer(minLength: 16)
                                
                                if let hover = currentHover {
                                    Text("\(hover.1, format: .currency(code: selectedCurrency)) on \(hover.0.formatted(.dateTime.month().day()))")
                                        .font(.caption)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.icon).opacity(0.6).shadow(radius: 2))
                                        .offset(x: 0, y: -10)
                                }
                                else {
                                    Text("Drag over dates")
                                        .font(.caption)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.icon).opacity(0.6).shadow(radius: 2))
                                        .offset(x: 0, y: -10)
                                }
                                Spacer(minLength: 16)
                                Chart {
                                    ForEach(data, id: \.0) { (date, value) in
                                        LineMark(
                                            x: .value("Date", date),
                                            y: .value("Expenses", value)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(Color.icon.opacity(0.3))
                                        PointMark(
                                            x: .value("Date", date),
                                            y: .value("Expenses", value)
                                        )
                                        .foregroundStyle(currentHover?.0 == date ? Color.primary : Color.Icon)
                                        .symbolSize(currentHover?.0 == date ? 100 : 50)
                                    }
                                    //limitline for expenses
                                    RuleMark(
                                        y: .value("", savedAmount))
                                    .foregroundStyle(.primary)
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [10]))
                                    
                                    RuleMark(
                                        y: .value("Expected Amount", ratio))
                                    .foregroundStyle(.icon)
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [10]))
                                    
                                    // Draw tooltip circle and text when hovering
                                    if let hover = currentHover {
                                        RuleMark(x: .value("Hover", hover.0))
                                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                            .foregroundStyle(Color.primary)
                                        
                                        PointMark(
                                            x: .value("Hover", hover.0),
                                            y: .value("Hover", hover.1)
                                        )
                                        .symbolSize(150)
                                        .foregroundStyle(Color.secondary)
                                    }
                                }
                                .chartOverlay { proxy in
                                    GeometryReader { geo in
                                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                                            .gesture(
                                                DragGesture(minimumDistance: 0)
                                                    .onChanged { value in
                                                        let location = value.location
                                                        if let date: Date = proxy.value(atX: location.x) {
                                                            // Find the closest data point
                                                            if let nearest = data.min(by: { abs($0.0.timeIntervalSince(date)) < abs($1.0.timeIntervalSince(date)) }) {
                                                                currentHover = nearest
                                                            }
                                                        }
                                                    }
                                                    .onEnded { _ in
                                                        currentHover = nil
                                                    }
                                            )
                                    }
                                }
                                .chartXAxis {
                                    AxisMarks(values: .stride(by: .day, count: 4)) { value in
                                        AxisGridLine().foregroundStyle(.clear)
                                        AxisValueLabel(format: .dateTime.month().day())
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading) { _ in
                                        AxisGridLine().foregroundStyle(.clear)
                                        AxisValueLabel()
                                    }
                                }
                                .frame(height: 300)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground).shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 5))
                            
                            RecentTransactionList()
                        }
                        else {
                            EmptyTransacationsView()
                            
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                }
                .background(Color.background)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            action: {showingAddTransaction.toggle()}
                        ) {
                            Image(systemName: "plus")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.Icon, .primary)
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button(action : {
                            playSound(named: "audio1", withExtension: "mp3", player: &audioPlayer)
                        }){
                            Image("mascot")
                                .resizable()         
                                .scaledToFit()
                                .frame(width: 50)
                        }
                    }
                }
                .sheet(isPresented: $showingAddTransaction) {
                    AddNewTransactionView()
                        .environmentObject(transactionListVM)
                        .presentationDetents([.fraction(0.9)])
                }
                .scrollContentBackground(.hidden)
                
            }
            .accentColor(.primary)
        
    }
}

#Preview {
    let transactionListVM: TransactionListViewModel = {
        let tranasctionListVM = TransactionListViewModel()
        tranasctionListVM.transactions = transactionListPreviewData
        return tranasctionListVM
    }()
    
    ContentView()
        .environmentObject(transactionListVM)
    
}
