document.addEventListener('contextmenu', function(e) {
  e.preventDefault();
});

document.querySelectorAll('a[href^="http"]').forEach(link => {
  link.setAttribute('rel', 'noopener noreferrer');
});
