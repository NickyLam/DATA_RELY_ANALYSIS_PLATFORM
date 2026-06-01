: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_agt_indv_e_acct_role_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_agt_indv_e_acct_role_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,prod_acct_id
,trdpty_party_id
,acct_role_type_cd
,role_start_tm
,role_end_tm from idl.rpt_agt_indv_e_acct_role_h where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_agt_indv_e_acct_role_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes