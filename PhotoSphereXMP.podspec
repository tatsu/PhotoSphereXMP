Pod::Spec.new do |s|
  s.name         = "PhotoSphereXMP"
  s.version      = "0.9.0"
  s.summary      = "Photo Sphere XMP Parser in Swift"
  s.description  = <<-DESC
A Swift Parser for Photo Sphere XMP metadata that is serialized and embedded inside the photo sphere as described by the Adobe XMP standard.
                   DESC
  s.homepage     = "https://github.com/tatsu/PhotoSphereXMP"
  s.license      = "MIT"
  s.author       = { "Tatsuhiko Arai" => "email@address.com" }

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/tatsu/PhotoSphereXMP.git", :tag => "#{s.version}" }
  s.source_files  = "PhotoSphereXMP", "PhotoSphereXMP/**/*.{h,m}"
end
