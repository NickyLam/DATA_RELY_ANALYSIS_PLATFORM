: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ibms_vtrd_hsyetz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_vtrd_hsyetz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.secu_acct_name,chr(13),''),chr(10),'') as secu_acct_name
,replace(replace(t1.secu_acctg_type_name,chr(13),''),chr(10),'') as secu_acctg_type_name
,replace(replace(t1.p_type_name,chr(13),''),chr(10),'') as p_type_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.i_code1,chr(13),''),chr(10),'') as i_code1
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.trd_orddate,chr(13),''),chr(10),'') as trd_orddate
,replace(replace(t1.trd_party_name,chr(13),''),chr(10),'') as trd_party_name
,replace(replace(t1.trd_party_class,chr(13),''),chr(10),'') as trd_party_class
,replace(replace(t1.issue_name,chr(13),''),chr(10),'') as issue_name
,replace(replace(t1.issue_class,chr(13),''),chr(10),'') as issue_class
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.cp as cp
,t1.coupon as coupon
,replace(replace(t1.inst_start_date,chr(13),''),chr(10),'') as inst_start_date
,replace(replace(t1.inst_mrt_date,chr(13),''),chr(10),'') as inst_mrt_date
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.pay_freq_name,chr(13),''),chr(10),'') as pay_freq_name
,replace(replace(t1.daycount_name,chr(13),''),chr(10),'') as daycount_name
,replace(replace(t1.coupon_type_name,chr(13),''),chr(10),'') as coupon_type_name
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade
,t1.tzye as tzye
,t1.zmye as zmye
,t1.tycb as tycb
,t1.ai as ai
,t1.due_cp as due_cp
,t1.due_ai as due_ai
,t1.amrt_ir as amrt_ir
,t1.chg_fv as chg_fv
,t1.year_prft_ir as year_prft_ir
,t1.prft_ir as prft_ir
,t1.year_prft_trd as year_prft_trd
,t1.prft_trd as prft_trd
,t1.tax_due_amrt as tax_due_amrt
,t1.tax_ai as tax_ai
,t1.tax_due_trd as tax_due_trd
,t1.ai_cost as ai_cost
,t1.due_amrt_ir as due_amrt_ir
,t1.prft_ir_amrt as prft_ir_amrt
,t1.bw_ai as bw_ai
,replace(replace(t1.cp_subj_code,chr(13),''),chr(10),'') as cp_subj_code
,replace(replace(t1.prft_ir_subj_code,chr(13),''),chr(10),'') as prft_ir_subj_code
,replace(replace(t1.ai_subj_code,chr(13),''),chr(10),'') as ai_subj_code
,replace(replace(t1.sfbb,chr(13),''),chr(10),'') as sfbb
,t1.ai_tax_rate as ai_tax_rate
,t1.amrt_tax_rate as amrt_tax_rate
,t1.trd_tax_rate as trd_tax_rate
,replace(replace(t1.ftp_jzz,chr(13),''),chr(10),'') as ftp_jzz
,replace(replace(t1.ftp_rate,chr(13),''),chr(10),'') as ftp_rate
,t1.yrj as yrj
,t1.jrj as jrj
,t1.nrj as nrj
,replace(replace(t1.hxkhh,chr(13),''),chr(10),'') as hxkhh
,replace(replace(t1.hxkhh1,chr(13),''),chr(10),'') as hxkhh1
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
from ${iol_schema}.ibms_vtrd_hsyetz t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_hsyetz.f.${batch_date}.dat" \
        charset=utf8
        safe=yes