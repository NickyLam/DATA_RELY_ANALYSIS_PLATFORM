: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_irrs_adm_rate_weekinfor_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_irrs_adm_rate_weekinfor.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.business_typ,chr(13),''),chr(10),'') as business_typ
,replace(replace(t1.acct_typ,chr(13),''),chr(10),'') as acct_typ
,replace(replace(t1.corp_scale,chr(13),''),chr(10),'') as corp_scale
,replace(replace(t1.rate_float_range,chr(13),''),chr(10),'') as rate_float_range
,t1.amount as amount
,replace(replace(t1.orig_term_code,chr(13),''),chr(10),'') as orig_term_code
,replace(replace(t1.int_rate_typ,chr(13),''),chr(10),'') as int_rate_typ
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.max_int_rat as max_int_rat
,t1.min_int_rat as min_int_rat
,t1.ave_int_rat as ave_int_rat
,t1.max_amt as max_amt
,t1.min_amt as min_amt
,replace(replace(t1.float_type,chr(13),''),chr(10),'') as float_type
,replace(replace(t1.srcsys_cd,chr(13),''),chr(10),'') as srcsys_cd
,replace(replace(t1.loan_type_sub,chr(13),''),chr(10),'') as loan_type_sub
,replace(replace(t1.plat_flg,chr(13),''),chr(10),'') as plat_flg
,replace(replace(t1.contract_sign_date,chr(13),''),chr(10),'') as contract_sign_date
,replace(replace(t1.rate_range,chr(13),''),chr(10),'') as rate_range
from ${idl_schema}.hdws_dml_d_irrs_adm_rate_weekinfor t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_irrs_adm_rate_weekinfor.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
