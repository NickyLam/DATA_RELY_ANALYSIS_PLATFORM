: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cabs_v_sys_clerk_oper_a
CreateDate: 20220916
FileName:   ${iel_data_path}/cabs_v_sys_clerk_oper.a.${batch_date}.dat
IF_mark:    a
Logs:
   Sundexin
' \
        query="select    
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.txn_dt as txn_dt
    ,replace(replace(t.txn_tm,chr(13),''),chr(10),'') as txn_tm
    ,replace(replace(t.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
    ,replace(replace(t.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
    ,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
    ,replace(replace(t.txn_num,chr(13),''),chr(10),'') as txn_num
    ,replace(replace(t.txn_desc,chr(13),''),chr(10),'') as txn_desc
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,t.serv_flag as serv_flag
from iol.cabs_v_sys_clerk_oper t
where to_char(txn_dt,'yyyymmdd') >='20220601' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cabs_v_sys_clerk_oper.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes