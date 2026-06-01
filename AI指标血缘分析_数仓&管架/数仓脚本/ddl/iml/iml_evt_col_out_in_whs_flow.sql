/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_col_out_in_whs_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_col_out_in_whs_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_col_out_in_whs_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_col_out_in_whs_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,rec_flow_num varchar2(100) -- 记录流水号
    ,col_id varchar2(100) -- 押品编号
    ,out_in_whs_status_cd varchar2(30) -- 出入库状态代码
    ,out_in_whs_dt date -- 出入库日期
    ,col_type_cd varchar2(60) -- 押品类型代码
    ,hxb_cfm_val number(30,2) -- 我行确认价值
    ,curr_cd varchar2(30) -- 币种代码
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,belong_org_id varchar2(100) -- 所属机构编号
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
grant select on ${iml_schema}.evt_col_out_in_whs_flow to ${icl_schema};
grant select on ${iml_schema}.evt_col_out_in_whs_flow to ${idl_schema};
grant select on ${iml_schema}.evt_col_out_in_whs_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_col_out_in_whs_flow is '押品出入库登记流水';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.rec_flow_num is '记录流水号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.col_id is '押品编号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.out_in_whs_status_cd is '出入库状态代码';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.out_in_whs_dt is '出入库日期';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.col_type_cd is '押品类型代码';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.hxb_cfm_val is '我行确认价值';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_col_out_in_whs_flow.etl_timestamp is 'ETL处理时间戳';
