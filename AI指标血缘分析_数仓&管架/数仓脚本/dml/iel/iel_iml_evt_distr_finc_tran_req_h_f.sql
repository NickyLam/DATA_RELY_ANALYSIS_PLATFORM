: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_distr_finc_tran_req_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_distr_finc_tran_req_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t.appl_dt as appl_dt
,t.appl_tm as appl_tm
,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t.lot_cate_cd,chr(13),''),chr(10),'') as lot_cate_cd
,t.appl_amt as appl_amt
,t.appl_shares as appl_shares
,replace(replace(t.init_appl_flow_num,chr(13),''),chr(10),'') as init_appl_flow_num
,replace(replace(t.init_cfm_flow_num,chr(13),''),chr(10),'') as init_cfm_flow_num
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t.ta_init_flg,chr(13),''),chr(10),'') as ta_init_flg
,replace(replace(t.ext_bus_cd,chr(13),''),chr(10),'') as ext_bus_cd
,replace(replace(t.ta_manu_check_flg,chr(13),''),chr(10),'') as ta_manu_check_flg
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,t.cfm_dt as cfm_dt
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,t.cfm_amt as cfm_amt
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.redem_mode_cd,chr(13),''),chr(10),'') as redem_mode_cd
,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_distr_finc_tran_req_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_distr_finc_tran_req_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes