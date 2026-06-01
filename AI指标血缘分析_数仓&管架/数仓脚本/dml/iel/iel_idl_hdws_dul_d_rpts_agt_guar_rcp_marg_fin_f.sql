: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_guar_rcp_marg_fin_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_guar_rcp_marg_fin.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as etl_dt
,replace(replace(t1.dps_rcp_open_out_bank,chr(13),''),chr(10),'') as dps_rcp_open_out_bank
,replace(replace(t1.vchr_pty_name,chr(13),''),chr(10),'') as vchr_pty_name
,replace(replace(t1.vchr_num,chr(13),''),chr(10),'') as vchr_num
,replace(replace(t1.dps_rcp_acct_num,chr(13),''),chr(10),'') as dps_rcp_acct_num
,replace(replace(t1.sub_num,chr(13),''),chr(10),'') as sub_num
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,t1.amt as amt
,t1.open_dt as open_dt
,t1.due_dt as due_dt
,replace(replace(t1.vchr_typ_cd,chr(13),''),chr(10),'') as vchr_typ_cd
,replace(replace(t1.vchr_term_corp_cd,chr(13),''),chr(10),'') as vchr_term_corp_cd
,t1.vchr_term as vchr_term
,t1.vchr_rate as vchr_rate
,replace(replace(t1.stop_pay_advi_id,chr(13),''),chr(10),'') as stop_pay_advi_id
,replace(replace(t1.stop_pay_flg,chr(13),''),chr(10),'') as stop_pay_flg
,replace(replace(t1.stop_pay_org,chr(13),''),chr(10),'') as stop_pay_org
,t1.stop_pay_amt as stop_pay_amt
,t1.stop_pay_start_dt as stop_pay_start_dt
,t1.stop_pay_due_dt as stop_pay_due_dt
,replace(replace(t1.stop_pay_term_corp_cd,chr(13),''),chr(10),'') as stop_pay_term_corp_cd
,t1.stop_pay_term as stop_pay_term
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_guar_rcp_marg_fin t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_guar_rcp_marg_fin.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes