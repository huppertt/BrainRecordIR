function figHand=LaunchSplash(imagefile)

I = imread(imagefile);

splashImage = im2java(I);
figHand = javax.swing.JWindow;
icon = javax.swing.ImageIcon(splashImage);
label = javax.swing.JLabel(icon);
set(label,'VerticalTextPosition',0);
set(label,'HorizontalTextPosition',0);

set(label,'Foreground',[0 1 0]);


figHand.getContentPane.add(label);

% get the actual screen size
screenSize = figHand.getToolkit.getScreenSize;
screenHeight = screenSize.height;
screenWidth = screenSize.width;
% get the actual splashImage size
imgHeight = icon.getIconHeight;
imgWidth = icon.getIconWidth;
% set the splash image to the center of the screen
figHand.setLocation((screenWidth-imgWidth)/2,(screenHeight-imgHeight)/2);
figHand.pack
figHand.show % show the splash screen


return