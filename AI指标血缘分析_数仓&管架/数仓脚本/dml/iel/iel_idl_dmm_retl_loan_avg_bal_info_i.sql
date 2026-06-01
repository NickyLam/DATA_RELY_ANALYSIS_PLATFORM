: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_dmm_retl_loan_avg_bal_info_i
CreateDate: 20250702
FileName:   ${iel_data_path}/dmm_retl_loan_avg_bal_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.dubil_num as dubil_num
,t1.std_prod_id as std_prod_id
,t1.curr_mon_is_ovdue_flg as curr_mon_is_ovdue_flg
,t1.curr_mon_fir_ovdue_dt as curr_mon_fir_ovdue_dt
,t1.m_avg_bal as m_avg_bal

from ${idl_schema}.dmm_retl_loan_avg_bal_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dmm_retl_loan_avg_bal_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
