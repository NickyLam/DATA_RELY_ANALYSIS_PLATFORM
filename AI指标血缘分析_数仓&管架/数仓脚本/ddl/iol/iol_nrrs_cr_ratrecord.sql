/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_cr_ratrecord
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_cr_ratrecord
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_cr_ratrecord purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_cr_ratrecord(
    lsh varchar2(30) -- 评级流水号
    ,custid varchar2(30) -- 客户号
    ,ratdate varchar2(10) -- 评级日期
    ,operatorid varchar2(20) -- 评级人
    ,reportno varchar2(16) -- 基准报表期次
    ,modelcode number(22) -- 选用的财务模型
    ,conmodelcode number(22) -- 确认级别
    ,modelselcond1 varchar2(30) -- 模型选择条件1
    ,modelselcond2 varchar2(30) -- 模型选择条件2
    ,modelselcond3 varchar2(30) -- 模型选择条件3
    ,modelselcond4 number(16,2) -- 模型选择条件4
    ,modelselcond5 number(16,2) -- 模型选择条件5
    ,modelselcond6 number(16,2) -- 模型选择条件6
    ,financelevel varchar2(4) -- 评级财务级别
    ,nonfinancelevel varchar2(4) -- 非财务控制级别
    ,confirmlevel varchar2(4) -- 确认级别
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
grant select on ${iol_schema}.nrrs_cr_ratrecord to ${iml_schema};
grant select on ${iol_schema}.nrrs_cr_ratrecord to ${icl_schema};
grant select on ${iol_schema}.nrrs_cr_ratrecord to ${idl_schema};
grant select on ${iol_schema}.nrrs_cr_ratrecord to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_cr_ratrecord is '评级记录表';
comment on column ${iol_schema}.nrrs_cr_ratrecord.lsh is '评级流水号';
comment on column ${iol_schema}.nrrs_cr_ratrecord.custid is '客户号';
comment on column ${iol_schema}.nrrs_cr_ratrecord.ratdate is '评级日期';
comment on column ${iol_schema}.nrrs_cr_ratrecord.operatorid is '评级人';
comment on column ${iol_schema}.nrrs_cr_ratrecord.reportno is '基准报表期次';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelcode is '选用的财务模型';
comment on column ${iol_schema}.nrrs_cr_ratrecord.conmodelcode is '确认级别';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond1 is '模型选择条件1';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond2 is '模型选择条件2';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond3 is '模型选择条件3';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond4 is '模型选择条件4';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond5 is '模型选择条件5';
comment on column ${iol_schema}.nrrs_cr_ratrecord.modelselcond6 is '模型选择条件6';
comment on column ${iol_schema}.nrrs_cr_ratrecord.financelevel is '评级财务级别';
comment on column ${iol_schema}.nrrs_cr_ratrecord.nonfinancelevel is '非财务控制级别';
comment on column ${iol_schema}.nrrs_cr_ratrecord.confirmlevel is '确认级别';
comment on column ${iol_schema}.nrrs_cr_ratrecord.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_cr_ratrecord.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_cr_ratrecord.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_cr_ratrecord.etl_timestamp is 'ETL处理时间戳';
