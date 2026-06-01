: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_acct_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_finc_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(intnal_cust_acct,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(ta_cd,chr(13),''),chr(10),'')
,replace(replace(finc_acct_id,chr(13),''),chr(10),'')
,replace(replace(belong_org_id,chr(13),''),chr(10),'')
,replace(replace(ta_tran_acct_id,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_id,chr(13),''),chr(10),'')
,replace(replace(open_acct_way_cd,chr(13),''),chr(10),'')
,replace(replace(cust_type_cd,chr(13),''),chr(10),'')
,replace(replace(bus_cate_cd,chr(13),''),chr(10),'')
,replace(replace(acct_status_cd,chr(13),''),chr(10),'')
,open_dt
,replace(replace(sign_acct_id,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_finc_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
