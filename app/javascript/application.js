// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@fortawesome/fontawesome-free"

const dropdownbtn = document.querySelectorAll(".dropdownbtn")
const dropdownbox = document.querySelectorAll(".dropdownbox")



dropdownbtn.forEach((dropb, index) => {
    dropb.addEventListener("mouseover", () => {

        dropdownbox[index].classList.remove("active")
    })
    dropb.addEventListener("mouseout", () => {

        dropdownbox[index].classList.add("active")
    })
})
