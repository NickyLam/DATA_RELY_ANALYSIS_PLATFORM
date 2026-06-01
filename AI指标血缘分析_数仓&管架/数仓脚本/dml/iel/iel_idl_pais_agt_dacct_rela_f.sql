: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pais_agt_dacct_rela_f
CreateDate: 20241230
FileName:   ${iel_data_path}/pais_agt_dacct_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.stl_cust_acct_num,chr(13),''),chr(10),'') as stl_cust_acct_num
,replace(replace(t1.open_acct_bank_fin_inst_id,chr(13),''),chr(10),'') as open_acct_bank_fin_inst_id
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
,etl_timestamp

from ${idl_schema}.pais_agt_dacct_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pais_agt_dacct_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
