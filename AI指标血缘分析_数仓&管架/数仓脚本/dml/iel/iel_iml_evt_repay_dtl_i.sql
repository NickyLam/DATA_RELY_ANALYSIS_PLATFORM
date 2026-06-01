: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_repay_dtl_i
CreateDate: 20221122
FileName:   ${iel_data_path}/evt_repay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.callbk_id,chr(13),''),chr(10),'') as callbk_id
,replace(replace(t1.advise_odd_no,chr(13),''),chr(10),'') as advise_odd_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,curr_pd
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.callbk_curr_cd,chr(13),''),chr(10),'') as callbk_curr_cd
,callbk_to_cny_exch_rat
,replace(replace(t1.callbk_exch_way_cd,chr(13),''),chr(10),'') as callbk_exch_way_cd
,callbk_pric
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,tran_tm
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_repay_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_repay_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
