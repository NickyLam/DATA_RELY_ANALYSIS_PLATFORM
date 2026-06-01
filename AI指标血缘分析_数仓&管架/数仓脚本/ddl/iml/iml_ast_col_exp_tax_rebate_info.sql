/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_exp_tax_rebate_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_exp_tax_rebate_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_exp_tax_rebate_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_exp_tax_rebate_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,exp_tax_rebate_amt number(30,8) -- 出口退税金额
    ,debt_fulfil_begin_dt date -- 债务履行起始日期
    ,debt_fulfil_exp_dt date -- 债务履行到期日期
    ,spec_acct_id varchar2(60) -- 专用账户编号
    ,spec_acct_name varchar2(150) -- 专用账户名称
    ,acct_owner_name varchar2(150) -- 账户所有人名称
    ,cus_decl_id varchar2(100) -- 报关单编号
    ,aging number(38) -- 账龄
    ,cred_rht_prod_flg varchar2(10) -- 债权产生标志
    ,other_comnt varchar2(4000) -- 其他说明
    ,rela_flg varchar2(10) -- 关系标志
    ,curr_cd varchar2(30) -- 币种代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_exp_tax_rebate_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_exp_tax_rebate_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_exp_tax_rebate_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_exp_tax_rebate_info is '押品出口退税信息';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.exp_tax_rebate_amt is '出口退税金额';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.debt_fulfil_begin_dt is '债务履行起始日期';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.debt_fulfil_exp_dt is '债务履行到期日期';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.spec_acct_id is '专用账户编号';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.spec_acct_name is '专用账户名称';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.acct_owner_name is '账户所有人名称';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.cus_decl_id is '报关单编号';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.aging is '账龄';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.cred_rht_prod_flg is '债权产生标志';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.rela_flg is '关系标志';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_exp_tax_rebate_info.etl_timestamp is 'ETL处理时间戳';
