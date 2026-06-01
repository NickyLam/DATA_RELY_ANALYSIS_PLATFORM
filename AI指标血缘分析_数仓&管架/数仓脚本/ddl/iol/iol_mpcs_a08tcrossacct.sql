/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tcrossacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tcrossacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tcrossacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tcrossacct(
    contractnumber varchar2(45) -- 协议编号
    ,accountnumber varchar2(48) -- 主办企业专用账户
    ,accountname varchar2(180) -- 主办企业账户名称
    ,amountlimit varchar2(27) -- 净流入额度
    ,amount varchar2(27) -- 已使用额度
    ,signdate varchar2(30) -- 入库日期
    ,signflag varchar2(3) -- 协议状态 0-签约状态；3-取消状态
    ,updt varchar2(30) -- 最后修改时间
    ,custno varchar2(30) -- 客户号
    ,srcseqno varchar2(75) -- 交易流水号
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
grant select on ${iol_schema}.mpcs_a08tcrossacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tcrossacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tcrossacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tcrossacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tcrossacct is '跨境资金池主办企业账户表';
comment on column ${iol_schema}.mpcs_a08tcrossacct.contractnumber is '协议编号';
comment on column ${iol_schema}.mpcs_a08tcrossacct.accountnumber is '主办企业专用账户';
comment on column ${iol_schema}.mpcs_a08tcrossacct.accountname is '主办企业账户名称';
comment on column ${iol_schema}.mpcs_a08tcrossacct.amountlimit is '净流入额度';
comment on column ${iol_schema}.mpcs_a08tcrossacct.amount is '已使用额度';
comment on column ${iol_schema}.mpcs_a08tcrossacct.signdate is '入库日期';
comment on column ${iol_schema}.mpcs_a08tcrossacct.signflag is '协议状态 0-签约状态；3-取消状态';
comment on column ${iol_schema}.mpcs_a08tcrossacct.updt is '最后修改时间';
comment on column ${iol_schema}.mpcs_a08tcrossacct.custno is '客户号';
comment on column ${iol_schema}.mpcs_a08tcrossacct.srcseqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a08tcrossacct.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tcrossacct.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tcrossacct.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tcrossacct.etl_timestamp is 'ETL处理时间戳';
