: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_grp_pty_base_info_tab_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_grp_pty_base_info_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(cn_fname,chr(10),''),chr(13),'') as cn_fname
      ,replace(replace(blng_org_id,chr(10),''),chr(13),'') as blng_org_id
      ,replace(replace(emp_id,chr(10),''),chr(13),'') as emp_id
      ,replace(replace(src_sys,chr(10),''),chr(13),'') as src_sys
      ,replace(replace(cn_sname,chr(10),''),chr(13),'') as cn_sname
      ,replace(replace(grp_corp_dom_offic_loc,chr(10),''),chr(13),'') as grp_corp_dom_offic_loc
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,open_dt 
from idl.hdws_dul_d_ccrm_grp_pty_base_info_tab 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_grp_pty_base_info_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes