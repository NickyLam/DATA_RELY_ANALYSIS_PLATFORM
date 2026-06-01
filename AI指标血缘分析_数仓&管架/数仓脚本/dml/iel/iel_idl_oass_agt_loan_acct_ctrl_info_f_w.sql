: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_acct_ctrl_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/oass_agt_loan_acct_ctrl_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.agt_id
,t.lp_id
,t.dubil_id
,t.loan_cust_type_cd
,t.promis_loan_flg
,t.circl_loan_flg
,t.unite_loan_flg
,t.deriv_loan_flg
,t.agent_loan_flg
,t.acru_non_acru_accti_flg
,t.oots_accti_flg
,t.loan_modal_subj_accti_flg
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.oass_agt_loan_acct_ctrl_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_acct_ctrl_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes