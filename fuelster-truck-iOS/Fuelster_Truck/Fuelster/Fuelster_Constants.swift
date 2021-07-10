//
//  Fuelster_Constants.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

let kappName     = "Fuelster"
let kstoryBoardName = "Main"

// MARK: User Constants
let kUserFirstName = "firstName"
let kUserLastName = "lastName"
let kUserEmail = "email"
let kUserPhone = "phone"
let kUserPassword = "password"
let kUserAuthToken = "authToken"
let kUserRefreshToken = "refreshToken"
let kUserNewPassword = "newPassword"
let kUserOldPassword = "oldPassword"
let kuserCity = "city"
let kUserAddress = "address"
let kuserCountry = "country"
let kuserLine1 = "line1"
let kuserLine2 = "line2"
let kuserState = "state"
let kuserZipcode = "zipcode"
let kuserEmergencyNumber = "emergencyPhone"


let kUserRole = "role"
let kUserProfilePicture = "profilePicture"
let kUserName = "username"
let kUserId = "_id"
let kDeviceToken = "deviceToken"
// MARK: Vehicle Constants

let kVehicleTitle = "title"
let kVehicleMake = "make"
let kVehicleModel = "model"
let kVehicleNumber = "vehicleNumber"
let kVehicleFuel = "fuel"
let kVehiclePicture = "vehiclePicture"
let kVehicleId = "_id"
let kVehicleCard = "card"




// MARK: Credit Card

let kCardholderName = "cardholderName"
let kCardNumber = "cardNumber"
let kCardCvv = "cvv"
let kCardHolderName = "cardholderName"
let kCardExpiry = "expiry"
let kCardZipcode = "zipcode"
let kCardId = "_id"


//MARK: Truck

let kTruckNumber = "truckNumber"
let kTruckId = "_id"
let kTruckDriverId = "driver"



//MARK: Driver
let kDriver =  "driver"
let kDriverName = "name"
let kDriverPhone = "phone"
let kDriverPhoto = "photo"
let kDriverCity = "city"
let kDriverState = "state"
let kDriverZipcode = "zipcode"


//MARK: Fuel

let kFuel = "fuel"
let kFuelType = "fuelType"
let kFuelPrice = "price"
let kFuelId = "_id"


//MARK: Orders
let kOrderLongitude = "lon"
let kOrderLatiitude = "lat"
let kOrderQuantity = "quantity"
let kOrderStatus = "status"
let kOrderCancelReason = "cancelReason"
let kOrderEstimatedTime = "estimatedTime"
let kOrderDeliveryTimee = "deliveryTime"
let kOrderRating = "rating"
let kOrderCreateAt = "createAt"
let kOrderUpdatedAt = "updatedAt"
let kOrderFlaggedBy = "flaggedBy"
let kOrderId = "orderId"
let kOrderLocation = "location"
let kOrderUser = "user"
let kOrderVehicle = "vehicle"


//MARK: Notifications

let kNotificationSenderId = "_id"
let kNotificationSenderName = "name"
let kNotificationReceiverId = "_id"
let kNotificationReceiverName = "name"
let kNotificationIsViewed = "isViewed"
let kNotificationMessage = "message"
let kNotificationCreatedAt = "createdAt"
let kNotification = "cancelReason"


//MARK: Location

let kLocationLongitude = "lon"
let kLocationLattitude = "lat"
let kLocationCreatedBy = "createdBy"
let kLocation = "cancelReason"


//MARK:API Status Codes

let kRequestSuccessCode = 200
let kRequestError400 = 400
let kRequestError401 = 401
let kRequestError403 = 403
let kRequestError404 = 404
let kRequestError405 = 405
let kRequestError415 = 415
let kRequestError500 = 500


//MARK:API Status code Messages
let kUserSignUpSuccessMessage = "registered successfully"
let kUserSignUpError400Message = "Please provide email"
let kUserSignUpError401Message = 401
let kUserSignUpError403Message = 403
let kUserSignUpError404Message = 404
let kUserSignUpError405Message = 405
let kUserSignUpError415Message = 415
let kUserSignUpError500Message = 500
let kRequestErrorMessage = "message"
let kUserLoginSuccessMessage = 200


