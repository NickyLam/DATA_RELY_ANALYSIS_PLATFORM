: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tbvirbankaccmap_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nfss_tbvirbankaccmap.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.vir_bank_acc,chr(13),''),chr(10),'') as vir_bank_acc
    ,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
    ,replace(replace(t.bank_acc,chr(13),''),chr(10),'') as bank_acc
    ,replace(replace(t.in_client_no,chr(13),''),chr(10),'') as in_client_no
    ,replace(replace(t.open_branch,chr(13),''),chr(10),'') as open_branch
    ,t.open_date as open_date
    ,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
    ,replace(replace(t.vir_type,chr(13),''),chr(10),'') as vir_type
    ,t.amt1 as amt1
    ,t.amt2 as amt2
    ,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
    ,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
    ,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nfss_tbvirbankaccmap t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tbvirbankaccmap.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes