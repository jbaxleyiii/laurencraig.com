Package.describe({
  summary: "Manipulate the DOM using CSS selectors",
  version: '1.0.0',
  name: "newspring:junction",
});

Package.onUse(function (api) {
  api.addFiles(['junction.js'], 'client');

  // api.export('$', 'client');
  api.export('junction', 'client');
});
