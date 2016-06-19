module Admin
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path('app/datatables')

    isolate_namespace Admin
  end
end
