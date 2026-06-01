/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acctg_account_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acctg_account_type
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acctg_account_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acctg_account_type(
    typeid varchar2(45) -- 分类id
    ,typename varchar2(90) -- 分类名称
    ,tradecostmethod varchar2(45) -- 交易成本核算方法,可选值：ma\fifo\lifo
    ,holdcostmethod varchar2(45) -- 持有成本方法,可选值：amrt_cost\trd_price
    ,fvmethod varchar2(45) -- 估值方法,可选值：use_cost\use_fv
    ,aimethod varchar2(45) -- 
    ,i9_class number(2,0) -- i9分类
    ,i9_class_m varchar2(15) -- i9分类,数据标准落标,触发器添加
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
grant select on ${iol_schema}.ibms_ttrd_acctg_account_type to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acctg_account_type to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acctg_account_type to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acctg_account_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acctg_account_type is '账户会计类型';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.typeid is '分类id';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.typename is '分类名称';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.tradecostmethod is '交易成本核算方法,可选值：ma\fifo\lifo';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.holdcostmethod is '持有成本方法,可选值：amrt_cost\trd_price';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.fvmethod is '估值方法,可选值：use_cost\use_fv';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.aimethod is '';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.i9_class is 'i9分类';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.i9_class_m is 'i9分类,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acctg_account_type.etl_timestamp is 'ETL处理时间戳';
