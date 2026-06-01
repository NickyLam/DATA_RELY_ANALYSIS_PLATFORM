: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_consmt_fund_auto_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_consmt_fund_auto_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.auto_finc_id,chr(13),''),chr(10),'') as auto_finc_id
,replace(replace(t.finc_tran_cd,chr(13),''),chr(10),'') as finc_tran_cd
,t.appl_dt as appl_dt
,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd
,replace(replace(t.open_chn_cd,chr(13),''),chr(10),'') as open_chn_cd
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t.invest_amt as invest_amt
,t.invest_lot as invest_lot
,replace(replace(t.huge_redem_proc_flg_cd,chr(13),''),chr(10),'') as huge_redem_proc_flg_cd
,t.lowt_invest_amt as lowt_invest_amt
,t.higt_invest_amt as higt_invest_amt
,t.resv_amt as resv_amt
,t.tran_discnt_rat as tran_discnt_rat
,replace(replace(t.termnt_mode_cd,chr(13),''),chr(10),'') as termnt_mode_cd
,t.invest_day as invest_day
,t.invest_perds as invest_perds
,t.surp_invest_perds as surp_invest_perds
,t.sucs_invest_perds as sucs_invest_perds
,t.conti_fail_perds as conti_fail_perds
,replace(replace(t.invest_ped_cd,chr(13),''),chr(10),'') as invest_ped_cd
,t.invest_intrv as invest_intrv
,t.next_invest_dt as next_invest_dt
,t.last_invest_dt as last_invest_dt
,replace(replace(t.latest_tran_comnt,chr(13),''),chr(10),'') as latest_tran_comnt
,replace(replace(t.end_flg_cd,chr(13),''),chr(10),'') as end_flg_cd
,t.start_invest_dt as start_invest_dt
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_consmt_fund_auto_info_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_consmt_fund_auto_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes