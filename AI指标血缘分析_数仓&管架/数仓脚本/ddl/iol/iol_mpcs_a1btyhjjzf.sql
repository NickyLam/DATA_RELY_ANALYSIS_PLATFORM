/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1btyhjjzf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1btyhjjzf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1btyhjjzf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhjjzf(
    transdt varchar2(12) -- 登记日期
    ,transtm varchar2(9) -- 登记时间
    ,qqdbs varchar2(45) -- 请求单标识
    ,rwlsh varchar2(53) -- 任务流水号
    ,zh varchar2(75) -- 账卡号
    ,yrwlsh varchar2(45) -- 原任务流水号
    ,updttm varchar2(21) -- 更新时间
    ,result varchar2(2) -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,tradetype varchar2(2) -- 交易类型 1-紧急止付 2-解除止付
    ,openbr varchar2(15) -- 
    ,pckno varchar2(15) -- 
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
grant select on ${iol_schema}.mpcs_a1btyhjjzf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1btyhjjzf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1btyhjjzf is '紧急止付表';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.transtm is '登记时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.qqdbs is '请求单标识';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.rwlsh is '任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.zh is '账卡号';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.yrwlsh is '原任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.updttm is '更新时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.result is '处理结果 0-录入 1-已处理 2-处理失败 3-已登记';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.tradetype is '交易类型 1-紧急止付 2-解除止付';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.openbr is '';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.pckno is '';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1btyhjjzf.etl_timestamp is 'ETL处理时间戳';
