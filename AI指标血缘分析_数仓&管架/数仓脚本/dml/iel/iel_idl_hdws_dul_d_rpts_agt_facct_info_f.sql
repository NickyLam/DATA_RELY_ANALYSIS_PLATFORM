: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_facct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_facct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(agt_id,chr(10),''),chr(13),'') as agt_id
      ,etl_dt
      ,replace(replace(facct_typ_cd,chr(10),''),chr(13),'') as facct_typ_cd
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(assoc_eacct_id,chr(10),''),chr(13),'') as assoc_eacct_id
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(prd_name,chr(10),''),chr(13),'') as prd_name
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(blng_duty_center_id,chr(10),''),chr(13),'') as blng_duty_center_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,open_dt
      ,colse_dt
      ,effective_dt
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,usable_bal
      ,actual_bal
      ,last_bal
      ,frz_bal
      ,replace(replace(agt_status_cd,chr(10),''),chr(13),'') as agt_status_cd
      ,replace(replace(merch_id,chr(10),''),chr(13),'') as merch_id
      ,replace(replace(merch_name,chr(10),''),chr(13),'') as merch_name
      ,merch_up_line_dt
      ,replace(replace(open_tm,chr(10),''),chr(13),'') as open_tm
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_facct_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_facct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes