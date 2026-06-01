/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_loan_prod_policy_compnt_cfg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h(
    edit_id varchar2(100) -- 版本编号
    ,claus_id varchar2(100) -- 条款编号
    ,lp_id varchar2(100) -- 法人编号
    ,compnt_id varchar2(100) -- 组件编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h to ${icl_schema};
grant select on ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h to ${idl_schema};
grant select on ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h is '贷款产品政策组件配置历史';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.edit_id is '版本编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.claus_id is '条款编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.compnt_id is '组件编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.modif_dt is '变更日期';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h.etl_timestamp is 'ETL处理时间戳';
