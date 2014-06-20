Package.describe({
  summary: 'A pattern to display application errors to the user'
});

Package.on_use(function(api, where) {
  api.use(['minimongo', 'mongo-livedata', 'templating', 'jade', 'coffeescript'], 'client');

  //api.add_files(['errors.coffee', 'errors_list.jade', 'errors_list.coffee'], 'client');
  //api.add_files(['errors.js', 'errors_list.jade', 'errors_list.js'], 'client');
  api.add_files(['errors.js', 'errors_list.jade', 'errors_list.coffee', 'global_variables.js'], 'client');
    
  //if (api.export) 
  //  api.export('Errors');

  console.log('[--------')
  console.log(api.export);
  console.log(api.export('Errors'));
  console.log('--------]')

});
