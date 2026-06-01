: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_coll_batch_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_bill_coll_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.agt_apv_status_cd,chr(13),''),chr(10),'') as agt_apv_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,init_coll_dt
,replace(replace(t1.cust_open_bank_no,chr(13),''),chr(10),'') as cust_open_bank_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.bus_sponsor_id,chr(13),''),chr(10),'') as bus_sponsor_id
,replace(replace(t1.final_operr_id,chr(13),''),chr(10),'') as final_operr_id
,final_oper_tm
,replace(replace(t1.valet_coll_flg,chr(13),''),chr(10),'') as valet_coll_flg
,replace(replace(t1.send_out_coll_status_cd,chr(13),''),chr(10),'') as send_out_coll_status_cd
,coll_appl_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,to_date('${batch_date}','yyyymmdd') as etl_dt

from ${iml_schema}.agt_bill_coll_batch t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_coll_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
