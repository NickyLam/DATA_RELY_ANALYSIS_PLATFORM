/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ref_bill_bus_code_subj_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ref_bill_bus_code_subj_rela
whenever sqlerror continue none;
drop table ${idl_schema}.ref_bill_bus_code_subj_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ref_bill_bus_code_subj_rela(
    etl_dt date -- 数据日期   
    ,subj_id varchar2(60) -- 科目编号   
    ,subj_name varchar2(250) -- 科目名称   
    ,bus_code varchar2(60) -- 业务编码   
    ,amt_type_cd varchar2(10) -- 金额类型代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ref_bill_bus_code_subj_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.ref_bill_bus_code_subj_rela is '票据业务编码和科目关系';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.etl_dt is '数据日期';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.subj_id is '科目编号';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.subj_name is '科目名称';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.bus_code is '业务编码';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.amt_type_cd is '金额类型代码';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.create_dt is '创建日期';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.update_dt is '更新日期';
comment on column ${idl_schema}.ref_bill_bus_code_subj_rela.id_mark is '删除标识';