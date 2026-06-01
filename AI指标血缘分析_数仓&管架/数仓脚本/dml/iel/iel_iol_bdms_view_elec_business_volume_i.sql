: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_view_elec_business_volume_i
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_view_elec_business_volume.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,txn_dt
      ,replace(replace(txn_tm,chr(13),''),chr(10),'') as txn_tm
      ,blng_org_id
      ,oper_teller_id
      ,replace(replace(txn_desc,chr(13),''),chr(10),'') as txn_desc
      ,replace(replace(txn_num,chr(13),''),chr(10),'') as txn_num
      ,data_src_cd
  from ${iol_schema}.bdms_view_elec_business_volume t1 where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_view_elec_business_volume.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes