import SwiftUI
import Charts

// 1. Data model for each slice
struct ChartData: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var value: Double
    var color: Color
    
    static let initialData: [ChartData] = [
        // --- Main Categories ---
        ChartData(name: "Auto & Transport", value: 0.0, color: Color(hue: 0.46, saturation: 0.85, brightness: 0.63)),
        ChartData(name: "Bills & Utilities", value: 0.0, color: Color(hue: 0.11, saturation: 0.92, brightness: 0.95)),
        ChartData(name: "Entertainment", value: 0.0, color: Color(hue: 0.03, saturation: 0.78, brightness: 0.75)),
        ChartData(name: "Fees & Charges", value: 0.0, color: Color(hue: 0.57, saturation: 0.76, brightness: 0.86)),
        ChartData(name: "Food & Dining", value: 0.0, color: Color(hue: 0.79, saturation: 0.55, brightness: 0.71)),
        ChartData(name: "Home", value: 0.0, color: Color(hue: 0.38, saturation: 0.77, brightness: 0.68)),
        ChartData(name: "Income", value: 0.0, color: Color(hue: 0.08, saturation: 0.73, brightness: 0.90)),
        ChartData(name: "Shopping", value: 0.0, color: Color(hue: 0.59, saturation: 0.28, brightness: 0.50)),
        ChartData(name: "Transfer", value: 0.0, color: Color(hue: 0.44, saturation: 0.85, brightness: 0.73)),
        
        // --- Subcategories ---
        ChartData(name: "Public Transportation", value: 0.0, color: Color(hue: 0.76, saturation: 0.50, brightness: 0.68)),
        ChartData(name: "Taxi", value: 0.0, color: Color(hue: 0.03, saturation: 0.80, brightness: 0.91)),
        ChartData(name: "Mobile Phone", value: 0.0, color: Color(hue: 0.78, saturation: 0.26, brightness: 0.69)),
        ChartData(name: "Movies & DVDs", value: 0.0, color: Color(hue: 0.15, saturation: 0.92, brightness: 0.95)),
        ChartData(name: "Bank Fee", value: 0.0, color: Color(hue: 0.58, saturation: 0.42, brightness: 0.91)),
        ChartData(name: "Finance Charge", value: 0.0, color: Color(hue: 0.56, saturation: 0.05, brightness: 0.64)),
        ChartData(name: "Groceries", value: 0.0, color: Color(hue: 0.03, saturation: 0.59, brightness: 0.93)),
        ChartData(name: "Restaurants", value: 0.0, color: Color(hue: 0.39, saturation: 0.45, brightness: 0.88)),
        ChartData(name: "Rent", value: 0.0, color: Color(hue: 0.79, saturation: 0.61, brightness: 0.35)),
        ChartData(name: "Home Suplies", value: 0.0, color: Color(hue: 0.06, saturation: 0.65, brightness: 0.63)),
        ChartData(name: "Paycheque", value: 0.0, color: Color(hue: 0.28, saturation: 0.59, brightness: 0.68)),
        ChartData(name: "Software", value: 0.0, color: Color(hue: 0.12, saturation: 0.20, brightness: 0.97)),
        ChartData(name: "Credit Card Payment", value: 0.0, color: Color(hue: 0.59, saturation: 0.20, brightness: 0.58))
    ]
}

struct PieChartView: View {
    
    @EnvironmentObject var transactionListVM : TransactionListViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    
    @State private var date = Date()

    @State private var selectedSlice: String? = nil
    @State private var selectedSliceValue: Double? = nil
    @State var selectedSliceSum: Double? = 0.0
    @State var selectedSliceSumPercentage: Double? = 0.0
    
    @State var totalExpenses: Double = 0.0
    @State var dailyExpenses: [(Date, Double)] = []
    
    @State private var currentHover: (Date, Double)? = nil
    
    @State private var selectedMonth: Int = Date().getMonthInt()
    @State private var selectedYear: Int = Date().getYear()
        
    // Data sources for the pickers
    let months = 1...12
    let years = 2000...2050
    
    @State private var activeChartData: [ChartData] = ChartData.initialData
    
    // Helper to get the month name
    var monthSymbols: [String] {
            Calendar.current.monthSymbols
    }
        
    //Computed property for the final selected date
    var selectedDate: Date {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: 1)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    MonthYearPickerView(
                        selectedMonth: $selectedMonth,
                        selectedYear: $selectedYear,
                        months: months,
                        years: years,
                        monthSymbols: monthSymbols
                    )
                    PieChartBoxView(
                        currentData: activeChartData,
                        currency: selectedCurrency,
                        totalExpenses: totalExpenses,
                        selectedSlice: $selectedSlice,
                        selectedSliceValue: $selectedSliceValue,
                        selectedSliceSum: $selectedSliceSum,
                        selectedSliceSumPercentage: $selectedSliceSumPercentage
                    )
                    .onChange(of: selectedSliceValue) { oldValue, newValue in
                        updateSelectedSlice(from: newValue)
                    }
                    
