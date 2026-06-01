/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_risk_warn_rgst_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_risk_warn_rgst_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_risk_warn_rgst_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_risk_warn_rgst_h(
    flow_num varchar2(100) -- 流水号
    ,lp_id varchar2(100) -- 法人编号
    ,party_id varchar2(100) -- 当事人编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,rgst_dt date -- 登记日期
    ,warn_proc_status_cd varchar2(30) -- 预警处理状态代码
    ,effect_flg varchar2(10) -- 生效标志
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,org_id varchar2(100) -- 机构编号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,warn_init_way_cd varchar2(30) -- 预警发起方式代码
    ,warn_type_cd varchar2(30) -- 警示类型代码
    ,bal number(30,8) -- 余额
    ,exp_not_cmplt_flg varchar2(10) -- 过期未完成标志
    ,flow_status_cd varchar2(30) -- 流程状态代码
    ,task_closing_dt date -- 任务截止日期
    ,warn_info varchar2(4000) -- 预警信息
    ,warn_info_src_cd varchar2(30) -- 预警信息来源代码
    ,exp_flg varchar2(10) -- 过期标志
    ,end_flg varchar2(10) -- 结束标志
    ,cmplt_dt date -- 完成日期
    ,cust_mgr_invalid_rs_remark varchar2(2000) -- 客户经理失效原因备注
    ,risk_mgr_invalid_rs_remark varchar2(2000) -- 风险经理失效原因备注
    ,mger_offic_invalid_remark varchar2(2000) -- 总经理室失效原因备注
    ,cust_mgr_effect_remark varchar2(2000) -- 客户经理生效原因备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
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
grant select on ${iml_schema}.pty_cust_risk_warn_rgst_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_risk_warn_rgst_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_risk_warn_rgst_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_risk_warn_rgst_h is '客户风险预警登记历史';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.flow_num is '流水号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cust_name is '客户名称';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.warn_proc_status_cd is '预警处理状态代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.effect_flg is '生效标志';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.org_id is '机构编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.warn_init_way_cd is '预警发起方式代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.warn_type_cd is '警示类型代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.bal is '余额';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.exp_not_cmplt_flg is '过期未完成标志';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.task_closing_dt is '任务截止日期';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.warn_info is '预警信息';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.warn_info_src_cd is '预警信息来源代码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.exp_flg is '过期标志';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.end_flg is '结束标志';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cmplt_dt is '完成日期';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cust_mgr_invalid_rs_remark is '客户经理失效原因备注';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.risk_mgr_invalid_rs_remark is '风险经理失效原因备注';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.mger_offic_invalid_remark is '总经理室失效原因备注';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.cust_mgr_effect_remark is '客户经理生效原因备注';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_risk_warn_rgst_h.etl_timestamp is 'ETL处理时间戳';
