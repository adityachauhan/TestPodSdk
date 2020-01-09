
Pod::Spec.new do |spec|

  spec.name         = "TestPodSdk"
  spec.version      = "1.0.0"
  spec.summary      = "A short camers test pos spec"
  spec.description  = "A small framework that enables camera in your app"
  spec.homepage     = "https://github.com/adityachauhan/TestPodSdk"
  spec.license      = "None"
  spec.author       = { "Aditya Chauhan" => "aditya@khoslalabs.com" }
  spec.platform     = :ios, "12.4"
  spec.source       = { :git => "https://github.com/adityachauhan/TestPodSdk.git", :tag => "1.0.0" }
  spec.source_files  = "Kl-Scan-Sdk/**/*"

end
