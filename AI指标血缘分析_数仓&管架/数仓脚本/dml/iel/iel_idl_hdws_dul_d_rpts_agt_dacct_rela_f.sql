: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dacct_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dacct_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(acct_num,chr(10),''),chr(13),'') as acct_num
      ,replace(replace(bind_acct_id,chr(10),''),chr(13),'') as bind_acct_id
      ,replace(replace(acct_rela_typ_cd,chr(10),''),chr(13),'') as acct_rela_typ_cd
      ,etl_dt
      ,replace(replace(ghb_flg,chr(10),''),chr(13),'') as ghb_flg
      ,replace(replace(bind_acct_typ_cd,chr(10),''),chr(13),'') as bind_acct_typ_cd
      ,replace(replace(bind_acct_name,chr(10),''),chr(13),'') as bind_acct_name
      ,replace(replace(bind_acct_open_bk,chr(10),''),chr(13),'') as bind_acct_open_bk
      ,replace(replace(bind_acct_open_bk_name,chr(10),''),chr(13),'') as bind_acct_open_bk_name
      ,replace(replace(bind_acct_ceph_num,chr(10),''),chr(13),'') as bind_acct_ceph_num
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_dacct_rela 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dacct_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes