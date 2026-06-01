/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_para_lnmerchant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_para_lnmerchant
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_para_lnmerchant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_para_lnmerchant(
    id number(30,0) -- 
    ,branch_no varchar2(18) -- 
    ,ln_no varchar2(30) -- 
    ,merchant_no varchar2(23) -- 
    ,merchant_name varchar2(150) -- 
    ,account varchar2(30) -- 
    ,merchant_type varchar2(15) -- 
    ,merchant_gene_type varchar2(15) -- 
    ,region varchar2(15) -- 
    ,address varchar2(300) -- 
    ,postcode varchar2(30) -- 
    ,merchant_status varchar2(15) -- 
    ,merchant_phone varchar2(45) -- 
    ,operator_id varchar2(18) -- 
    ,author_id varchar2(18) -- 
    ,operate_date varchar2(12) -- 
    ,operate_time varchar2(9) -- 
    ,accept_org_no varchar2(30) -- 
    ,expand_1 varchar2(150) -- 
    ,expand_2 varchar2(150) -- 
    ,expand_3 varchar2(150) -- 
    ,expand_4 varchar2(150) -- 
    ,expand_5 varchar2(150) -- 
    ,is_valid varchar2(2) -- y有效；n无效
    ,last_modify_time varchar2(21) -- 
    ,remark varchar2(300) -- 
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
grant select on ${iol_schema}.cpms_t_para_lnmerchant to ${iml_schema};
grant select on ${iol_schema}.cpms_t_para_lnmerchant to ${icl_schema};
grant select on ${iol_schema}.cpms_t_para_lnmerchant to ${idl_schema};
grant select on ${iol_schema}.cpms_t_para_lnmerchant to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_para_lnmerchant is '联名卡商户管理';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.id is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.branch_no is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.ln_no is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_no is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_name is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.account is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_type is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_gene_type is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.region is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.address is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.postcode is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_status is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.merchant_phone is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.operator_id is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.author_id is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.operate_date is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.operate_time is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.accept_org_no is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.expand_1 is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.expand_2 is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.expand_3 is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.expand_4 is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.expand_5 is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.is_valid is 'y有效；n无效';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.last_modify_time is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.remark is '';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.start_dt is '开始时间';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.end_dt is '结束时间';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.id_mark is '增删标志';
comment on column ${iol_schema}.cpms_t_para_lnmerchant.etl_timestamp is 'ETL处理时间戳';
