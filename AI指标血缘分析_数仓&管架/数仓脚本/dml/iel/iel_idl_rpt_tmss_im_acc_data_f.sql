: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_tmss_im_acc_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_tmss_im_acc_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t1.acc_id as acc_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t1.bankacc,chr(13),''),chr(10),'') as bankacc
,replace(replace(t1.checkeds,chr(13),''),chr(10),'') as checkeds
,replace(replace(t1.bank_cust_id,chr(13),''),chr(10),'') as bank_cust_id
 from iol.tmss_im_acc_data T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_tmss_im_acc_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes