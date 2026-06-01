: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wrt_guat_tran_flow_addit_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wrt_guat_tran_flow_addit_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.decl_type_cd,chr(13),''),chr(10),'') as decl_type_cd
,replace(replace(t1.decl_cust_type_cd,chr(13),''),chr(10),'') as decl_cust_type_cd
,replace(replace(t1.subm_num,chr(13),''),chr(10),'') as subm_num
,replace(replace(t1.inco_tran_code,chr(13),''),chr(10),'') as inco_tran_code
,replace(replace(t1.expns_tran_code,chr(13),''),chr(10),'') as expns_tran_code
,replace(replace(t1.wrt_guat_type_cd,chr(13),''),chr(10),'') as wrt_guat_type_cd
,replace(replace(t1.wrt_guat_proj_code,chr(13),''),chr(10),'') as wrt_guat_proj_code
,replace(replace(t1.wrt_guat_tran_status_cd,chr(13),''),chr(10),'') as wrt_guat_tran_status_cd
,replace(replace(t1.wrt_guat_usage,chr(13),''),chr(10),'') as wrt_guat_usage
,replace(replace(t1.wrt_guat_dtl_usage,chr(13),''),chr(10),'') as wrt_guat_dtl_usage
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,t1.check_dt as check_dt
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.cust_single_acct_prefr_val as cust_single_acct_prefr_val
,replace(replace(t1.int_rat_apv_form_id,chr(13),''),chr(10),'') as int_rat_apv_form_id
from ${iml_schema}.evt_wrt_guat_tran_flow_addit_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wrt_guat_tran_flow_addit_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes