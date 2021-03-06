class UILabel_Adjustable
	# Borrowed and modified the excellent example at http://www.11pixel.com/blog/28/resize-multi-line-text-to-fit-uilabel-on-iphone/
	# adaption for RubyMotion by Thom Parkin (https://github.com/ParkinT )
	#      This applies only to a multi-line label.  You can use '.adjustsFontSizeToFitWidth = true' for a single-line label

	# usage is:
	#   text = "It's bad luck to be superstitious"
	#   text_label = UILabel.alloc.initWithFrame([[20, 20], [70, 120]])
	#   text_label.numberOfLines = 0 # set 0 for word wrap
        #   text_label.lineBreakMode = UILineBreakModeWordWrap
        #   text_label.setText(text)
	#   adjustableLabel = UILabel_Adjustable.new({:fontName => "Arial", :fontSize => 72, :msg => text, :labelHeight => 120, :labelWidth => 360.0})
	#    ==== or you can be more verbose ====
        #   adjustableLabel = UILabel_Adjustable.new()
        #   adjustableLabel.fontName = "Arial"
        #   adjustableLabel.fontSize = 72
        #   adjustableLabel.msg = text
        #   text_label.setFont(adjustableLabel.bestFit)

  DEBUG_MODE = false
	MIN_FONT_SIZE = 8.0  #change this as desired for your purposes

    PROPERTIES=[
	    :msg,  # the text to display in the UILabel
			:fontName, #define the font you want (using iOS font name)
			:fontSize, #define the largest font size you want
			:labelHeight, #this must be set - the height of your UILabel
      :labelWidth   #this must be set - the height of your UILabel
    ]
    PROPERTIES.each{|prop|
      attr_accessor prop 
    }

	def initialize(params = {})
=begin
		@labelHeight = params[:labelHeight] if params[:labelHeight]
		@fontName = params[:fontName] if params[:fontName]
		@fontSize = params[:fontSize] if params[:fontSize]
		@msg = params[:msg] if params[:msg]
=end
		params.each{ |key,value|
        if self.class.const_get(:PROPERTIES).member?key.to_sym
          self.send((key.to_s+"=:").to_sym,value)
        end
    }
	end

	def bestFit
		#some defaults
		@msg ||= "It's bad luck to be superstitious"
		@fontName ||= "Marker Felt"
		@fontSize ||= 28
    @labelHeight ||= 80.0
    @labelWidth ||= 360.0

		font = UIFont.fontWithName(@fontName, size:@fontSize)
		# the loop begins at the largets font size and counts down two point sizes until
		# either it hits a size that will fit or the minimum size we want to allow
		for s in @fontSize.downto(MIN_FONT_SIZE) do
			#set the font size
			font = font.fontWithSize(s)
			NSLog("Trying size: #{s}") if DEBUG_MODE
	        #This step is important: We make a constraint box using only the fixed WIDTH of the UILabel.
	        #The height will be checked later.

			#Next, check how tall the label would be with the desired font.
			labelSize = @msg.sizeWithFont(font, constrainedToSize:[@labelWidth, Float::MAX], lineBreakMode:UILineBreakModeWordWrap)
			#Here is where you use the height requirement!
	   		#Set the value in the if statement to the height of your UILabel
	   		#If the label fits into your required height, it will break the loop and use that font size.
			break if(labelSize.height <= @labelHeight)
		end
	 	NSLog("Best size is: #{s}") if DEBUG_MODE
		#return the selected font
		font
	end
end