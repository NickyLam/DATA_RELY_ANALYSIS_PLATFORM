/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl prd_corp_crdt_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.prd_corp_crdt_prod
whenever sqlerror continue none;
drop table ${idl_schema}.prd_corp_crdt_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.prd_corp_crdt_prod(
    etl_dt date -- 数据日期   
    ,prod_id varchar2(60) -- 产品编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,src_prod_id varchar2(60) -- 源产品编号   
    ,prod_name varchar2(100) -- 产品名称   
    ,input_org_id varchar2(60) -- 录入机构编号   
    ,input_tm timestamp -- 录入时间   
    ,prod_update_tm timestamp -- 产品更新时间   
    ,sellbl_prod_flg varchar2(20) -- 可售产品标志   
    ,loan_size_ctrl_flg varchar2(20) -- 贷款规模控制标志   
    ,prod_catlg_id varchar2(60) -- 产品目录编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.prd_corp_crdt_prod to ${iel_schema};

-- comment
comment on table ${idl_schema}.prd_corp_crdt_prod is '对公信贷产品';
comment on column ${idl_schema}.prd_corp_crdt_prod.etl_dt is '数据日期';
comment on column ${idl_schema}.prd_corp_crdt_prod.prod_id is '产品编号';
comment on column ${idl_schema}.prd_corp_crdt_prod.lp_id is '法人编号';
comment on column ${idl_schema}.prd_corp_crdt_prod.src_prod_id is '源产品编号';
comment on column ${idl_schema}.prd_corp_crdt_prod.prod_name is '产品名称';
comment on column ${idl_schema}.prd_corp_crdt_prod.input_org_id is '录入机构编号';
comment on column ${idl_schema}.prd_corp_crdt_prod.input_tm is '录入时间';
comment on column ${idl_schema}.prd_corp_crdt_prod.prod_update_tm is '产品更新时间';
comment on column ${idl_schema}.prd_corp_crdt_prod.sellbl_prod_flg is '可售产品标志';
comment on column ${idl_schema}.prd_corp_crdt_prod.loan_size_ctrl_flg is '贷款规模控制标志';
comment on column ${idl_schema}.prd_corp_crdt_prod.prod_catlg_id is '产品目录编号';
comment on column ${idl_schema}.prd_corp_crdt_prod.create_dt is '创建日期';
comment on column ${idl_schema}.prd_corp_crdt_prod.update_dt is '更新日期';
comment on column ${idl_schema}.prd_corp_crdt_prod.id_mark is '删除标识';