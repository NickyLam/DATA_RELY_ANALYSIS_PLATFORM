: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_pbs_pub_trade_flow_i
CreateDate: 20240328
FileName:   ${iel_data_path}/osbs_pbs_pub_trade_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ptf_trade_flowno,chr(13),''),chr(10),'') as ptf_trade_flowno
,replace(replace(t1.ptf_transtime,chr(13),''),chr(10),'') as ptf_transtime
,replace(replace(t1.ptf_transcode,chr(13),''),chr(10),'') as ptf_transcode
,replace(replace(t1.ptf_state,chr(13),''),chr(10),'') as ptf_state
,replace(replace(t1.ptf_returncode,chr(13),''),chr(10),'') as ptf_returncode
,replace(replace(t1.ptf_returnmsg,chr(13),''),chr(10),'') as ptf_returnmsg
,replace(replace(t1.ptf_accno,chr(13),''),chr(10),'') as ptf_accno
,ptf_amonut
,replace(replace(t1.ptf_currency,chr(13),''),chr(10),'') as ptf_currency
,replace(replace(t1.ptf_ecifno,chr(13),''),chr(10),'') as ptf_ecifno
,replace(replace(t1.ptf_userno,chr(13),''),chr(10),'') as ptf_userno
,replace(replace(t1.ptf_channel,chr(13),''),chr(10),'') as ptf_channel
,replace(replace(t1.ptf_sendflowno,chr(13),''),chr(10),'') as ptf_sendflowno
,replace(replace(t1.ptf_src_sendflowno,chr(13),''),chr(10),'') as ptf_src_sendflowno
,replace(replace(t1.ptf_hostflowno,chr(13),''),chr(10),'') as ptf_hostflowno
,ptf_fee
,replace(replace(t1.ptf_accessflowno,chr(13),''),chr(10),'') as ptf_accessflowno
,replace(replace(t1.ptf_host_returntime,chr(13),''),chr(10),'') as ptf_host_returntime
,replace(replace(t1.ptf_svrtranscode,chr(13),''),chr(10),'') as ptf_svrtranscode
,replace(replace(t1.ptf_customerip,chr(13),''),chr(10),'') as ptf_customerip
,replace(replace(t1.ptf_hostname,chr(13),''),chr(10),'') as ptf_hostname
,replace(replace(t1.ptf_src_serverip,chr(13),''),chr(10),'') as ptf_src_serverip
,replace(replace(t1.ptf_clientmac,chr(13),''),chr(10),'') as ptf_clientmac
,replace(replace(t1.ptf_clientos,chr(13),''),chr(10),'') as ptf_clientos
,replace(replace(t1.ptf_clientbrowser,chr(13),''),chr(10),'') as ptf_clientbrowser
,replace(replace(t1.ptf_clientnunittype,chr(13),''),chr(10),'') as ptf_clientnunittype
,replace(replace(t1.ptf_clientterminateno,chr(13),''),chr(10),'') as ptf_clientterminateno
,replace(replace(t1.ptf_sessionid,chr(13),''),chr(10),'') as ptf_sessionid
,replace(replace(t1.ptf_relflowno,chr(13),''),chr(10),'') as ptf_relflowno
,replace(replace(t1.ptf_trade_inf,chr(13),''),chr(10),'') as ptf_trade_inf
,replace(replace(t1.ptf_transtype,chr(13),''),chr(10),'') as ptf_transtype
,replace(replace(t1.ptf_ecifname,chr(13),''),chr(10),'') as ptf_ecifname
,replace(replace(t1.ptf_securitytype,chr(13),''),chr(10),'') as ptf_securitytype
,replace(replace(t1.ptf_menuid,chr(13),''),chr(10),'') as ptf_menuid
,replace(replace(t1.ptf_marketing_number,chr(13),''),chr(10),'') as ptf_marketing_number
,replace(replace(t1.ptf_businessno,chr(13),''),chr(10),'') as ptf_businessno
,replace(replace(t1.ptf_channelcode,chr(13),''),chr(10),'') as ptf_channelcode

from ${iol_schema}.osbs_pbs_pub_trade_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_pub_trade_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
