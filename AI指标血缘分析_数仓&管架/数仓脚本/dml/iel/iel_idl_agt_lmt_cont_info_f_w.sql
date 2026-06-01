: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_lmt_cont_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_lmt_cont_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt 
,t.agt_id
,t.lp_id
,t.lmt_agt_id
,t.lmt_appl_id
,t.cust_id
,t.cust_name
,t.apv_amt
,t.occu_lmt
,t.lmt_status_cd
,t.curr_cd
,t.tenor_type_cd
,t.tenor
,t.lmt_begin_dt
,t.lmt_exp_dt
,t.applit_id
,t.cust_mgr_id
,t.modif_dt
,t.oper_org_id
,t.mgmt_org_id
,t.remark
,t.print_contr_no
,t.surp_lmt
,t.low_risk_flg
,t.guar_type_cd
,t.guar_type_cd_2
,t.guar_type_cd_3
,t.final_modif_dt
,t.lmt_lmt
,t.froz_lmt
,t.cust_char_cd
,t.crdt_bus_type_cd
,t.group_id
,t.lmt_risk_open_amt
,t.start_use_amt
,t.lmt_circl_flg
,t.prod_id
,t.prod_type
,t.prod_name
,t.intd_co_proj_flg
,t.co_proj_id
,t.ptal_coprator
,t.intd_ptal_coprator_flg
,t.cont_create_dt
,t.intd_pub_loan_corp_flg
,t.pub_loan_corp_id
,t.coprator_stand_b_id
,t.co_proj_cate_cd
,t.coprator_type_cd
,t.lmt_cont_cn_cont_id
,t.lmt_agt_wrtoff_tm
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.agt_lmt_cont_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_lmt_cont_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes