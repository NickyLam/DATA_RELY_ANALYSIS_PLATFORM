: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_vchr_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_vchr_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(scd_vchr_id,chr(10),''),chr(13),'') as scd_vchr_id
      ,replace(replace(vchr_rela_typ_cd,chr(10),''),chr(13),'') as vchr_rela_typ_cd
      ,etl_dt
      ,replace(replace(main_vchr_id,chr(10),''),chr(13),'') as main_vchr_id
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,last_update_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name 
from idl.hdws_dul_d_rpts_agt_vchr_rela 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_vchr_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes