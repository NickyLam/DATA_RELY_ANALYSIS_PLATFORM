: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_we_dep_acct_ip_check_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_we_dep_acct_ip_check_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.agt_id as agt_id
    ,t.lp_id as lp_id
    ,t.cust_name as cust_name
    ,t.cert_no as cert_no
    ,t.cust_id as cust_id
    ,t.ghb_card_no as ghb_card_no
    ,t.webank_card_no as webank_card_no
    ,t.open_ip as open_ip
    ,t.permt_ip as permt_ip
    ,t.check_ip_flg as check_ip_flg
    ,t.gd_prov_int_flg as gd_prov_int_flg
    ,t.check_tm as check_tm
    ,t.wdraw_flg as wdraw_flg
    ,t.wdraw_tm as wdraw_tm
    ,t.wdraw_return_code as wdraw_return_code
    ,t.wdraw_return_code_descb as wdraw_return_code_descb
from iml.agt_we_dep_acct_ip_check_dtl t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_we_dep_acct_ip_check_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes