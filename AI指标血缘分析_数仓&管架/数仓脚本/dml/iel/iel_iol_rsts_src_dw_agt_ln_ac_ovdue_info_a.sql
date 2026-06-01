: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_ln_ac_ovdue_info_a
CreateDate: 20241014
FileName:   ${iel_data_path}/rsts_src_dw_agt_ln_ac_ovdue_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,etl_dt_ora
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,ovdue_princp_amt
,ovdue_int_amt
,ovdue_int_compd_int
,rcva_owe_int_bal
,rcva_pnlt_bal
,princp_ovdue_dt
,int_ovdue_dt
,ovdue_term
,sub_term
,ovdue_days
,dull_bal
,bad_debt_bal
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg

from ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_ln_ac_ovdue_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
