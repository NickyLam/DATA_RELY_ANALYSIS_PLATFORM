: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_inter_income_bus_tran_dtl_i
CreateDate: 20251106
FileName:   ${iel_data_path}/evt_inter_income_bus_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.bus_sys_id,chr(13),''),chr(10),'') as bus_sys_id
,fin_dt
,replace(replace(t1.doc_id,chr(13),''),chr(10),'') as doc_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.new_tran_flow_num,chr(13),''),chr(10),'') as new_tran_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,tran_tm
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.fee_cd,chr(13),''),chr(10),'') as fee_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_chn_id,chr(13),''),chr(10),'') as tran_chn_id
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,amort_start_dt
,amort_end_dt
,amorted_tot_amt
,ths_tm_amort_amt
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.update_bus_flow_num,chr(13),''),chr(10),'') as update_bus_flow_num
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id

from ${iml_schema}.evt_inter_income_bus_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_inter_income_bus_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
