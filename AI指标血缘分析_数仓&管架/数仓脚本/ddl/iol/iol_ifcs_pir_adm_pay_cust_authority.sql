/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_pir_adm_pay_cust_authority
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_pir_adm_pay_cust_authority
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_pir_adm_pay_cust_authority(
    data_dt varchar2(15) -- 数据日期
    ,org_num varchar2(18) -- 机构号
    ,cust_typ varchar2(2) -- 客户类型
    ,authority_typ varchar2(2) -- 支付权限类型
    ,cust_num number(18,0) -- 客户数
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
grant select on ${iol_schema}.ifcs_pir_adm_pay_cust_authority to ${iml_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_cust_authority to ${icl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_cust_authority to ${idl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_cust_authority to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_pir_adm_pay_cust_authority is '客户支付权限汇总';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.data_dt is '数据日期';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.org_num is '机构号';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.cust_typ is '客户类型';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.authority_typ is '支付权限类型';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.cust_num is '客户数';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_pir_adm_pay_cust_authority.etl_timestamp is 'ETL处理时间戳';
