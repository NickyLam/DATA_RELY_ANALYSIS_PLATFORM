: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_for_other_pers_guar_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_for_other_pers_guar.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(guar_cust_nbr,chr(10),''),chr(13),'') as guar_cust_nbr
      ,replace(replace(guar_name,chr(10),''),chr(13),'') as guar_name
      ,replace(replace(guar_contr_id,chr(10),''),chr(13),'') as guar_contr_id
      ,replace(replace(guar_contr_typ_cd,chr(10),''),chr(13),'') as guar_contr_typ_cd
      ,replace(replace(guar_contr_stats_cd,chr(10),''),chr(13),'') as guar_contr_stats_cd
      ,crdt_lmt
      ,lett_lmt
      ,replace(replace(guar_mode_cd,chr(10),''),chr(13),'') as guar_mode_cd
      ,guar_amt
      ,replace(replace(ccy,chr(10),''),chr(13),'') as ccy
      ,guar_dt
      ,guar_term 
from idl.hdws_dul_d_ccrm_pty_for_other_pers_guar 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_for_other_pers_guar.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes