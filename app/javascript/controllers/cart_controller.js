import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  initialize() {
    console.log("cart controller initialized")
    
    this.taxRates = {
      "ON": { gst: 0.05, pst: 0.08, hst: 0.13 },
      "QC": { gst: 0.05, pst: 0.09975, hst: 0.00 },
      "BC": { gst: 0.05, pst: 0.07, hst: 0.00 },
      "AB": { gst: 0.05, pst: 0.00, hst: 0.00 },
      "MB": { gst: 0.05, pst: 0.07, hst: 0.00 },
      "SK": { gst: 0.05, pst: 0.06, hst: 0.00 },
      "NS": { gst: 0.05, pst: 0.10, hst: 0.00 },
      "NB": { gst: 0.05, pst: 0.10, hst: 0.00 },
      "PE": { gst: 0.05, pst: 0.10, hst: 0.00 },
      "NL": { gst: 0.05, pst: 0.00, hst: 0.00 },
      "NT": { gst: 0.05, pst: 0.00, hst: 0.00 },
      "YT": { gst: 0.05, pst: 0.00, hst: 0.00 },
      "NU": { gst: 0.05, pst: 0.00, hst: 0.00 }
    };

    const cart = JSON.parse(localStorage.getItem("cart"))
    if (!cart) {
      return
    }

    let total = 0
    let pstTotal = 0
    let gstTotal = 0
    let hstTotal = 0

    for (let i = 0; i < cart.length; i++) {
      const item = cart[i]
      total += item.price * item.quantity
      const div = document.createElement("div")
      div.classList.add("mt-2")
      div.innerText = `Item: ${item.name} - $${(item.price / 100.0).toFixed(2)} - Size: ${item.size} - Quantity: ${item.quantity}`
      
      pstTotal += (item.price * item.quantity) * 0.07
      gstTotal += (item.price * item.quantity) * 0.05

      const deleteButton = document.createElement("button")
      deleteButton.innerText = "Remove"
      deleteButton.value = JSON.stringify({id: item.id, size: item.size})
      deleteButton.classList.add("bg-gray-500", "rounded", "text-white", "px-2", "py-1", "ml-2")
      deleteButton.addEventListener("click", this.removeFromCart)
      div.appendChild(deleteButton)
      this.element.prepend(div)
    }

    const provinceDropdown = document.getElementById("province")
    provinceDropdown.addEventListener("change", (event) => this.updateTaxes(event, total, cart));

    const province = provinceDropdown.value || "ON" 
    this.updateTaxes({ target: { value: province } }, total, cart);
  }

  updateTaxes(event, total, cart) {
    const province = event.target.value;
    const { gst, pst, hst } = this.taxRates[province] || this.taxRates["ON"];

    let pstTotal = 0;
    let gstTotal = 0;
    let hstTotal = 0;

    for (let i = 0; i < cart.length; i++) {
      const item = cart[i];
      if (pst) pstTotal += (item.price * item.quantity) * pst;
      gstTotal += (item.price * item.quantity) * gst;
      if (hst) hstTotal += (item.price * item.quantity) * hst;
    }

    const totalWithTax = total + pstTotal + gstTotal + hstTotal;

    const totalEl = document.getElementById("total");
    totalEl.innerHTML = `
      Subtotal: $${(total / 100.0).toFixed(2)} 
      - PST: $${(pstTotal / 100.0).toFixed(2)} 
      - GST: $${(gstTotal / 100.0).toFixed(2)} 
      - HST: $${(hstTotal / 100.0).toFixed(2)} 
      - Total: $${(totalWithTax / 100.0).toFixed(2)}
    `;
  }

  clear() {
    localStorage.removeItem("cart")
    window.location.reload()
  }

  removeFromCart(event) {
    const cart = JSON.parse(localStorage.getItem("cart"))
    const values = JSON.parse(event.target.value)
    const { id, size } = values
    const index = cart.findIndex(item => item.id === id && item.size === size)
    if (index >= 0) {
      cart.splice(index, 1)
    }
    localStorage.setItem("cart", JSON.stringify(cart))
    window.location.reload()
  }

  checkout() {
    const cart = JSON.parse(localStorage.getItem("cart"))
    const payload = {
      authenticity_token: "",
      cart: cart
    }

    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch("/checkout", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify(payload)
    }).then(response => {
        if (response.ok) {
          response.json().then(body => {
            window.location.href = body.url
          })
        } else {
          response.json().then(body => {
            const errorEl = document.createElement("div")
            errorEl.innerText = `There was an error processing your order. ${body.error}`
            let errorContainer = document.getElementById("errorContainer")
            errorContainer.appendChild(errorEl)
          })
        }
      })
  }
}