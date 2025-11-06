import { Controller } from "@hotwired/stimulus"
import { API_OPTIONS } from "./api/options.js"

export default class extends Controller {
  static targets = [
    "id", "lastId", // navBar
    "banner", "bannerTitle", "bannerSpinner", // Banner
    "error", "debug", // Main content
  ]

  static values = {
    creds: String,
    apiOptions: Object
  }

  connect() {
    console.log("API Controller connected")
    this.selectOption({ params: { option: 'Asst' } })
  }

  selectOption = (event) => {
    const optionKey = event.params.option
    this.apiOptionsValue = API_OPTIONS[optionKey]

    // Update banner
    this.bannerTitleTarget.textContent = this.apiOptionsValue.text
    this.bannerTarget.style.backgroundColor = this.apiOptionsValue.color
    this.bannerSpinnerTarget.style.display = 'none'
  }

  submit = async () => {
    const optionUrl = `${this.apiOptionsValue.url}/${this.idTarget.value}`;
    this.lastIdTarget.innerHTML = `Último Id: <strong>${this.idTarget.value}</strong>`
    this.showSpinner(true)
    debugger

    try {
      console.log(`Sending ${this.apiOptionsValue.method} request to ${optionUrl}`)
      const response = await fetch(optionUrl, {
        method: this.apiOptionsValue.method,
        headers: {
          "Authorization": `Basic ${this.credsValue}`,
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      })
      const data = await response.json()

      console.log('API Response:', data)
      if (!response.ok) {
        // Handle HTTP errors
        let errorMsg
        if (typeof data === 'string') {
          if (result === '') {
            errorMsg = `HTTP Error ${response.status}: ${response.statusText}`
          } else {
            try {
              const json = JSON.parse(result)
              errorMsg = json.status || json.error || result
            } catch (e) {
              errorMsg = result
            }
          }
        } else {
          errorMsg = result.status || result.error || JSON.stringify(result)
        }


        this.showError(errorMsg)
      } else {
        // Success
        this.showError(null)
      }

    } catch (error) {
      // Network or other errors
      debugger
      this.showError(`Error de conexión: ${error.message}`)
    } finally {
      // Always execute cleanup
      this.showSpinner(false)
      this.idTarget.focus()
    }
  }

  showSpinner(show) {
    this.bannerSpinnerTarget.style.display = show ? 'inline-block' : 'none'
  }

  showError(message) {
    if (!message || message.trim() === '') {
      this.errorTarget.style.display = 'none'
      return
    }

    this.errorTarget.style.display = 'block'
    this.errorTarget.innerHTML = `
    <h2>
      <i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> Error<br><br>
      <span>${message}</span>
    </h2>
    <code class="font-monospace"></code>`
  }

  showDebug(code) {
    this.debugTarget.textContent = code
  }
}