                    BarChartView(
                        cData: dailyExpenses,
                        selectedCurrency: selectedCurrency,
                        totalExpenses: totalExpenses
                    )
                }
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("You selected: ")
                        .font(.headline)
                    + Text("\(monthSymbols[selectedMonth - 1])")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.icon)
                    + Text(" \(String(selectedYear))")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.icon)
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Changes title to inline style
            .onChange(of: selectedDate){
                loadData(animated: true)
            }
            .onAppear{
                loadData(animated: true)
            }
        }
    }

    //Compute the data of the selected slice
    private func updateSelectedSlice(from rawValue: Double?) {
        guard let rawValue else {
            selectedSlice = nil
            return
        }
        let data = transactionListVM.getChartDataForMonth(for: selectedDate)
        var cumulativeTotal: Double = 0
        let tappedSlice = data.first { item in
            cumulativeTotal += item.value
            return rawValue <= cumulativeTotal
        }
        selectedSlice = tappedSlice?.name
        selectedSliceSum = tappedSlice?.value ?? 0
        selectedSliceSumPercentage = (selectedSliceSum ?? 0.0) / totalExpenses * 100
    }
    
    //helper function to properly load data, and potentially do it without animations
    private func loadData(animated: Bool) {
        let execution = {
            //For PieChart
            let data = transactionListVM.getChartDataForMonth(for: selectedDate)
            
            if !data.isEmpty{
                activeChartData = data
            }
            else {
                activeChartData = ChartData.initialData
            }
            
            //For BarChart
            dailyExpenses = transactionListVM.accumulateTransaction(selectedDate.getLastDay())
            totalExpenses = dailyExpenses.last?.1 ?? 0
        }
        
        //execute the data change animation
        if animated {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                execution()
            }
        } else {
            execution() //don't execute the animation
        }
    }
}

struct MonthYearPickerView : View {
    
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    let months: ClosedRange<Int>
    let years: ClosedRange<Int>
    let monthSymbols: [String]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                // --- Month Picker ---
                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(monthSymbols[month - 1]).tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 165, height: 90) // Adjust width as needed
                
                // --- Year Picker ---
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 165, height: 90) // Adjust width as needed
            }
            .padding([.bottom, .horizontal])
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.background))
        }
    }
}

struct PieChartBoxView : View {
    
    let currentData: [ChartData]
    let currency: String
    let totalExpenses: Double
        
    @Binding var selectedSlice: String?
    @Binding var selectedSliceValue: Double?
    @Binding var selectedSliceSum: Double?
    @Binding var selectedSliceSumPercentage: Double?
    
    var body: some View {
        
        VStack {
            Chart(currentData) { element in
                SectorMark(
                    angle: .value("Value", element.value),
                    innerRadius: .ratio(0.618),
                    outerRadius: .ratio(selectedSlice == element.name ? 1.6 : 1.0),
                    angularInset: 2
                )
                .foregroundStyle(element.color)
                .opacity(selectedSlice == nil ? 1.0 : (selectedSlice == element.name ? 1.0 : 0.4))
                .cornerRadius(6)
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    VStack{
                        if currentData.isEmpty {
                            Text("Select another month")
                        }
                        else {
                            Text(selectedSlice ?? "Select a slice")
                                .bold()
                            if selectedSlice == nil{
                                
                            }
                            else {
                                Text("\(selectedSliceSum ?? 0.0, specifier: "%.2f")")
                                + Text(currency)
                                Text("\(selectedSliceSumPercentage ?? 0.0, specifier: "%.2f")%")
                            }
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            .chartLegend(.hidden)
            .chartAngleSelection(value: $selectedSliceValue)
            .frame(height: 350)
            .animation(.spring(), value: selectedSlice)
        }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground).shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 5))
            .padding(.horizontal)
    }
}

struct BarChartView : View {
        let cData: [(Date, Double)]
        let selectedCurrency: String
        let totalExpenses: Double
        
        @State private var currentHover: (Date, Double)? = nil
    
        var body: some View {
            
            let maxAmount = cData.map { $0.1 }.max() ?? 0
            let yAxisTop = ceil(maxAmount * 1.1) //round up a bit the graph
            let yAxisDomainTop = yAxisTop > 0 ? yAxisTop : 10 //ensure that when the data is empty, the line is at the bottom
            
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
                    ForEach(cData, id: \.0) { (date, value) in
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
                .chartYScale(domain: 0.0...yAxisDomainTop)
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x) {
                                            // Find the closest data point
                                            if let nearest = cData.min(by: { abs($0.0.timeIntervalSince(date)) < abs($1.0.timeIntervalSince(date)) }) {
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
                .frame(height: 250)
            }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground).shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 5))
        .padding(.horizontal)
    }
}

#Preview {
    let transactionListVM: TransactionListViewModel = {
        let tranasctionListVM = TransactionListViewModel()
        tranasctionListVM.transactions = transactionListPreviewData
        return tranasctionListVM
    }()
    PieChartView()
        .environmentObject(transactionListVM)
}
