: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3b_case_acct_i
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t3b_case_acct.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.is_del,chr(13),''),chr(10),'') as is_del
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,t.stat_dt as stat_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.fetr_id,chr(13),''),chr(10),'') as fetr_id
    ,replace(replace(t.case_id,chr(13),''),chr(10),'') as case_id
 from iol.amls_t3b_case_acct t
where to_date('${batch_date}','yyyy-mm-dd') = stat_dt" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3b_case_acct.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes