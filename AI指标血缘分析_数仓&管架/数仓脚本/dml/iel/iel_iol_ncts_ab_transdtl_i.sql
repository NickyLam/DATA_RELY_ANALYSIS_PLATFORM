: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_transdtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_transdtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.clt_seqno,chr(13),''),chr(10),'') as clt_seqno
    ,replace(replace(t.glob_seq,chr(13),''),chr(10),'') as glob_seq
    ,replace(replace(t.tran_date,chr(13),''),chr(10),'') as tran_date
    ,replace(replace(t.tran_time,chr(13),''),chr(10),'') as tran_time
    ,replace(replace(t.tran_end_time,chr(13),''),chr(10),'') as tran_end_time
    ,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
    ,replace(replace(t.tran_name,chr(13),''),chr(10),'') as tran_name
    ,replace(replace(t.tran_type,chr(13),''),chr(10),'') as tran_type
    ,replace(replace(t.tran_inst,chr(13),''),chr(10),'') as tran_inst
    ,replace(replace(t.tran_opt_no,chr(13),''),chr(10),'') as tran_opt_no
    ,replace(replace(t.tran_opt_name,chr(13),''),chr(10),'') as tran_opt_name
    ,replace(replace(t.abip,chr(13),''),chr(10),'') as abip
    ,replace(replace(t.abmac,chr(13),''),chr(10),'') as abmac
    ,replace(replace(t.aboid,chr(13),''),chr(10),'') as aboid
    ,replace(replace(t.auth_seqno,chr(13),''),chr(10),'') as auth_seqno
    ,replace(replace(t.auth_opt_no,chr(13),''),chr(10),'') as auth_opt_no
    ,replace(replace(t.auth_opt_name,chr(13),''),chr(10),'') as auth_opt_name
    ,replace(replace(t.cust_no1,chr(13),''),chr(10),'') as cust_no1
    ,replace(replace(t.acc_no1,chr(13),''),chr(10),'') as acc_no1
    ,replace(replace(t.acc_name1,chr(13),''),chr(10),'') as acc_name1
    ,replace(replace(t.card_no1,chr(13),''),chr(10),'') as card_no1
    ,replace(replace(t.cust_no2,chr(13),''),chr(10),'') as cust_no2
    ,replace(replace(t.acc_no2,chr(13),''),chr(10),'') as acc_no2
    ,replace(replace(t.acc_name2,chr(13),''),chr(10),'') as acc_name2
    ,replace(replace(t.card_no2,chr(13),''),chr(10),'') as card_no2
    ,replace(replace(t.ccy,chr(13),''),chr(10),'') as ccy
    ,t.amt as amt
    ,replace(replace(t.dr_cr_flag,chr(13),''),chr(10),'') as dr_cr_flag
    ,replace(replace(t.csh_tsf_flag,chr(13),''),chr(10),'') as csh_tsf_flag
    ,replace(replace(t.custcerttype,chr(13),''),chr(10),'') as custcerttype
    ,replace(replace(t.custcertno,chr(13),''),chr(10),'') as custcertno
    ,replace(replace(t.custidcheck,chr(13),''),chr(10),'') as custidcheck
    ,replace(replace(t.agentcerttype,chr(13),''),chr(10),'') as agentcerttype
    ,replace(replace(t.agentcertno,chr(13),''),chr(10),'') as agentcertno
    ,replace(replace(t.agentidcheck,chr(13),''),chr(10),'') as agentidcheck
    ,replace(replace(t.water_check,chr(13),''),chr(10),'') as water_check
    ,replace(replace(t.tran_stat,chr(13),''),chr(10),'') as tran_stat
    ,replace(replace(t.core_sysid,chr(13),''),chr(10),'') as core_sysid
    ,replace(replace(t.core_date,chr(13),''),chr(10),'') as core_date
    ,replace(replace(t.core_seq,chr(13),''),chr(10),'') as core_seq
    ,replace(replace(t.core_transcode,chr(13),''),chr(10),'') as core_transcode
    ,replace(replace(t.core_return_code,chr(13),''),chr(10),'') as core_return_code
    ,replace(replace(t.core_return_mesg,chr(13),''),chr(10),'') as core_return_mesg
    ,replace(replace(t.batchserno,chr(13),''),chr(10),'') as batchserno
    ,replace(replace(t.relationserno,chr(13),''),chr(10),'') as relationserno
    ,replace(replace(t.tradereversestatus,chr(13),''),chr(10),'') as tradereversestatus
    ,replace(replace(t.baccheckflag,chr(13),''),chr(10),'') as baccheckflag
    ,replace(replace(t.baccheckdate,chr(13),''),chr(10),'') as baccheckdate
    ,replace(replace(t.bacchecktime,chr(13),''),chr(10),'') as bacchecktime
    ,replace(replace(t.baccheckoper,chr(13),''),chr(10),'') as baccheckoper
    ,replace(replace(t.crossb_flg,chr(13),''),chr(10),'') as crossb_flg
    ,replace(replace(t.agentcertname,chr(13),''),chr(10),'') as agentcertname
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.purpose,chr(13),''),chr(10),'') as purpose
    ,replace(replace(t.agentcerttel,chr(13),''),chr(10),'') as agentcerttel
    ,replace(replace(t.agentcertcty,chr(13),''),chr(10),'') as agentcertcty
    ,replace(replace(t.agentcertsex,chr(13),''),chr(10),'') as agentcertsex
    ,replace(replace(t.agentcertaddress,chr(13),''),chr(10),'') as agentcertaddress
    ,replace(replace(t.agentcertresion,chr(13),''),chr(10),'') as agentcertresion
    ,replace(replace(t.custtype1,chr(13),''),chr(10),'') as custtype1
    ,replace(replace(t.custtype2,chr(13),''),chr(10),'') as custtype2
    ,replace(replace(t.campid,chr(13),''),chr(10),'') as campid
    ,replace(replace(t.tradechannel,chr(13),''),chr(10),'') as tradechannel
    ,replace(replace(t.slf_face_iden_resu,chr(13),''),chr(10),'') as slf_face_iden_resu
    ,replace(replace(t.agidbt,chr(13),''),chr(10),'') as agidbt
    ,replace(replace(t.agidmt,chr(13),''),chr(10),'') as agidmt
    ,replace(replace(t.paper_data_num,chr(13),''),chr(10),'') as paper_data_num
from iol.ncts_ab_transdtl t
where tran_date='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_transdtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes