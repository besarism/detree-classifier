import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var age = ""
    @State private var income = ""
    @State private var creditScore = ""
    
    @State private var predictionResult = ""
    
    let model = try! LoanApprovalClassifier(configuration: MLModelConfiguration())
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Loan Approval Predictor")
                .font(.title)
                .bold()
            
            TextField("Age", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            TextField("Income", text: $income)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            TextField("Credit Score", text: $creditScore)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Button(action: predictApproval) {
                Text("Predict")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(predictionResult)
                .font(.headline)
                .padding()
            
            Spacer()
        }
        .padding()
    }
    
    func predictApproval() {
        guard let ageVal = Double(age),
              let incomeVal = Double(income),
              let creditVal = Double(creditScore) else {
            predictionResult = "Please enter valid numbers."
            return
        }
        
        do {
            let prediction = try model.prediction(
                Age: ageVal,
                Income: incomeVal,
                CreditScore: creditVal
            )
            
            predictionResult = prediction.Approved == 1 ? "✅ Loan Approved!" : "❌ Loan Not Approved."
        } catch {
            predictionResult = "Prediction failed: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
