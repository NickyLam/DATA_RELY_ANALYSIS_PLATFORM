/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_investment_client_mark
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_investment_client_mark
whenever sqlerror continue none;
drop table ${iol_schema}.icms_investment_client_mark purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_investment_client_mark(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- 关联编号
    ,objecttype varchar2(32) -- 指标类型
    ,markoriginalvalue varchar2(10) -- 指标原值
    ,markmodifyvalue varchar2(10) -- 指标修改值
    ,markmodifyreason varchar2(1000) -- 指标修改原因
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
grant select on ${iol_schema}.icms_investment_client_mark to ${iml_schema};
grant select on ${iol_schema}.icms_investment_client_mark to ${icl_schema};
grant select on ${iol_schema}.icms_investment_client_mark to ${idl_schema};
grant select on ${iol_schema}.icms_investment_client_mark to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_investment_client_mark is '投资级客户判断标识';
comment on column ${iol_schema}.icms_investment_client_mark.serialno is '流水号';
comment on column ${iol_schema}.icms_investment_client_mark.objectno is '关联编号';
comment on column ${iol_schema}.icms_investment_client_mark.objecttype is '指标类型';
comment on column ${iol_schema}.icms_investment_client_mark.markoriginalvalue is '指标原值';
comment on column ${iol_schema}.icms_investment_client_mark.markmodifyvalue is '指标修改值';
comment on column ${iol_schema}.icms_investment_client_mark.markmodifyreason is '指标修改原因';
comment on column ${iol_schema}.icms_investment_client_mark.start_dt is '开始时间';
comment on column ${iol_schema}.icms_investment_client_mark.end_dt is '结束时间';
comment on column ${iol_schema}.icms_investment_client_mark.id_mark is '增删标志';
comment on column ${iol_schema}.icms_investment_client_mark.etl_timestamp is 'ETL处理时间戳';
