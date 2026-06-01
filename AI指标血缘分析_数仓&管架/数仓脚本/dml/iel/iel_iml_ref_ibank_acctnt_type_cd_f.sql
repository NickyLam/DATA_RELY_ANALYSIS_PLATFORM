: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ibank_acctnt_type_cd_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_acctnt_type_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cls_id,chr(13),''),chr(10),'') as cls_id
,replace(replace(t1.cls_name,chr(13),''),chr(10),'') as cls_name
,replace(replace(t1.tran_cost_accti_method_cd,chr(13),''),chr(10),'') as tran_cost_accti_method_cd
,replace(replace(t1.hold_cost_method_cd,chr(13),''),chr(10),'') as hold_cost_method_cd
,replace(replace(t1.evltion_method_cd,chr(13),''),chr(10),'') as evltion_method_cd
,replace(replace(t1.provi_method_cd,chr(13),''),chr(10),'') as provi_method_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.i9_cls_cd,chr(13),''),chr(10),'') as i9_cls_cd
,create_dt
,update_dt

from ${iml_schema}.ref_ibank_acctnt_type_cd t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_acctnt_type_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
