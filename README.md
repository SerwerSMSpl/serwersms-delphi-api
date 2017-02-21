# SerwerSMS.pl Delphi Client API
Klient Delphi do komunikacji zdalnej z API v2 SerwerSMS.pl

Zalecane jest, aby komunikacja przez HTTPS API odbywała się z loginów utworzonych specjalnie do połączenia przez API. Konto użytkownika API można utworzyć w Panelu Klienta → Ustawienia interfejsów → HTTPS XML API → Użytkownicy.

#### Przykładowe wywołanie
```Delphi
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

var
  DllInstance: THandle;
  MessagesSendSms: TMessagesSendSms;
  Result: string;
  Auth: TDictionary<string,string>;
  Options: TDictionary<string,string>;

begin
  try

    DllInstance := LoadLibrary('serwersms.dll');
    if DllInstance = 0 then
      Exit;

    @MessagesSendSms := GetProcAddress(DllInstance, 'MessagesSendSms');

    if @MessagesSendSms <> nil then
    begin

      Auth  := TDictionary<string,string>.Create;
      Options  := TDictionary<string,string>.Create;

      Auth.Add('username', 'demo');
      Auth.Add('password', 'demo');
      Auth.Add('format', 'json');

      Options.Add('details', 'true');
      Options.Add('utf', '1');
      Options.Add('test', '1');
      Result := MessagesSendSms(Auth, '500000000', 'Test message', 'INFORMACJA', Options);

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
```

#### Wysyłka SMS
```Delphi
Options.Add('details', 'true');
Options.Add('utf', 'true');
Options.Add('test', 'true');
Result := MessagesSendSms(Auth, '500000000', 'Test message', 'INFORMACJA', Options);
```

#### Wysyłka spersonalizowanych SMS
```Delphi
Messsages := TObjectList<TDictionary<string,string>>.Create();

Temp := TDictionary<string,string>.Create();
Temp.Add('phone', '500000000');
Temp.Add('text', 'Test message 1');
Messsages.Add(Temp);

Temp := TDictionary<string,string>.Create();
Temp.Add('phone', '600000000');
Temp.Add('text', 'Test message 2');
Messsages.Add(Temp);

Options.Add('details', 'true');
Options.Add('utf', 'true');
Result := MessagesSendPersonalized(Auth, Messsages, 'INFORMACJA', Options);
```

#### Pobieranie raportów doręczeń
```Delphi
Options.Add('id', '09d3e84be1');
Result := MessagesReports(Auth, Options);
```

#### Pobieranie wiadomości przychodzących
```Delphi
Options.Add('phone', '500600700');
Result := MessagesRecived(Auth, 'eco', Options);
```

## Instalacja

Po ściągnięciu pliku serwersms.dll należy podpiąć bibliotekę w swoim projekcie,
zdefiniować nowy typ oraz załadowac wybraną funkcję.

## Wymagania
Delphi XE6
Biblioteka do komunikacji HTTPS wymaga plików libeay32.dll oraz ssleay32.dll.

## Dokumentacja
http://dev.serwersms.pl

## Konsola API
http://apiconsole.serwersms.pl