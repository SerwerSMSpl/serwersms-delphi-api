library serwersms;

uses
  IdHTTP,
  Generics.Collections,
  System.JSON,
  System.SysUtils,
  System.Classes;

{$R *.res}

// Function convert TDictionary to JSON object
function StringsToJSONObject(const Data: TDictionary<string,string>): TJSONObject;
var
  Key: string;
begin
  Result := TJSONObject.Create;
  for Key in Data.Keys do
  begin
    Result.AddPair(TJSONPair.Create(Key, Data[Key]));
  end;
end;


// Function merge params
function Prepare(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): TDictionary<string,string>; stdcall;
var
  Options: TDictionary<string,string>;
  Key: string;
begin

  Options := TDictionary<string,string>.Create;

  // Set Auth data
  for Key in Auth.Keys do
  begin
    if(SameText(Key,'username') or SameText(Key,'password')) then
    begin
       Options.AddOrSetValue(Key,Auth[Key]);
    end;
  end;

  // Set staticts data
  Options.AddOrSetValue('system', 'delphi');

  // Set params
  for Key in Params.Keys do
  begin
    if(length(Key) > 0) then
    begin
      Options.AddOrSetValue(Key,Params[Key]);
    end;
  end;

  Result := Options;

end;

// Function to execure HTTP request with POST data
function Request(Action: string; Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
var
  HTTP: TIdHTTP;

  RequestBody: TStream;
  ResponseBody: string;

  JSON: TJSONObject;
  Options: TDictionary<string,string>;

  Key: string;

  API: string;
  Format: string;

begin

  API := 'https://api2.serwersms.pl/';
  Format := 'json';

  // Create object for request
  HTTP := TIdHTTP.Create(nil);

  // Prepare options
  Options := Prepare(Auth, Params);

  // Set format
  for Key in Auth.Keys do
  begin
    if(SameText(Key,'format')) then
        Format := Auth[Key];
  end;

  // Define url api
  API := API + Action + '.' + Format;

  // Convert tstring to json
  JSON := StringsToJSONObject(Options);

  try

    try

      // Create request body
      RequestBody := TStringStream.Create(JSON.ToString, TEncoding.UTF8);

      try

        // Request HTTP
        HTTP.Request.Accept := 'application/json';
        HTTP.Request.ContentType := 'application/json';

        ResponseBody := HTTP.Post(API, RequestBody);

        // Return result
        Result := ResponseBody;

      finally
        RequestBody.Free;
        Options.Free;
      end;

    except
      on E: EIdHTTPProtocolException do
      begin
      end;

      on E: Exception do
      begin
      end;

    end;

  finally
    HTTP.Free;
    JSON.Free;
  end;

end;

// MESSAGES

// 1. Messages - > Sending messages
function MessagesSendSms(Auth: TDictionary<string,string>; Phone: string; Text: string; Sender: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('text', Text);
  Params.AddOrSetValue('sender', Sender);

  Result := Request('messages/send_sms', Auth, Params);

end;

// 2. Messages - > Sending personalized messages
function MessagesSendPersonalized(Auth: TDictionary<string,string>; Messsages: TObjectList<TDictionary<string,string>>; Sender: string; Params: TDictionary<string,string>): string; stdcall;
var
  MessagesList: string;
  I : Integer;
begin

  MessagesList := '';

  // Lopp messages
  for I := 0 to Messsages.Count - 1 do
  begin
    if(Messsages[I] <> nil) then
    begin
      if(Messsages[I].ContainsKey('phone') and Messsages[I].ContainsKey('text')) then
        MessagesList := MessagesList + Messsages[I]['phone'] + ':' + Messsages[I]['text'] + ']|[';
    end;
  end;

  if(Length(MessagesList)>3) then
  begin
    MessagesList := Copy(MessagesList,0,Length(MessagesList)-3);
  end;

  Params.AddOrSetValue('sender', Sender);
  Params.AddOrSetValue('messages', MessagesList);

  Result := Request('messages/send_personalized', Auth, Params);

end;

// 3. Messages - > Sending Voice message
function MessagesSendVoice(Auth: TDictionary<string,string>; Phone: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('phone', Phone);

  Result := Request('messages/send_voice', Auth, Params);

end;

// 4. Messages - > Sending MMS
function MessagesSendMms(Auth: TDictionary<string,string>; Phone: string; Title: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('title', Title);

  Result := Request('messages/send_mms', Auth, Params);

end;

// 5. Messages - > View single message
function MessagesView(Auth: TDictionary<string,string>; Id: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('id', Id);

  Result := Request('messages/view', Auth, Params);

end;

// 6. Messages - > Checking messages reports
function MessagesReports(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('messages/reports', Auth, Params);

end;

// 7. Messages - > Deleting message from the scheduler
function MessagesDelete(Auth: TDictionary<string,string>; Id: string; Unique_id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('unique_id', Unique_id);

  Result := Request('messages/delete', Auth, Params);
  Params.Free;

end;

// 8. Messages - > List of received messages
function MessagesRecived(Auth: TDictionary<string,string>; Types: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('type', Types);

  Result := Request('messages/recived', Auth, Params);

end;

// 9. Messages - > Sending a message to an ND/SC
function MessagesSendNd(Auth: TDictionary<string,string>; Phone: string; Text: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('text', Text);

  Result := Request('messages/send_nd', Auth, Params);
  Params.Free;

end;

// 10. Messages - > Sending a message to an NDI/SCI
function MessagesSendNdi(Auth: TDictionary<string,string>; Phone: string; Text: string; NDI: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('text', Text);
  Params.AddOrSetValue('ndi_number', NDI);

  Result := Request('messages/send_ndi', Auth, Params);
  Params.Free;

end;

// STOP MESSAGES

// FILES

// 1. Files - > Add new file
function FilesAdd(Auth: TDictionary<string,string>; Types: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('type', Types);

  Result := Request('files/add', Auth, Params);
  Params.Free;

end;

// 2. Files - > List of files
function FilesIndex(Auth: TDictionary<string,string>; Types: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('type', Types);

  Result := Request('files/index', Auth, Params);
  Params.Free;

end;

// 3. Files - > View file
function FilesView(Auth: TDictionary<string,string>; Id: string; Types: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('type', Types);

  Result := Request('files/view', Auth, Params);
  Params.Free;

end;

// 4. Files - > Deleting a file
function FilesDelete(Auth: TDictionary<string,string>; Id: string; Types: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('type', Types);

  Result := Request('files/delete', Auth, Params);
  Params.Free;

end;

// STOP FILES

// BLACKLISTS

// 1. Blacklists - > Add phone to the blacklist
function BlacklistsAdd(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);

  Result := Request('blacklist/add', Auth, Params);
  Params.Free;

end;

// 2. Blacklists - > List of blacklist phones
function BlacklistsIndex(Auth: TDictionary<string,string>; Phone: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('phone', Phone);

  Result := Request('blacklist/index', Auth, Params);
  Params.Free;

end;

// 3. Blacklists - > Checking if phone is blacklisted
function BlacklistsCheck(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);

  Result := Request('blacklist/check', Auth, Params);
  Params.Free;

end;

// 4. Blacklists - > Deleting phone from the blacklist
function BlacklistsDelete(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);

  Result := Request('blacklist/delete', Auth, Params);
  Params.Free;

end;

// STOP BLACKLIST S

// FAULTS

// 1. Fault - > Preview error
function FaultsView(Auth: TDictionary<string,string>; Code: integer): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('error/' + inttostr(Code), Auth, Params);
  Params.Free;

end;

// STOP FAULTS

// STATS

// 1. Stat - > Statistics an sending
function StatsIndex(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('stats/index', Auth, Params);
  Params.Free;

end;

// STOP STATS

// PHONES

// 1. Phones - > Checking phone in to HLR
function PhonesCheck(Auth: TDictionary<string,string>; Phone: string; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('id', Id);

  Result := Request('phones/check', Auth, Params);
  Params.Free;

end;

// 2. Phones - > Validating phone number
function PhonesTest(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);

  Result := Request('phones/test', Auth, Params);
  Params.Free;

end;

// STOP PHONES

// ACCOUNTS

// 1. Accounts - > Register new account
function AccountsAdd(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('account/add', Auth, Params);
  Params.Free;

end;

// 2. Accounts - > Return limits SMS
function AccountsLimits(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('account/limits', Auth, Params);
  Params.Free;

end;

// 3. Accounts - >  Return contact details
function AccountsHelp(Auth: TDictionary<string,string>): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('account/help', Auth, Params);
  Params.Free;

end;

// 4. Accounts - >  Return messages from the administrator
function AccountsMessages(Auth: TDictionary<string,string>): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('account/messages', Auth, Params);
  Params.Free;

end;

// STOP ACCOUNTS

// CONTACT

// 1. Contacts - >  Add new contact
function ContactsAdd(Auth: TDictionary<string,string>; Group_id: string; Phone: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('group_id', Group_id);
  Params.AddOrSetValue('phone', Phone);

  Result := Request('contacts/add', Auth, Params);
  Params.Free;

end;

// 2. Contacts - >  List of contacts
function ContactsIndex(Auth: TDictionary<string,string>; Group_id: string; Search: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('group_id', Group_id);
  Params.AddOrSetValue('search', Search);

  Result := Request('contacts/index', Auth, Params);
  Params.Free;

end;

// 3. Contacts - >  View single contact
function ContactsView(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('contacts/view', Auth, Params);
  Params.Free;

end;

// 4. Contacts - >  View single contact
function ContactsEdit(Auth: TDictionary<string,string>; Id: string; Group_id: string; Phone: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('group_id', Group_id);
  Params.AddOrSetValue('phone', Phone);

  Result := Request('contacts/edit', Auth, Params);
  Params.Free;

end;

// 5. Contacts - >  Deleting a phone from contacts
function ContactsDelete(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('contacts/delete', Auth, Params);
  Params.Free;

end;

// 6. Contacts - > Import contact list
function ContactsImport(Auth: TDictionary<string,string>; Group_name: string; Contacts: TObjectList<TDictionary<string,string>>): string; stdcall;
var
  I : Integer;
  Params: TDictionary<string,string>;
  Element: TJSONObject;
  List : TJsonArray;
begin

  List := TJsonArray.Create();

  // Lopp contacts
  for I := 0 to Contacts.Count - 1 do
  begin
    if(Contacts[I] <> nil) then
    begin

      Element := TJSONObject.Create;

      if(Contacts[I].ContainsKey('phone')) then
        Element.AddPair(TJSONPair.Create('phone', Contacts[I]['phone']));

      if(Contacts[I].ContainsKey('email')) then
        Element.AddPair(TJSONPair.Create('email', Contacts[I]['email']));

      if(Contacts[I].ContainsKey('first_name')) then
        Element.AddPair(TJSONPair.Create('first_name', Contacts[I]['first_name']));

      if(Contacts[I].ContainsKey('last_name')) then
        Element.AddPair(TJSONPair.Create('last_name', Contacts[I]['last_name']));

      if(Contacts[I].ContainsKey('company')) then
        Element.AddPair(TJSONPair.Create('company', Contacts[I]['company']));

      List.AddElement(Element);

    end;
  end;

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('group_name', Group_name);
  Params.AddOrSetValue('contact', List.ToString());

  Result := Request('contacts/import', Auth, Params);

end;

// STOP CONTACTS

// GROUPS

// 1. Groups - >  Add new group
function GroupsAdd(Auth: TDictionary<string,string>; Name: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('name', Name);

  Result := Request('groups/add', Auth, Params);
  Params.Free;

end;

// 2. Groups - >  List of group
function GroupsIndex(Auth: TDictionary<string,string>; Search: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('search', Search);

  Result := Request('groups/index', Auth, Params);
  Params.Free;

end;

// 3. Groups - >  View
function GroupsView(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('groups/view', Auth, Params);
  Params.Free;

end;

// 4. Groups - >  Edit
function GroupsEdit(Auth: TDictionary<string,string>; Id: string; Name: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('name', Name);

  Result := Request('groups/edit', Auth, Params);
  Params.Free;

end;

// 5. Groups - >  Delete
function GroupsDelete(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('groups/delete', Auth, Params);
  Params.Free;

end;

// 5. Groups - >  Check
function GroupsCheck(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);

  Result := Request('groups/check', Auth, Params);
  Params.Free;

end;

// STOP GROUPS

// SENDERS

// 1. Senders - >  Creating new Sender name
function SendersAdd(Auth: TDictionary<string,string>; Name: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('name', Name);

  Result := Request('senders/add', Auth, Params);
  Params.Free;

end;

// 2. Senders - >  Senders list
function SendersIndex(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('senders/index', Auth, Params);
  Params.Free;

end;

// STOP SENDERS

// PREMIUM

// 1. Premium - >  List of received SMS Premium
function PremiumIndex(Auth: TDictionary<string,string>): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('premium/index', Auth, Params);
  Params.Free;

end;

// 2. Premium - >  Sending replies for received SMS Premium
function PremiumSend(Auth: TDictionary<string,string>; Phone: string; Text: string; Gate: string; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('phone', Phone);
  Params.AddOrSetValue('text', Text);
  Params.AddOrSetValue('gate', Gate);
  Params.AddOrSetValue('id', Id);

  Result := Request('premium/send', Auth, Params);
  Params.Free;

end;


// 3. Premium - >  View quiz results
function PremiumQuiz(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('quiz/view', Auth, Params);
  Params.Free;

end;

// STOP PREMIUM

// TEMPLATES

// 1. Templates - >  List of templates
function TemplatesIndex(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
begin

  Result := Request('templates/index', Auth, Params);
  Params.Free;

end;

// 2. Templates - >  Adding new template
function TemplatesAdd(Auth: TDictionary<string,string>; Name: string; Text: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('name', Name);
  Params.AddOrSetValue('text', Text);

  Result := Request('templates/add', Auth, Params);
  Params.Free;

end;

// 3. Templates - >  Editing a template
function TemplatesEdit(Auth: TDictionary<string,string>; Id: string; Name: string; Text: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('name', Name);
  Params.AddOrSetValue('text', Text);

  Result := Request('templates/edit', Auth, Params);
  Params.Free;

end;


// 4. Templates - >  Deleting a template
function TemplatesDelete(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('templates/delete', Auth, Params);
  Params.Free;

end;

// STOP TEMPLATES

// SUBACCOUNTS

// 1. Subaccounts - >  Creating new subaccount
function SubaccountsAdd(Auth: TDictionary<string,string>; Username: string; Password: string; Id: string; Params: TDictionary<string,string>): string; stdcall;
begin

  Params.AddOrSetValue('subaccount_username', Username);
  Params.AddOrSetValue('subaccount_password', Password);
  Params.AddOrSetValue('subaccount_id', Id);

  Result := Request('subaccounts/add', Auth, Params);
  Params.Free;

end;

// 2. Subaccounts - >  List of subaccounts
function SubaccountsIndex(Auth: TDictionary<string,string>): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('subaccounts/index', Auth, Params);
  Params.Free;

end;

// 3. Subaccounts - >  View details of subaccount
function SubaccountsView(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('subaccounts/view', Auth, Params);
  Params.Free;

end;

// 4. Subaccounts - >  Setting the limit on subaccount
function SubaccountsLimit(Auth: TDictionary<string,string>; Id: string; Types: string; Value: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);
  Params.AddOrSetValue('type', Types);
  Params.AddOrSetValue('value', Value);

  Result := Request('subaccounts/limit', Auth, Params);
  Params.Free;

end;

// 5. Subaccounts - >  Deleting a subaccount
function SubaccountsDelete(Auth: TDictionary<string,string>; Id: string): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', Id);

  Result := Request('subaccounts/delete', Auth, Params);
  Params.Free;

end;

// STOP SUBACCOUNTS

// PAYMENTS

// 1. Payments - >  List of payments
function PaymentsIndex(Auth: TDictionary<string,string>): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Result := Request('payments/index', Auth, Params);
  Params.Free;

end;

// 2. Payments - >  View single payment
function PaymentsView(Auth: TDictionary<string,string>; Id: integer): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', inttostr(Id));

  Result := Request('payments/view', Auth, Params);
  Params.Free;

end;

// 3. Payments - >  Download invoice as PDF
function PaymentsInvoice(Auth: TDictionary<string,string>; Id: integer): string; stdcall;
var
  Params: TDictionary<string,string>;
begin

  Params := TDictionary<string,string>.Create;

  Params.AddOrSetValue('id', inttostr(Id));

  Result := Request('payments/invoice', Auth, Params);
  Params.Free;

end;

// STOP PAYMENTS

exports

  MessagesSendSms,
  MessagesSendPersonalized,
  MessagesSendVoice,
  MessagesSendMms,
  MessagesView,
  MessagesReports,
  MessagesDelete,
  MessagesRecived,
  MessagesSendNd,
  MessagesSendNdi,

  FilesAdd,
  FilesIndex,
  FilesView,
  FilesDelete,

  BlacklistsAdd,
  BlacklistsIndex,
  BlacklistsCheck,
  BlacklistsDelete,

  FaultsView,
  StatsIndex,

  PhonesCheck,
  PhonesTest,

  AccountsAdd,
  AccountsLimits,
  AccountsHelp,
  AccountsMessages,

  ContactsAdd,
  ContactsIndex,
  ContactsView,
  ContactsEdit,
  ContactsDelete,
  ContactsImport,

  GroupsAdd,
  GroupsIndex,
  GroupsView,
  GroupsEdit ,
  GroupsDelete,
  GroupsCheck,

  SendersAdd,
  SendersIndex,

  PremiumIndex,
  PremiumSend,
  PremiumQuiz,

  TemplatesIndex,
  TemplatesAdd,
  TemplatesEdit,
  TemplatesDelete,

  SubaccountsAdd,
  SubaccountsIndex,
  SubaccountsView,
  SubaccountsLimit,
  SubaccountsDelete,

  PaymentsIndex,
  PaymentsView,
  PaymentsInvoice;


begin
end.
