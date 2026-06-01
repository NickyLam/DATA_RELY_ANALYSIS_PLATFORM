: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_sec_acpt_pay_int_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_sec_acpt_pay_int.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,src_evt_id
,quote_table_name
,dept_id
,quote_tab_2_id
,rpp_int_dt
,acct_id
,acct_name
,asset_cate_name
,bond_cd
,pric_int_type_cd
,rpp_amt
,pay_int_amt
,init_tran_id
,actl_pay_dt
,actl_rp_cfm_tm
from idl.rpt_evt_sec_acpt_pay_int where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_sec_acpt_pay_int.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes