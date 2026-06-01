: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_core_sign_agt_type_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_core_sign_agt_type_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sign_type_cd,chr(13),''),chr(10),'') as sign_type_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_type_descb,chr(13),''),chr(10),'') as agt_type_descb
,replace(replace(t1.sign_post_allow_clos_acct_flg,chr(13),''),chr(10),'') as sign_post_allow_clos_acct_flg
,replace(replace(t1.agt_exclude_type_cd,chr(13),''),chr(10),'') as agt_exclude_type_cd
,replace(replace(t1.allow_repeat_sign_flg,chr(13),''),chr(10),'') as allow_repeat_sign_flg

from ${iml_schema}.ref_core_sign_agt_type_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_core_sign_agt_type_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
