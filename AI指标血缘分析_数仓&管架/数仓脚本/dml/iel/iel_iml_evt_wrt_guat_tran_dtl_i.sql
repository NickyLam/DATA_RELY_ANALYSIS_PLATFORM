: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wrt_guat_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wrt_guat_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,replace(replace(t.wrt_guat_type_cd,chr(13),''),chr(10),'') as wrt_guat_type_cd
    ,replace(replace(t.wrt_guat_dtl_type_cd,chr(13),''),chr(10),'') as wrt_guat_dtl_type_cd
    ,replace(replace(t.stat_proj_cd,chr(13),''),chr(10),'') as stat_proj_cd
    ,replace(replace(t.buy_curr_cd,chr(13),''),chr(10),'') as buy_curr_cd
    ,replace(replace(t.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id
    ,replace(replace(t.buy_acct_sub_acct_id,chr(13),''),chr(10),'') as buy_acct_sub_acct_id
    ,replace(replace(t.buy_ec_idf_cd,chr(13),''),chr(10),'') as buy_ec_idf_cd
    ,t.buy_nr as buy_nr
    ,t.buy_tran_exch_rat as buy_tran_exch_rat
    ,t.buy_amt as buy_amt
    ,t.buy_np as buy_np
    ,replace(replace(t.sell_curr_cd,chr(13),''),chr(10),'') as sell_curr_cd
    ,replace(replace(t.sell_acct_id,chr(13),''),chr(10),'') as sell_acct_id
    ,replace(replace(t.sell_acct_sub_acct_id,chr(13),''),chr(10),'') as sell_acct_sub_acct_id
    ,replace(replace(t.sell_ec_idf_cd,chr(13),''),chr(10),'') as sell_ec_idf_cd
    ,t.sell_nr as sell_nr
    ,t.sell_tran_exch_rat as sell_tran_exch_rat
    ,t.sell_amt as sell_amt
    ,t.sell_np as sell_np
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,t.cust_prefr_point as cust_prefr_point
    ,replace(replace(t.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,t.quot_tm as quot_tm
    ,replace(replace(t.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
    ,replace(replace(t.bs_type_cd,chr(13),''),chr(10),'') as bs_type_cd
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.resdnt_refund_flg,chr(13),''),chr(10),'') as resdnt_refund_flg
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
from iml.evt_wrt_guat_tran_dtl t
where tran_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wrt_guat_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes