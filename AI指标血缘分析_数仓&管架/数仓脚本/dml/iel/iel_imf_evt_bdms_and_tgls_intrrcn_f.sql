: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bdms_and_tgls_intrrcn_f
CreateDate: 20240307
FileName:   ${iel_data_path}/evt_bdms_and_tgls_intrrcn.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intrrcn_flow_num,chr(13),''),chr(10),'') as intrrcn_flow_num
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,replace(replace(t1.tran_amt_type_cd,chr(13),''),chr(10),'') as tran_amt_type_cd
,tran_amt
,init_tran_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,replace(replace(t1.revs_bus_status_cd,chr(13),''),chr(10),'') as revs_bus_status_cd
,replace(replace(t1.revs_tm,chr(13),''),chr(10),'') as revs_tm
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.dtl_id,chr(13),''),chr(10),'') as dtl_id
,send_tgls_batch
,send_tgls__end_day_batch
,replace(replace(t1.end_day_feedback_status_cd,chr(13),''),chr(10),'') as end_day_feedback_status_cd
,replace(replace(t1.send_tgls__doc_name,chr(13),''),chr(10),'') as send_tgls__doc_name
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id

from ${iml_schema}.evt_bdms_and_tgls_intrrcn t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bdms_and_tgls_intrrcn.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
