: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dtl_prod_tran_flow_f
CreateDate: 20241227
FileName:   ${iel_data_path}/evt_dtl_prod_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.ext_flow_num,chr(13),''),chr(10),'') as ext_flow_num
,replace(replace(t1.dtl_prod_id,chr(13),''),chr(10),'') as dtl_prod_id
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,tran_dt
,tran_tm
,replace(replace(t1.sub_flow_num,chr(13),''),chr(10),'') as sub_flow_num
,replace(replace(t1.sub_tran_cd,chr(13),''),chr(10),'') as sub_tran_cd
,replace(replace(t1.sub_tran_status_cd,chr(13),''),chr(10),'') as sub_tran_status_cd
,replace(replace(t1.fin_status_cd,chr(13),''),chr(10),'') as fin_status_cd
,amt
,lot
,comm_fee
,cfm_amt
,cfm_lot
,cfm_nv
,cfm_comm_fee
,cfm_dt
,revo_amt
,revo_dt
,revo_tm
,discnt_rat
,clear_dt
,check_entry_dt
,init_tran_host_check_entry_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t1.send_host_flow_num,chr(13),''),chr(10),'') as send_host_flow_num
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,host_dt
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id

from ${iml_schema}.evt_dtl_prod_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dtl_prod_tran_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
