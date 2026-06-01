: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_case_involvement_f
CreateDate: 20250828
FileName:   ${iel_data_path}/alss_am_case_involvement.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t1.case_typ,chr(13),''),chr(10),'') as case_typ
,replace(replace(t1.sfip_date,chr(13),''),chr(10),'') as sfip_date
,replace(replace(t1.involved_amount,chr(13),''),chr(10),'') as involved_amount
,replace(replace(t1.whether_pre_control,chr(13),''),chr(10),'') as whether_pre_control
,replace(replace(t1.victim,chr(13),''),chr(10),'') as victim
,replace(replace(t1.fpsi_pft_date,chr(13),''),chr(10),'') as fpsi_pft_date
,replace(replace(t1.aum_m_avg_bal,chr(13),''),chr(10),'') as aum_m_avg_bal
,replace(replace(t1.facm_date,chr(13),''),chr(10),'') as facm_date
,replace(replace(t1.after_calc_day_lmt,chr(13),''),chr(10),'') as after_calc_day_lmt
,replace(replace(t1.froa_date,chr(13),''),chr(10),'') as froa_date
,replace(replace(t1.data_release_id,chr(13),''),chr(10),'') as data_release_id

from ${iol_schema}.alss_am_case_involvement t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_case_involvement.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
