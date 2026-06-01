: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbps_cpr_acc_group_rel_f
CreateDate: 20231110
FileName:   ${iel_data_path}/tbps_cpr_acc_group_rel.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agr_accountno,chr(13),''),chr(10),'') as agr_accountno
,replace(replace(t1.agr_ecifno,chr(13),''),chr(10),'') as agr_ecifno
,replace(replace(t1.agr_channel,chr(13),''),chr(10),'') as agr_channel
,replace(replace(t1.agr_grpid,chr(13),''),chr(10),'') as agr_grpid
,replace(replace(t1.agr_authmodel,chr(13),''),chr(10),'') as agr_authmodel

from ${iol_schema}.tbps_cpr_acc_group_rel t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_acc_group_rel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
