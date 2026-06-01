/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_utdy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_utdy
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_utdy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_utdy(
    stacid number(19) -- 账套标记
    ,acctdt varchar2(8) -- 账务会计日期（科目日结单日期）
    ,usercd varchar2(20) -- 用户代码
    ,brchcd varchar2(12) -- 机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,trdram number(20,2) -- 转账借方本期发生额
    ,trdrnm number -- 转账借方笔数
    ,trcram number(20,2) -- 转账贷方本期发生额
    ,trcrnm number -- 转账贷方笔数
    ,csdram number(20,2) -- 现金借方本期发生额
    ,csdrnm number -- 现金借方笔数
    ,cscram number(20,2) -- 现金贷方本期发生额
    ,cscrnm number -- 现金贷方笔数
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
grant select on ${iol_schema}.tgls_gab_utdy to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_utdy to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_utdy to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_utdy to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_utdy is '调账日结单';
comment on column ${iol_schema}.tgls_gab_utdy.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gab_utdy.acctdt is '账务会计日期（科目日结单日期）';
comment on column ${iol_schema}.tgls_gab_utdy.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gab_utdy.brchcd is '机构编号';
comment on column ${iol_schema}.tgls_gab_utdy.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gab_utdy.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gab_utdy.trdram is '转账借方本期发生额';
comment on column ${iol_schema}.tgls_gab_utdy.trdrnm is '转账借方笔数';
comment on column ${iol_schema}.tgls_gab_utdy.trcram is '转账贷方本期发生额';
comment on column ${iol_schema}.tgls_gab_utdy.trcrnm is '转账贷方笔数';
comment on column ${iol_schema}.tgls_gab_utdy.csdram is '现金借方本期发生额';
comment on column ${iol_schema}.tgls_gab_utdy.csdrnm is '现金借方笔数';
comment on column ${iol_schema}.tgls_gab_utdy.cscram is '现金贷方本期发生额';
comment on column ${iol_schema}.tgls_gab_utdy.cscrnm is '现金贷方笔数';
comment on column ${iol_schema}.tgls_gab_utdy.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_utdy.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_utdy.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_utdy.etl_timestamp is 'ETL处理时间戳';
