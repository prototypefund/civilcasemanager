// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
//import L from "../vendor/node_modules/leaflet";
//import 'leaflet/dist/leaflet.css';


let Hooks = {};

Hooks.FadeIn = {
  updated() {
    this.el.classList.add("fade-in");
  },
  mounted() {
    if (document.body.classList.contains("initial-mount-complete")) {
      this.el.classList.add("fade-in");
    }
  }
};

Hooks.ParentMount = {
  mounted() {
    // Enable insert animation 100ms after page load
    setTimeout(function(){
      document.body.classList.add("initial-mount-complete");
    }, 100)
  }
};

Hooks.FormHelpers = {
  updated() {
    // `this.el` references the parent form
    let firstError = this.el.querySelector(".has-errors");
    if (firstError) {
      firstError.scrollIntoView({ behavior: "smooth", block: "end", inline: "nearest" });
    }
  }
}

Hooks.Leaflet = {
  mounted() {
      const el = this.el;
      const map = L.map(el).setView([36, 16], 2);
      L.tileLayer(
          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          {
              attribution:
                  '© OpenStreetMap contributors',
              maxZoom: 16,
          }
      ).addTo(map);

      const positions = JSON.parse(el.dataset.positions);
      const bounds = L.latLngBounds();
    
      positions.forEach(pos => {
        L.marker([pos.lat, pos.lon]).bindPopup(`Timestamp: ${pos.timestamp}`).addTo(map);
        bounds.extend([pos.lat, pos.lon]);
      });

      if (positions.length > 0) {
       map.fitBounds(bounds, {
        maxZoom: 7
       });
      }
  },
};

Hooks.ThemeToggle = {
  mounted() {
    this.updateTheme(localStorage.theme || 'system')
    this.handleClickOutside = (event) => {
      if (!this.el.contains(event.target)) {
        this.hideThemeMenu()
      }
    }
    document.addEventListener('click', this.handleClickOutside)
    
        this.el.querySelectorAll('#theme-menu a').forEach(link => {
          link.addEventListener('click', (event) => {
            event.preventDefault();
            const theme = event.target.getAttribute('phx-value-theme');
            this.setTheme(theme);
          });
        });
    
  },
  destroyed() {
    document.removeEventListener('click', this.handleClickOutside)
  },
  updated() {
    this.updateTheme(localStorage.theme || 'system')
  },
  updateTheme(theme) {
    if (theme === 'dark' || (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
    this.updateIcons(theme)
  },
  updateIcons(theme) {
    const lightIcon = this.el.querySelector('.light-icon')
    const darkIcon = this.el.querySelector('.dark-icon')
    const systemIcon = this.el.querySelector('.system-icon')
    if (theme === 'dark') {
      lightIcon.style.display = 'none'
      darkIcon.style.display = 'block'
      systemIcon.style.display = 'none'
    } else if (theme === 'light') {
      lightIcon.style.display = 'block'
      darkIcon.style.display = 'none'
      systemIcon.style.display = 'none'
    } else {
      lightIcon.style.display = 'none'
      darkIcon.style.display = 'none'
      systemIcon.style.display = 'block'
    }
  },
  hideThemeMenu() {
    this.el.querySelector('#theme-menu').style.display = 'none'
  },
  toggleThemeMenu() {
    const menu = this.el.querySelector('#theme-menu')
    menu.style.display = menu.style.display === 'none' ? 'block' : 'none'
  },
  setTheme(theme) {
    localStorage.theme = theme
    this.updateTheme(theme)
    this.hideThemeMenu()
  }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
  dom: {
    onBeforeElUpdated: (fromEl, toEl) => {
      if(["DIALOG", "DETAILS"].indexOf(fromEl.tagName) >= 0){
        Array.from(fromEl.attributes).forEach(attr => {
          toEl.setAttribute(attr.name, attr.value)
        })
      }
    }
  }
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


