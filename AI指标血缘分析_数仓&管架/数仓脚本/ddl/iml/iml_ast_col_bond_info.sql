/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_bond_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_bond_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_bond_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_bond_info(
    col_id varchar2(100) -- 押品编号
    ,lp_id varchar2(100) -- 法人编号
    ,bond_id varchar2(100) -- 债券编号
    ,bond_name varchar2(500) -- 债券名称
    ,bond_qtty number(22) -- 债券数量
    ,bond_have_ext_bond_item_rating_flg varchar2(10) -- 债券有外部债项评级标志
    ,bond_ext_rating_cd varchar2(30) -- 债券外部评级代码
    ,fac_val_amt number(30,8) -- 票面金额
    ,fac_val_nv number(30,8) -- 票面净值
    ,curr_cd varchar2(30) -- 币种代码
    ,int_rat number(30,8) -- 利率
    ,issue_dt date -- 发行日期
    ,exp_dt date -- 到期日期
    ,other_comnt varchar2(4000) -- 其他说明
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
grant select on ${iml_schema}.ast_col_bond_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_bond_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_bond_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_bond_info is '押品债券信息';
comment on column ${iml_schema}.ast_col_bond_info.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_bond_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_bond_info.bond_id is '债券编号';
comment on column ${iml_schema}.ast_col_bond_info.bond_name is '债券名称';
comment on column ${iml_schema}.ast_col_bond_info.bond_qtty is '债券数量';
comment on column ${iml_schema}.ast_col_bond_info.bond_have_ext_bond_item_rating_flg is '债券有外部债项评级标志';
comment on column ${iml_schema}.ast_col_bond_info.bond_ext_rating_cd is '债券外部评级代码';
comment on column ${iml_schema}.ast_col_bond_info.fac_val_amt is '票面金额';
comment on column ${iml_schema}.ast_col_bond_info.fac_val_nv is '票面净值';
comment on column ${iml_schema}.ast_col_bond_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_bond_info.int_rat is '利率';
comment on column ${iml_schema}.ast_col_bond_info.issue_dt is '发行日期';
comment on column ${iml_schema}.ast_col_bond_info.exp_dt is '到期日期';
comment on column ${iml_schema}.ast_col_bond_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_bond_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_bond_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_bond_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_bond_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_bond_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_bond_info.etl_timestamp is 'ETL处理时间戳';
