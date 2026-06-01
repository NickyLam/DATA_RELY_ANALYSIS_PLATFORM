/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_custser_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_custser_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_custser_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_custser_log(
    endtime timestamp -- 结束时间戳
    ,note1 varchar2(512) -- 备用1
    ,note2 varchar2(512) -- 备用2
    ,sys_num varchar2(6) -- 系统编号
    ,app_num varchar2(6) -- 应用编号
    ,chan_num varchar2(6) -- 渠道编号
    ,custserialnum varchar2(32) -- 客户服务流水号
    ,tx_seq_num varchar2(33) -- 业务流水号(交易订单号)
    ,channeltrancode varchar2(32) -- 渠道交易码
    ,channeltranname varchar2(128) -- 渠道交易名称
    ,nodecode varchar2(32) -- 节点编码
    ,nodename varchar2(128) -- 节点名称
    ,seqnum varchar2(100) -- 操作序号
    ,tx_org_num varchar2(12) -- 交易机构号
    ,tx_teller_num varchar2(30) -- 交易柜员编号
    ,devicenum varchar2(32) -- 设备编号
    ,tx_cust_num varchar2(16) -- 交易客户编号
    ,tx_cust_name varchar2(100) -- 交易客户名称
    ,cert_type_cd varchar2(4) -- 证件类型
    ,cert_num varchar2(60) -- 证件号码
    ,tel_num varchar2(30) -- 电话号码
    ,isagent varchar2(2) -- 是否代理
    ,agent_person_cert_type_cd varchar2(4) -- 代办人证件类型
    ,agent_person_cert_num varchar2(60) -- 代办人证件号码
    ,agent_person_name varchar2(200) -- 代办人名称
    ,agent_person_tel_num varchar2(30) -- 代办人手机号
    ,tradeserno varchar2(16) -- 预受理编号
    ,queuenum varchar2(6) -- 排队号
    ,tx_dt date -- 交易日期
    ,starttime timestamp -- 开始时间戳
    ,handeltime varchar2(10) -- 处理时间（秒）
    ,tierflag varchar2(10) -- 交易层级|0-交易级 1-节点级（长交易用）
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
grant select on ${iol_schema}.nibs_ib_log_custser_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_custser_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_custser_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_custser_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_custser_log is '客户服务流水表';
comment on column ${iol_schema}.nibs_ib_log_custser_log.endtime is '结束时间戳';
comment on column ${iol_schema}.nibs_ib_log_custser_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_custser_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_custser_log.sys_num is '系统编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.app_num is '应用编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.chan_num is '渠道编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.custserialnum is '客户服务流水号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.nibs_ib_log_custser_log.channeltrancode is '渠道交易码';
comment on column ${iol_schema}.nibs_ib_log_custser_log.channeltranname is '渠道交易名称';
comment on column ${iol_schema}.nibs_ib_log_custser_log.nodecode is '节点编码';
comment on column ${iol_schema}.nibs_ib_log_custser_log.nodename is '节点名称';
comment on column ${iol_schema}.nibs_ib_log_custser_log.seqnum is '操作序号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_org_num is '交易机构号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_teller_num is '交易柜员编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.devicenum is '设备编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_cust_num is '交易客户编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_cust_name is '交易客户名称';
comment on column ${iol_schema}.nibs_ib_log_custser_log.cert_type_cd is '证件类型';
comment on column ${iol_schema}.nibs_ib_log_custser_log.cert_num is '证件号码';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tel_num is '电话号码';
comment on column ${iol_schema}.nibs_ib_log_custser_log.isagent is '是否代理';
comment on column ${iol_schema}.nibs_ib_log_custser_log.agent_person_cert_type_cd is '代办人证件类型';
comment on column ${iol_schema}.nibs_ib_log_custser_log.agent_person_cert_num is '代办人证件号码';
comment on column ${iol_schema}.nibs_ib_log_custser_log.agent_person_name is '代办人名称';
comment on column ${iol_schema}.nibs_ib_log_custser_log.agent_person_tel_num is '代办人手机号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tradeserno is '预受理编号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.queuenum is '排队号';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tx_dt is '交易日期';
comment on column ${iol_schema}.nibs_ib_log_custser_log.starttime is '开始时间戳';
comment on column ${iol_schema}.nibs_ib_log_custser_log.handeltime is '处理时间（秒）';
comment on column ${iol_schema}.nibs_ib_log_custser_log.tierflag is '交易层级|0-交易级 1-节点级（长交易用）';
comment on column ${iol_schema}.nibs_ib_log_custser_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_custser_log.etl_timestamp is 'ETL处理时间戳';
