/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gl059660
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gl059660
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gl059660 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gl059660(
    inr varchar2(12) -- 主键
    ,trninr varchar2(12) -- trn表inr
    ,credattim timestamp -- 创建日期
    ,seq varchar2(5) -- 序号
    ,base_acct_no varchar2(75) -- 账号
    ,acct_seq_no varchar2(5) -- 序列号
    ,branch varchar2(30) -- 所属机构
    ,tran_type varchar2(30) -- 实体关键字
    ,ccy varchar2(5) -- 币种
    ,tran_amt number(17,2) -- 金额
    ,tran_branch varchar2(30) -- 交易机构
    ,company varchar2(30) -- 内部唯一id
    ,system_id varchar2(15) -- 系统id
    ,event_type varchar2(60) -- 事件类型
    ,amt_type varchar2(15) -- 金额类型
    ,tran_date varchar2(12) -- 业务交易日期
    ,write_off_seq_no varchar2(75) -- 销账序号
    ,narrative varchar2(600) -- 摘要
    ,is_northbound_sign varchar2(3) -- 是否北向通账号
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
grant select on ${iol_schema}.isbs_gl059660 to ${iml_schema};
grant select on ${iol_schema}.isbs_gl059660 to ${icl_schema};
grant select on ${iol_schema}.isbs_gl059660 to ${idl_schema};
grant select on ${iol_schema}.isbs_gl059660 to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gl059660 is '通用记账接口信息表';
comment on column ${iol_schema}.isbs_gl059660.inr is '主键';
comment on column ${iol_schema}.isbs_gl059660.trninr is 'trn表inr';
comment on column ${iol_schema}.isbs_gl059660.credattim is '创建日期';
comment on column ${iol_schema}.isbs_gl059660.seq is '序号';
comment on column ${iol_schema}.isbs_gl059660.base_acct_no is '账号';
comment on column ${iol_schema}.isbs_gl059660.acct_seq_no is '序列号';
comment on column ${iol_schema}.isbs_gl059660.branch is '所属机构';
comment on column ${iol_schema}.isbs_gl059660.tran_type is '实体关键字';
comment on column ${iol_schema}.isbs_gl059660.ccy is '币种';
comment on column ${iol_schema}.isbs_gl059660.tran_amt is '金额';
comment on column ${iol_schema}.isbs_gl059660.tran_branch is '交易机构';
comment on column ${iol_schema}.isbs_gl059660.company is '内部唯一id';
comment on column ${iol_schema}.isbs_gl059660.system_id is '系统id';
comment on column ${iol_schema}.isbs_gl059660.event_type is '事件类型';
comment on column ${iol_schema}.isbs_gl059660.amt_type is '金额类型';
comment on column ${iol_schema}.isbs_gl059660.tran_date is '业务交易日期';
comment on column ${iol_schema}.isbs_gl059660.write_off_seq_no is '销账序号';
comment on column ${iol_schema}.isbs_gl059660.narrative is '摘要';
comment on column ${iol_schema}.isbs_gl059660.is_northbound_sign is '是否北向通账号';
comment on column ${iol_schema}.isbs_gl059660.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_gl059660.etl_timestamp is 'ETL处理时间戳';