//MARK: Hud Show mesages
let kHudLoggingMessage = "Logging..."
let kHudRegisteringMessage = "Registering..."
let kHudLoadingMessage = "Loading..."
let kHudWaitingMessage = "Please Wait..."


//MARK: Flurry Event mesages
let kFlurryLogin = "Sign in Tapped"
let kFlurryVehiclesList = "Vehicles list view populated"
let kFlurryAddNewVehicle = "Adding New Vehicle"
let kFlurryUpdateVehicle = "Editing Vehicle"
let kFlurryDeleteVehicle = "Deleting Vehicle"

//MARK: URL EndPoints


//MARK: USER End Points

let kUserSignUp = "/register" //"/signup"
let kUserEmailVerify = "/verify/"
let kUserLogin = "/login"
let kUserForgotPassword = "/forgot-password"
let kUserResetPassword = "/change-password"
let kUserLogout = "/logout"
let kGetUsers = "/users/"
let kGetUserInfo = "/user/"
let kGetUserUpdate = "/user"


//MARK: VEHICLE End Points

let kVehicleSave = "/vehicle"
let kGetVehicles = "/vehicles/"
let kGetVehicleInfo = "/vehicle/"


//MARK: CARD End Points

let kCardSave = "/card"
let kGetCards = "/cards/"
let kGetCardInfo = "/card/"


//MARK: TRUCK End Points

let kTruckSave = "/truck"
let kGetTrucks = "/trucks"
let kGetTruckInfo = "/truck/"

let kValidateTruckNumber = "/validate-truck"



//MARK: DRIVER End Points

let kDriverSave = "/driver"
let kGetDrivers = "/drivers"
let kGetDriverInfo = "/driver/"


//MARK: FUEL End Points

let kFuelSave = "/fuel"
let kGetFuels = "/fuels"
let kGetFuelInfo = "/fuel/"


//MARK: ORDERS End Points

let kOrderSave = "/order"
let kGetOrders = "/orders"
let kGetOrderInfo = "/order/"
let kGetOrderEstimatedTime = "/estimatedTime"


//MARK: NOTIFICATION End Points

let kNotificationSave = "/notification"
let kGetNotifications = "/notifications"
let kGetNotificationInfo = "/notifications/"


//MARK: LOCATION End Points

let kUpdateLocation = "/location"

//MARK: Alert Messages

let kSignUpAllDetailsMessage = "Please enter all the mandatory fields."
let kEmailvalidationMessage = "Please enter valid email address."
let kPhoneNumberValidationMessage = "Please enter a valid phone number."
let kPasswordValidationMessage = "Entered password does not the requirements. Please try again."
let kLoginErrorMessage = "Entered password does not the requirements. Please try again."
let kDeleteSureMessage = "Are you sure to delete vehicle?"

let kPasswordValidationMaxLengthMessage = "Please enter a password minimum of 6 digits and maximum of 20 digits."
let kUserNameValidationMaxLengthMessage = "Please enter a Firstname and Lastname more than 2 characters."

let kvalidNumberPlateationMessage = "Please enter valid vechicle number."



//MARK: Stripe Messages
let kStripeCardNumberErrorMessage = "Your card's number is invalid"
let kStripeCardNameOnCardErrorMessage = "Your name on card is invalid"
let kStripeCardSecurityErrorMessage = "Your card's security code is invalid"
let kStripeCardExpirationDateErrorMessage = "Your card's expiration year is invalid"
let kStripeCardExpirationYearErrorMessage = "Your card's expiration year is invalid"
let kStripeCardExpirationMonthErrorMessage = "Your card's expiration month is invalid"

let kStripeCardDetailsErrorMessage = "Please enter valid credit card details."



