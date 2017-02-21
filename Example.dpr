program Example;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF }
  Generics.Collections,
  System.SysUtils,
  System.Classes;

type
  TMessagesSendSms = function(Auth: TDictionary<string,string>; Phone: string; Text: string; Sender: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesSendPersonalized = function(Auth: TDictionary<string,string>; Messsages: TObjectList<TDictionary<string,string>>; Sender: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesSendVoice = function(Auth: TDictionary<string,string>; Phone: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesSendMms = function(Auth: TDictionary<string,string>; Phone: string; Title: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesView = function(Auth: TDictionary<string,string>; Id: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesReports = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
  TMessagesDelete = function(Auth: TDictionary<string,string>; Id: string; Unique_id: string): string; stdcall;
  TMessagesRecived = function(Auth: TDictionary<string,string>; Types: string; Params: TDictionary<string,string>): string; stdcall;
  TMessagesSendNd = function(Auth: TDictionary<string,string>; Phone: string; Text: string): string; stdcall;
  TMessagesSendNdi = function(Auth: TDictionary<string,string>; Phone: string; Text: string; NDI: string): string; stdcall;

  TFilesAdd = function(Auth: TDictionary<string,string>; Types: string; Params: TDictionary<string,string>): string; stdcall;
  TFilesIndex = function(Auth: TDictionary<string,string>; Types: string): string; stdcall;
  TFilesView = function(Auth: TDictionary<string,string>; Id: string; Types: string): string; stdcall;
  TFilesDelete = function(Auth: TDictionary<string,string>; Id: string; Types: string): string; stdcall;

  TBlacklistsAdd = function(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
  TBlacklistsIndex = function(Auth: TDictionary<string,string>; Phone: string; Params: TDictionary<string,string>): string; stdcall;
  TBlacklistsCheck = function(Auth: TDictionary<string,string>; Phone: string): string; stdcall;
  TBlacklistsDelete = function(Auth: TDictionary<string,string>; Phone: string): string; stdcall;

  TFaultsView = function(Auth: TDictionary<string,string>; Code: integer): string; stdcall;

  TStatsIndex = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;

  TPhonesCheck = function (Auth: TDictionary<string,string>; Phone: string; Id: string): string; stdcall;
  TPhonesTest = function (Auth: TDictionary<string,string>; Phone: string): string; stdcall;

  TAccountsAdd = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
  TAccountsLimits = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
  TAccountsHelp = function(Auth: TDictionary<string,string>): string; stdcall;
  TAccountsMessages = function(Auth: TDictionary<string,string>): string; stdcall;

  TContactsAdd = function(Auth: TDictionary<string,string>; Group_id: string; Phone: string; Params: TDictionary<string,string>): string; stdcall;
  TContactsIndex = function(Auth: TDictionary<string,string>; Group_id: string; Search: string; Params: TDictionary<string,string>): string; stdcall;
  TContactsView = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;
  TContactsEdit = function(Auth: TDictionary<string,string>; Id: string; Group_id: string; Phone: string; Params: TDictionary<string,string>): string; stdcall;
  TContactsDelete = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;
  TContactsImport = function(Auth: TDictionary<string,string>; Group_name: string; Contacts: TObjectList<TDictionary<string,string>>): string; stdcall;

  TGroupsAdd = function(Auth: TDictionary<string,string>; Name: string): string; stdcall;
  TGroupsIndex = function(Auth: TDictionary<string,string>; Search: string; Params: TDictionary<string,string>): string; stdcall;
  TGroupsView = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;
  TGroupsEdit = function(Auth: TDictionary<string,string>; Id: string; Name: string): string; stdcall;
  TGroupsDelete = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;
  TGroupsCheck = function(Auth: TDictionary<string,string>; Phone: string): string; stdcall;

  TSendersAdd = function(Auth: TDictionary<string,string>; Name: string): string; stdcall;
  TSendersIndex = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;

  TPremiumIndex = function(Auth: TDictionary<string,string>): string; stdcall;
  TPremiumSend = function(Auth: TDictionary<string,string>; Phone: string; Text: string; Gate: string; Id: string): string; stdcall;
  TPremiumQuiz = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;

  TTemplatesIndex = function(Auth: TDictionary<string,string>; Params: TDictionary<string,string>): string; stdcall;
  TTemplatesAdd = function(Auth: TDictionary<string,string>; Name: string; Text: string): string; stdcall;
  TTemplatesEdit = function(Auth: TDictionary<string,string>; Id: string; Name: string; Text: string): string; stdcall;
  TTemplatesDelete = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;

  TSubaccountsAdd = function(Auth: TDictionary<string,string>; Username: string; Password: string; Id: string; Params: TDictionary<string,string>): string; stdcall;
  TSubaccountsIndex = function(Auth: TDictionary<string,string>): string; stdcall;
  TSubaccountsView = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;
  TSubaccountsLimit = function(Auth: TDictionary<string,string>; Id: string; Types: string; Value: string): string; stdcall;
  TSubaccountsDelete = function(Auth: TDictionary<string,string>; Id: string): string; stdcall;

  TPaymentsIndex = function(Auth: TDictionary<string,string>): string; stdcall;
  TPaymentsView = function(Auth: TDictionary<string,string>; Id: integer): string; stdcall;
  TPaymentsInvoice = function(Auth: TDictionary<string,string>; Id: integer): string; stdcall;


var
  DllInstance: THandle;

  MessagesSendSms: TMessagesSendSms;
  MessagesSendPersonalized: TMessagesSendPersonalized;
  MessagesSendVoice: TMessagesSendVoice;
  MessagesSendMms: TMessagesSendMms;
  MessagesView: TMessagesView;
  MessagesReports: TMessagesReports;
  MessagesDelete: TMessagesDelete;
  MessagesRecived: TMessagesRecived;
  MessagesSendNd: TMessagesSendNd;
  MessagesSendNdi: TMessagesSendNdi;

  FilesAdd: TFilesAdd;
  FilesIndex: TFilesIndex;
  FilesView: TFilesView;
  FilesDelete: TFilesDelete;

  BlacklistsAdd: TBlacklistsAdd;
  BlacklistsIndex: TBlacklistsIndex;
  BlacklistsCheck: TBlacklistsCheck;
  BlacklistsDelete: TBlacklistsDelete;

  FaultsView: TFaultsView;

  StatsIndex: TStatsIndex;

  PhonesCheck: TPhonesCheck;
  PhonesTest: TPhonesTest;

  AccountsAdd: TAccountsAdd;
  AccountsLimits: TAccountsLimits;
  AccountsHelp: TAccountsHelp;
  AccountsMessages: TAccountsMessages;

  ContactsAdd: TContactsAdd;
  ContactsIndex: TContactsIndex;
  ContactsView: TContactsView;
  ContactsEdit: TContactsEdit;
  ContactsDelete: TContactsDelete;
  ContactsImport: TContactsImport;

  GroupsAdd: TGroupsAdd;
  GroupsIndex: TGroupsIndex;
  GroupsView: TGroupsView;
  GroupsEdit: TGroupsEdit;
  GroupsDelete: TGroupsDelete;
  GroupsCheck: TGroupsCheck;

  SendersAdd: TSendersAdd;
  SendersIndex: TSendersIndex;

  PremiumIndex: TPremiumIndex;
  PremiumSend: TPremiumSend;
  PremiumQuiz: TPremiumQuiz;

  TemplatesIndex: TTemplatesIndex;
  TemplatesAdd: TTemplatesAdd;
  TemplatesEdit: TTemplatesEdit;
  TemplatesDelete: TTemplatesDelete;

  SubaccountsAdd: TSubaccountsAdd;
  SubaccountsIndex: TSubaccountsIndex;
  SubaccountsView: TSubaccountsView;
  SubaccountsLimit: TSubaccountsLimit;
  SubaccountsDelete: TSubaccountsDelete;

  PaymentsIndex: TPaymentsIndex;
  PaymentsView: TPaymentsView;
  PaymentsInvoice: TPaymentsInvoice;

  Result: string;

  Auth: TDictionary<string,string>;
  Options: TDictionary<string,string>;

  Messsages: TObjectList<TDictionary<string,string>>;
  Contacts: TObjectList<TDictionary<string,string>>;
  Temp: TDictionary<string,string>;

begin
  try

    DllInstance := LoadLibrary('serwersms.dll');
    if DllInstance = 0 then
      Exit;

    @MessagesSendSms := GetProcAddress(DllInstance, 'MessagesSendSms');
    @MessagesSendPersonalized := GetProcAddress(DllInstance, 'MessagesSendPersonalized');
    @MessagesSendVoice := GetProcAddress(DllInstance, 'MessagesSendVoice');
    @MessagesSendMms := GetProcAddress(DllInstance, 'MessagesSendMms');
    @MessagesView := GetProcAddress(DllInstance, 'MessagesView');
    @MessagesReports := GetProcAddress(DllInstance, 'MessagesReports');
    @MessagesDelete := GetProcAddress(DllInstance, 'MessagesDelete');
    @MessagesRecived := GetProcAddress(DllInstance, 'MessagesRecived');
    @MessagesSendNd := GetProcAddress(DllInstance, 'MessagesSendNd');
    @MessagesSendNdi := GetProcAddress(DllInstance, 'MessagesSendNdi');

    @FilesAdd := GetProcAddress(DllInstance, 'FilesAdd');
    @FilesIndex := GetProcAddress(DllInstance, 'FilesIndex');
    @FilesView := GetProcAddress(DllInstance, 'FilesView');
    @FilesDelete := GetProcAddress(DllInstance, 'FilesDelete');

    @BlacklistsAdd := GetProcAddress(DllInstance, 'BlacklistsAdd');
    @BlacklistsIndex := GetProcAddress(DllInstance, 'BlacklistsIndex');
    @BlacklistsCheck := GetProcAddress(DllInstance, 'BlacklistsCheck');
    @BlacklistsDelete := GetProcAddress(DllInstance, 'BlacklistsDelete');

    @FaultsView := GetProcAddress(DllInstance, 'FaultsView');

    @StatsIndex := GetProcAddress(DllInstance, 'StatsIndex');

    @PhonesCheck := GetProcAddress(DllInstance, 'PhonesCheck');
    @PhonesTest := GetProcAddress(DllInstance, 'PhonesTest');

    @AccountsAdd := GetProcAddress(DllInstance, 'AccountsAdd');
    @AccountsLimits := GetProcAddress(DllInstance, 'AccountsLimits');
    @AccountsHelp := GetProcAddress(DllInstance, 'AccountsHelp');
    @AccountsMessages := GetProcAddress(DllInstance, 'AccountsMessages');

    @ContactsAdd := GetProcAddress(DllInstance, 'ContactsAdd');
    @ContactsIndex := GetProcAddress(DllInstance, 'ContactsIndex');
    @ContactsView := GetProcAddress(DllInstance, 'ContactsView');
    @ContactsEdit := GetProcAddress(DllInstance, 'ContactsEdit');
    @ContactsDelete := GetProcAddress(DllInstance, 'ContactsDelete');
    @ContactsImport := GetProcAddress(DllInstance, 'ContactsImport');

    @GroupsAdd := GetProcAddress(DllInstance, 'GroupsAdd');
    @GroupsIndex := GetProcAddress(DllInstance, 'GroupsIndex');
    @GroupsView := GetProcAddress(DllInstance, 'GroupsView');
    @GroupsEdit := GetProcAddress(DllInstance, 'GroupsEdit');
    @GroupsDelete := GetProcAddress(DllInstance, 'GroupsDelete');
    @GroupsCheck := GetProcAddress(DllInstance, 'GroupsCheck');

    @SendersAdd := GetProcAddress(DllInstance, 'SendersAdd');
    @SendersIndex := GetProcAddress(DllInstance, 'SendersIndex');

    @PremiumIndex := GetProcAddress(DllInstance, 'PremiumIndex');
    @PremiumSend := GetProcAddress(DllInstance, 'PremiumSend');
    @PremiumQuiz := GetProcAddress(DllInstance, 'PremiumQuiz');

    @TemplatesIndex := GetProcAddress(DllInstance, 'TemplatesIndex');
    @TemplatesAdd := GetProcAddress(DllInstance, 'TemplatesAdd');
    @TemplatesEdit := GetProcAddress(DllInstance, 'TemplatesEdit');
    @TemplatesDelete := GetProcAddress(DllInstance, 'TemplatesDelete');

    @SubaccountsAdd := GetProcAddress(DllInstance, 'SubaccountsAdd');
    @SubaccountsIndex := GetProcAddress(DllInstance, 'SubaccountsIndex');
    @SubaccountsView := GetProcAddress(DllInstance, 'SubaccountsView');
    @SubaccountsLimit := GetProcAddress(DllInstance, 'SubaccountsLimit');
    @SubaccountsDelete := GetProcAddress(DllInstance, 'SubaccountsDelete');

    @PaymentsIndex := GetProcAddress(DllInstance, 'PaymentsIndex');
    @PaymentsView := GetProcAddress(DllInstance, 'PaymentsView');
    @PaymentsInvoice := GetProcAddress(DllInstance, 'PaymentsInvoice');

    if @MessagesSendSms <> nil then
    begin

      Auth  := TDictionary<string,string>.Create;
      Options  := TDictionary<string,string>.Create;

      Auth.Add('username', 'demo');
      Auth.Add('password', 'demo');
      Auth.Add('format', 'json');

      // 1. Messages - > SendSms

      Options.Add('details', 'true');
      Options.Add('utf', '1');
      Options.Add('test', '1');
      Result := MessagesSendSms(Auth, '500000000', 'Test message', 'INFORMACJA', Options);

      // 2. Messages - > SendPersonalized
      {
      Messsages := TObjectList<TDictionary<string,string>>.Create();

      Temp := TDictionary<string,string>.Create();
      Temp.Add('phone', '500000000');
      Temp.Add('text', 'Test message 1');
      Messsages.Add(Temp);

      Temp := TDictionary<string,string>.Create();
      Temp.Add('phone', '600000000');
      Temp.Add('text', 'Test message 2');
      Messsages.Add(Temp);

      Options.Add('details', '1');
      Options.Add('utf', '1');
      Result := MessagesSendPersonalized(Auth, Messsages, 'INFORMACJA', Options);
      }

      // 3. Messages - > SendVoice
      {
      Options.Add('test', '1');
      Options.Add('details', '1');
      Options.Add('text', 'Test message');
      Result := MessagesSendVoice(Auth, '500000000', Options);
      }

      // 4. Messages - > SendMms
      {
      Options.Add('test', 'true');
      Options.Add('details', 'true');
      Options.Add('file_id', 'a84b949384');
      Result := MessagesSendMms(Auth, '500000000', 'Title message', Options);
      }

      // 5. Messages - > View
      {
      Options.Add('unique_id', '');
      Result := MessagesView(Auth, '09d3e84be1', Options);
      }

      // 6. Messages - > Reports
      {
      Options.Add('id', '09d3e84be1');
      Result := MessagesReports(Auth, Options);
      }

      // 7. Messages - > Delete
      {
      Result := MessagesDelete(Auth, 'c4e7fa68ad1', '');
      }

      // 8. Messages - > Recived
      {
      Options.Add('phone', '500000000');
      Result := MessagesRecived(Auth, 'eco', Options);
      }

      // 9. Messages - > SendNd
      {
      Result := MessagesSendNd(Auth, '500000000', 'Test');
      }

      // 10. Messages - > SendNdi
      {
      Result := MessagesSendNdi(Auth, '500000000', 'Test message', '600000000');
      }

      // 1. Files -> Add
      {
      Options.Add('url', 'http://example.com/file.jpg');
      Result := FilesAdd(Auth, 'mms', Options);
      }

      // 2. Files -> Index
      {
      Result := FilesIndex(Auth, 'mms');
      }

      // 3. Files -> View
      {
      Result := FilesView(Auth, '93e1e3fd15', 'mms');
      }

      // 4. Files -> Delete
      {
      Result := FilesDelete(Auth, '93e1e3fd15', 'mms');
      }

      // 1. Blacklists -> Add
      {
      Result := BlacklistsAdd(Auth, '500000000');
      }

      // 2. Blacklists -> Index
      {
      Options.Add('limit', '10');
      Result := BlacklistsIndex(Auth, '500000000', Options);
      }

      // 3. Blacklists -> Check
      {
      Result := BlacklistsCheck(Auth, '500000000');
      }

      // 4. Blacklists -> Delete
      {
      Result := BlacklistsDelete(Auth, '500000000');
      }

      // 1. Faults -> View
      {
      Result := FaultsView(Auth, 1002);
      }

      // 1. Stats -> Index
      {
      Options.Add('type', 'eco');
      Result := StatsIndex(Auth, Options);
      }

      // 1. Phones -> Check
      {
      Result := PhonesCheck(Auth, '500000000', '');
      }

      // 2. Phones -> Test
      {
      Result := PhonesTest(Auth, '500000000');
      }

      // 1. Accounts -> Add
      {
      Options.Add('first_name', 'Test');
      Options.Add('last_name', 'Test');
      Options.Add('email', 'email@example.com');
      Options.Add('company', 'Company');
      Result := AccountsAdd(Auth, Options);
      }

      // 2. Accounts -> Limits
      {
      Options.Add('show_type', 'true');
      Result := AccountsLimits(Auth, Options);
      }

      // 3. Accounts -> Help
      {
      Result := AccountsHelp(Auth);
      }

      // 4. Accounts -> Messages
      {
      Result := AccountsMessages(Auth);
      }

      // 1. Contacts -> Add
      {
      Options.Add('email', 'test@example.com');
      Options.Add('first_name', 'Test');
      Result := ContactsAdd(Auth, '17325177', '500000000', Options);
      }

      // 2. Contacts -> Index
      {
      Options.Add('page', '1');
      Options.Add('limit', '1');
      Result := ContactsIndex(Auth, '', '', Options);
      }

      // 3. Contacts -> View
      {
      Result := ContactsView(Auth, '305174397');
      }

      // 4. Contacts -> Edit
      {
      Options.Add('first_name', 'Tester');
      Options.Add('last_name', 'Tester');
      Result := ContactsEdit(Auth, '305174397', '', '500600700', Options);
      }

      // 5. Contacts -> Delete
      {
      Result := ContactsDelete(Auth, '305174397');
      }

      // 6. Contacts -> Import
      {
      Contacts := TObjectList<TDictionary<string,string>>.Create();

      Temp := TDictionary<string,string>.Create();
      Temp.Add('phone', '500000000');
      Temp.Add('email', 'test@example.com');
      Temp.Add('first_name', 'Test');
      Contacts.Add(Temp);

      Temp := TDictionary<string,string>.Create();
      Temp.Add('phone', '600000000');
      Temp.Add('email', 'test@example.com');
      Temp.Add('first_name', 'Test');
      Contacts.Add(Temp);

      Result := ContactsImport(Auth, 'Test', Contacts);
      }

      // 1. Groups -> Add
      {
      Result := GroupsAdd(Auth, 'Test');
      }

      // 2. Groups -> Index
      {
      Options.Add('order', 'desc');
      Options.Add('limit', '10');
      Options.Add('page', '1');
      Result := GroupsIndex(Auth, '', Options);
      }

      // 3. Groups -> View
      {
      Result := GroupsView(Auth, '17373061');
      }

      // 4. Groups -> Edit
      {
      Result := GroupsEdit(Auth, '17373061', 'Test edit');
      }

      // 5. Groups -> Delete
      {
      Result := GroupsDelete(Auth, '17373061');
      }

      // 6. Groups -> Check
      {
      Result := GroupsCheck(Auth, '500000000');
      }

      // 1. Senders -> Add
      {
      Result := SendersAdd(Auth, 'Test');
      }

      // 2. Senders -> Index
      {
      Options.Add('predefined', '1');
      Result := SendersIndex(Auth, Options);
      }

      // 1. Premium -> Index
      {
      Result := PremiumIndex(Auth);
      }

      // 2. Premium -> Send
      {
      Result := PremiumSend(Auth, '500000000', 'Test', '600000000', '123');
      }

      // 3. Premium -> Quiz
      {
      Result := PremiumQuiz(Auth, '123');
      }

      // 1. Templates -> Index
      {
      Options.Add('order', 'desc');
      Result := TemplatesIndex(Auth, Options);
      }

      // 2. Templates -> Add
      {
      Result := TemplatesAdd(Auth, 'Test', 'Text 1');
      }

      // 3. Templates -> Edit
      {
      Result := TemplatesEdit(Auth, '34461', 'Test ed', 'Text 1 edit');
      }

      // 4. Templates -> Delete
      {
      Result := TemplatesDelete(Auth, '34461');
      }

      // 1. Subaccounts -> Add
      {
      Options.Add('email', 'test@test.pl"');
      Result := SubaccountsAdd(Auth, 'demo', 'demo', '100', Options);
      }

      // 2. Subaccounts -> Index
      {
      Result := SubaccountsIndex(Auth);
      }

      // 3. Subaccounts -> View
      {
      Result := SubaccountsView(Auth, '100');
      }

      // 4. Subaccounts -> Limit
      {
      Result := SubaccountsLimit(Auth, '100', 'eco', '1');
      }

      // 4. Subaccounts -> Delete
      {
      Result := SubaccountsDelete(Auth, '100');
      }

      // 1. Payments -> Index
      {
      Result := PaymentsIndex(Auth);
      }

      // 2. Payments -> View
      {
      Result := PaymentsView(Auth, 47957);
      }

      // 3. Payments -> Invoice
      {
      Result := PaymentsInvoice(Auth, 47957);
      }

      WriteLn(Result);

    end
    else
      begin
        WriteLn('Problem with load function');
      end;
    FreeLibrary(DllInstance);

    Write('End');
    ReadLn;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

