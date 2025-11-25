import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const html = document.documentElement
    const currentTheme = html.classList.contains("dark") ? "dark" : "light"
    const newTheme = currentTheme === "dark" ? "light" : "dark"

    if (newTheme === "dark") {
      html.classList.add("dark")
    } else {
      html.classList.remove("dark")
    }

    // Save preference
    document.cookie = `theme=${newTheme};path=/;max-age=31536000`

    // Optional: notify server
    fetch("/toggle_theme", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      }
    })
  }
}
