Pod::Spec.new do |s|
  	s.name         		= "JBMessage"
 	s.version      		= "1.1"
  	s.summary      		= "JBMessage is simple iOS networking wrapper based on AFNetworking"
  	s.homepage     		= "https://github.com/tdahuynguyen/JBMessage"
  	s.license      		= { :type => "MIT", :file => "LICENSE" }
  	s.author            = { "Josip Bernat" => "josip.bernat@gmail.com" }
  	s.social_media_url	= "http://twitter.com/josipbernat"
  	s.platform     		= :ios, "9.0"
  	s.source       		= { :git => "https://github.com/tdahuynguyen/JBMessage", :tag => "v1.1" }
  	s.source_files  	= 'JBMessage/JBMessage/**/*.{h,m}'
   	s.requires_arc 		= true
	s.dependency 		"AFNetworking", "~> 4.0"
end

