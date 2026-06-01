: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_ast_pkg_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_ast_pkg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.ast_pkg_id,chr(13),''),chr(10),'') as ast_pkg_id
,replace(replace(t1.ast_pkg_name,chr(13),''),chr(10),'') as ast_pkg_name
,replace(replace(t1.ast_pkg_status_cd,chr(13),''),chr(10),'') as ast_pkg_status_cd
,replace(replace(t1.ast_pkg_txt_id,chr(13),''),chr(10),'') as ast_pkg_txt_id
,t1.in_pool_dbill_qtty as in_pool_dbill_qtty
,t1.in_pool_dbill_gross_amt as in_pool_dbill_gross_amt
,t1.pkg_dt as pkg_dt
,t1.tfr_txn_price as tfr_txn_price
,replace(replace(t1.tfr_price_input_mode_cd,chr(13),''),chr(10),'') as tfr_price_input_mode_cd
,replace(replace(t1.inter_acct_id_1,chr(13),''),chr(10),'') as inter_acct_id_1
,replace(replace(t1.inter_acct_name_1,chr(13),''),chr(10),'') as inter_acct_name_1
,replace(replace(t1.inter_acct_id_2,chr(13),''),chr(10),'') as inter_acct_id_2
,replace(replace(t1.inter_acct_name_2,chr(13),''),chr(10),'') as inter_acct_name_2
,t1.cfm_pass_dt as cfm_pass_dt
,t1.tran_dt as tran_dt
,t1.ablsh_tfr_dt as ablsh_tfr_dt
,replace(replace(t1.reg_emp_id,chr(13),''),chr(10),'') as reg_emp_id
,replace(replace(t1.reg_org_id,chr(13),''),chr(10),'') as reg_org_id
,t1.reg_dt as reg_dt
from ${idl_schema}.hdws_dul_d_rpts_agt_ast_pkg_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_ast_pkg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes