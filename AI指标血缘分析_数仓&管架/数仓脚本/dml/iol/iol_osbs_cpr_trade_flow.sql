/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_cpr_trade_flow
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.osbs_cpr_trade_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_cpr_trade_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_cpr_trade_flow_op purge;
drop table ${iol_schema}.osbs_cpr_trade_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_cpr_trade_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_cpr_trade_flow where 0=1;

create table ${iol_schema}.osbs_cpr_trade_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_cpr_trade_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_cpr_trade_flow_cl(
            ctf_trade_flowno -- 流水号
            ,ctf_transtime -- 交易时间
            ,ctf_transdate -- 交易日期
            ,ctf_transcode -- 交易码
            ,ctf_action -- 请求do
            ,ctf_ecifno -- 全行统一客户号
            ,ctf_userno -- 用户顺序号
            ,ctf_channel -- 交易渠道
            ,ctf_ecifname -- 客户姓名
            ,ctf_menuid -- 
            ,ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
            ,ctf_returncode -- 交易返回码
            ,ctf_returnmsg -- 失败原因
            ,ctf_accno -- 交易账号
            ,ctf_amonut -- 交易金额
            ,ctf_currency -- 币种
            ,ctf_sendflowno -- 渠道发送流水号
            ,ctf_src_sendflowno -- 源系统流水号
            ,ctf_hostflowno -- 核心交易流水号
            ,ctf_fee -- 手续费
            ,ctf_parentlogno -- 父流水号
            ,ctf_rootlogno -- 来源流水顺序号
            ,ctf_authrefusecause -- 授权拒绝原因
            ,ctf_accessflowno -- 访问流水号
            ,ctf_host_returntime -- 核心交易日期
            ,ctf_svrtranscode -- 被调方交易编码
            ,ctf_customerip -- 客户IP
            ,ctf_hostname -- 当前服务器主机名
            ,ctf_src_serverip -- 请求来源服务器IP
            ,ctf_clientmac -- 客户终端MAC地址
            ,ctf_clientos -- 客户终端操作系统
            ,ctf_clientbrowser -- 客户终端浏览器
            ,ctf_clientnunittype -- 客户终端设备型号
            ,ctf_clientterminateno -- 客户终端设备ID
            ,ctf_sessionid -- 登陆sessionID
            ,ctf_relflowno -- 关联流水号
            ,ctf_securitytype -- 安全认证方式
            ,ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
            ,ctf_delegateflag -- 是否银行代办(N:非;Y:是)
            ,ctf_authstep -- 授权角色编号
            ,ctf_senddate -- 交易真正提交核心的日期
            ,ctf_sendtime -- 交易真正提交核心的时间
            ,ctf_totalcount -- 交易总笔数
            ,ctf_remark -- 摘要
            ,ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
            ,ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
            ,ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
            ,ctf_biz_flow_no -- 业务流水号
            ,ctf_chain_track_no -- 链路跟踪号
            ,ctf_send_flow_no -- 上游交易流水号
            ,ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
            ,ctf_imei -- 手机串号
            ,ctf_udid -- 手机SIM
            ,ctf_sim -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_cpr_trade_flow_op(
            ctf_trade_flowno -- 流水号
            ,ctf_transtime -- 交易时间
            ,ctf_transdate -- 交易日期
            ,ctf_transcode -- 交易码
            ,ctf_action -- 请求do
            ,ctf_ecifno -- 全行统一客户号
            ,ctf_userno -- 用户顺序号
            ,ctf_channel -- 交易渠道
            ,ctf_ecifname -- 客户姓名
            ,ctf_menuid -- 
            ,ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
            ,ctf_returncode -- 交易返回码
            ,ctf_returnmsg -- 失败原因
            ,ctf_accno -- 交易账号
            ,ctf_amonut -- 交易金额
            ,ctf_currency -- 币种
            ,ctf_sendflowno -- 渠道发送流水号
            ,ctf_src_sendflowno -- 源系统流水号
            ,ctf_hostflowno -- 核心交易流水号
            ,ctf_fee -- 手续费
            ,ctf_parentlogno -- 父流水号
            ,ctf_rootlogno -- 来源流水顺序号
            ,ctf_authrefusecause -- 授权拒绝原因
            ,ctf_accessflowno -- 访问流水号
            ,ctf_host_returntime -- 核心交易日期
            ,ctf_svrtranscode -- 被调方交易编码
            ,ctf_customerip -- 客户IP
            ,ctf_hostname -- 当前服务器主机名
            ,ctf_src_serverip -- 请求来源服务器IP
            ,ctf_clientmac -- 客户终端MAC地址
            ,ctf_clientos -- 客户终端操作系统
            ,ctf_clientbrowser -- 客户终端浏览器
            ,ctf_clientnunittype -- 客户终端设备型号
            ,ctf_clientterminateno -- 客户终端设备ID
            ,ctf_sessionid -- 登陆sessionID
            ,ctf_relflowno -- 关联流水号
            ,ctf_securitytype -- 安全认证方式
            ,ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
            ,ctf_delegateflag -- 是否银行代办(N:非;Y:是)
            ,ctf_authstep -- 授权角色编号
            ,ctf_senddate -- 交易真正提交核心的日期
            ,ctf_sendtime -- 交易真正提交核心的时间
            ,ctf_totalcount -- 交易总笔数
            ,ctf_remark -- 摘要
            ,ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
            ,ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
            ,ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
            ,ctf_biz_flow_no -- 业务流水号
            ,ctf_chain_track_no -- 链路跟踪号
            ,ctf_send_flow_no -- 上游交易流水号
            ,ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
            ,ctf_imei -- 手机串号
            ,ctf_udid -- 手机SIM
            ,ctf_sim -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ctf_trade_flowno, o.ctf_trade_flowno) as ctf_trade_flowno -- 流水号
    ,nvl(n.ctf_transtime, o.ctf_transtime) as ctf_transtime -- 交易时间
    ,nvl(n.ctf_transdate, o.ctf_transdate) as ctf_transdate -- 交易日期
    ,nvl(n.ctf_transcode, o.ctf_transcode) as ctf_transcode -- 交易码
    ,nvl(n.ctf_action, o.ctf_action) as ctf_action -- 请求do
    ,nvl(n.ctf_ecifno, o.ctf_ecifno) as ctf_ecifno -- 全行统一客户号
    ,nvl(n.ctf_userno, o.ctf_userno) as ctf_userno -- 用户顺序号
    ,nvl(n.ctf_channel, o.ctf_channel) as ctf_channel -- 交易渠道
    ,nvl(n.ctf_ecifname, o.ctf_ecifname) as ctf_ecifname -- 客户姓名
    ,nvl(n.ctf_menuid, o.ctf_menuid) as ctf_menuid -- 
    ,nvl(n.ctf_state, o.ctf_state) as ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
    ,nvl(n.ctf_returncode, o.ctf_returncode) as ctf_returncode -- 交易返回码
    ,nvl(n.ctf_returnmsg, o.ctf_returnmsg) as ctf_returnmsg -- 失败原因
    ,nvl(n.ctf_accno, o.ctf_accno) as ctf_accno -- 交易账号
    ,nvl(n.ctf_amonut, o.ctf_amonut) as ctf_amonut -- 交易金额
    ,nvl(n.ctf_currency, o.ctf_currency) as ctf_currency -- 币种
    ,nvl(n.ctf_sendflowno, o.ctf_sendflowno) as ctf_sendflowno -- 渠道发送流水号
    ,nvl(n.ctf_src_sendflowno, o.ctf_src_sendflowno) as ctf_src_sendflowno -- 源系统流水号
    ,nvl(n.ctf_hostflowno, o.ctf_hostflowno) as ctf_hostflowno -- 核心交易流水号
    ,nvl(n.ctf_fee, o.ctf_fee) as ctf_fee -- 手续费
    ,nvl(n.ctf_parentlogno, o.ctf_parentlogno) as ctf_parentlogno -- 父流水号
    ,nvl(n.ctf_rootlogno, o.ctf_rootlogno) as ctf_rootlogno -- 来源流水顺序号
    ,nvl(n.ctf_authrefusecause, o.ctf_authrefusecause) as ctf_authrefusecause -- 授权拒绝原因
    ,nvl(n.ctf_accessflowno, o.ctf_accessflowno) as ctf_accessflowno -- 访问流水号
    ,nvl(n.ctf_host_returntime, o.ctf_host_returntime) as ctf_host_returntime -- 核心交易日期
    ,nvl(n.ctf_svrtranscode, o.ctf_svrtranscode) as ctf_svrtranscode -- 被调方交易编码
    ,nvl(n.ctf_customerip, o.ctf_customerip) as ctf_customerip -- 客户IP
    ,nvl(n.ctf_hostname, o.ctf_hostname) as ctf_hostname -- 当前服务器主机名
    ,nvl(n.ctf_src_serverip, o.ctf_src_serverip) as ctf_src_serverip -- 请求来源服务器IP
    ,nvl(n.ctf_clientmac, o.ctf_clientmac) as ctf_clientmac -- 客户终端MAC地址
    ,nvl(n.ctf_clientos, o.ctf_clientos) as ctf_clientos -- 客户终端操作系统
    ,nvl(n.ctf_clientbrowser, o.ctf_clientbrowser) as ctf_clientbrowser -- 客户终端浏览器
    ,nvl(n.ctf_clientnunittype, o.ctf_clientnunittype) as ctf_clientnunittype -- 客户终端设备型号
    ,nvl(n.ctf_clientterminateno, o.ctf_clientterminateno) as ctf_clientterminateno -- 客户终端设备ID
    ,nvl(n.ctf_sessionid, o.ctf_sessionid) as ctf_sessionid -- 登陆sessionID
    ,nvl(n.ctf_relflowno, o.ctf_relflowno) as ctf_relflowno -- 关联流水号
    ,nvl(n.ctf_securitytype, o.ctf_securitytype) as ctf_securitytype -- 安全认证方式
    ,nvl(n.ctf_authstate, o.ctf_authstate) as ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
    ,nvl(n.ctf_delegateflag, o.ctf_delegateflag) as ctf_delegateflag -- 是否银行代办(N:非;Y:是)
    ,nvl(n.ctf_authstep, o.ctf_authstep) as ctf_authstep -- 授权角色编号
    ,nvl(n.ctf_senddate, o.ctf_senddate) as ctf_senddate -- 交易真正提交核心的日期
    ,nvl(n.ctf_sendtime, o.ctf_sendtime) as ctf_sendtime -- 交易真正提交核心的时间
    ,nvl(n.ctf_totalcount, o.ctf_totalcount) as ctf_totalcount -- 交易总笔数
    ,nvl(n.ctf_remark, o.ctf_remark) as ctf_remark -- 摘要
    ,nvl(n.ctf_authflag, o.ctf_authflag) as ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
    ,nvl(n.ctf_authtype, o.ctf_authtype) as ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
    ,nvl(n.ctf_applogintype, o.ctf_applogintype) as ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
    ,nvl(n.ctf_biz_flow_no, o.ctf_biz_flow_no) as ctf_biz_flow_no -- 业务流水号
    ,nvl(n.ctf_chain_track_no, o.ctf_chain_track_no) as ctf_chain_track_no -- 链路跟踪号
    ,nvl(n.ctf_send_flow_no, o.ctf_send_flow_no) as ctf_send_flow_no -- 上游交易流水号
    ,nvl(n.ctf_faceno, o.ctf_faceno) as ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
    ,nvl(n.ctf_imei, o.ctf_imei) as ctf_imei -- 手机串号
    ,nvl(n.ctf_udid, o.ctf_udid) as ctf_udid -- 手机SIM
    ,nvl(n.ctf_sim, o.ctf_sim) as ctf_sim -- 
    ,case when
            n.ctf_trade_flowno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ctf_trade_flowno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ctf_trade_flowno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_cpr_trade_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_cpr_trade_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ctf_trade_flowno = n.ctf_trade_flowno
where (
        o.ctf_trade_flowno is null
    )
    or (
        n.ctf_trade_flowno is null
    )
    or (
        o.ctf_transtime <> n.ctf_transtime
        or o.ctf_transdate <> n.ctf_transdate
        or o.ctf_transcode <> n.ctf_transcode
        or o.ctf_action <> n.ctf_action
        or o.ctf_ecifno <> n.ctf_ecifno
        or o.ctf_userno <> n.ctf_userno
        or o.ctf_channel <> n.ctf_channel
        or o.ctf_ecifname <> n.ctf_ecifname
        or o.ctf_menuid <> n.ctf_menuid
        or o.ctf_state <> n.ctf_state
        or o.ctf_returncode <> n.ctf_returncode
        or o.ctf_returnmsg <> n.ctf_returnmsg
        or o.ctf_accno <> n.ctf_accno
        or o.ctf_amonut <> n.ctf_amonut
        or o.ctf_currency <> n.ctf_currency
        or o.ctf_sendflowno <> n.ctf_sendflowno
        or o.ctf_src_sendflowno <> n.ctf_src_sendflowno
        or o.ctf_hostflowno <> n.ctf_hostflowno
        or o.ctf_fee <> n.ctf_fee
        or o.ctf_parentlogno <> n.ctf_parentlogno
        or o.ctf_rootlogno <> n.ctf_rootlogno
        or o.ctf_authrefusecause <> n.ctf_authrefusecause
        or o.ctf_accessflowno <> n.ctf_accessflowno
        or o.ctf_host_returntime <> n.ctf_host_returntime
        or o.ctf_svrtranscode <> n.ctf_svrtranscode
        or o.ctf_customerip <> n.ctf_customerip
        or o.ctf_hostname <> n.ctf_hostname
        or o.ctf_src_serverip <> n.ctf_src_serverip
        or o.ctf_clientmac <> n.ctf_clientmac
        or o.ctf_clientos <> n.ctf_clientos
        or o.ctf_clientbrowser <> n.ctf_clientbrowser
        or o.ctf_clientnunittype <> n.ctf_clientnunittype
        or o.ctf_clientterminateno <> n.ctf_clientterminateno
        or o.ctf_sessionid <> n.ctf_sessionid
        or o.ctf_relflowno <> n.ctf_relflowno
        or o.ctf_securitytype <> n.ctf_securitytype
        or o.ctf_authstate <> n.ctf_authstate
        or o.ctf_delegateflag <> n.ctf_delegateflag
        or o.ctf_authstep <> n.ctf_authstep
        or o.ctf_senddate <> n.ctf_senddate
        or o.ctf_sendtime <> n.ctf_sendtime
        or o.ctf_totalcount <> n.ctf_totalcount
        or o.ctf_remark <> n.ctf_remark
        or o.ctf_authflag <> n.ctf_authflag
        or o.ctf_authtype <> n.ctf_authtype
        or o.ctf_applogintype <> n.ctf_applogintype
        or o.ctf_biz_flow_no <> n.ctf_biz_flow_no
        or o.ctf_chain_track_no <> n.ctf_chain_track_no
        or o.ctf_send_flow_no <> n.ctf_send_flow_no
        or o.ctf_faceno <> n.ctf_faceno
        or o.ctf_imei <> n.ctf_imei
        or o.ctf_udid <> n.ctf_udid
        or o.ctf_sim <> n.ctf_sim
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_cpr_trade_flow_cl(
            ctf_trade_flowno -- 流水号
            ,ctf_transtime -- 交易时间
            ,ctf_transdate -- 交易日期
            ,ctf_transcode -- 交易码
            ,ctf_action -- 请求do
            ,ctf_ecifno -- 全行统一客户号
            ,ctf_userno -- 用户顺序号
            ,ctf_channel -- 交易渠道
            ,ctf_ecifname -- 客户姓名
            ,ctf_menuid -- 
            ,ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
            ,ctf_returncode -- 交易返回码
            ,ctf_returnmsg -- 失败原因
            ,ctf_accno -- 交易账号
            ,ctf_amonut -- 交易金额
            ,ctf_currency -- 币种
            ,ctf_sendflowno -- 渠道发送流水号
            ,ctf_src_sendflowno -- 源系统流水号
            ,ctf_hostflowno -- 核心交易流水号
            ,ctf_fee -- 手续费
            ,ctf_parentlogno -- 父流水号
            ,ctf_rootlogno -- 来源流水顺序号
            ,ctf_authrefusecause -- 授权拒绝原因
            ,ctf_accessflowno -- 访问流水号
            ,ctf_host_returntime -- 核心交易日期
            ,ctf_svrtranscode -- 被调方交易编码
            ,ctf_customerip -- 客户IP
            ,ctf_hostname -- 当前服务器主机名
            ,ctf_src_serverip -- 请求来源服务器IP
            ,ctf_clientmac -- 客户终端MAC地址
            ,ctf_clientos -- 客户终端操作系统
            ,ctf_clientbrowser -- 客户终端浏览器
            ,ctf_clientnunittype -- 客户终端设备型号
            ,ctf_clientterminateno -- 客户终端设备ID
            ,ctf_sessionid -- 登陆sessionID
            ,ctf_relflowno -- 关联流水号
            ,ctf_securitytype -- 安全认证方式
            ,ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
            ,ctf_delegateflag -- 是否银行代办(N:非;Y:是)
            ,ctf_authstep -- 授权角色编号
            ,ctf_senddate -- 交易真正提交核心的日期
            ,ctf_sendtime -- 交易真正提交核心的时间
            ,ctf_totalcount -- 交易总笔数
            ,ctf_remark -- 摘要
            ,ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
            ,ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
            ,ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
            ,ctf_biz_flow_no -- 业务流水号
            ,ctf_chain_track_no -- 链路跟踪号
            ,ctf_send_flow_no -- 上游交易流水号
            ,ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
            ,ctf_imei -- 手机串号
            ,ctf_udid -- 手机SIM
            ,ctf_sim -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_cpr_trade_flow_op(
            ctf_trade_flowno -- 流水号
            ,ctf_transtime -- 交易时间
            ,ctf_transdate -- 交易日期
            ,ctf_transcode -- 交易码
            ,ctf_action -- 请求do
            ,ctf_ecifno -- 全行统一客户号
            ,ctf_userno -- 用户顺序号
            ,ctf_channel -- 交易渠道
            ,ctf_ecifname -- 客户姓名
            ,ctf_menuid -- 
            ,ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
            ,ctf_returncode -- 交易返回码
            ,ctf_returnmsg -- 失败原因
            ,ctf_accno -- 交易账号
            ,ctf_amonut -- 交易金额
            ,ctf_currency -- 币种
            ,ctf_sendflowno -- 渠道发送流水号
            ,ctf_src_sendflowno -- 源系统流水号
            ,ctf_hostflowno -- 核心交易流水号
            ,ctf_fee -- 手续费
            ,ctf_parentlogno -- 父流水号
            ,ctf_rootlogno -- 来源流水顺序号
            ,ctf_authrefusecause -- 授权拒绝原因
            ,ctf_accessflowno -- 访问流水号
            ,ctf_host_returntime -- 核心交易日期
            ,ctf_svrtranscode -- 被调方交易编码
            ,ctf_customerip -- 客户IP
            ,ctf_hostname -- 当前服务器主机名
            ,ctf_src_serverip -- 请求来源服务器IP
            ,ctf_clientmac -- 客户终端MAC地址
            ,ctf_clientos -- 客户终端操作系统
            ,ctf_clientbrowser -- 客户终端浏览器
            ,ctf_clientnunittype -- 客户终端设备型号
            ,ctf_clientterminateno -- 客户终端设备ID
            ,ctf_sessionid -- 登陆sessionID
            ,ctf_relflowno -- 关联流水号
            ,ctf_securitytype -- 安全认证方式
            ,ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
            ,ctf_delegateflag -- 是否银行代办(N:非;Y:是)
            ,ctf_authstep -- 授权角色编号
            ,ctf_senddate -- 交易真正提交核心的日期
            ,ctf_sendtime -- 交易真正提交核心的时间
            ,ctf_totalcount -- 交易总笔数
            ,ctf_remark -- 摘要
            ,ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
            ,ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
            ,ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
            ,ctf_biz_flow_no -- 业务流水号
            ,ctf_chain_track_no -- 链路跟踪号
            ,ctf_send_flow_no -- 上游交易流水号
            ,ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
            ,ctf_imei -- 手机串号
            ,ctf_udid -- 手机SIM
            ,ctf_sim -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ctf_trade_flowno -- 流水号
    ,o.ctf_transtime -- 交易时间
    ,o.ctf_transdate -- 交易日期
    ,o.ctf_transcode -- 交易码
    ,o.ctf_action -- 请求do
    ,o.ctf_ecifno -- 全行统一客户号
    ,o.ctf_userno -- 用户顺序号
    ,o.ctf_channel -- 交易渠道
    ,o.ctf_ecifname -- 客户姓名
    ,o.ctf_menuid -- 
    ,o.ctf_state -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
    ,o.ctf_returncode -- 交易返回码
    ,o.ctf_returnmsg -- 失败原因
    ,o.ctf_accno -- 交易账号
    ,o.ctf_amonut -- 交易金额
    ,o.ctf_currency -- 币种
    ,o.ctf_sendflowno -- 渠道发送流水号
    ,o.ctf_src_sendflowno -- 源系统流水号
    ,o.ctf_hostflowno -- 核心交易流水号
    ,o.ctf_fee -- 手续费
    ,o.ctf_parentlogno -- 父流水号
    ,o.ctf_rootlogno -- 来源流水顺序号
    ,o.ctf_authrefusecause -- 授权拒绝原因
    ,o.ctf_accessflowno -- 访问流水号
    ,o.ctf_host_returntime -- 核心交易日期
    ,o.ctf_svrtranscode -- 被调方交易编码
    ,o.ctf_customerip -- 客户IP
    ,o.ctf_hostname -- 当前服务器主机名
    ,o.ctf_src_serverip -- 请求来源服务器IP
    ,o.ctf_clientmac -- 客户终端MAC地址
    ,o.ctf_clientos -- 客户终端操作系统
    ,o.ctf_clientbrowser -- 客户终端浏览器
    ,o.ctf_clientnunittype -- 客户终端设备型号
    ,o.ctf_clientterminateno -- 客户终端设备ID
    ,o.ctf_sessionid -- 登陆sessionID
    ,o.ctf_relflowno -- 关联流水号
    ,o.ctf_securitytype -- 安全认证方式
    ,o.ctf_authstate -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
    ,o.ctf_delegateflag -- 是否银行代办(N:非;Y:是)
    ,o.ctf_authstep -- 授权角色编号
    ,o.ctf_senddate -- 交易真正提交核心的日期
    ,o.ctf_sendtime -- 交易真正提交核心的时间
    ,o.ctf_totalcount -- 交易总笔数
    ,o.ctf_remark -- 摘要
    ,o.ctf_authflag -- 1:手机OA录入授权模式,0:网银PC录入授权模式
    ,o.ctf_authtype -- 授权类型 1:交易授权; 2:管理授权
    ,o.ctf_applogintype -- 1.0：手机版；2.0：旧网银；3.0：新网银
    ,o.ctf_biz_flow_no -- 业务流水号
    ,o.ctf_chain_track_no -- 链路跟踪号
    ,o.ctf_send_flow_no -- 上游交易流水号
    ,o.ctf_faceno -- 人脸识别流水(有值则需要人脸识别)
    ,o.ctf_imei -- 手机串号
    ,o.ctf_udid -- 手机SIM
    ,o.ctf_sim -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_cpr_trade_flow_bk o
    left join ${iol_schema}.osbs_cpr_trade_flow_op n
        on
            o.ctf_trade_flowno = n.ctf_trade_flowno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_cpr_trade_flow_cl d
        on
            o.ctf_trade_flowno = d.ctf_trade_flowno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_cpr_trade_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_cpr_trade_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_cpr_trade_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_cpr_trade_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_cpr_trade_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_cpr_trade_flow_cl;
alter table ${iol_schema}.osbs_cpr_trade_flow exchange partition p_20991231 with table ${iol_schema}.osbs_cpr_trade_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_cpr_trade_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_cpr_trade_flow_op purge;
drop table ${iol_schema}.osbs_cpr_trade_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_cpr_trade_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_cpr_trade_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
