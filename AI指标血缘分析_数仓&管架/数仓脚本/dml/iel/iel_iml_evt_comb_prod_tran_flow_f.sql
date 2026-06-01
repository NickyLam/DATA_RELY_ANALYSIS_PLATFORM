: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_comb_prod_tran_flow_f
CreateDate: 20230817
FileName:   ${iel_data_path}/evt_comb_prod_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,tran_dt
,tran_tm
,sys_tran_dt
,replace(replace(t1.vtual_bank_acct_id,chr(13),''),chr(10),'') as vtual_bank_acct_id
,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'') as ctrl_flg_comb
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cap_acct_id,chr(13),''),chr(10),'') as cap_acct_id
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,init_tran_dt
,tran_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.init_tran_chn_cd,chr(13),''),chr(10),'') as init_tran_chn_cd
,replace(replace(t1.init_tran_org_id,chr(13),''),chr(10),'') as init_tran_org_id
,init_tran_host_check_entry_dt
,replace(replace(t1.send_finc_plat_flow_num,chr(13),''),chr(10),'') as send_finc_plat_flow_num
,finc_plat_check_entry_dt
,replace(replace(t1.finc_plat_flow_num,chr(13),''),chr(10),'') as finc_plat_flow_num
,replace(replace(t1.finc_plat_tran_code,chr(13),''),chr(10),'') as finc_plat_tran_code
,finc_plat_dt
,replace(replace(t1.send_host_flow_num,chr(13),''),chr(10),'') as send_host_flow_num
,host_check_entry_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code
,host_dt
,replace(replace(t1.fin_status_cd,chr(13),''),chr(10),'') as fin_status_cd
,replace(replace(t1.target_bank_acct_id,chr(13),''),chr(10),'') as target_bank_acct_id
,replace(replace(t1.sp_acct_id,chr(13),''),chr(10),'') as sp_acct_id
,replace(replace(t1.huge_redem_flg,chr(13),''),chr(10),'') as huge_redem_flg
,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id
,replace(replace(t1.comb_redem_coll_acct_id,chr(13),''),chr(10),'') as comb_redem_coll_acct_id
,cfm_amt
,cfm_dt
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t1.brch_org_id,chr(13),''),chr(10),'') as brch_org_id
,replace(replace(t1.open_acct_belong_org_id,chr(13),''),chr(10),'') as open_acct_belong_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id

from ${iml_schema}.evt_comb_prod_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_comb_prod_tran_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
