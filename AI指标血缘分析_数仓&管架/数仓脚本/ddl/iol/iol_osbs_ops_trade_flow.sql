/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ops_trade_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ops_trade_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ops_trade_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ops_trade_flow(
    otf_trade_flowno varchar2(128) -- 主流水号
    ,otf_tran_seqno varchar2(64) -- 交易流水号
    ,otf_global_seqno varchar2(33) -- 全局流水号
    ,otf_ecifno varchar2(32) -- 全行统一客户号
    ,otf_ecifname varchar2(160) -- 客户姓名
    ,otf_userno varchar2(32) -- 用户顺序号
    ,otf_transcode varchar2(64) -- 交易代码
    ,otf_transcategory varchar2(64) -- 业务大类
    ,otf_transtype varchar2(64) -- 业务类型
    ,otf_transdate varchar2(8) -- 交易日期
    ,otf_transtime varchar2(17) -- 交易时间
    ,otf_accno varchar2(128) -- 交易账号
    ,otf_currency varchar2(3) -- 交易币种
    ,otf_amonut number(15,2) -- 交易金额
    ,otf_fee number(15,2) -- 手续费
    ,otf_sysid varchar2(16) -- 系统编号，如NMB,NPB,OGW
    ,otf_sourcesysid varchar2(16) -- 源系统编号，如NMB,NPB,OGW
    ,otf_channelcode varchar2(6) -- 4位渠道码
    ,otf_state varchar2(2) -- 交易状态(90:操作成功;99:操作失败;33:结果未明;)
    ,otf_returncode varchar2(128) -- 交易错误代码
    ,otf_returnmsg varchar2(1024) -- 交易错误原因
    ,otf_hostflowno varchar2(32) -- 核心交易流水号
    ,otf_host_returntime varchar2(14) -- 核心交易日期
    ,otf_accessflowno varchar2(64) -- 访问流水号
    ,otf_relflowno varchar2(64) -- 关联流水号
    ,otf_serverip varchar2(32) -- 处理服务器IP
    ,otf_sessionid varchar2(120) -- 登陆SESSIONID
    ,otf_accesstoken varchar2(120) -- 分步交易TOKEN，例如网银预订单的TOKEN；二类户开户分步交易中使用的TOKEN
    ,otf_trade_abstract varchar2(1024) -- 例如：“您发起了一笔转账，付款账号尾数为XXX，金额为YYY，收款账号为ZZZ”。
    ,otf_trstype varchar2(64) -- 交易类型：网银操作日志查询场景使用
    ,otf_menuid varchar2(10) -- 功能菜单ID：网银操作日志查询场景使用
    ,otf_clientip varchar2(200) -- 客户端IP
    ,otf_clientmac varchar2(32) -- 客户端MAC
    ,otf_deviceno varchar2(128) -- 设备号
    ,otf_brand varchar2(96) -- 设备品牌
    ,otf_model varchar2(96) -- 设备型号
    ,otf_browsertype varchar2(64) -- 浏览器类型
    ,otf_browserversion varchar2(64) -- 浏览器版本号
    ,otf_longitude varchar2(24) -- 经度
    ,otf_latitude varchar2(24) -- 维度
    ,otf_tellerid varchar2(24) -- 柜员号
    ,otf_tellerdeptid varchar2(16) -- 柜员所属机构
    ,otf_reqtime varchar2(17) -- 交易请求时间(yyyyMMddhhmmss)
    ,otf_resptime varchar2(17) -- 交易响应时间(yyyyMMddhhmmss)
    ,otf_logthreadno varchar2(128) -- 日志线程号
    ,otf_moveflag varchar2(2) -- 迁移标识
    ,otf_fingerprint_id varchar2(256) -- 设备指纹
    ,tx_seq_num varchar2(33) -- 交易订单号
    ,chain_way_track_no varchar2(128) -- 链路跟踪号
    ,biz_seq_num varchar2(64) -- 系统内流水号
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
grant select on ${iol_schema}.osbs_ops_trade_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_ops_trade_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_ops_trade_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_ops_trade_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ops_trade_flow is '操作日志流水表';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_trade_flowno is '主流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_tran_seqno is '交易流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_global_seqno is '全局流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_ecifname is '客户姓名';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_transcode is '交易代码';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_transcategory is '业务大类';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_transtype is '业务类型';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_transdate is '交易日期';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_transtime is '交易时间';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_accno is '交易账号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_currency is '交易币种';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_amonut is '交易金额';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_fee is '手续费';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_sysid is '系统编号，如NMB,NPB,OGW';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_sourcesysid is '源系统编号，如NMB,NPB,OGW';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_channelcode is '4位渠道码';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_state is '交易状态(90:操作成功;99:操作失败;33:结果未明;)';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_returncode is '交易错误代码';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_returnmsg is '交易错误原因';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_hostflowno is '核心交易流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_host_returntime is '核心交易日期';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_accessflowno is '访问流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_relflowno is '关联流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_serverip is '处理服务器IP';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_sessionid is '登陆SESSIONID';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_accesstoken is '分步交易TOKEN，例如网银预订单的TOKEN；二类户开户分步交易中使用的TOKEN';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_trade_abstract is '例如：“您发起了一笔转账，付款账号尾数为XXX，金额为YYY，收款账号为ZZZ”。';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_trstype is '交易类型：网银操作日志查询场景使用';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_menuid is '功能菜单ID：网银操作日志查询场景使用';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_clientip is '客户端IP';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_clientmac is '客户端MAC';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_deviceno is '设备号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_brand is '设备品牌';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_model is '设备型号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_browsertype is '浏览器类型';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_browserversion is '浏览器版本号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_longitude is '经度';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_latitude is '维度';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_tellerid is '柜员号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_tellerdeptid is '柜员所属机构';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_reqtime is '交易请求时间(yyyyMMddhhmmss)';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_resptime is '交易响应时间(yyyyMMddhhmmss)';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_logthreadno is '日志线程号';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_moveflag is '迁移标识';
comment on column ${iol_schema}.osbs_ops_trade_flow.otf_fingerprint_id is '设备指纹';
comment on column ${iol_schema}.osbs_ops_trade_flow.tx_seq_num is '交易订单号';
comment on column ${iol_schema}.osbs_ops_trade_flow.chain_way_track_no is '链路跟踪号';
comment on column ${iol_schema}.osbs_ops_trade_flow.biz_seq_num is '系统内流水号';
comment on column ${iol_schema}.osbs_ops_trade_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_ops_trade_flow.etl_timestamp is 'ETL处理时间戳';
