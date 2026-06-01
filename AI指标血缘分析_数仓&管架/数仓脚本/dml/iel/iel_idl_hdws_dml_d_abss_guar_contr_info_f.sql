: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_guar_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_guar_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.asset_src,chr(13),''),chr(10),'') as asset_src
,replace(replace(t1.guar_contr_id,chr(13),''),chr(10),'') as guar_contr_id
,t1.eff_dt as eff_dt
,t1.due_dt as due_dt
,replace(replace(t1.guar_contr_typ_cd,chr(13),''),chr(10),'') as guar_contr_typ_cd
,replace(replace(t1.guar_contr_stats_cd,chr(13),''),chr(10),'') as guar_contr_stats_cd
,replace(replace(t1.guar_mode_cd,chr(13),''),chr(10),'') as guar_mode_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.guar_amt as guar_amt
,replace(replace(t1.guart_pty_id,chr(13),''),chr(10),'') as guart_pty_id
,replace(replace(t1.guart_name,chr(13),''),chr(10),'') as guart_name
from ${idl_schema}.hdws_dml_d_abss_guar_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_guar_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes