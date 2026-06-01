: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibss_wx_userbindaccount_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibss_wx_userbindaccount.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.openid,chr(13),''),chr(10),'') as openid
    ,replace(replace(t.oldacno,chr(13),''),chr(10),'') as oldacno
    ,replace(replace(t.newacno,chr(13),''),chr(10),'') as newacno
    ,replace(replace(t.bankactype,chr(13),''),chr(10),'') as bankactype
    ,replace(replace(t.acname,chr(13),''),chr(10),'') as acname
    ,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
    ,replace(replace(t.crflag,chr(13),''),chr(10),'') as crflag
    ,replace(replace(t.acpermit,chr(13),''),chr(10),'') as acpermit
    ,t.deptseq as deptseq
    ,replace(replace(t.acstate,chr(13),''),chr(10),'') as acstate
    ,replace(replace(t.entcode,chr(13),''),chr(10),'') as entcode
    ,replace(replace(t.mobilephone,chr(13),''),chr(10),'') as mobilephone
    ,replace(replace(t.productid,chr(13),''),chr(10),'') as productid
    ,replace(replace(t.msgnotice,chr(13),''),chr(10),'') as msgnotice
    ,replace(replace(t.isdefault,chr(13),''),chr(10),'') as isdefault
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibss_wx_userbindaccount t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibss_wx_userbindaccount.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes