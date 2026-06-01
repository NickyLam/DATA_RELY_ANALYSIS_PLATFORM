: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_cap_supv_batch_tot_i
CreateDate: 20240806
FileName:   ${iel_data_path}/evt_cap_supv_batch_tot.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.batch_name_cd,chr(13),''),chr(10),'') as batch_name_cd
,replace(replace(t1.batch_type_cd,chr(13),''),chr(10),'') as batch_type_cd
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.coprator_id,chr(13),''),chr(10),'') as coprator_id
,check_entry_dt
,replace(replace(t1.trdpty_batch_id,chr(13),''),chr(10),'') as trdpty_batch_id
,replace(replace(t1.trdpty_flow_num,chr(13),''),chr(10),'') as trdpty_flow_num
,submit_data_tot
,submit_data_tot_amt
,rest_data_tot
,rest_data_tot_amt
,in_gold_submit_tot
,in_gold_submit_tot_amt
,wdraw_submit_tot
,wdraw_submit_tot_amt
,sucs_cnt
,sucs_amt
,fail_cnt
,fail_amt
,submit_tot_guar_amt
,sucs_guar_amt
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_info,chr(13),''),chr(10),'') as resp_info
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_dt
,init_create_dt
,init_create_affair_dt
,final_modif_dt
,final_modif_affair_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_cap_supv_batch_tot t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cap_supv_batch_tot.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
