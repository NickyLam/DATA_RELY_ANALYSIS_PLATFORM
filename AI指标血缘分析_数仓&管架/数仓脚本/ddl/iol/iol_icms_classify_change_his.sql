/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_change_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_change_his
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_change_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_change_his(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,bdserialno varchar2(32) -- 借据编号
    ,currency varchar2(3) -- 业务币种
    ,balance number(24,6) -- 余额
    ,classifyresultold varchar2(2) -- 调整前五级分类
    ,classifyresultnew varchar2(2) -- 调整后五级分类
    ,inputdate date -- 调整日期
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
grant select on ${iol_schema}.icms_classify_change_his to ${iml_schema};
grant select on ${iol_schema}.icms_classify_change_his to ${icl_schema};
grant select on ${iol_schema}.icms_classify_change_his to ${idl_schema};
grant select on ${iol_schema}.icms_classify_change_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_change_his is '五级分类变动明细表';
comment on column ${iol_schema}.icms_classify_change_his.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_change_his.customerid is '客户号';
comment on column ${iol_schema}.icms_classify_change_his.customername is '客户名称';
comment on column ${iol_schema}.icms_classify_change_his.bdserialno is '借据编号';
comment on column ${iol_schema}.icms_classify_change_his.currency is '业务币种';
comment on column ${iol_schema}.icms_classify_change_his.balance is '余额';
comment on column ${iol_schema}.icms_classify_change_his.classifyresultold is '调整前五级分类';
comment on column ${iol_schema}.icms_classify_change_his.classifyresultnew is '调整后五级分类';
comment on column ${iol_schema}.icms_classify_change_his.inputdate is '调整日期';
comment on column ${iol_schema}.icms_classify_change_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_classify_change_his.etl_timestamp is 'ETL处理时间戳';
