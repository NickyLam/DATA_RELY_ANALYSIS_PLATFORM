: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bill_discount_click_bag_dtl_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_bill_discount_click_bag_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dtl_ser_num,chr(13),''),chr(10),'') as dtl_ser_num
,replace(replace(t1.batch_ser_num,chr(13),''),chr(10),'') as batch_ser_num
,replace(replace(t1.bill_ser_num,chr(13),''),chr(10),'') as bill_ser_num
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,fac_val_amt
,bill_exp_dt
,actl_exp_dt
,surp_tenor
,int_paybl
,stl_amt
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,final_modif_tm
,replace(replace(t1.crdt_main_type_cd,chr(13),''),chr(10),'') as crdt_main_type_cd
,replace(replace(t1.crdt_main_id,chr(13),''),chr(10),'') as crdt_main_id
,replace(replace(t1.bag_flg,chr(13),''),chr(10),'') as bag_flg
,replace(replace(t1.ctr_nt_ser_num,chr(13),''),chr(10),'') as ctr_nt_ser_num
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,start_dt
,end_dt

from ${iml_schema}.evt_bill_discount_click_bag_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_discount_click_bag_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
