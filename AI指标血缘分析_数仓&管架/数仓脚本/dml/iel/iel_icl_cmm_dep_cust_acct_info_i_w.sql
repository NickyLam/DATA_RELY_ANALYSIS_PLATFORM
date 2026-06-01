: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_cust_acct_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_dep_cust_acct_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t.cust_acct_name,chr(13),''),chr(10),'') as cust_acct_name
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.max_sub_acct_num,chr(13),''),chr(10),'') as max_sub_acct_num
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.drawdown_way_cd,chr(13),''),chr(10),'') as drawdown_way_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t.e_acct_type_cd,chr(13),''),chr(10),'') as e_acct_type_cd
,replace(replace(t.e_acct_status_cd,chr(13),''),chr(10),'') as e_acct_status_cd
,replace(replace(t.acct_drawdown_way_status,chr(13),''),chr(10),'') as acct_drawdown_way_status
,replace(replace(t.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd
,replace(replace(t.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t.acpt_pay_status_cd,chr(13),''),chr(10),'') as acpt_pay_status_cd
,replace(replace(t.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t.vouch_char_cd,chr(13),''),chr(10),'') as vouch_char_cd
,replace(replace(t.vouch_form_cd,chr(13),''),chr(10),'') as vouch_form_cd
,replace(replace(t.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd
,replace(replace(t.vrif_status_cd,chr(13),''),chr(10),'') as vrif_status_cd
,replace(replace(t.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg
,replace(replace(t.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg
,replace(replace(t.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg
,replace(replace(t.bind_acct_flg,chr(13),''),chr(10),'') as bind_acct_flg
,replace(replace(t.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id
,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,replace(replace(t.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,t.open_acct_dt as open_acct_dt
,t.open_acct_tm as open_acct_tm
,replace(replace(t.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id
,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,t.clos_acct_dt as clos_acct_dt
,t.clos_acct_tm as clos_acct_tm
,replace(replace(t.unvrif_rs_descb,chr(13),''),chr(10),'') as unvrif_rs_descb
,replace(replace(t.disp_method_descb,chr(13),''),chr(10),'') as disp_method_descb
,replace(replace(t.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd
from ${icl_schema}.cmm_dep_cust_acct_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_cust_acct_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes