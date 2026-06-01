/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_log_tran_com
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_log_tran_com
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_log_tran_com purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com(
    trans_service_id varchar2(60) -- 服务流水号
    ,cc_jour_seq varchar2(80) -- 渠道请求流水号
    ,connect_id varchar2(80) -- 呼叫流水号
    ,tran_code varchar2(80) -- 交易码
    ,host_tran_code varchar2(80) -- 主机交易码（前置）
    ,return_code varchar2(60) -- 返回码
    ,trunk_id varchar2(10) -- 中继接入号
    ,paper_id varchar2(80) -- 证件号
    ,paper_type varchar2(30) -- 证件类型
    ,card_no varchar2(50) -- 账号
    ,card_type varchar2(60) -- 账号类型
    ,currency varchar2(80) -- 币种
    ,call_no varchar2(40) -- 呼入号码
    ,operator_code varchar2(40) -- 操作员工号
    ,cust_name varchar2(150) -- 客户姓名
    ,channel_code varchar2(20) -- 渠道编码（c/i）
    ,ivr_line_no varchar2(60) -- ivr通道号
    ,channel_send_date date -- 渠道开始代理日期
    ,trans_date date -- 交易时间
    ,permission_code varchar2(30) -- 功能编号
    ,return_message varchar2(2000) -- 返回信息
    ,host_return_code varchar2(60) -- 主机返回码
    ,host_return_message varchar2(2000) -- 主机返回信息
    ,business_type varchar2(30) -- 业务类型（信用卡、个人、对公等）
    ,service_sign varchar2(6) -- 服务标识  1：查询，2：操作，0：自动
    ,sum_no varchar2(50) -- 来电小结编号
    ,aexpinfo varchar2(80) -- 附加信息
    ,cust_type varchar2(30) -- 客户类型
    ,code varchar2(80) -- 主键
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ccdb_log_tran_com to ${iml_schema};
grant select on ${iol_schema}.ccdb_log_tran_com to ${icl_schema};
grant select on ${iol_schema}.ccdb_log_tran_com to ${idl_schema};

-- comment
comment on table ${iol_schema}.ccdb_log_tran_com is '交易明细表';
comment on column ${iol_schema}.ccdb_log_tran_com.trans_service_id is '服务流水号';
comment on column ${iol_schema}.ccdb_log_tran_com.cc_jour_seq is '渠道请求流水号';
comment on column ${iol_schema}.ccdb_log_tran_com.connect_id is '呼叫流水号';
comment on column ${iol_schema}.ccdb_log_tran_com.tran_code is '交易码';
comment on column ${iol_schema}.ccdb_log_tran_com.host_tran_code is '主机交易码（前置）';
comment on column ${iol_schema}.ccdb_log_tran_com.return_code is '返回码';
comment on column ${iol_schema}.ccdb_log_tran_com.trunk_id is '中继接入号';
comment on column ${iol_schema}.ccdb_log_tran_com.paper_id is '证件号';
comment on column ${iol_schema}.ccdb_log_tran_com.paper_type is '证件类型';
comment on column ${iol_schema}.ccdb_log_tran_com.card_no is '账号';
comment on column ${iol_schema}.ccdb_log_tran_com.card_type is '账号类型';
comment on column ${iol_schema}.ccdb_log_tran_com.currency is '币种';
comment on column ${iol_schema}.ccdb_log_tran_com.call_no is '呼入号码';
comment on column ${iol_schema}.ccdb_log_tran_com.operator_code is '操作员工号';
comment on column ${iol_schema}.ccdb_log_tran_com.cust_name is '客户姓名';
comment on column ${iol_schema}.ccdb_log_tran_com.channel_code is '渠道编码（c/i）';
comment on column ${iol_schema}.ccdb_log_tran_com.ivr_line_no is 'ivr通道号';
comment on column ${iol_schema}.ccdb_log_tran_com.channel_send_date is '渠道开始代理日期';
comment on column ${iol_schema}.ccdb_log_tran_com.trans_date is '交易时间';
comment on column ${iol_schema}.ccdb_log_tran_com.permission_code is '功能编号';
comment on column ${iol_schema}.ccdb_log_tran_com.return_message is '返回信息';
comment on column ${iol_schema}.ccdb_log_tran_com.host_return_code is '主机返回码';
comment on column ${iol_schema}.ccdb_log_tran_com.host_return_message is '主机返回信息';
comment on column ${iol_schema}.ccdb_log_tran_com.business_type is '业务类型（信用卡、个人、对公等）';
comment on column ${iol_schema}.ccdb_log_tran_com.service_sign is '服务标识  1：查询，2：操作，0：自动';
comment on column ${iol_schema}.ccdb_log_tran_com.sum_no is '来电小结编号';
comment on column ${iol_schema}.ccdb_log_tran_com.aexpinfo is '附加信息';
comment on column ${iol_schema}.ccdb_log_tran_com.cust_type is '客户类型';
comment on column ${iol_schema}.ccdb_log_tran_com.code is '主键';
comment on column ${iol_schema}.ccdb_log_tran_com.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_log_tran_com.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_log_tran_com.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_log_tran_com.etl_timestamp is 'ETL处理时间戳';
