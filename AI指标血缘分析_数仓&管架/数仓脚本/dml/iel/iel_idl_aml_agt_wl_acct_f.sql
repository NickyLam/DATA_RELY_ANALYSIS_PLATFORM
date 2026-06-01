: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_wl_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_wl_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,acct_id
,lp_id
,acct_name
,acct_type_cd
,cap_acct_id
,open_bank_name
,open_bank_num
,open_acct_name
,acct_status_cd
,teller_id
,asset_acct_type_cd
,bd_card_no
,bind_mobile_no
,pbc_fin_inst_code
,obank_card_flg
,cust_id
,start_dt
,end_dt
,id_mark
from idl.aml_agt_wl_acct
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_wl_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes