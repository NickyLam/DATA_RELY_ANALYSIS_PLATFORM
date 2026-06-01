: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cds_pd_lmt_info_h_f
CreateDate: 20230607
FileName:   ${iel_data_path}/agt_cds_pd_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.priv_flg,chr(13),''),chr(10),'') as priv_flg
,replace(replace(t1.issue_year,chr(13),''),chr(10),'') as issue_year
,tran_dt
,ocup_lmt
,tot_amt
,asigned_lmt
,replace(replace(t1.upper_lmt_type_cd,chr(13),''),chr(10),'') as upper_lmt_type_cd
,surp_lmt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_cds_pd_lmt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_pd_lmt_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
