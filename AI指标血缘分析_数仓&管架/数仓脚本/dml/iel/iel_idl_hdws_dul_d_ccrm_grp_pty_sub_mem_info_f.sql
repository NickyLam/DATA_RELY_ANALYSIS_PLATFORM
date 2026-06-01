: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_grp_pty_sub_mem_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_grp_pty_sub_mem_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(blng_grp_num,chr(10),''),chr(13),'') as blng_grp_num
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(sub_mem_typ,chr(10),''),chr(13),'') as sub_mem_typ
      ,replace(replace(cn_fname,chr(10),''),chr(13),'') as cn_fname
      ,replace(replace(blng_org_id,chr(10),''),chr(13),'') as blng_org_id
      ,replace(replace(emp_id,chr(10),''),chr(13),'') as emp_id
      ,replace(replace(src_sys,chr(10),''),chr(13),'') as src_sys
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,open_dt
      ,replace(replace(corp_size_gb_cd,chr(10),''),chr(13),'') as corp_size_gb_cd
      ,replace(replace(iden_typ_cd,chr(10),''),chr(13),'') as iden_typ_cd
      ,replace(replace(iden_num,chr(10),''),chr(13),'') as iden_num 
from idl.hdws_dul_d_ccrm_grp_pty_sub_mem_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_grp_pty_sub_mem_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes