: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_ln_ac_ovdue_info_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_ovdue_info_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,t1.ovdue_princp_amt as ovdue_princp_amt
,t1.ovdue_int_amt as ovdue_int_amt
,t1.ovdue_int_compd_int as ovdue_int_compd_int
,t1.rcva_owe_int_bal as rcva_owe_int_bal
,t1.rcva_pnlt_bal as rcva_pnlt_bal
,t1.princp_ovdue_dt as princp_ovdue_dt
,t1.int_ovdue_dt as int_ovdue_dt
,t1.ovdue_term as ovdue_term
,t1.sub_term as sub_term
,t1.ovdue_days as ovdue_days
,t1.dull_bal as dull_bal
,t1.bad_debt_bal as bad_debt_bal
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_ln_ac_ovdue_info_02 t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_ovdue_info_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes