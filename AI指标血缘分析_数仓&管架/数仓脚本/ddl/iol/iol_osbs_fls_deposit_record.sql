/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_fls_deposit_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_fls_deposit_record
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_fls_deposit_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_fls_deposit_record(
    fdr_flowno varchar2(64) -- 系统流水号
    ,fdr_globalflow varchar2(33) -- 全局流水号
    ,fdr_transcode varchar2(24) -- 接口码
    ,fdr_transdate varchar2(12) -- 交易日期
    ,fdr_transtime varchar2(12) -- 交易时间
    ,fdr_ecifno varchar2(24) -- 客户号
    ,fdr_prodtype varchar2(64) -- 产品类型
    ,fdr_ccy varchar2(3) -- 币种
    ,fdr_amount varchar2(24) -- 金额
    ,fdr_stagecode varchar2(64) -- 大额存单期次
    ,fdr_composeid varchar2(64) -- 存款加ID
    ,fdr_status varchar2(2) -- 交易状态
    ,fdr_errorcode varchar2(13) -- 错误码
    ,fdr_errormsg varchar2(512) -- 错误信息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_fls_deposit_record to ${iml_schema};
grant select on ${iol_schema}.osbs_fls_deposit_record to ${icl_schema};
grant select on ${iol_schema}.osbs_fls_deposit_record to ${idl_schema};
grant select on ${iol_schema}.osbs_fls_deposit_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_fls_deposit_record is '客户存款购买记录表';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_flowno is '系统流水号';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_globalflow is '全局流水号';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_transcode is '接口码';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_transdate is '交易日期';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_transtime is '交易时间';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_ecifno is '客户号';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_prodtype is '产品类型';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_ccy is '币种';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_amount is '金额';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_stagecode is '大额存单期次';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_composeid is '存款加ID';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_status is '交易状态';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_errorcode is '错误码';
comment on column ${iol_schema}.osbs_fls_deposit_record.fdr_errormsg is '错误信息';
comment on column ${iol_schema}.osbs_fls_deposit_record.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_fls_deposit_record.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_fls_deposit_record.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_fls_deposit_record.etl_timestamp is 'ETL处理时间戳';
