: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ibs_wx_userbindaccount_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ibs_wx_userbindaccount_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
openid
,oldacno
,newacno
,bankactype
,acname
,currency
,crflag
,acpermit
,deptseq
,acstate
,entcode
,mobilephone
,productid
,msgnotice
,isdefault
from ${idl_schema}.crms_ibs_wx_userbindaccount
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ibs_wx_userbindaccount_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes