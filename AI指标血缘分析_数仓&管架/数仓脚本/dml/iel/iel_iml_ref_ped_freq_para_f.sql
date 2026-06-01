: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ped_freq_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_ped_freq_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ped_freq_cd,chr(13),''),chr(10),'') as ped_freq_cd
,replace(replace(t1.ped_freq_descb,chr(13),''),chr(10),'') as ped_freq_descb
,replace(replace(t1.holiday_defer_flg,chr(13),''),chr(10),'') as holiday_defer_flg
,t1.eh_issue_qtty as eh_issue_qtty
,replace(replace(t1.eh_issue_corp_cd,chr(13),''),chr(10),'') as eh_issue_corp_cd
,t1.eh_issue_days as eh_issue_days
,t1.tenor_corp_val as tenor_corp_val
,replace(replace(t1.tm_bg_or_term_end_flg_cd,chr(13),''),chr(10),'') as tm_bg_or_term_end_flg_cd
,replace(replace(t1.half_mon_flg,chr(13),''),chr(10),'') as half_mon_flg
,t1.cust_flo_val as cust_flo_val
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_ped_freq_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ped_freq_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes