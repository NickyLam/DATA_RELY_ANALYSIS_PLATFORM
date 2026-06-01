/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_core_sub_acct_temp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_core_sub_acct_temp
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_core_sub_acct_temp(
    id varchar2(57) -- 主键id
    ,order_id varchar2(75) -- 审批单号
    ,acct varchar2(75) -- 账户
    ,sub_acct varchar2(75) -- 子户号
    ,customer_no varchar2(75) -- 客户号
    ,business_type varchar2(15) -- 业务类型，定期：a09，活期：a11
    ,imp_date varchar2(15) -- 导入日期
    ,product varchar2(150) -- 产品
    ,currency varchar2(15) -- 币种
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
grant select on ${iol_schema}.ibms_ttrd_core_sub_acct_temp to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_core_sub_acct_temp to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_core_sub_acct_temp to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_core_sub_acct_temp to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_core_sub_acct_temp is '';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.id is '主键id';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.order_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.acct is '账户';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.sub_acct is '子户号';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.customer_no is '客户号';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.business_type is '业务类型，定期：a09，活期：a11';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.product is '产品';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_core_sub_acct_temp.etl_timestamp is 'ETL处理时间戳';
