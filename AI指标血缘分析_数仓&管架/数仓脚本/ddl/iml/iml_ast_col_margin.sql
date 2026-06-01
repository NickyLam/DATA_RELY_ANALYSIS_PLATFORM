/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_margin
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_margin
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_margin purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_margin(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,col_acct_num varchar2(100) -- 押品账号
    ,begin_dt date -- 起始日期
    ,closing_dt date -- 截止日期
    ,acct_bal number(30,2) -- 账户余额
    ,margin_flow_id varchar2(60) -- 保证金流水编号
    ,is_cmplt_froz_flg varchar2(10) -- 是否完成冻结标志
    ,margin_froz_amt number(30,2) -- 保证金冻结金额
    ,remark varchar2(4000) -- 备注
    ,sub_acct_id varchar2(100) -- 子账户编号
    ,open_acct_org varchar2(150) -- 开户机构
    ,aval_bal number(30,2) -- 可用余额
    ,curr_cd varchar2(10) -- 币种代码
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
grant select on ${iml_schema}.ast_col_margin to ${icl_schema};
grant select on ${iml_schema}.ast_col_margin to ${idl_schema};
grant select on ${iml_schema}.ast_col_margin to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_margin is '押品保证金';
comment on column ${iml_schema}.ast_col_margin.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_margin.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_margin.col_acct_num is '押品账号';
comment on column ${iml_schema}.ast_col_margin.begin_dt is '起始日期';
comment on column ${iml_schema}.ast_col_margin.closing_dt is '截止日期';
comment on column ${iml_schema}.ast_col_margin.acct_bal is '账户余额';
comment on column ${iml_schema}.ast_col_margin.margin_flow_id is '保证金流水编号';
comment on column ${iml_schema}.ast_col_margin.is_cmplt_froz_flg is '是否完成冻结标志';
comment on column ${iml_schema}.ast_col_margin.margin_froz_amt is '保证金冻结金额';
comment on column ${iml_schema}.ast_col_margin.remark is '备注';
comment on column ${iml_schema}.ast_col_margin.sub_acct_id is '子账户编号';
comment on column ${iml_schema}.ast_col_margin.open_acct_org is '开户机构';
comment on column ${iml_schema}.ast_col_margin.aval_bal is '可用余额';
comment on column ${iml_schema}.ast_col_margin.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_margin.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_margin.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_margin.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_margin.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_margin.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_margin.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_margin.etl_timestamp is 'ETL处理时间戳';
