/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_comm_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_comm_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_comm_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_comm_log(
    p_workdate date -- 协同平台工作日期
    ,note2 varchar2(512) -- 备用2
    ,core_tran_flow_num varchar2(33) -- 全局流水号
    ,p_biz_seq_num varchar2(64) -- 协同平台流水号
    ,sys_num varchar2(6) -- 系统编号
    ,app_num varchar2(6) -- 应用编号
    ,chan_num varchar2(6) -- 渠道编号
    ,channeldate date -- 渠道日期
    ,chan_biz_seq_num varchar2(64) -- 渠道方系统流水号
    ,backsysnum varchar2(6) -- 后台服务系统
    ,backintercode varchar2(128) -- 后台服务系统接口码
    ,backintercodenm varchar2(512) -- 后台服务系统接口名称
    ,backrspdate date -- 后台响应日期
    ,backserialnum varchar2(64) -- 后台流水号
    ,back_ret_status varchar2(2) -- 后台处理状态
    ,back_ret_code varchar2(50) -- 后台处理码
    ,back_ret_desc varchar2(512) -- 后台返回信息
    ,reqdatetime timestamp -- 请求时间戳
    ,rspdatetime timestamp -- 响应时间戳
    ,channeltrancode varchar2(32) -- 渠道交易码
    ,channeltranname varchar2(128) -- 渠道交易名称
    ,biztype varchar2(4) -- 业务类型
    ,nodecode varchar2(32) -- 节点编码
    ,nodename varchar2(128) -- 节点名称
    ,ismaincomm varchar2(1) -- 主通讯标志
    ,cust_type_cd varchar2(1) -- 客户类型
    ,cust_num varchar2(16) -- 客户编号
    ,cn_name varchar2(200) -- 客户名称
    ,cert_type_cd varchar2(4) -- 证件类型
    ,cert_num varchar2(60) -- 证件号码
    ,acct_num varchar2(50) -- 账户编号
    ,acct_name varchar2(512) -- 账号名称
    ,tx_amt number(20,2) -- 交易金额
    ,tx_cntpty_acct_num varchar2(50) -- 交易对手账号
    ,tx_cntpty_name varchar2(200) -- 交易对手名称
    ,note1 varchar2(512) -- 备用1
    ,tx_seq_num varchar2(33) -- 业务流水号(交易订单号)
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
grant select on ${iol_schema}.nibs_ib_log_comm_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_comm_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_comm_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_comm_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_comm_log is '通讯流水表';
comment on column ${iol_schema}.nibs_ib_log_comm_log.p_workdate is '协同平台工作日期';
comment on column ${iol_schema}.nibs_ib_log_comm_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_comm_log.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.p_biz_seq_num is '协同平台流水号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.sys_num is '系统编号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.app_num is '应用编号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.chan_num is '渠道编号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.channeldate is '渠道日期';
comment on column ${iol_schema}.nibs_ib_log_comm_log.chan_biz_seq_num is '渠道方系统流水号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.backsysnum is '后台服务系统';
comment on column ${iol_schema}.nibs_ib_log_comm_log.backintercode is '后台服务系统接口码';
comment on column ${iol_schema}.nibs_ib_log_comm_log.backintercodenm is '后台服务系统接口名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.backrspdate is '后台响应日期';
comment on column ${iol_schema}.nibs_ib_log_comm_log.backserialnum is '后台流水号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.back_ret_status is '后台处理状态';
comment on column ${iol_schema}.nibs_ib_log_comm_log.back_ret_code is '后台处理码';
comment on column ${iol_schema}.nibs_ib_log_comm_log.back_ret_desc is '后台返回信息';
comment on column ${iol_schema}.nibs_ib_log_comm_log.reqdatetime is '请求时间戳';
comment on column ${iol_schema}.nibs_ib_log_comm_log.rspdatetime is '响应时间戳';
comment on column ${iol_schema}.nibs_ib_log_comm_log.channeltrancode is '渠道交易码';
comment on column ${iol_schema}.nibs_ib_log_comm_log.channeltranname is '渠道交易名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.biztype is '业务类型';
comment on column ${iol_schema}.nibs_ib_log_comm_log.nodecode is '节点编码';
comment on column ${iol_schema}.nibs_ib_log_comm_log.nodename is '节点名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.ismaincomm is '主通讯标志';
comment on column ${iol_schema}.nibs_ib_log_comm_log.cust_type_cd is '客户类型';
comment on column ${iol_schema}.nibs_ib_log_comm_log.cust_num is '客户编号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.cn_name is '客户名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.cert_type_cd is '证件类型';
comment on column ${iol_schema}.nibs_ib_log_comm_log.cert_num is '证件号码';
comment on column ${iol_schema}.nibs_ib_log_comm_log.acct_num is '账户编号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.acct_name is '账号名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.tx_amt is '交易金额';
comment on column ${iol_schema}.nibs_ib_log_comm_log.tx_cntpty_acct_num is '交易对手账号';
comment on column ${iol_schema}.nibs_ib_log_comm_log.tx_cntpty_name is '交易对手名称';
comment on column ${iol_schema}.nibs_ib_log_comm_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_comm_log.tx_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.nibs_ib_log_comm_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_comm_log.etl_timestamp is 'ETL处理时间戳';
