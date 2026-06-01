/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_chlexch_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_chlexch_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_chlexch_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_chlexch_log(
    sys_num varchar2(6) -- 系统编号
    ,app_num varchar2(6) -- 应用编号
    ,chan_num varchar2(6) -- 渠道编号
    ,org_num varchar2(12) -- 机构编号
    ,teller_num varchar2(30) -- 柜员编号
    ,devicenum varchar2(50) -- 设备编号
    ,channeldate date -- 渠道日期
    ,channeltime date -- 渠道时间
    ,chan_biz_seq_num varchar2(64) -- 渠道方系统流水号
    ,channelip varchar2(400) -- 渠道ip
    ,channelmac varchar2(64) -- 渠道mac
    ,channeltrancode varchar2(32) -- 渠道交易码
    ,req_code varchar2(64) -- 发起方标识
    ,p_servicecode varchar2(32) -- 协同平台服务码
    ,p_workdate date -- 协同平台工作日期
    ,core_tran_flow_num varchar2(33) -- 全局流水号
    ,p_biz_seq_num varchar2(64) -- 协同平台流水号
    ,tx_seq_num varchar2(35) -- 业务流水号(交易订单号)
    ,p_ret_status varchar2(2) -- 协同平台响应状态
    ,p_ret_code varchar2(20) -- 协同平台响应码
    ,p_ret_desc varchar2(512) -- 协同平台响应信息
    ,reqdatetime timestamp -- 请求时间戳
    ,rspdatetime timestamp -- 响应时间戳
    ,p_ip varchar2(64) -- 协同平台ip
    ,logfilename varchar2(128) -- 日志文件名
    ,note1 varchar2(512) -- 备用1
    ,note2 varchar2(512) -- 备用2
    ,recinfo varchar2(4000) -- 渠道的请求报文
    ,handletime varchar2(255) -- 交易耗时-毫秒
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
grant select on ${iol_schema}.nibs_ib_log_chlexch_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_chlexch_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_chlexch_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_chlexch_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_chlexch_log is '渠道接入流水表';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.sys_num is '系统编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.app_num is '应用编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.chan_num is '渠道编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.org_num is '机构编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.teller_num is '柜员编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.devicenum is '设备编号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.channeldate is '渠道日期';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.channeltime is '渠道时间';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.chan_biz_seq_num is '渠道方系统流水号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.channelip is '渠道ip';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.channelmac is '渠道mac';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.channeltrancode is '渠道交易码';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.req_code is '发起方标识';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_servicecode is '协同平台服务码';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_workdate is '协同平台工作日期';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_biz_seq_num is '协同平台流水号';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.tx_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_ret_status is '协同平台响应状态';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_ret_code is '协同平台响应码';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_ret_desc is '协同平台响应信息';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.reqdatetime is '请求时间戳';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.rspdatetime is '响应时间戳';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.p_ip is '协同平台ip';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.logfilename is '日志文件名';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.recinfo is '渠道的请求报文';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.handletime is '交易耗时-毫秒';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_chlexch_log.etl_timestamp is 'ETL处理时间戳';
