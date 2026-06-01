: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_ifs_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_ifs_user_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
userid
,username
,userpswd
,usercode
,brid
,roleid
,staid
,department
,position
,uservalidstatus
,userstatus
,sex
,birthday
,marriage
,education
,officephone
,homephone
,mobilephone
,fax
,email
,smssign
,emailsign
,subbankid
,userpyname
,birthyear
,birthmonday
,cmbcdate
,rolegroup
,roledept
,mageorg
,subbrid
from ${idl_schema}.odss_ifs_user
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_ifs_user_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes