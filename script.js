document.addEventListener("contextmenu", (e) => e.preventDefault());

document.getElementById("discordBtn").addEventListener("click", () => {
  window.open("https://discord.gg/9krxH9g4MH", "_blank");
});

document.getElementById("githubBtn").addEventListener("click", () => {
  window.open("https://github.com/deadhoes/EyeHub", "_blank");
});

const toggle = document.getElementById("modeToggle");
const body = document.body;

toggle.addEventListener("change", () => {
  if (toggle.checked) {
    body.classList.remove("light-mode");
    body.classList.add("dark-mode");
  } else {
    body.classList.remove("dark-mode");
    body.classList.add("light-mode");
  }
});
