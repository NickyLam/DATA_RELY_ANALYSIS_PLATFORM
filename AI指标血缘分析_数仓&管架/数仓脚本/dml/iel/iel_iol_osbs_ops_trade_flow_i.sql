: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_ops_trade_flow_i
CreateDate: 20220309
FileName:   ${iel_data_path}/osbs_ops_trade_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.otf_trade_flowno,chr(13),''),chr(10),'') as otf_trade_flowno
    ,replace(replace(t.otf_tran_seqno,chr(13),''),chr(10),'') as otf_tran_seqno
    ,replace(replace(t.otf_global_seqno,chr(13),''),chr(10),'') as otf_global_seqno
    ,replace(replace(t.otf_ecifno,chr(13),''),chr(10),'') as otf_ecifno
    ,replace(replace(t.otf_ecifname,chr(13),''),chr(10),'') as otf_ecifname
    ,replace(replace(t.otf_userno,chr(13),''),chr(10),'') as otf_userno
    ,replace(replace(t.otf_transcode,chr(13),''),chr(10),'') as otf_transcode
    ,replace(replace(t.otf_transcategory,chr(13),''),chr(10),'') as otf_transcategory
    ,replace(replace(t.otf_transtype,chr(13),''),chr(10),'') as otf_transtype
    ,replace(replace(t.otf_transdate,chr(13),''),chr(10),'') as otf_transdate
    ,replace(replace(t.otf_transtime,chr(13),''),chr(10),'') as otf_transtime
    ,replace(replace(t.otf_accno,chr(13),''),chr(10),'') as otf_accno
    ,replace(replace(t.otf_currency,chr(13),''),chr(10),'') as otf_currency
    ,t.otf_amonut as otf_amonut
    ,t.otf_fee as otf_fee
    ,replace(replace(t.otf_sysid,chr(13),''),chr(10),'') as otf_sysid
    ,replace(replace(t.otf_sourcesysid,chr(13),''),chr(10),'') as otf_sourcesysid
    ,replace(replace(t.otf_channelcode,chr(13),''),chr(10),'') as otf_channelcode
    ,replace(replace(t.otf_state,chr(13),''),chr(10),'') as otf_state
    ,replace(replace(t.otf_returncode,chr(13),''),chr(10),'') as otf_returncode
    ,replace(replace(t.otf_returnmsg,chr(13),''),chr(10),'') as otf_returnmsg
    ,replace(replace(t.otf_hostflowno,chr(13),''),chr(10),'') as otf_hostflowno
    ,replace(replace(t.otf_host_returntime,chr(13),''),chr(10),'') as otf_host_returntime
    ,replace(replace(t.otf_accessflowno,chr(13),''),chr(10),'') as otf_accessflowno
    ,replace(replace(t.otf_relflowno,chr(13),''),chr(10),'') as otf_relflowno
    ,replace(replace(t.otf_serverip,chr(13),''),chr(10),'') as otf_serverip
    ,replace(replace(t.otf_sessionid,chr(13),''),chr(10),'') as otf_sessionid
    ,replace(replace(t.otf_accesstoken,chr(13),''),chr(10),'') as otf_accesstoken
    ,replace(replace(t.otf_trade_abstract,chr(13),''),chr(10),'') as otf_trade_abstract
    ,replace(replace(t.otf_trstype,chr(13),''),chr(10),'') as otf_trstype
    ,replace(replace(t.otf_menuid,chr(13),''),chr(10),'') as otf_menuid
    ,replace(replace(t.otf_clientip,chr(13),''),chr(10),'') as otf_clientip
    ,replace(replace(t.otf_clientmac,chr(13),''),chr(10),'') as otf_clientmac
    ,replace(replace(t.otf_deviceno,chr(13),''),chr(10),'') as otf_deviceno
    ,replace(replace(t.otf_brand,chr(13),''),chr(10),'') as otf_brand
    ,replace(replace(t.otf_model,chr(13),''),chr(10),'') as otf_model
    ,replace(replace(t.otf_browsertype,chr(13),''),chr(10),'') as otf_browsertype
    ,replace(replace(t.otf_browserversion,chr(13),''),chr(10),'') as otf_browserversion
    ,replace(replace(t.otf_longitude,chr(13),''),chr(10),'') as otf_longitude
    ,replace(replace(t.otf_latitude,chr(13),''),chr(10),'') as otf_latitude
    ,replace(replace(t.otf_tellerid,chr(13),''),chr(10),'') as otf_tellerid
    ,replace(replace(t.otf_tellerdeptid,chr(13),''),chr(10),'') as otf_tellerdeptid
    ,replace(replace(t.otf_reqtime,chr(13),''),chr(10),'') as otf_reqtime
    ,replace(replace(t.otf_resptime,chr(13),''),chr(10),'') as otf_resptime
    ,replace(replace(t.otf_logthreadno,chr(13),''),chr(10),'') as otf_logthreadno
    ,replace(replace(t.otf_moveflag,chr(13),''),chr(10),'') as otf_moveflag
    ,replace(replace(t.otf_fingerprint_id,chr(13),''),chr(10),'') as otf_fingerprint_id
from iol.osbs_ops_trade_flow t
  where t.otf_transdate = '${batch_date}'  " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_ops_trade_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes