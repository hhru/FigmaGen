Pod::Spec.new do |spec|
  spec.name = 'FigmaGen'
  spec.version = `make version`
  spec.summary = 'Swift code & resources generator for your Figma files.'

  spec.homepage = 'https://github.com/hhru/FigmaGen'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Almaz Ibragimov" => "almazrafi@gmail.com" }

  spec.source = {
    http: "https://github.com/hhru/FigmaGen/releases/download/#{spec.version}/figmagen-#{spec.version}.zip"
  }

  spec.preserve_paths = '*'
  spec.exclude_files = '**/file.zip'

  spec.ios.deployment_target = '11.0'
  spec.osx.deployment_target = '10.13'
  spec.watchos.deployment_target = '4.0'
  spec.tvos.deployment_target = '11.0'
end
