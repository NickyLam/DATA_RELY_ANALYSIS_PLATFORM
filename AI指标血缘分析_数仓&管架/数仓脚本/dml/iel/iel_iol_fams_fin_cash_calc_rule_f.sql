: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_cash_calc_rule_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_fin_cash_calc_rule.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cash_id,chr(13),''),chr(10),'') as cash_id
,eff_date
,replace(replace(t1.calc_type,chr(13),''),chr(10),'') as calc_type
,replace(replace(t1.base_type,chr(13),''),chr(10),'') as base_type
,replace(replace(t1.base_date_type,chr(13),''),chr(10),'') as base_date_type
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,yield
,replace(replace(t1.is_initial,chr(13),''),chr(10),'') as is_initial
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,replace(replace(t1.finprod_type2,chr(13),''),chr(10),'') as finprod_type2
,branch
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_fin_cash_calc_rule t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_cash_calc_rule.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
