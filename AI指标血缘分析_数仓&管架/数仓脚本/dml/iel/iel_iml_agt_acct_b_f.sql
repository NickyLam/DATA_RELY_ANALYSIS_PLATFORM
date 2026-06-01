: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_acct_b_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_acct_b.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_b_name,chr(13),''),chr(10),'') as acct_b_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cost_accti_way_cd,chr(13),''),chr(10),'') as cost_accti_way_cd
,replace(replace(t1.fair_val_flg,chr(13),''),chr(10),'') as fair_val_flg
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd
,create_dt
,update_dt

from ${iml_schema}.agt_acct_b t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_acct_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
