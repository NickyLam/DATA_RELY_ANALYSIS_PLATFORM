/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_risk_cls_adj_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_risk_cls_adj_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_risk_cls_adj_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,risk_cls_id varchar2(100) -- 风险分类编号
    ,init_cls_id varchar2(100) -- 原分类编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,cls_pd number(10) -- 分类期次
    ,adj_way_cd varchar2(60) -- 调整方式代码
    ,curr_cls_way_cd varchar2(60) -- 当前分类方式代码
    ,curr_cls_rest_cd varchar2(100) -- 当前分类结果代码
    ,cls_adj_rs_descb varchar2(1000) -- 分类调整原因描述
    ,adj_cls_rest_cd varchar2(60) -- 调整分类结果代码
    ,adj_appl_teller_id varchar2(100) -- 调整申请柜员编号
    ,adj_appl_org_id varchar2(100) -- 调整申请机构编号
    ,adj_appl_dt date -- 调整申请日期
    ,apv_status_cd varchar2(60) -- 审批状态代码
    ,belong_strip_line_cd varchar2(60) -- 所属条线代码
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,move_flg varchar2(10) -- 迁移标志
    ,idtfy_cmplt_dt date -- 认定完成日期
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
grant select on ${iml_schema}.agt_loan_risk_cls_adj_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_risk_cls_adj_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_risk_cls_adj_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_risk_cls_adj_h is '贷款风险分类调整历史';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.risk_cls_id is '风险分类编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.init_cls_id is '原分类编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.cls_pd is '分类期次';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.adj_way_cd is '调整方式代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.curr_cls_way_cd is '当前分类方式代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.curr_cls_rest_cd is '当前分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.cls_adj_rs_descb is '分类调整原因描述';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.adj_cls_rest_cd is '调整分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.adj_appl_teller_id is '调整申请柜员编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.adj_appl_org_id is '调整申请机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.adj_appl_dt is '调整申请日期';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.move_flg is '迁移标志';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.idtfy_cmplt_dt is '认定完成日期';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_risk_cls_adj_h.etl_timestamp is 'ETL处理时间戳';
