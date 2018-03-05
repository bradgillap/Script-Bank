try 
{ 
    import-module activedirectory  
} 
catch 
{ 
    write-Output "Error while importing Active Directly module, please install AD Powershell modules first before running this script." 
} 
 
# Get AD Users and export results to CSV.  Spacing seems to matter to powershell. Don't try to make a list.
Get-ADUser -Filter '*' |  select Enabled,EmployeeID,EmployeeNumber,SamAccountName,UserPrincipalName,Department,Organization,Company,Manager,Surname,GivenName,Initials,Name,StreetAddress,PostalCode,EmailAddress,OfficePhone,MobilePhone,Fax,HomePhone,HomePage,ObjectCategory,ProfilePath,LastLogonDate,LastBadPasswordAttempt,LockedOut,AccountExpirationDate,TrustedForDelegation,TrustedtoAuthForDelegation,Created,Deleted,Modified | Export-Csv c:\temp\ADUsers.csv
								

<#
Here are some other possible export categories/properties. Just add in the select statement above. 
Output that says Microsoft.ActiveDirectory.Management.ADPropertyValueCollection are multivalued array items such as memberof and require
a different solution.

AccountExpirationDate
AccountLockoutTime
AccountNotDeligated
AllowReversiblePasswordEncryption
BadLogonCount
CannotChangePassword
CanonicalName
Certificates
ChangePasswordAtLogon
City
CN
Company
Country
Created
Deleted
Department
Description
DisplayName
DistinguishedName
Division
DoesNotRequirePreAuth
EmailAddress
EmployeeID
EmployeeNumber
Enabled
Fax
GivenName
HomeDirectory
HomedirRequired
HomeDrive
HomePage
HomePhone
Initials
LastBadPasswordAttempt
LastKnownParent
LastLogonDate
LockedOut
LogonWorkstations
Manager
MemberOf
MNSLogonAccount
MobilePhone
Modified
Name
ObjectCategory
ObjectGUID
Office
OfficePhone
Organization
OtherName
PasswordExpired
PasswordLastSet
PasswordNeverExpires
PasswordNotRequired
POBox
PostalCode
PriaryGroup
ProfilePath
ProtectedFromAccidentalDeletion
SamAccountName
ScriptPath
ServicePrincipalNames
SID
SIDHistory
SmartcardLogonRequired
State
StreetAddress
Surname
Title
TrustedForDelegation
TrustedtoAuthForDelegation
UseDESKeyOnly
UserPrincipalName
#>
