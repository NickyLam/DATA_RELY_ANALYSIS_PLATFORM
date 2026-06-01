/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dubil_risk_adj_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dubil_risk_adj_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dubil_risk_adj_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dubil_risk_adj_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,dubil_id varchar2(100) -- 借据编号
    ,curr_cd varchar2(30) -- 币种代码
    ,bal number(30,8) -- 余额
    ,bf_adj_level5_cls_cd varchar2(30) -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd varchar2(30) -- 调整后五级分类代码
    ,adj_dt date -- 调整日期
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
grant select on ${iml_schema}.evt_dubil_risk_adj_flow to ${icl_schema};
grant select on ${iml_schema}.evt_dubil_risk_adj_flow to ${idl_schema};
grant select on ${iml_schema}.evt_dubil_risk_adj_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dubil_risk_adj_flow is '借据风险调整流水';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.bal is '余额';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.bf_adj_level5_cls_cd is '调整前五级分类代码';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.a_adjust_level5_cls_cd is '调整后五级分类代码';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.adj_dt is '调整日期';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dubil_risk_adj_flow.etl_timestamp is 'ETL处理时间戳';
