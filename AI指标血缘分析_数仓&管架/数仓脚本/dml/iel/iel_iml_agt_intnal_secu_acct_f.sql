: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_intnal_secu_acct_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_intnal_secu_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,replace(replace(t1.owner_name,chr(13),''),chr(10),'') as owner_name
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
,replace(replace(t1.acctnt_cls_cd,chr(13),''),chr(10),'') as acctnt_cls_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,create_dt
,update_dt

from ${iml_schema}.agt_intnal_secu_acct t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intnal_secu_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
