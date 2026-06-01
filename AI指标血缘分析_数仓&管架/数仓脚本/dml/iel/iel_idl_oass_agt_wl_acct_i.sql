: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_wl_acct_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_wl_acct.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_name as acct_name
,t1.acct_type_cd as acct_type_cd
,t1.cap_acct_id as cap_acct_id
,t1.open_bank_name as open_bank_name
,t1.open_bank_num as open_bank_num
,t1.open_acct_name as open_acct_name
,t1.acct_status_cd as acct_status_cd
,t1.teller_id as teller_id
,t1.asset_acct_type_cd as asset_acct_type_cd
,t1.bd_card_no as bd_card_no
,t1.bind_mobile_no as bind_mobile_no
,t1.pbc_fin_inst_code as pbc_fin_inst_code
,t1.obank_card_flg as obank_card_flg
,t1.cust_id as cust_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.acct_id as acct_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_wl_acct t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_wl_acct.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
