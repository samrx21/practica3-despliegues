// Mostrar la fecha actual y estado del sistema
document.addEventListener('DOMContentLoaded', () => {
  const footer = document.querySelector('footer p');
  const year = new Date().getFullYear();
  const dateStr = new Date().toLocaleDateString('es-CO', {
    year: 'numeric', month: 'long', day: 'numeric'
  });

  if (footer) {
    footer.textContent = `Práctica 3 — Despliegue de Software · IIS y Azure App Service · ${dateStr}`;
  }

  // Verificar /health en vivo
  fetch('/health/')
    .then(r => r.text())
    .then(text => {
      const cards = document.querySelectorAll('.status-card');
      if (cards[2]) {
        const dot = cards[2].querySelector('.status-dot');
        const span = cards[2].querySelector('span');
        if (text.includes('OK') || text.includes('ok')) {
          dot.classList.add('green');
          span.textContent = 'Respondiendo: ' + text.trim();
        }
      }
    })
    .catch(() => {});
});
