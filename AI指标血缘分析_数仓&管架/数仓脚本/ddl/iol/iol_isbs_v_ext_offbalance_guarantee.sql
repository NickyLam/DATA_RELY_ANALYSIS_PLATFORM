/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_ext_offbalance_guarantee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_ext_offbalance_guarantee
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_ext_offbalance_guarantee(
    as_of_date date -- 
    ,finish_type varchar2(2) -- 
    ,gl_account_id varchar2(18) -- 
    ,data_source varchar2(6) -- 
    ,cif_key varchar2(24) -- 
    ,iso_currency_cd varchar2(5) -- 
    ,org_book_bal_latest number(22) -- 
    ,flag varchar2(2) -- 
    ,cur_book_bal number(18,3) -- 
    ,org_book_bal number(22) -- 
    ,maturity_date date -- 
    ,account_open_date date -- 
    ,org_unit_id varchar2(12) -- 
    ,account_number varchar2(48) -- 
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
grant select on ${iol_schema}.isbs_v_ext_offbalance_guarantee to ${iml_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_guarantee to ${icl_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_guarantee to ${idl_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_guarantee to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_ext_offbalance_guarantee is '保函总帐余额';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.as_of_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.finish_type is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.gl_account_id is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.data_source is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.cif_key is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.iso_currency_cd is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.org_book_bal_latest is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.flag is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.cur_book_bal is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.org_book_bal is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.maturity_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.account_open_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.org_unit_id is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.account_number is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_v_ext_offbalance_guarantee.etl_timestamp is 'ETL处理时间戳';
