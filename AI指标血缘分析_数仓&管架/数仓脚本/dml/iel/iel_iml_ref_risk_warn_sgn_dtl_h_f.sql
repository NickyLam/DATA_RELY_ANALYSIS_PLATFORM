: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_risk_warn_sgn_dtl_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_risk_warn_sgn_dtl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.warn_id,chr(13),''),chr(10),'') as warn_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.warn_name,chr(13),''),chr(10),'') as warn_name
,replace(replace(t1.warn_sgn_type_cd,chr(13),''),chr(10),'') as warn_sgn_type_cd
,replace(replace(t1.warn_descb,chr(13),''),chr(10),'') as warn_descb
,replace(replace(t1.warn_hibchy,chr(13),''),chr(10),'') as warn_hibchy
,rgst_dt
,modif_dt

from ${iml_schema}.ref_risk_warn_sgn_dtl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_risk_warn_sgn_dtl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