let POSTMETHOD = "POST"
let GETMETHOD = "GET"
let PUTMETHOD = "PUT"
let DELETEMETHOD = "DELETE"


//MARK: KVO PATH KEYS

let MYLOCATIONKEYPATH = "myLocationAddress"
let MYLOCATIONTITLE = "title"

//MARK: StoryBoard IDS and ViewControllers IDS
let VEHICLE_STORYBOARD = "Fuelster_Vehicle"
let VEHICLEVC = "Fuelster_Vehicle_ListVC"
let MAIN_STORYBOARD = "Main"
let MAINVC = "MainOrdersVC"
let MENUVC = "MenuVC"
let PROFILEVC = "ProfileVC"
let SETTINGSVC = "SettingsVC"
let HELPVC = "HelpVC"
let ORDER_HISTORY_VC = "OrderHistoryVC"
let ORDER_FINISH_VC = "OrderFinishVC"
let VEHICLE_ADDVC = "Fuelster_AddNewVehicle"
let ORDER_FUELVC = "OrderFuelVC"
let ORDER_MAPVC = "OrderMapVC"
let PAYMENTCARDSTORYBOARD = "PaymentCard"
let PAYMENTCARDVC = "PaymentCardsVC"
let ADDNEWCARDVC = "AddNewCardVC"
let VIEWCARDVC = "ViewCardVC"
let ORDER_DETAILVC = "OrderDetail"
let NUMBER_PLATE_VC = "NumberPlate"
let LOGIN_VC = "LoginVC"
let FORGOT_PWD_CONFIRMATION_VC = "ForgotPWConfirmation"
let NOTIFICATIONVC = "Fuelster_NotificationListVC"



enum UserAPIType{
    case Login
    case Register
    case EmailVerification
    case ForgotPassword
    case ResetPassword
    case Logout
}

let OrderStatusNew = "New"
let OrderStatusAccepted = "Accepted"
let OrderStatusCompleted = "Completed"
let OrderStatusCancelled = "Canceled"

let MENU_HOME = "Home"
let MENU_ABOUT = "About Fuelster"
let MENU_PROFILE = "Profile"
let MENU_ORDER_HISTORY = "Order History"
let MENU_HELP = "Help"
let MENU_SETTINGS = "Settings"
let MENU_SIGNOUT = "Sign Out"

let MENU_HOME_IMAGE = "Home_small"
let MENU_ABOUT_IMAGE = "About_small"
let MENU_PROFILE_IMAGE = "Profile_small"
let MENU_ORDER_HISTORY_IMAGE = "Order_small"
let MENU_HELP_IMAGE = "Info_small"
let MENU_SETTINGS_IMAGE = "Settings_small"
let MENU_SIGNOUT_IMAGE = "Signout_small"


let VEHILCE_LIST_TITLE = "Select your vehicle"
let ADD_VEHICLE_TITLE = "Add Vehicle"
let VEHICLE_LIST_TITLE = "My Vehicles"

let ADD_CARD_TITLE = "Add Card"
let ADD_NEW_CARD_TITLE = "Add New Card"
let CARDS_LIST_TITLE = "My Cards"



let SELECT_FUEL_TITLE = "Select your fuel"

let ORDER_PROCESSING_TITLE = "Order Processing"
let ORDER_DECLINED_TITLE = "Order Declined"
let ORDER_CONFIRMATION_TITLE = "Order COnfirmation"
let ORDER_TRACK_TITLE = "Track Order"
let ORDER_COMLETE_TITLE = "Order Complete"
let ORDER_DETAILS = "Order Details"
let CANCEL_REASONS = "Reasons for Cancellation"

//MARK : TABLEVIEWCELL 

let MENUCELL = "MenuCell"
let PROFILECELL = "ProfileCell"
let ORDERHISTORYCELL = "OrderHistoryCell"
let OrderHistoryCell2 = "OrderHistoryCell2"
let LOADINGCELL = "LoadingCell"


//MARK:--- Credit card types
let CREDITCARD_EMPTY = "EMPTY"