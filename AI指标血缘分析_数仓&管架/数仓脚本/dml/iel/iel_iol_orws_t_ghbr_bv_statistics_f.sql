: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_ghbr_bv_statistics_f
CreateDate: 20240101
FileName:   ${iel_data_path}/orws_t_ghbr_bv_statistics.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,data_date
,replace(replace(t1.data_type,chr(13),''),chr(10),'') as data_type
,replace(replace(t1.is_shield,chr(13),''),chr(10),'') as is_shield
,replace(replace(t1.hb_num,chr(13),''),chr(10),'') as hb_num
,replace(replace(t1.hb_name,chr(13),''),chr(10),'') as hb_name
,replace(replace(t1.bb_num,chr(13),''),chr(10),'') as bb_num
,replace(replace(t1.bb_name,chr(13),''),chr(10),'') as bb_name
,replace(replace(t1.sb_num,chr(13),''),chr(10),'') as sb_num
,replace(replace(t1.sb_name,chr(13),''),chr(10),'') as sb_name
,replace(replace(t1.organ_num,chr(13),''),chr(10),'') as organ_num
,replace(replace(t1.organ_name,chr(13),''),chr(10),'') as organ_name
,replace(replace(t1.display_num,chr(13),''),chr(10),'') as display_num
,replace(replace(t1.display_name,chr(13),''),chr(10),'') as display_name
,total_txnvol
,total_weight_txnvol
,cbss_txnvol
,cbss_weight_txnvol
,pwbs_txnvol
,pwbs_weight_txnvol
,ifms_txnvol
,ifms_weight_txnvol
,pbss_txnvol
,pbss_weight_txnvol
,isbs_txnvol
,isbs_weight_txnvol
,crss_txnvol
,crss_weight_txnvol
,svss_txnvol
,svss_weight_txnvol
,amls_txnvol
,amls_weight_txnvol
,bdms_txnvol
,bdms_weight_txnvol
,mpcs_txnvol
,mpcs_weight_txnvol
,ma_txnvol
,ma_weight_txnvol
,period_type
,teller_type
,auto_txnvol
,auto_weight_txnvol

from ${iol_schema}.orws_t_ghbr_bv_statistics t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_ghbr_bv_statistics.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
