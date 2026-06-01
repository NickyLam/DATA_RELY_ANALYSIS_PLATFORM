: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_agt_acct_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_agt_acct_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(acct_num,chr(10),''),chr(13),'') as acct_num
      ,etl_dt
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(cm_pcm_typ_cd,chr(10),''),chr(13),'') as cm_pcm_typ_cd
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(acct_blng_org_num,chr(10),''),chr(13),'') as acct_blng_org_num
      ,replace(replace(out_cmpnt_prd_cd,chr(10),''),chr(13),'') as out_cmpnt_prd_cd
      ,replace(replace(max_sub_num,chr(10),''),chr(13),'') as max_sub_num
      ,sub_num_qty
      ,replace(replace(acct_typ_cd,chr(10),''),chr(13),'') as acct_typ_cd
      ,open_dt
      ,replace(replace(open_seq_num,chr(10),''),chr(13),'') as open_seq_num
      ,colse_dt
      ,replace(replace(colse_seq_num,chr(10),''),chr(13),'') as colse_seq_num
      ,replace(replace(acct_status_cd,chr(10),''),chr(13),'') as acct_status_cd
      ,replace(replace(corp_dep_flg,chr(10),''),chr(13),'') as corp_dep_flg
      ,replace(replace(non_activ_flg,chr(10),''),chr(13),'') as non_activ_flg
      ,replace(replace(sleep_flg,chr(10),''),chr(13),'') as sleep_flg
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_agt_acct_base_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_agt_acct_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes