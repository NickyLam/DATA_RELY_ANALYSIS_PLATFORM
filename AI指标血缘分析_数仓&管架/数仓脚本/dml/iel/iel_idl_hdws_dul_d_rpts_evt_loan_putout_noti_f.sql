: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_loan_putout_noti_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_loan_putout_noti.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(seq_num,chr(10),''),chr(13),'') as seq_num
      ,txn_dt
      ,replace(replace(singl_bil_id,chr(10),''),chr(13),'') as singl_bil_id
      ,replace(replace(putout_org_id,chr(10),''),chr(13),'') as putout_org_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(pty_name,chr(10),''),chr(13),'') as pty_name
      ,replace(replace(ibp_id,chr(10),''),chr(13),'') as ibp_id
      ,replace(replace(biz_id_1,chr(10),''),chr(13),'') as biz_id_1
      ,replace(replace(biz_id_2,chr(10),''),chr(13),'') as biz_id_2
      ,replace(replace(biz_typ,chr(10),''),chr(13),'') as biz_typ
      ,replace(replace(coll_typ_cd,chr(10),''),chr(13),'') as coll_typ_cd
      ,replace(replace(coll_row,chr(10),''),chr(13),'') as coll_row
      ,issue_dt
      ,due_dt
      ,replace(replace(biz_ccy_cd,chr(10),''),chr(13),'') as biz_ccy_cd
      ,replace(replace(biz_ccy_cd_3,chr(10),''),chr(13),'') as biz_ccy_cd_3
      ,biz_amt
      ,biz_rate
      ,replace(replace(oper_org,chr(10),''),chr(13),'') as oper_org
      ,replace(replace(oprt,chr(10),''),chr(13),'') as oprt
      ,oper_dt
      ,replace(replace(contr_num,chr(10),''),chr(13),'') as contr_num
      ,replace(replace(dbill_num,chr(10),''),chr(13),'') as dbill_num
      ,replace(replace(txn_status_cd,chr(10),''),chr(13),'') as txn_status_cd
      ,rela_dt
      ,rela_ratio_1
      ,rela_ratio_2
      ,rela_amt_1
      ,rela_amt_2
      ,rela_amt_3
      ,etl_dt
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_rpts_evt_loan_putout_noti 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_loan_putout_noti.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes