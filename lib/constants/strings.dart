class Strings {

  static const String stringAppName = 'Felixx';
  static const String patternEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String stringUnknown = 'Unknown';
  static String stringVersion = 'Version: ';

  static String stringContinueEmail = 'Continue with Email';
  static String stringContinueEmailHeader = 'Please Enter the Gate Pass below';
  static String stringName = 'Name';
  static String stringEmail = 'Email Address';
  static String stringPhone = 'Phone Number';
  static String stringProceed = 'Proceed';
  static String stringCancel = 'Cancel';
  static String stringRetry = 'Retry';

  static String stringContinueGoogle = 'Continue with Google';

  static String stringWelcome = 'Hey,';
  static String stringUser = 'User';

  static String stringAddAnAlbum = 'Add an Album';
  static String stringScanAnAlbumCode = 'Scan an Album Code';
  static String stringShareAlbum = 'Share Album';
  static String stringRemoveAlbum = 'Remove Album';
  static String stringLogout = 'Logout';
  static String stringAreYouSure = 'Are you sure?';
  static String stringYes = 'Yes';
  static String stringNo = 'No';
  static String stringConfirmExit = 'You\'re one tap away from EXIT!';

  static String stringErrorName = 'Please enter your name!';
  static String stringErrorEmail = 'Please enter your email!';
  static String stringErrorEmailValid = 'Please enter a valid Email ID!';
  static String stringTypeEmail = 'email';
  static String stringErrorPhone = 'Please enter a valid phone number!';
  static String stringErrorNoData = 'Sorry!\nNo data found!';
  static String stringErrorContinueGoogle = 'Authentication error! Please try again...';
  static String stringOTPVerificationHeader = 'OTP Verification';
  static String stringOTPVerificationMessage = 'Enter the OTP sent to ';
  static String stringOTPVerificationPaste = 'Paste OTP?';
  static String stringOTPVerificationMessageWait = 'Verifying OTP...';
  static String stringOTPVerificationNoOTP = 'Didn\'t receive the OTP?';

  static String stringPublishedBy = 'Published By: ';
  static String stringAddAlbumHeader = 'Please enter the Album ID';
  static String stringAlbumID = 'Album ID';
  static String stringAddAlbum = 'Add Album';
  static String stringErrorAlbumID = 'Please enter a valid Album ID!';
  static String stringScanAlbumHeader = 'Please scan\nthe QR code of Album';
  static String stringShareAlbumHeader = 'Hey, check out the Album in ${Strings.stringAppName}!\n\nAdd album with code ';
  static String stringShareAlbumURL = '.\n\n\nDownload the Felixx app here';

  static String imageHome = 'assets/images/';
  static String imageLogo = '${imageHome}logo.png';
  static String imageSplash = '${imageHome}splash.jpg';
  static String imageNoResult = '${imageHome}no_result.png';
  static String imagePlaceholder = '${imageHome}placeholder.png';

  static String iconHome = 'assets/icons/';
  static String iconEmail = '${iconHome}email_logo.png';
  static String iconGoogle = '${iconHome}google_logo.png';
  static String iconWhatsapp = '${iconHome}whatsapp.png';
  static String iconDelete = '${iconHome}delete.png';

  static String urlMain = 'https://album.univexsolutions.in';
  static String urlAPI = '$urlMain/api';
  static String urlLogin = '$urlAPI/login';
  static String urlLogout = '$urlAPI/logout';
  static String urlToken = '$urlAPI/token-checking';
  static String urlAlbumList = '$urlAPI/album/list';
  static String urlAlbumAdd = '$urlAPI/user/album/add';
  static String urlAlbumRemove = '$urlAPI/user/album/remove';
  static String urlAlbumDetails = '$urlAPI/album/view';
}