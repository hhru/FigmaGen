using_bundler = defined? Bundler

unless using_bundler
  puts "\nPlease re-run using:".red
  puts "  bundle exec pod install\n\n"

  exit(1)
end

platform :macos, '10.12'
inhibit_all_warnings!
use_frameworks!

source 'https://cdn.cocoapods.org/'

target 'FigmaGen' do
  pod 'SwiftLint'
  pod 'SwiftCLI'
  pod 'RainbowSwift'
  pod 'Yams'
  pod 'PathKit'
  pod 'Stencil'
  pod 'StencilSwiftKit'
  pod 'Alamofire', '~> 5.0.0-rc.2'
  pod 'PromiseKit'
end

target 'FigmaGenTests' do
  inherit! :search_paths
end
