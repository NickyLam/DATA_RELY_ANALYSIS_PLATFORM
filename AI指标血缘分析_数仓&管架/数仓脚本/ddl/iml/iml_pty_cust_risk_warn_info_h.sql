/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_risk_warn_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_risk_warn_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_risk_warn_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_risk_warn_info_h(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,warn_id varchar2(500) -- 预警编号
    ,flow_num varchar2(100) -- 流水号
    ,warn_descb varchar2(1000) -- 预警描述
    ,warn_hibchy varchar2(60) -- 预警层级
    ,warn_type_cd varchar2(30) -- 预警类型代码
    ,warn_status_cd varchar2(30) -- 预警状态代码
    ,warn_sgn_idtfy_comnt varchar2(4000) -- 预警信号认定说明
    ,risk_ctrl_measure_descb varchar2(4000) -- 风险控制措施描述
    ,cfm_status_cd varchar2(30) -- 确认状态代码
    ,remit_comnt varchar2(500) -- 解除说明
    ,remit_flg varchar2(10) -- 解除标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,modif_dt date -- 变更日期
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
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
grant select on ${iml_schema}.pty_cust_risk_warn_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_risk_warn_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_risk_warn_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_risk_warn_info_h is '客户风险预警信息历史';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.obj_id is '对象编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_id is '预警编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.flow_num is '流水号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_descb is '预警描述';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_hibchy is '预警层级';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_type_cd is '预警类型代码';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_status_cd is '预警状态代码';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.warn_sgn_idtfy_comnt is '预警信号认定说明';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.risk_ctrl_measure_descb is '风险控制措施描述';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.cfm_status_cd is '确认状态代码';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.remit_comnt is '解除说明';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.remit_flg is '解除标志';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_risk_warn_info_h.etl_timestamp is 'ETL处理时间戳';
