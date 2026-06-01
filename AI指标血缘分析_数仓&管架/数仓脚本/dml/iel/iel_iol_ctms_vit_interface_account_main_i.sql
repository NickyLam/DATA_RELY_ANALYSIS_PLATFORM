: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_vit_interface_account_main_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_vit_interface_account_main.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,src_cd
      ,settledate
      ,replace(replace(settletime,chr(13),''),chr(10),'') as settletime
      ,bus_depart_id
      ,ope_depart_id
      ,handle_teller_id
      ,check_teller_id
      ,replace(replace(txn_num,chr(13),''),chr(10),'') as txn_num
      ,replace(replace(txn_desc,chr(13),''),chr(10),'') as txn_desc
      ,alterbalance_id
      ,replace(replace(core_seq,chr(13),''),chr(10),'') as core_seq
      ,replace(replace(amount,chr(13),''),chr(10),'') as amount
      ,start_dt
      ,end_dt
      ,id_mark
  from ${iol_schema}.ctms_vit_interface_account_main t1 where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_vit_interface_account_main.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes