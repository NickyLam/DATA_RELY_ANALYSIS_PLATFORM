: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_pty_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_pty_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(pty_typ_cd,chr(10),''),chr(13),'') as pty_typ_cd
      ,replace(replace(cn_fname,chr(10),''),chr(13),'') as cn_fname
      ,replace(replace(cn_sname,chr(10),''),chr(13),'') as cn_sname
      ,replace(replace(piny_name,chr(10),''),chr(13),'') as piny_name
      ,replace(replace(en_fname,chr(10),''),chr(13),'') as en_fname
      ,replace(replace(en_sname,chr(10),''),chr(13),'') as en_sname
      ,open_dt
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,colse_dt
      ,replace(replace(colse_org_id,chr(10),''),chr(13),'') as colse_org_id
      ,replace(replace(colse_teller_id,chr(10),''),chr(13),'') as colse_teller_id
      ,replace(replace(non_resident_flg,chr(10),''),chr(13),'') as non_resident_flg
      ,replace(replace(pty_status_cd,chr(10),''),chr(13),'') as pty_status_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_pty_party 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_pty_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes