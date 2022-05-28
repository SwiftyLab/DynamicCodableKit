require 'json'

Pod::Spec.new do |s|
  package = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

  s.name              = 'DynamicCodableKit'
  s.version           = package.version.to_s
  s.homepage          = package.homepage
  s.summary           = package.summary
  s.description       = package.description
  s.license           = { :type => package.license, :file => 'LICENSE' }
  s.documentation_url = "https://swiftylab.github.io/DynamicCodableKit/#{s.version}/documentation/#{s.name.downcase}/"
  s.social_media_url  = package.author.url

  s.source            = {
    package.repository.type.to_sym => package.repository.url,
    :tag => s.version
  }

  s.authors           = {
    package.author.name => package.author.email
  }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.macos.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.10'

  s.vendored_frameworks = "#{s.name}.xcframework"
end
