function removePageFromHistory() {
    history.replaceState(null, '', location.href);
    window.addEventListener('popstate', function () {
      history.replaceState(null, '', location.href);
    });
  }
  
  window.onload = function () {
    removePageFromHistory();
  };

 /*window.addEventListener('popstate', function (event) {
    history.pushState(null, document.title, location.href);
  });*/