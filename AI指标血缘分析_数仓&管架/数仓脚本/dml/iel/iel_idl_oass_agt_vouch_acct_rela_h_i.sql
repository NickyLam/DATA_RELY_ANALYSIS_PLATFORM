: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_vouch_acct_rela_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_vouch_acct_rela_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cust_acct_num as cust_acct_num
,t1.dep_vouch_cate_cd as dep_vouch_cate_cd
,t1.vouch_no as vouch_no
,t1.prod_id as prod_id
,t1.curr_cd as curr_cd
,t1.sub_acct_num as sub_acct_num
,t1.card_no as card_no
,t1.vouch_kind_cd as vouch_kind_cd
,t1.vouch_status_cd as vouch_status_cd
,t1.vouch_orig_status_cd as vouch_orig_status_cd
,t1.tran_ref_no as tran_ref_no
,t1.pm_flg as pm_flg
,t1.pm_id as pm_id
,t1.cust_id as cust_id
,t1.tran_memo_descb as tran_memo_descb
,t1.tran_dt as tran_dt
,t1.cancel_rs_cd as cancel_rs_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_vouch_acct_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_vouch_acct_rela_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
