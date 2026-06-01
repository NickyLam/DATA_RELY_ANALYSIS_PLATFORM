/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_log_tran_com_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_log_tran_com_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_log_tran_com_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com_detail(
    code varchar2(50) -- 流水号
    ,tran_type varchar2(4) -- 报文类型（i内部请求 o对外报文）
    ,tran_code varchar2(50) -- 交易码
    ,trans_date date -- 交易时间
    ,chanel varchar2(50) -- 渠道
    ,return_code varchar2(200) -- 返回码
    ,return_message varchar2(3000) -- 返回值
    ,request varchar2(4000) -- 请求报文
    ,response varchar2(4000) -- 返回报文
    ,glob_seq_num varchar2(100) -- esb流水号
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
grant select on ${iol_schema}.ccdb_log_tran_com_detail to ${iml_schema};
grant select on ${iol_schema}.ccdb_log_tran_com_detail to ${icl_schema};
grant select on ${iol_schema}.ccdb_log_tran_com_detail to ${idl_schema};

-- comment
comment on table ${iol_schema}.ccdb_log_tran_com_detail is '原子交易详细表';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.code is '流水号';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.tran_type is '报文类型（i内部请求 o对外报文）';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.tran_code is '交易码';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.trans_date is '交易时间';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.chanel is '渠道';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.return_code is '返回码';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.return_message is '返回值';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.request is '请求报文';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.response is '返回报文';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.glob_seq_num is 'esb流水号';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_log_tran_com_detail.etl_timestamp is 'ETL处理时间戳';
