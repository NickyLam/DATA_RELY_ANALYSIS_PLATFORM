: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_abs_cont_dtl_h_f
CreateDate: 20230919
FileName:   ${iel_data_path}/agt_abs_cont_dtl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_bag_cont_dtl_seq_num,chr(13),''),chr(10),'') as asset_bag_cont_dtl_seq_num
,replace(replace(t1.asset_bag_cont_id,chr(13),''),chr(10),'') as asset_bag_cont_id
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,bal
,replace(replace(t1.asset_acct_status_cd,chr(13),''),chr(10),'') as asset_acct_status_cd
,replace(replace(t1.issue_batch_no,chr(13),''),chr(10),'') as issue_batch_no
,replace(replace(t1.issue_flow_num,chr(13),''),chr(10),'') as issue_flow_num
,issue_convt_prem
,replace(replace(t1.issue_revo_batch_no,chr(13),''),chr(10),'') as issue_revo_batch_no
,replace(replace(t1.circl_buy_flg,chr(13),''),chr(10),'') as circl_buy_flg
,replace(replace(t1.circl_buy_batch_no,chr(13),''),chr(10),'') as circl_buy_batch_no
,replace(replace(t1.circl_buy_flow_num,chr(13),''),chr(10),'') as circl_buy_flow_num
,circl_buy_dt
,replace(replace(t1.revo_pkg_batch_no,chr(13),''),chr(10),'') as revo_pkg_batch_no
,replace(replace(t1.revo_pkg_tran_flow_num,chr(13),''),chr(10),'') as revo_pkg_tran_flow_num
,replace(replace(t1.revo_tran_ref_no,chr(13),''),chr(10),'') as revo_tran_ref_no
,replace(replace(t1.redem_tran_flow_num,chr(13),''),chr(10),'') as redem_tran_flow_num
,replace(replace(t1.redem_batch_no,chr(13),''),chr(10),'') as redem_batch_no
,redem_convt_prem
,replace(replace(t1.pkg_batch_no,chr(13),''),chr(10),'') as pkg_batch_no
,replace(replace(t1.pkg_flow_num,chr(13),''),chr(10),'') as pkg_flow_num
,pkg_tran_dt
,replace(replace(t1.tran_code_descb,chr(13),''),chr(10),'') as tran_code_descb
,final_modif_dt
,tran_tm
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id

from ${iml_schema}.agt_abs_cont_dtl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_abs_cont_dtl_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
