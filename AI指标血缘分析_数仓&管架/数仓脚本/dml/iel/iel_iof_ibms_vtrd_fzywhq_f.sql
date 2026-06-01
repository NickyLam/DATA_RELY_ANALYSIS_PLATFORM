: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ibms_vtrd_fzywhq_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_vtrd_fzywhq.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.intordid,chr(13),''),chr(10),'') as intordid
,replace(replace(t1.secu_accname,chr(13),''),chr(10),'') as secu_accname
,replace(replace(t1.secu_acctg_type_name,chr(13),''),chr(10),'') as secu_acctg_type_name
,replace(replace(t1.p_type_name,chr(13),''),chr(10),'') as p_type_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.orddate,chr(13),''),chr(10),'') as orddate
,replace(replace(t1.partyname,chr(13),''),chr(10),'') as partyname
,replace(replace(t1.t_path,chr(13),''),chr(10),'') as t_path
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.ordamount as ordamount
,t1.bnd_aiamount as bnd_aiamount
,t1.bnd_ytm as bnd_ytm
,replace(replace(t1.open_date,chr(13),''),chr(10),'') as open_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.first_payment_date,chr(13),''),chr(10),'') as first_payment_date
,replace(replace(t1.payment_freq_name,chr(13),''),chr(10),'') as payment_freq_name
,replace(replace(t1.daycount_name,chr(13),''),chr(10),'') as daycount_name
,replace(replace(t1.coupon_type_name,chr(13),''),chr(10),'') as coupon_type_name
,t1.real_amount as real_amount
,replace(replace(t1.business_category_name,chr(13),''),chr(10),'') as business_category_name
,replace(replace(t1.business_category_min_name,chr(13),''),chr(10),'') as business_category_min_name
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade
,replace(replace(t1.exhacc,chr(13),''),chr(10),'') as exhacc
,replace(replace(t1.party_acct_code,chr(13),''),chr(10),'') as party_acct_code
,replace(replace(t1.trader,chr(13),''),chr(10),'') as trader
,replace(replace(t1.op_user_name1,chr(13),''),chr(10),'') as op_user_name1
,replace(replace(t1.op_user_name2,chr(13),''),chr(10),'') as op_user_name2
,replace(replace(t1.subj_code,chr(13),''),chr(10),'') as subj_code
,replace(replace(t1.ibs,chr(13),''),chr(10),'') as ibs
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
from ${iol_schema}.ibms_vtrd_fzywhq t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_fzywhq.f.${batch_date}.dat" \
        charset=utf8
        safe=yes