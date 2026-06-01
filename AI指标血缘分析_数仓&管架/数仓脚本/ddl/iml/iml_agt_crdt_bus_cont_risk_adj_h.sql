/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_bus_cont_risk_adj_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(60) -- 流水号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(100) -- 客户名称
    ,bus_cont_id varchar2(60) -- 业务合同编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_curr_cd varchar2(60) -- 业务币种代码
    ,bal number(30,8) -- 余额
    ,bf_adj_level5_cls_cd varchar2(30) -- 调整前五级分类代码
    ,a_adjust_level5_cls_cd varchar2(30) -- 调整后五级分类代码
    ,bf_adj_level11_cls_cd varchar2(30) -- 调整前十一级分类代码
    ,a_adjust_level11_cls_cd varchar2(30) -- 调整后十一级分类代码
    ,adj_dt date -- 调整日期
    ,mg_prot_teller_id varchar2(30) -- 管护柜员编号
    ,mg_prot_org_id varchar2(30) -- 管护机构编号
    ,rela_flow_id varchar2(60) -- 关联流程编号
    ,rela_flow_type_cd varchar2(30) -- 关联流程类型代码
    ,obj_type_cd varchar2(30) -- 对象类型代码
    ,obj_descb varchar2(60) -- 对象描述
    ,init_teller_id varchar2(30) -- 发起柜员编号
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
grant select on ${iml_schema}.agt_crdt_bus_cont_risk_adj_h to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_bus_cont_risk_adj_h to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_bus_cont_risk_adj_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_bus_cont_risk_adj_h is '信贷业务合同风险调整历史';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.flow_num is '流水号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bus_cont_id is '业务合同编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bus_curr_cd is '业务币种代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bal is '余额';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bf_adj_level5_cls_cd is '调整前五级分类代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.a_adjust_level5_cls_cd is '调整后五级分类代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.bf_adj_level11_cls_cd is '调整前十一级分类代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.a_adjust_level11_cls_cd is '调整后十一级分类代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.adj_dt is '调整日期';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.mg_prot_teller_id is '管护柜员编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.mg_prot_org_id is '管护机构编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.rela_flow_id is '关联流程编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.rela_flow_type_cd is '关联流程类型代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.obj_type_cd is '对象类型代码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.obj_descb is '对象描述';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.init_teller_id is '发起柜员编号';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_bus_cont_risk_adj_h.etl_timestamp is 'ETL处理时间戳';
