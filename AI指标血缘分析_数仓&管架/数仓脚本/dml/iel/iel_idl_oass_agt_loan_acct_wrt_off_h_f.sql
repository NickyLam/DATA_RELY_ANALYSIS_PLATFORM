: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_acct_wrt_off_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_acct_wrt_off_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.wrt_off_seq_num as wrt_off_seq_num
,t1.acct_id as acct_id
,t1.cust_id as cust_id
,t1.wrt_off_dt as wrt_off_dt
,t1.wrt_off_pric as wrt_off_pric
,t1.ld_wrt_off_pric as ld_wrt_off_pric
,t1.wrt_off_tm_point_amt as wrt_off_tm_point_amt
,t1.wrt_off_nomal_int as wrt_off_nomal_int
,t1.ld_wrt_off_nomal_int as ld_wrt_off_nomal_int
,t1.wrt_off_tm_point_int_amt as wrt_off_tm_point_int_amt
,t1.wrt_off_comp_int_int as wrt_off_comp_int_int
,t1.ld_wrt_off_comp_int_int as ld_wrt_off_comp_int_int
,t1.wrt_off_tm_point_comp_int_amt as wrt_off_tm_point_comp_int_amt
,t1.wrt_off_comp_int_comp_int as wrt_off_comp_int_comp_int
,t1.ld_wrt_off_comp_int_comp_int as ld_wrt_off_comp_int_comp_int
,t1.wrt_off_tm_point_comp_int_comp_int_amt as wrt_off_tm_point_comp_int_comp_int_amt
,t1.wrt_off_pnlt_comp_int as wrt_off_pnlt_comp_int
,t1.ld_wrt_off_pnlt_comp_int as ld_wrt_off_pnlt_comp_int
,t1.wrt_off_tm_point_pnlt_comp_int_amt as wrt_off_tm_point_pnlt_comp_int_amt
,t1.wrt_off_pnlt_int as wrt_off_pnlt_int
,t1.ld_wrt_off_pnlt_int as ld_wrt_off_pnlt_int
,t1.wrt_off_tm_point_pnlt_amt as wrt_off_tm_point_pnlt_amt
,t1.wrt_off_type_cd as wrt_off_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_acct_wrt_off_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_acct_wrt_off_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
