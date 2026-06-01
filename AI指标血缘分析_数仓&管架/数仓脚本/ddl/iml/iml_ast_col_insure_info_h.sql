/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_insure_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_insure_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_insure_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_insure_info_h(
    insure_rec_id varchar2(100) -- 保险记录编号
    ,lp_id varchar2(100) -- 法人编号
    ,insu_comp_id varchar2(100) -- 保险公司编号
    ,insu_comp_name varchar2(500) -- 保险公司名称
    ,policy_num varchar2(250) -- 保险单号
    ,guar_amt number(30,8) -- 担保金额
    ,insure_begin_dt date -- 保险起始日期
    ,insure_exp_dt date -- 保险到期日期
    ,fst_ctfer_name varchar2(500) -- 第一核保人名称
    ,secd_ctfer_name varchar2(500) -- 第二核保人名称
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,latest_update_dt date -- 最新更新日期
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
grant select on ${iml_schema}.ast_col_insure_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_col_insure_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_col_insure_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_insure_info_h is '押品保险信息';
comment on column ${iml_schema}.ast_col_insure_info_h.insure_rec_id is '保险记录编号';
comment on column ${iml_schema}.ast_col_insure_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_insure_info_h.insu_comp_id is '保险公司编号';
comment on column ${iml_schema}.ast_col_insure_info_h.insu_comp_name is '保险公司名称';
comment on column ${iml_schema}.ast_col_insure_info_h.policy_num is '保险单号';
comment on column ${iml_schema}.ast_col_insure_info_h.guar_amt is '担保金额';
comment on column ${iml_schema}.ast_col_insure_info_h.insure_begin_dt is '保险起始日期';
comment on column ${iml_schema}.ast_col_insure_info_h.insure_exp_dt is '保险到期日期';
comment on column ${iml_schema}.ast_col_insure_info_h.fst_ctfer_name is '第一核保人名称';
comment on column ${iml_schema}.ast_col_insure_info_h.secd_ctfer_name is '第二核保人名称';
comment on column ${iml_schema}.ast_col_insure_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.ast_col_insure_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.ast_col_insure_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.ast_col_insure_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.ast_col_insure_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.ast_col_insure_info_h.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.ast_col_insure_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_insure_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_insure_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_insure_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_insure_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_insure_info_h.etl_timestamp is 'ETL处理时间戳';
