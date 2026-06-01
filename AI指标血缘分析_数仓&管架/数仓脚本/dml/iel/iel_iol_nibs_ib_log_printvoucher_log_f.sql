: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_log_printvoucher_log_f
CreateDate: 20230423
FileName:   ${iel_data_path}/nibs_ib_log_printvoucher_log.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pr_sn,chr(13),''),chr(10),'') as pr_sn
,replace(replace(t1.chan_num,chr(13),''),chr(10),'') as chan_num
,replace(replace(t1.tx_seq_num,chr(13),''),chr(10),'') as tx_seq_num
,replace(replace(t1.channeltrancode,chr(13),''),chr(10),'') as channeltrancode
,replace(replace(t1.channeltranname,chr(13),''),chr(10),'') as channeltranname
,replace(replace(t1.nodecode,chr(13),''),chr(10),'') as nodecode
,tx_dt
,backrspdate
,replace(replace(t1.vouchertype,chr(13),''),chr(10),'') as vouchertype
,replace(replace(t1.vouchername,chr(13),''),chr(10),'') as vouchername
,replace(replace(t1.iselecseal,chr(13),''),chr(10),'') as iselecseal
,replace(replace(t1.elecsealnum,chr(13),''),chr(10),'') as elecsealnum
,replace(replace(t1.isprtcontrol,chr(13),''),chr(10),'') as isprtcontrol
,replace(replace(t1.prtcontrolnum,chr(13),''),chr(10),'') as prtcontrolnum
,replace(replace(t1.prtseqno,chr(13),''),chr(10),'') as prtseqno
,prtnum
,prtdate
,replace(replace(t1.prtbranch,chr(13),''),chr(10),'') as prtbranch
,replace(replace(t1.prtreason,chr(13),''),chr(10),'') as prtreason
,replace(replace(t1.prtmsg,chr(13),''),chr(10),'') as prtmsg
,replace(replace(t1.print_telr_no,chr(13),''),chr(10),'') as print_telr_no
,replace(replace(t1.prompt,chr(13),''),chr(10),'') as prompt
,replace(replace(t1.rprint_telr_no,chr(13),''),chr(10),'') as rprint_telr_no
,rprint_dt
,rprint_tms
,replace(replace(t1.rprint_auth_telr_no,chr(13),''),chr(10),'') as rprint_auth_telr_no
,replace(replace(t1.rprint_typ_cd,chr(13),''),chr(10),'') as rprint_typ_cd
,replace(replace(t1.rprint_rsn,chr(13),''),chr(10),'') as rprint_rsn
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.blip_id,chr(13),''),chr(10),'') as blip_id

from ${iol_schema}.nibs_ib_log_printvoucher_log t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_printvoucher_log.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
