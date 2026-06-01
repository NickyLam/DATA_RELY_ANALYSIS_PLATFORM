/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_resv_lc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_resv_lc
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_resv_lc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_resv_lc(
    asset_id varchar2(250) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(100) -- 押品编号
    ,resv_lc_id varchar2(100) -- 备用信用证编号
    ,issue_cty_rg_cd varchar2(100) -- 开证国家和地区代码
    ,issue_org_name varchar2(300) -- 开证机构名称
    ,issue_org_type_cd varchar2(30) -- 开证机构类型代码
    ,issue_org_ext_rating_rest_cd varchar2(60) -- 开证机构外部评级结果代码
    ,issue_org_ext_rating_dt date -- 开证机构外部评级日期
    ,issue_org_intnal_rating_rest_cd varchar2(100) -- 开证机构内部评级结果代码
    ,issue_org_intnal_rating_dt date -- 开证机构内部评级日期
    ,issue_org_rgst_cty_rg_cd varchar2(200) -- 开证机构注册地国家和地区代码
    ,issue_org_rgst_ext_rating_rest_cd varchar2(100) -- 开证机构注册地外部评级结果代码
    ,amt number(38,8) -- 金额
    ,irevbl_flg varchar2(10) -- 不可撤销标志
    ,curr_cd varchar2(30) -- 币种代码
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
grant select on ${iml_schema}.ast_col_resv_lc to ${icl_schema};
grant select on ${iml_schema}.ast_col_resv_lc to ${idl_schema};
grant select on ${iml_schema}.ast_col_resv_lc to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_resv_lc is '押品备用信用证';
comment on column ${iml_schema}.ast_col_resv_lc.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_resv_lc.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_resv_lc.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_resv_lc.resv_lc_id is '备用信用证编号';
comment on column ${iml_schema}.ast_col_resv_lc.issue_cty_rg_cd is '开证国家和地区代码';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_name is '开证机构名称';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_type_cd is '开证机构类型代码';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_ext_rating_rest_cd is '开证机构外部评级结果代码';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_ext_rating_dt is '开证机构外部评级日期';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_intnal_rating_rest_cd is '开证机构内部评级结果代码';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_intnal_rating_dt is '开证机构内部评级日期';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_rgst_cty_rg_cd is '开证机构注册地国家和地区代码';
comment on column ${iml_schema}.ast_col_resv_lc.issue_org_rgst_ext_rating_rest_cd is '开证机构注册地外部评级结果代码';
comment on column ${iml_schema}.ast_col_resv_lc.amt is '金额';
comment on column ${iml_schema}.ast_col_resv_lc.irevbl_flg is '不可撤销标志';
comment on column ${iml_schema}.ast_col_resv_lc.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_resv_lc.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_resv_lc.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_resv_lc.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_resv_lc.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_resv_lc.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_resv_lc.etl_timestamp is 'ETL处理时间戳';
