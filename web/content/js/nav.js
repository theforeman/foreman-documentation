function buildNavigation() {
  const versionRe = new RegExp(`/(nightly|\\d+.\\d+)/`);
  var currentVer = document.location.toString().match(versionRe);
  if (currentVer && currentVer.length > 1) {
    currentVer = currentVer[1];
  } else {
    currentVer = "nightly";
  }
  const navBuilds = navVersions.find(function(version) {
    return version['foreman'] == currentVer;
  }).builds;

  return `<nav>
  <a href="/">
    <img class="logo" src="/img/helmet.svg" alt="Home">
  </a>
<button type="button" class="btn-hamburger" data-action="nav-toggle">
  <span></span>
  <span></span>
  <span></span>
  <span></span>
  <span></span>
</button>
<ul class="nav-menu">
  <li class="nav-item"><a href="/">Home</a></li>`
    + navBuilds.map(function(build){
      return(
        `<li class="nav-item dropdown">
          <a href="#" data-action="dropdown-toggle">${build.title}</a>
            <div class="dropdown-menu">`
            + build.guides.map(function(guide){
              const url = `/${currentVer}/${guide.path}/${build.filename}`;
              return `<div class="dropdown-div"><a class="dropdown-item" href="${url}">${guide.title}</a></div>`;
            }).join("")
            +`</div>
        </li>`
      )}).join("")
    + `<li class="nav-item dropdown">
        <a href="#" data-action="dropdown-toggle">Version ${currentVer}</a>
        <div class="dropdown-menu dropdown-menu-left">`
    + navVersions.map(function(version) {
      if (document.location.pathname == "/") {
        var dl = `/release/${version.foreman}`;
      } else {
        var dl = document.location.toString().replace(versionRe, `/${version.foreman}/`);
      }
      return(`<div class="dropdown-div"><a class="dropdown-item" href=${dl}>${version.title}</a></div>`
      )}).join("")
    +`</div>
    </li>
  </ul>
</nav>`;
}

function toggleElement(dropdown) {
  if (dropdown.classList.contains("show")) {
    dropdown.classList.remove("show");
  } else {
    dropdown.classList.add("show");
  }
}

function closeAll(except) {
  const elems = document.getElementsByClassName("nav-item");
  for (let i = 0; i < elems.length; i++) {
    const elem = elems[i];
    if (elem != except) {
      elem.classList.remove("show");
    }
  };
}

var addNavbarListeners = () => {
  const nav = document.querySelector("nav");
  nav.querySelectorAll("[data-action='dropdown-toggle']").forEach((dropdownToggle) => {
    dropdownToggle.addEventListener("click", () => {
      closeAll(dropdownToggle.parentElement);
      toggleElement(dropdownToggle.parentElement);
    });
  });

  nav.querySelector("[data-action='nav-toggle']").addEventListener("click", () => {
    if (nav.classList.contains("opened")) {
      nav.classList.remove("opened");
    } else {
      nav.classList.add("opened");
    }
  });
}
