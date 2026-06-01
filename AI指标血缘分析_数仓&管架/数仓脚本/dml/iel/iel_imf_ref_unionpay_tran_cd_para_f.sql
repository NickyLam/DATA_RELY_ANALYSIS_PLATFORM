: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_unionpay_tran_cd_para_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_unionpay_tran_cd_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.msg_type_cd,chr(13),''),chr(10),'') as msg_type_cd
,replace(replace(t1.tran_proc_cd,chr(13),''),chr(10),'') as tran_proc_cd
,replace(replace(t1.tran_serv_cond_cd,chr(13),''),chr(10),'') as tran_serv_cond_cd
,replace(replace(t1.intnal_tran_cd,chr(13),''),chr(10),'') as intnal_tran_cd
,replace(replace(t1.unionpay_tran_cd,chr(13),''),chr(10),'') as unionpay_tran_cd
,replace(replace(t1.return_msg_type_cd,chr(13),''),chr(10),'') as return_msg_type_cd
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.fobid_flg,chr(13),''),chr(10),'') as fobid_flg
,replace(replace(t1.deflt_memo_cd,chr(13),''),chr(10),'') as deflt_memo_cd
,replace(replace(t1.memo_name,chr(13),''),chr(10),'') as memo_name
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_unionpay_tran_cd_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_unionpay_tran_cd_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
