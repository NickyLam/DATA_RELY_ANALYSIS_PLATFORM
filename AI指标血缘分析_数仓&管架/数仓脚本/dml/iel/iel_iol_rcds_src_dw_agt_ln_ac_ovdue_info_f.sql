: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_ln_ac_ovdue_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_ln_ac_ovdue_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
    ,t.ovdue_princp_amt as ovdue_princp_amt
    ,t.ovdue_int_amt as ovdue_int_amt
    ,t.ovdue_int_compd_int as ovdue_int_compd_int
    ,t.rcva_owe_int_bal as rcva_owe_int_bal
    ,t.rcva_pnlt_bal as rcva_pnlt_bal
    ,t.princp_ovdue_dt as princp_ovdue_dt
    ,t.int_ovdue_dt as int_ovdue_dt
    ,t.ovdue_term as ovdue_term
    ,t.sub_term as sub_term
    ,t.ovdue_days as ovdue_days
    ,t.dull_bal as dull_bal
    ,t.bad_debt_bal as bad_debt_bal
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_agt_ln_ac_ovdue_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_ln_ac_ovdue_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes