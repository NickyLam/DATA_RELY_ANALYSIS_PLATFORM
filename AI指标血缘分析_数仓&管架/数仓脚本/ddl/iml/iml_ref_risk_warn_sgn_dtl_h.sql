/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_risk_warn_sgn_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_risk_warn_sgn_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_risk_warn_sgn_dtl_h(
    warn_id varchar2(100) -- 预警编号
    ,lp_id varchar2(100) -- 法人编号
    ,warn_name varchar2(500) -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg varchar2(10) -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd varchar2(30) -- 预警信号类型代码
    ,warn_descb varchar2(4000) -- 预警描述
    ,warn_hibchy varchar2(60) -- 预警层级
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,modif_dt date -- 变更日期
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
grant select on ${iml_schema}.ref_risk_warn_sgn_dtl_h to ${icl_schema};
grant select on ${iml_schema}.ref_risk_warn_sgn_dtl_h to ${idl_schema};
grant select on ${iml_schema}.ref_risk_warn_sgn_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_risk_warn_sgn_dtl_h is '风险预警信号详情历史';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.warn_id is '预警编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.warn_name is '预警名称';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.trigger_rating_adj_warn_sgn_flg is '触发评级调整的预警信号标志';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.warn_sgn_type_cd is '预警信号类型代码';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.warn_descb is '预警描述';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.warn_hibchy is '预警层级';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.modif_dt is '变更日期';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_risk_warn_sgn_dtl_h.etl_timestamp is 'ETL处理时间戳';
