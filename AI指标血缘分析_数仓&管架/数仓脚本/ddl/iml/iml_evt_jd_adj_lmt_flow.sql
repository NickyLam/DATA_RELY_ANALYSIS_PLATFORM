/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_jd_adj_lmt_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_jd_adj_lmt_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_jd_adj_lmt_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_jd_adj_lmt_flow(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,adj_lmt_flow_id varchar2(60) -- 调额流水编号
    ,jd_cust_id varchar2(60) -- 外部客户编号
    ,prod_cd varchar2(10) -- 产品代码
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,adj_lmt_type_cd varchar2(10) -- 调额类型代码
    ,adj_lmt_way_cd varchar2(10) -- 调额方式代码
    ,adj_lmt number(30,2) -- 调额额度
    ,adj_lmt_bf_crdt_lmt number(30,2) -- 调额前授信额度
    ,adj_lmt_post_crdt_lmt number(30,2) -- 调额后授信额度
    ,adj_lmt_dt date -- 调额日期
    ,adj_lmt_effect_dt date -- 调额生效日期
    ,prod_id varchar2(60) -- 产品编号
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
grant select on ${iml_schema}.evt_jd_adj_lmt_flow to ${icl_schema};
grant select on ${iml_schema}.evt_jd_adj_lmt_flow to ${idl_schema};
grant select on ${iml_schema}.evt_jd_adj_lmt_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_jd_adj_lmt_flow is '京东调额流水';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_flow_id is '调额流水编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.jd_cust_id is '外部客户编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.prod_cd is '产品代码';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_type_cd is '调额类型代码';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_way_cd is '调额方式代码';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt is '调额额度';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_bf_crdt_lmt is '调额前授信额度';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_post_crdt_lmt is '调额后授信额度';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_dt is '调额日期';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.adj_lmt_effect_dt is '调额生效日期';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_jd_adj_lmt_flow.etl_timestamp is 'ETL处理时间戳';
