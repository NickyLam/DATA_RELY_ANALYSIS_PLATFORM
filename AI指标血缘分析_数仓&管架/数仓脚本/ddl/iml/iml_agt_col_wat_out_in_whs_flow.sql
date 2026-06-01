/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_col_wat_out_in_whs_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_col_wat_out_in_whs_flow
whenever sqlerror continue none;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_wat_out_in_whs_flow(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,col_id varchar2(60) -- 押品编号
    ,cont_id varchar2(60) -- 合同编号
    ,flow_status_cd varchar2(10) -- 流程状态代码
    ,guar_cont_id varchar2(60) -- 担保合同编号
    ,subor_org_id varchar2(60) -- 下级机构编号
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
grant select on ${iml_schema}.agt_col_wat_out_in_whs_flow to ${icl_schema};
grant select on ${iml_schema}.agt_col_wat_out_in_whs_flow to ${idl_schema};
grant select on ${iml_schema}.agt_col_wat_out_in_whs_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_col_wat_out_in_whs_flow is '押品权证出入库流程表';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.agt_id is '协议编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.lp_id is '法人编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.bus_id is '业务编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.col_id is '押品编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.cont_id is '合同编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.subor_org_id is '下级机构编号';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.start_dt is '开始时间';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.end_dt is '结束时间';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.id_mark is '增删标志';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.job_cd is '任务编码';
comment on column ${iml_schema}.agt_col_wat_out_in_whs_flow.etl_timestamp is 'ETL处理时间戳';
