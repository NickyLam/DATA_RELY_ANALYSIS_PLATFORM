/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_orderform
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_orderform
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_orderform purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_orderform(
    order_id varchar2(75) -- 
    ,order_no varchar2(75) -- 
    ,product_id varchar2(75) -- 
    ,ecif_no varchar2(75) -- 
    ,pay_amount number(20,2) -- 
    ,pay_status varchar2(20) -- 
    ,channel varchar2(12) -- 
    ,pay_accno varchar2(48) -- 
    ,pay_time varchar2(36) -- 
    ,custodian_bank_name varchar2(150) -- 
    ,custodian_bank_accname varchar2(150) -- 
    ,custodian_bank_accno varchar2(48) -- 
    ,customer_manager_no varchar2(75) -- 
    ,bank_ext_num varchar2(48) -- 
    ,sort_field varchar2(48) -- 
    ,is_push varchar2(48) -- 
    ,created_by varchar2(150) -- 
    ,updated_by varchar2(150) -- 
    ,create_time date -- 
    ,update_time date -- 
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
grant select on ${iol_schema}.nfss_ft_orderform to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_orderform to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_orderform to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_orderform to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_orderform is '订单表';
comment on column ${iol_schema}.nfss_ft_orderform.order_id is '';
comment on column ${iol_schema}.nfss_ft_orderform.order_no is '';
comment on column ${iol_schema}.nfss_ft_orderform.product_id is '';
comment on column ${iol_schema}.nfss_ft_orderform.ecif_no is '';
comment on column ${iol_schema}.nfss_ft_orderform.pay_amount is '';
comment on column ${iol_schema}.nfss_ft_orderform.pay_status is '';
comment on column ${iol_schema}.nfss_ft_orderform.channel is '';
comment on column ${iol_schema}.nfss_ft_orderform.pay_accno is '';
comment on column ${iol_schema}.nfss_ft_orderform.pay_time is '';
comment on column ${iol_schema}.nfss_ft_orderform.custodian_bank_name is '';
comment on column ${iol_schema}.nfss_ft_orderform.custodian_bank_accname is '';
comment on column ${iol_schema}.nfss_ft_orderform.custodian_bank_accno is '';
comment on column ${iol_schema}.nfss_ft_orderform.customer_manager_no is '';
comment on column ${iol_schema}.nfss_ft_orderform.bank_ext_num is '';
comment on column ${iol_schema}.nfss_ft_orderform.sort_field is '';
comment on column ${iol_schema}.nfss_ft_orderform.is_push is '';
comment on column ${iol_schema}.nfss_ft_orderform.created_by is '';
comment on column ${iol_schema}.nfss_ft_orderform.updated_by is '';
comment on column ${iol_schema}.nfss_ft_orderform.create_time is '';
comment on column ${iol_schema}.nfss_ft_orderform.update_time is '';
comment on column ${iol_schema}.nfss_ft_orderform.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ft_orderform.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ft_orderform.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ft_orderform.etl_timestamp is 'ETL处理时间戳';
