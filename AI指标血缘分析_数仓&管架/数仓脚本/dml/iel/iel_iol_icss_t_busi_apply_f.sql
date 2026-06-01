: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_busi_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_busi_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.operateorg,chr(13),''),chr(10),'') as operateorg
,replace(replace(t.leader,chr(13),''),chr(10),'') as leader
,replace(replace(t.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t.vouchtype,chr(13),''),chr(10),'') as vouchtype
,t.businesssum as businesssum
,t.totalsum as totalsum
,t.termmonth as termmonth
,replace(replace(t.pbusinesstype,chr(13),''),chr(10),'') as pbusinesstype
,replace(replace(t.pbusinesscurrency,chr(13),''),chr(10),'') as pbusinesscurrency
,t.pbusinesssum as pbusinesssum
,t.ptotalsum as ptotalsum
,replace(replace(t.pbegindate,chr(13),''),chr(10),'') as pbegindate
,replace(replace(t.penddate,chr(13),''),chr(10),'') as penddate
from ${iol_schema}.icss_t_busi_apply t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_busi_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes