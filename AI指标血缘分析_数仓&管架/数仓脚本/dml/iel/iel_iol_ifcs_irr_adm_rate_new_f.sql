: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifcs_irr_adm_rate_new_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifcs_irr_adm_rate_new.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t.business_typ,chr(13),''),chr(10),'') as business_typ
,replace(replace(t.acct_typ,chr(13),''),chr(10),'') as acct_typ
,replace(replace(t.corp_scale,chr(13),''),chr(10),'') as corp_scale
,replace(replace(t.rate_float_range,chr(13),''),chr(10),'') as rate_float_range
,t.amount as amount
,t.balance as balance
,replace(replace(t.orig_term_code,chr(13),''),chr(10),'') as orig_term_code
,replace(replace(t.int_rate_typ,chr(13),''),chr(10),'') as int_rate_typ
,replace(replace(t.fina_code,chr(13),''),chr(10),'') as fina_code
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.amt_typ,chr(13),''),chr(10),'') as amt_typ
,t.max_int_rat as max_int_rat
,t.min_int_rat as min_int_rat
,t.ave_int_rat as ave_int_rat
,t.max_amt as max_amt
,t.min_amt as min_amt
,replace(replace(t.tranway_flg,chr(13),''),chr(10),'') as tranway_flg
,replace(replace(t.cust_typ,chr(13),''),chr(10),'') as cust_typ
,replace(replace(t.agreement_typ,chr(13),''),chr(10),'') as agreement_typ
,replace(replace(t.srcsys_cd,chr(13),''),chr(10),'') as srcsys_cd
,replace(replace(t.fac_typ,chr(13),''),chr(10),'') as fac_typ
,replace(replace(t.operate_cust_type,chr(13),''),chr(10),'') as operate_cust_type
,replace(replace(t.float_type,chr(13),''),chr(10),'') as float_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ifcs_irr_adm_rate_new t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifcs_irr_adm_rate_new.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes