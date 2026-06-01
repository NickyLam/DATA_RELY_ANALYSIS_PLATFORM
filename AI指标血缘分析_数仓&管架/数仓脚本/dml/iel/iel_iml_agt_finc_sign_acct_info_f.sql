: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_sign_acct_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_finc_sign_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bank_cd,chr(13),''),chr(10),'') as bank_cd
,replace(replace(t1.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t1.acct_sign_status_cd,chr(13),''),chr(10),'') as acct_sign_status_cd
,sign_dt
,rels_dt
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_finc_sign_acct_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_sign_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
