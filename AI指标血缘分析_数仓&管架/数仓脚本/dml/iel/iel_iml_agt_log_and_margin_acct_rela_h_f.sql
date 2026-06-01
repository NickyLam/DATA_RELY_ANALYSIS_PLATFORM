: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_log_and_margin_acct_rela_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_log_and_margin_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.margin_acct_curr_cd,chr(13),''),chr(10),'') as margin_acct_curr_cd
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.margin_acct_sub_acct_num,chr(13),''),chr(10),'') as margin_acct_sub_acct_num
,replace(replace(t1.margin_prod_id,chr(13),''),chr(10),'') as margin_prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.froz_id,chr(13),''),chr(10),'') as froz_id

from ${iml_schema}.agt_log_and_margin_acct_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_log_and_margin_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
