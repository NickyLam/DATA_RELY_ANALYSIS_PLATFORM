/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_log_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_log_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_log_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_log_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,log_id varchar2(60) -- 保函编号
    ,log_kind_cd varchar2(30) -- 保函种类代码
    ,issue_cty_cd varchar2(30) -- 开证国家代码
    ,open_org_name varchar2(375) -- 开立机构名称
    ,open_org_type_cd varchar2(30) -- 开立机构类型代码
    ,open_org_rgst_cd varchar2(30) -- 开立机构注册地代码
    ,stage_guar_flg varchar2(30) -- 阶段性担保标志
    ,irevbl_flg varchar2(30) -- 不可撤销标志
    ,log_amt number(30,2) -- 保函金额
    ,curr_cd varchar2(30) -- 币种代码
    ,log_open_org_ext_rating_rest_cd varchar2(250) -- 保函开立机构外部评级结果代码
    ,log_open_org_ext_rating_dt date -- 保函开立机构外部评级日期
    ,log_open_org_intnal_rating_rest_cd varchar2(250) -- 保函开立机构内部评级结果代码
    ,log_open_org_intnal_rating_dt date -- 保函开立机构内部评级日期
    ,log_open_org_rgst_ext_rating_rest_cd varchar2(250) -- 保函开立机构注册地外部评级结果代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_log_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_log_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_log_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_log_info is '押品保函信息';
comment on column ${iml_schema}.ast_col_log_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_log_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_log_info.log_id is '保函编号';
comment on column ${iml_schema}.ast_col_log_info.log_kind_cd is '保函种类代码';
comment on column ${iml_schema}.ast_col_log_info.issue_cty_cd is '开证国家代码';
comment on column ${iml_schema}.ast_col_log_info.open_org_name is '开立机构名称';
comment on column ${iml_schema}.ast_col_log_info.open_org_type_cd is '开立机构类型代码';
comment on column ${iml_schema}.ast_col_log_info.open_org_rgst_cd is '开立机构注册地代码';
comment on column ${iml_schema}.ast_col_log_info.stage_guar_flg is '阶段性担保标志';
comment on column ${iml_schema}.ast_col_log_info.irevbl_flg is '不可撤销标志';
comment on column ${iml_schema}.ast_col_log_info.log_amt is '保函金额';
comment on column ${iml_schema}.ast_col_log_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_log_info.log_open_org_ext_rating_rest_cd is '保函开立机构外部评级结果代码';
comment on column ${iml_schema}.ast_col_log_info.log_open_org_ext_rating_dt is '保函开立机构外部评级日期';
comment on column ${iml_schema}.ast_col_log_info.log_open_org_intnal_rating_rest_cd is '保函开立机构内部评级结果代码';
comment on column ${iml_schema}.ast_col_log_info.log_open_org_intnal_rating_dt is '保函开立机构内部评级日期';
comment on column ${iml_schema}.ast_col_log_info.log_open_org_rgst_ext_rating_rest_cd is '保函开立机构注册地外部评级结果代码';
comment on column ${iml_schema}.ast_col_log_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_log_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_log_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_log_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_log_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_log_info.etl_timestamp is 'ETL处理时间戳';
