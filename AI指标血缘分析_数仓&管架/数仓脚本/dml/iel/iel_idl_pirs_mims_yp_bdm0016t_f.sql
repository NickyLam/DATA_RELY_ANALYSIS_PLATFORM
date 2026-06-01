: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_yp_bdm0016t_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_yp_bdm0016t.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.collztnno,chr(13),''),chr(10),'') as collztnno
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount
,replace(replace(t1.customerno,chr(13),''),chr(10),'') as customerno
,replace(replace(t1.creditcustno,chr(13),''),chr(10),'') as creditcustno
,replace(replace(t1.collztntlrcd,chr(13),''),chr(10),'') as collztntlrcd
,replace(replace(t1.collztnbranchid,chr(13),''),chr(10),'') as collztnbranchid
,replace(replace(t1.swtbizid,chr(13),''),chr(10),'') as swtbizid
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,'' as data_date
from ${iol_schema}.mims_yp_bdm0016t t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_yp_bdm0016t.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes