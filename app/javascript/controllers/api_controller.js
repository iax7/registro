import { Controller } from "@hotwired/stimulus"
import { API_OPTIONS } from "./api/options.js"

export default class extends Controller {
  static targets = ["id",
    "banner", "bannerTitle", "bannerSpinner"
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

    try {
      const response = await fetch(optionUrl, {
        method: this.apiOptionsValue.method,
        headers: {
          "Authorization": `Basic ${this.credsValue}`,
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      })
      const data = await response.json()
      debugger


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

        this.setLastId(id)
        this.showError(errorMsg)
      } else {
        // Success
        this.errorTarget.style.display = 'none'
        this.mainTarget.style.display = 'block'

        // Call the appropriate handler
        apiAction.handler(result)
      }

    } catch (error) {
      // Network or other errors
      this.setLastId(id)
      this.showError(`Error de conexión: ${error.message}`)
    } finally {
      // Always execute cleanup
      this.setLastId(id)
      this.idTarget.value = ''
      this.hideSpinner()
      this.idTarget.focus()
    }
  }
}
