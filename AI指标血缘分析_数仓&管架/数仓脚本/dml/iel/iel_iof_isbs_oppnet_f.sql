: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_isbs_oppnet_f
CreateDate: 20240131
FileName:   ${iel_data_path}/isbs_oppnet.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.gltyp,chr(13),''),chr(10),'') as gltyp
,replace(replace(t1.glinr,chr(13),''),chr(10),'') as glinr
,replace(replace(t1.gldate,chr(13),''),chr(10),'') as gldate
,replace(replace(t1.trninr,chr(13),''),chr(10),'') as trninr
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,replace(replace(t1.biz_seq_no,chr(13),''),chr(10),'') as biz_seq_no
,replace(replace(t1.biz_ccy,chr(13),''),chr(10),'') as biz_ccy
,biz_amt
,replace(replace(t1.pty_extkey,chr(13),''),chr(10),'') as pty_extkey
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.pty_acct_num,chr(13),''),chr(10),'') as pty_acct_num
,replace(replace(t1.pty_acct_no,chr(13),''),chr(10),'') as pty_acct_no
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.tx_cntpty_acct_num,chr(13),''),chr(10),'') as tx_cntpty_acct_num
,replace(replace(t1.tx_cntpty_name,chr(13),''),chr(10),'') as tx_cntpty_name
,replace(replace(t1.cntpty_fin_inst_brac_cd,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_cd
,replace(replace(t1.cntpty_fin_inst_brac_name,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_name
,replace(replace(t1.dist,chr(13),''),chr(10),'') as dist
,replace(replace(t1.tx_cntpty_cert_type,chr(13),''),chr(10),'') as tx_cntpty_cert_type
,replace(replace(t1.tx_cntpty_cert_type_txt,chr(13),''),chr(10),'') as tx_cntpty_cert_type_txt
,replace(replace(t1.tx_cntpty_cert_no,chr(13),''),chr(10),'') as tx_cntpty_cert_no
,replace(replace(t1.cd_typ,chr(13),''),chr(10),'') as cd_typ

from ${iol_schema}.isbs_oppnet t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_oppnet.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
