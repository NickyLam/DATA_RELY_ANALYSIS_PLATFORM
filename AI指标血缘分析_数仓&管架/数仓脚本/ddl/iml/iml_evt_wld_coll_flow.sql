/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_coll_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_coll_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_coll_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_coll_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_doc_name varchar2(750) -- 批量文件名称
    ,seq_num varchar2(60) -- 序号
    ,coll_flow_num varchar2(100) -- 催收流水号
    ,case_id varchar2(100) -- 案件编号
    ,cust_id varchar2(100) -- 客户编号
    ,way_cd varchar2(30) -- 催记方式代码
    ,coll_act_type_cd varchar2(30) -- 催收动作类型代码
    ,coll_dt date -- 催收日期
    ,coll_rest_type_cd varchar2(30) -- 催收结果类型代码
    ,promis_repay_amt number(30,2) -- 承诺偿还金额
    ,promis_repay_dt date -- 承诺偿还日期
    ,remark varchar2(750) -- 备注
    ,org_id varchar2(100) -- 机构编号
    ,create_tm timestamp -- 创建时间
    ,final_modif_tm timestamp -- 最后修改时间
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_wld_coll_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wld_coll_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wld_coll_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_coll_flow is '微粒贷催收流水';
comment on column ${iml_schema}.evt_wld_coll_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_coll_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_coll_flow.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.evt_wld_coll_flow.seq_num is '序号';
comment on column ${iml_schema}.evt_wld_coll_flow.coll_flow_num is '催收流水号';
comment on column ${iml_schema}.evt_wld_coll_flow.case_id is '案件编号';
comment on column ${iml_schema}.evt_wld_coll_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_wld_coll_flow.way_cd is '催记方式代码';
comment on column ${iml_schema}.evt_wld_coll_flow.coll_act_type_cd is '催收动作类型代码';
comment on column ${iml_schema}.evt_wld_coll_flow.coll_dt is '催收日期';
comment on column ${iml_schema}.evt_wld_coll_flow.coll_rest_type_cd is '催收结果类型代码';
comment on column ${iml_schema}.evt_wld_coll_flow.promis_repay_amt is '承诺偿还金额';
comment on column ${iml_schema}.evt_wld_coll_flow.promis_repay_dt is '承诺偿还日期';
comment on column ${iml_schema}.evt_wld_coll_flow.remark is '备注';
comment on column ${iml_schema}.evt_wld_coll_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_wld_coll_flow.create_tm is '创建时间';
comment on column ${iml_schema}.evt_wld_coll_flow.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_wld_coll_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_coll_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_coll_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_coll_flow.etl_timestamp is 'ETL处理时间戳';
