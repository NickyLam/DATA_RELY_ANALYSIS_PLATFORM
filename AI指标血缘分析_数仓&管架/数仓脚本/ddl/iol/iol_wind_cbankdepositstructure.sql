/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbankdepositstructure
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbankdepositstructure
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbankdepositstructure purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbankdepositstructure(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,crncy_type_code number(9,0) -- 币种类型代码
    ,loan_type_code number(9,0) -- 项目类别代码
    ,deposit_item_code number(9,0) -- 存款项目代码
    ,ann_item varchar2(150) -- 存款项目公布名称
    ,total_deposit number(20,4) -- 存款余额
    ,ave_deposit number(20,4) -- 存款平均余额
    ,interest_cost number(20,4) -- 存款利息支出
    ,average_yield number(20,4) -- 存款平均成本率
    ,memo varchar2(300) -- 备注
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
grant select on ${iol_schema}.wind_cbankdepositstructure to ${iml_schema};
grant select on ${iol_schema}.wind_cbankdepositstructure to ${icl_schema};
grant select on ${iol_schema}.wind_cbankdepositstructure to ${idl_schema};
grant select on ${iol_schema}.wind_cbankdepositstructure to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbankdepositstructure is '银行业存款结构';
comment on column ${iol_schema}.wind_cbankdepositstructure.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbankdepositstructure.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_cbankdepositstructure.report_period is '报告期';
comment on column ${iol_schema}.wind_cbankdepositstructure.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_cbankdepositstructure.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_cbankdepositstructure.crncy_type_code is '币种类型代码';
comment on column ${iol_schema}.wind_cbankdepositstructure.loan_type_code is '项目类别代码';
comment on column ${iol_schema}.wind_cbankdepositstructure.deposit_item_code is '存款项目代码';
comment on column ${iol_schema}.wind_cbankdepositstructure.ann_item is '存款项目公布名称';
comment on column ${iol_schema}.wind_cbankdepositstructure.total_deposit is '存款余额';
comment on column ${iol_schema}.wind_cbankdepositstructure.ave_deposit is '存款平均余额';
comment on column ${iol_schema}.wind_cbankdepositstructure.interest_cost is '存款利息支出';
comment on column ${iol_schema}.wind_cbankdepositstructure.average_yield is '存款平均成本率';
comment on column ${iol_schema}.wind_cbankdepositstructure.memo is '备注';
comment on column ${iol_schema}.wind_cbankdepositstructure.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbankdepositstructure.etl_timestamp is 'ETL处理时间戳';
