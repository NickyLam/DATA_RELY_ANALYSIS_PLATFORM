: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ref_rg_holiday_para_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ref_rg_holiday_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.local_cty_rg_cd as local_cty_rg_cd
,t1.local_prov_cd as local_prov_cd
,t1.holiday_dt as holiday_dt
,t1.holiday_type_descb as holiday_type_descb
,t1.wd_flg as wd_flg
,t1.fit_range_cd as fit_range_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.lp_id as lp_id
,t1.holiday_type_cd as holiday_type_cd

from ${idl_schema}.oass_ref_rg_holiday_para t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ref_rg_holiday_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
