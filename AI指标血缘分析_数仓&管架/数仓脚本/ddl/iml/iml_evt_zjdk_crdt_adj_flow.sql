/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_zjdk_crdt_adj_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_zjdk_crdt_adj_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_zjdk_crdt_adj_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_zjdk_crdt_adj_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_no varchar2(100) -- 批次号
    ,crdt_id varchar2(100) -- 授信编号
    ,crdt_chn_cd varchar2(30) -- 授信渠道代码
    ,crdt_adj_type_cd varchar2(30) -- 授信调整类型代码
    ,adj_flow_num varchar2(100) -- 调整流水号
    ,bf_adj_crdt_pre_lmt number(30,2) -- 调整前授信预估额度
    ,bf_adj_crdt_day_int_rat number(18,8) -- 调整前授信日利率
    ,bf_adj_crdt_year_int_rat number(18,8) -- 调整前授信年利率
    ,a_adjust_crdt_pre_lmt number(30,2) -- 调整后授信预估额度
    ,a_adjust_crdt_day_int_rat number(18,8) -- 调整后授信日利率
    ,a_adjust_crdt_year_int_rat number(18,8) -- 调整后授信年利率
    ,plat_charatic_prod_data varchar2(4000) -- 平台特色产品数据
    ,req_id varchar2(100) -- 请求编号
    ,apv_rest_cd varchar2(30) -- 审批结果代码
    ,refuse_opinion varchar2(4000) -- 拒绝意见
    ,input_teller_id varchar2(100) -- 录入柜员编号
    ,input_org_id varchar2(100) -- 录入机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.evt_zjdk_crdt_adj_flow to ${icl_schema};
grant select on ${iml_schema}.evt_zjdk_crdt_adj_flow to ${idl_schema};
grant select on ${iml_schema}.evt_zjdk_crdt_adj_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_zjdk_crdt_adj_flow is '字节小微贷授信调整流水';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.batch_no is '批次号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.crdt_id is '授信编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.crdt_adj_type_cd is '授信调整类型代码';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.adj_flow_num is '调整流水号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.bf_adj_crdt_pre_lmt is '调整前授信预估额度';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.bf_adj_crdt_day_int_rat is '调整前授信日利率';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.bf_adj_crdt_year_int_rat is '调整前授信年利率';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.a_adjust_crdt_pre_lmt is '调整后授信预估额度';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.a_adjust_crdt_day_int_rat is '调整后授信日利率';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.a_adjust_crdt_year_int_rat is '调整后授信年利率';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.plat_charatic_prod_data is '平台特色产品数据';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.req_id is '请求编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.apv_rest_cd is '审批结果代码';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.refuse_opinion is '拒绝意见';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.input_teller_id is '录入柜员编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.input_org_id is '录入机构编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_zjdk_crdt_adj_flow.etl_timestamp is 'ETL处理时间戳';
