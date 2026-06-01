: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_appr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_appr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t.term,chr(13),''),chr(10),'') as term
,replace(replace(t.creditarea,chr(13),''),chr(10),'') as creditarea
,t.businesssum as businesssum
,t.totalsum as totalsum
,t.businessavlsum as businessavlsum
,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t.approveopinion,chr(13),''),chr(10),'') as approveopinion
,replace(replace(t.approvedate,chr(13),''),chr(10),'') as approvedate
,replace(replace(t.isestatefinance,chr(13),''),chr(10),'') as isestatefinance
,replace(replace(t.isgovernfinance,chr(13),''),chr(10),'') as isgovernfinance
,replace(replace(t.isconsumerfinance,chr(13),''),chr(10),'') as isconsumerfinance
,replace(replace(t.isbeltroadfinance,chr(13),''),chr(10),'') as isbeltroadfinance
,replace(replace(t.isgreenfinance,chr(13),''),chr(10),'') as isgreenfinance
,replace(replace(t.amtduelevel,chr(13),''),chr(10),'') as amtduelevel
,replace(replace(t.pricerisktype,chr(13),''),chr(10),'') as pricerisktype
,replace(replace(t.pbusinesstype,chr(13),''),chr(10),'') as pbusinesstype
,replace(replace(t.pbusinesscurrency,chr(13),''),chr(10),'') as pbusinesscurrency
,t.pbusinesssum as pbusinesssum
,t.ptotalsum as ptotalsum
,t.pbusinessbal as pbusinessbal
,t.pbusinessavlbal as pbusinessavlbal
,replace(replace(t.pbegindate,chr(13),''),chr(10),'') as pbegindate
,replace(replace(t.penddate,chr(13),''),chr(10),'') as penddate
,replace(replace(t.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t.operateorgid,chr(13),''),chr(10),'') as operateorgid
from ${iol_schema}.icss_t_appr_info t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_appr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes