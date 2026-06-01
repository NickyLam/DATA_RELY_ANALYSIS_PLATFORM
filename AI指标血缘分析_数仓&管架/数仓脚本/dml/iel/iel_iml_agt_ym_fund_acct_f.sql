: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ym_fund_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ym_fund_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,t.open_dt as open_dt
,t.open_tm as open_tm
,replace(replace(t.serv_plat_abbr,chr(13),''),chr(10),'') as serv_plat_abbr
,replace(replace(t.open_flow_num,chr(13),''),chr(10),'') as open_flow_num
,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t.ym_riches_acct_id,chr(13),''),chr(10),'') as ym_riches_acct_id
,replace(replace(t.post_acct_bill_flg,chr(13),''),chr(10),'') as post_acct_bill_flg
,replace(replace(t.acct_bill_post_way_cd,chr(13),''),chr(10),'') as acct_bill_post_way_cd
,replace(replace(t.cust_bear_risk_level_cd,chr(13),''),chr(10),'') as cust_bear_risk_level_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.invtor_lev_cd,chr(13),''),chr(10),'') as invtor_lev_cd
,replace(replace(t.info_integy_flg,chr(13),''),chr(10),'') as info_integy_flg
,replace(replace(t.actl_invtor_name,chr(13),''),chr(10),'') as actl_invtor_name
,replace(replace(t.actl_invtor_cert_type_cd,chr(13),''),chr(10),'') as actl_invtor_cert_type_cd
,replace(replace(t.actl_invtor_cert_no,chr(13),''),chr(10),'') as actl_invtor_cert_no
,t.actl_invtor_cert_exp_dt as actl_invtor_cert_exp_dt
,replace(replace(t.invest_benefc_name,chr(13),''),chr(10),'') as invest_benefc_name
,replace(replace(t.invest_benefc_cert_type_cd,chr(13),''),chr(10),'') as invest_benefc_cert_type_cd
,replace(replace(t.invest_benefc_cert_no,chr(13),''),chr(10),'') as invest_benefc_cert_no
,t.invest_benefc_cert_exp_dt as invest_benefc_cert_exp_dt
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_ym_fund_acct t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ym_fund_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes