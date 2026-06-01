: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_batch_tran_flow_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_ponl_batch_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.onl_tran_flow_num,chr(13),''),chr(10),'') as onl_tran_flow_num
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t1.auth_type_cd,chr(13),''),chr(10),'') as auth_type_cd
,tot
,tot_amt
,sucs_cnt
,sucs_amt
,fail_cnt
,fail_amt
,replace(replace(t1.tran_dt,chr(13),''),chr(10),'') as tran_dt
,tran_timestamp
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.batch_data_src_cd,chr(13),''),chr(10),'') as batch_data_src_cd
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,tran_out_dt

from ${iml_schema}.evt_ponl_batch_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_batch_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
