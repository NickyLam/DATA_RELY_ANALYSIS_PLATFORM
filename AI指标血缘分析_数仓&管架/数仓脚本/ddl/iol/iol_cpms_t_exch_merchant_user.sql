/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_exch_merchant_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_exch_merchant_user
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_exch_merchant_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_exch_merchant_user(
    id number(22) -- 
    ,merchant_no varchar2(45) -- 
    ,merchant_name varchar2(150) -- 
    ,information_id number(22) -- 
    ,merchant_path varchar2(300) -- 
    ,is_valid varchar2(3) -- 
    ,branch_no varchar2(15) -- 
    ,operator_id varchar2(30) -- 
    ,operator_date varchar2(24) -- 
    ,accept_org_no varchar2(30) -- 
    ,account_no varchar2(75) -- 
    ,region varchar2(15) -- 
    ,expand_1 varchar2(150) -- 
    ,expand_2 varchar2(150) -- 
    ,expand_3 varchar2(150) -- 
    ,expand_4 varchar2(150) -- 
    ,expand_5 varchar2(150) -- 
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
grant select on ${iol_schema}.cpms_t_exch_merchant_user to ${iml_schema};
grant select on ${iol_schema}.cpms_t_exch_merchant_user to ${icl_schema};
grant select on ${iol_schema}.cpms_t_exch_merchant_user to ${idl_schema};
grant select on ${iol_schema}.cpms_t_exch_merchant_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_exch_merchant_user is 'pos商户信息表';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.id is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.merchant_no is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.merchant_name is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.information_id is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.merchant_path is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.is_valid is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.branch_no is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.operator_id is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.operator_date is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.accept_org_no is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.account_no is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.region is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.expand_1 is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.expand_2 is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.expand_3 is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.expand_4 is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.expand_5 is '';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.start_dt is '开始时间';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.end_dt is '结束时间';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.id_mark is '增删标志';
comment on column ${iol_schema}.cpms_t_exch_merchant_user.etl_timestamp is 'ETL处理时间戳';
