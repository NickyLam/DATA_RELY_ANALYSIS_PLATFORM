: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_corp_pty_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_corp_pty_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(rela_id,chr(10),''),chr(13),'') as rela_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(lnkm_typ_cd,chr(10),''),chr(13),'') as lnkm_typ_cd
      ,replace(replace(lnkm_name,chr(10),''),chr(13),'') as lnkm_name
      ,replace(replace(lnkm_pty_num,chr(10),''),chr(13),'') as lnkm_pty_num
      ,replace(replace(lnkm_iden_typ_cd,chr(10),''),chr(13),'') as lnkm_iden_typ_cd
      ,replace(replace(lnkm_other_iden_num,chr(10),''),chr(13),'') as lnkm_other_iden_num
      ,replace(replace(sys_id,chr(10),''),chr(13),'') as sys_id 
from idl.hdws_dul_d_ccrm_corp_pty_rela 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_corp_pty_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes