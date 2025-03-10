//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController {
    
    private let productId = "com.tramalho.InspoQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        if isPurchesed() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = quotesToShow.count
        
        if !isPurchesed() {
            count += 1
        }
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.0785657838, green: 0.3977849483, blue: 0.4162432551, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiunQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        sKPayment().restoreCompletedTransactions()
    }


}

// MARK: - In-App Purchase
extension QuoteTableViewController: SKPaymentTransactionObserver {
    
    fileprivate func sKPayment() -> SKPaymentQueue {
        return SKPaymentQueue.default()
    }
    
    private func buyPremiunQuotes() {
        if SKPaymentQueue.canMakePayments() {
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            sKPayment().add(paymentRequest)
            
        } else {
            print("User can't make payments")
        }
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        transactions.forEach { transaction in
            if transaction.transactionState == .purchased {
                sKPayment().finishTransaction(transaction)
                showPremiumQuotes()
            } else if transaction.transactionState == .failed {
                sKPayment().finishTransaction(transaction)
                print("Failed \(String(describing: transaction.error?.localizedDescription))")
            } else if transaction.transactionState == .restored {
                navigationItem.setRightBarButton(nil, animated: true)
                sKPayment().finishTransaction(transaction)
                showPremiumQuotes()
            }
        }
    }
    
    private func showPremiumQuotes() {
        UserDefaults.standard.setValue(true, forKey: productId)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    fileprivate func isPurchesed() -> Bool {
        return UserDefaults.standard.bool(forKey: productId)
    }
}
