create or replace function rrp_east.md5(certtype in varchar2, certid in varchar2)
return varchar2 is resultStr char(46);

uppercertid varchar2(100);
prefix char(14);
midStr char(32);

begin
if certtype = 'B01' or certtype = 'B08'
then
       uppercertid := upper(certid);
       prefix := substr(uppercertid,1,14);
       midStr := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => uppercertid));
     resultStr := prefix||lower(midStr);
     return trim(resultStr);
else
       uppercertid := upper(certid);
       resultStr := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => uppercertid));
     return trim(lower(resultStr));
end if;
end;
/

