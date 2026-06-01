: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_yp_bdm0016t_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_yp_bdm0016t.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t.collztnno,chr(13),''),chr(10),'') as collztnno
,replace(replace(t.bailaccount,chr(13),''),chr(10),'') as bailaccount
,replace(replace(t.customerno,chr(13),''),chr(10),'') as customerno
,replace(replace(t.creditcustno,chr(13),''),chr(10),'') as creditcustno
,replace(replace(t.collztntlrcd,chr(13),''),chr(10),'') as collztntlrcd
,replace(replace(t.collztnbranchid,chr(13),''),chr(10),'') as collztnbranchid
,replace(replace(t.swtbizid,chr(13),''),chr(10),'') as swtbizid
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_yp_bdm0016t t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_yp_bdm0016t.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes