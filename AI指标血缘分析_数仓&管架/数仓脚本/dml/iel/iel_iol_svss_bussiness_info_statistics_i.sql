: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_svss_bussiness_info_statistics_i
CreateDate: 20180529
FileName:   ${iel_data_path}/svss_bussiness_info_statistics.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,id
      ,txn_dt
      ,replace(replace(txn_tm,chr(13),''),chr(10),'') as txn_tm
      ,blng_org_id
      ,oper_teller_id
      ,replace(replace(oper_teller_name,chr(13),''),chr(10),'') as oper_teller_name
      ,auth_teller_id
      ,replace(replace(auth_teller_name,chr(13),''),chr(10),'') as auth_teller_name
      ,replace(replace(txn_num,chr(13),''),chr(10),'') as txn_num
      ,replace(replace(txn_desc,chr(13),''),chr(10),'') as txn_desc
      ,biz_sys_evt_id
      ,bcs_evt_id
      ,data_src_cd
      ,pay_agt_id
      ,rcv_agt_id
      ,txn_amt
      ,etl_dt_ora
      ,replace(replace(menuid,chr(13),''),chr(10),'') as menuid
      ,start_dt
      ,end_dt
      ,id_mark
  from ${iol_schema}.svss_bussiness_info_statistics t1 where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/svss_bussiness_info_statistics.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes