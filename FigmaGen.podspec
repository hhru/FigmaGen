Pod::Spec.new do |spec|
  spec.name = 'FigmaGen'
  spec.version = `make version`
  spec.summary = 'A tool to automate resources using the Figma API.'
  spec.osx.deployment_target = '10.12'

  spec.homepage = 'https://github.com/hhru/FigmaGen'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'HeadHunter iOS Team' => 'https://hh.ru' }

  spec.source = {
    http: "https://github.com/hhru/FigmaGen/releases/download/#{spec.version}/figmagen-#{spec.version}.zip"
  }

  spec.preserve_paths = '*'
  spec.exclude_files = '**/file.zip'
end
