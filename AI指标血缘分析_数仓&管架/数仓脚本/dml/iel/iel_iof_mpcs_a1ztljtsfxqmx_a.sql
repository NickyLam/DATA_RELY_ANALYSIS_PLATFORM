: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1ztljtsfxqmx_a
CreateDate: 20251010
FileName:   ${iel_data_path}/mpcs_a1ztljtsfxqmx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transtm,chr(13),''),chr(10),'') as transtm
,replace(replace(t1.mainseq,chr(13),''),chr(10),'') as mainseq
,replace(replace(t1.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.base_acct_name,chr(13),''),chr(10),'') as base_acct_name
,replace(replace(t1.tran_amt,chr(13),''),chr(10),'') as tran_amt
,replace(replace(t1.pay_acct,chr(13),''),chr(10),'') as pay_acct
,replace(replace(t1.pay_name,chr(13),''),chr(10),'') as pay_name
,replace(replace(t1.recv_acct,chr(13),''),chr(10),'') as recv_acct
,replace(replace(t1.recv_name,chr(13),''),chr(10),'') as recv_name
,replace(replace(t1.inhostdt,chr(13),''),chr(10),'') as inhostdt
,replace(replace(t1.inhosttm,chr(13),''),chr(10),'') as inhosttm
,replace(replace(t1.inhostseqno,chr(13),''),chr(10),'') as inhostseqno
,replace(replace(t1.inhostseqnosub,chr(13),''),chr(10),'') as inhostseqnosub
,replace(replace(t1.outhostdt,chr(13),''),chr(10),'') as outhostdt
,replace(replace(t1.outhosttm,chr(13),''),chr(10),'') as outhosttm
,replace(replace(t1.outhostseqno,chr(13),''),chr(10),'') as outhostseqno
,replace(replace(t1.outhostseqnosub,chr(13),''),chr(10),'') as outhostseqnosub
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2

from ${iol_schema}.mpcs_a1ztljtsfxqmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1ztljtsfxqmx.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
