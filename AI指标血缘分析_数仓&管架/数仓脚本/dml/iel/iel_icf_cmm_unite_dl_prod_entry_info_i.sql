: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_unite_dl_prod_entry_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_dl_prod_entry_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_char,chr(13),''),chr(10),'') as prod_char
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,t1.td_amt as td_amt
from ${icl_schema}.cmm_unite_dl_prod_entry_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_dl_prod_entry_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes