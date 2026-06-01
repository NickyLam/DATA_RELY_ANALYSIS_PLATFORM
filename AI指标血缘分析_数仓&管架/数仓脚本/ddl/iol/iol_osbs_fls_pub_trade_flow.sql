/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_fls_pub_trade_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_fls_pub_trade_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_fls_pub_trade_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_fls_pub_trade_flow(
    ptf_trade_flowno varchar2(64) -- 流水号
    ,ptf_transtime varchar2(34) -- 交易时间
    ,ptf_transcode varchar2(128) -- 交易码
    ,ptf_state varchar2(4) -- 交易状态(90:交易成功;99:交易失败;33:通讯异常;50:交易初始状态;10:待授权;11:授权中;12:授权完成)
    ,ptf_returncode varchar2(128) -- 交易返回码
    ,ptf_returnmsg varchar2(2048) -- 失败原因
    ,ptf_accno varchar2(64) -- 交易账号
    ,ptf_amonut number(15,2) -- 交易金额
    ,ptf_currency varchar2(6) -- 币种
    ,ptf_ecifno varchar2(64) -- 全行统一客户号
    ,ptf_userno varchar2(64) -- 用户顺序号
    ,ptf_channel varchar2(32) -- 交易渠道
    ,ptf_sendflowno varchar2(128) -- 渠道发送流水号
    ,ptf_src_sendflowno varchar2(66) -- 源系统流水号
    ,ptf_hostflowno varchar2(64) -- 核心交易流水号
    ,ptf_fee number(15,2) -- 手续费
    ,ptf_accessflowno varchar2(128) -- 访问流水号
    ,ptf_host_returntime varchar2(28) -- 核心交易日期
    ,ptf_svrtranscode varchar2(20) -- 被调方交易编码
    ,ptf_customerip varchar2(392) -- 客户IP
    ,ptf_hostname varchar2(100) -- 当前服务器主机名
    ,ptf_src_serverip varchar2(64) -- 请求来源服务器IP
    ,ptf_clientmac varchar2(48) -- 客户终端MAC地址
    ,ptf_clientos varchar2(60) -- 客户终端操作系统
    ,ptf_clientbrowser varchar2(120) -- 客户终端浏览器
    ,ptf_clientnunittype varchar2(100) -- 客户终端设备型号
    ,ptf_clientterminateno varchar2(200) -- 客户终端设备ID
    ,ptf_sessionid varchar2(240) -- 登陆sessionID
    ,ptf_relflowno varchar2(64) -- 关联流水号
    ,ptf_trade_inf varchar2(2048) -- 交易日志信息
    ,ptf_transtype varchar2(128) -- 交易类型
    ,ptf_ecifname varchar2(320) -- 客户姓名
    ,ptf_securitytype varchar2(2) -- 安全认证方式
    ,ptf_menuid varchar2(20) -- 功能菜单ID
    ,ptf_marketing_number varchar2(40) -- 营销工号
    ,ptf_businessno varchar2(64) -- 人行流水号
    ,tx_seq_num varchar2(66) -- 交易订单号
    ,chain_way_track_no varchar2(256) -- 链路跟踪号
    ,biz_seq_num varchar2(128) -- 系统内流水号
    ,ptf_channelcode varchar2(12) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_fls_pub_trade_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_fls_pub_trade_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_fls_pub_trade_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_fls_pub_trade_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_fls_pub_trade_flow is '交易流水表';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_trade_flowno is '流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_transtime is '交易时间';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_transcode is '交易码';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_state is '交易状态(90:交易成功;99:交易失败;33:通讯异常;50:交易初始状态;10:待授权;11:授权中;12:授权完成)';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_returncode is '交易返回码';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_returnmsg is '失败原因';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_accno is '交易账号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_amonut is '交易金额';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_currency is '币种';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_channel is '交易渠道';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_sendflowno is '渠道发送流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_src_sendflowno is '源系统流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_hostflowno is '核心交易流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_fee is '手续费';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_accessflowno is '访问流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_host_returntime is '核心交易日期';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_svrtranscode is '被调方交易编码';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_customerip is '客户IP';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_hostname is '当前服务器主机名';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_src_serverip is '请求来源服务器IP';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_clientmac is '客户终端MAC地址';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_clientos is '客户终端操作系统';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_clientbrowser is '客户终端浏览器';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_clientnunittype is '客户终端设备型号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_clientterminateno is '客户终端设备ID';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_sessionid is '登陆sessionID';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_relflowno is '关联流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_trade_inf is '交易日志信息';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_transtype is '交易类型';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_ecifname is '客户姓名';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_securitytype is '安全认证方式';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_menuid is '功能菜单ID';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_marketing_number is '营销工号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_businessno is '人行流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.tx_seq_num is '交易订单号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.chain_way_track_no is '链路跟踪号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.biz_seq_num is '系统内流水号';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.ptf_channelcode is '';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_fls_pub_trade_flow.etl_timestamp is 'ETL处理时间戳';
