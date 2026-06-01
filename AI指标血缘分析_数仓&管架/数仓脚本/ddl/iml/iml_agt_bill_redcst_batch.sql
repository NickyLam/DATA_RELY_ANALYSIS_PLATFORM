/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_redcst_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_redcst_batch
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_redcst_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_redcst_batch(
    batch_id varchar2(60) -- 批次编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,ctr_nt_id varchar2(60) -- 成交单编号
    ,quot_bill_id varchar2(60) -- 报价单编号
    ,appl_form_modif_rela_id varchar2(60) -- 申请单修改关联编号
    ,hq_org_id varchar2(60) -- 总行机构编号
    ,org_id varchar2(60) -- 机构编号
    ,appl_dt date -- 申请日期
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,dealer_id varchar2(60) -- 交易员编号
    ,cfm_ps_id varchar2(60) -- 确认人编号
    ,pbc_org_cd varchar2(30) -- 人行机构代码
    ,pbc_org_acquirer_id varchar2(60) -- 人行机构受理人编号
    ,pbc_org_acquirer_name varchar2(150) -- 人行机构受理人名称
    ,pbc_org_checker_id varchar2(60) -- 人行机构复核人编号
    ,pbc_org_checker_name varchar2(150) -- 人行机构复核人名称
    ,pbc_org_apver_id varchar2(60) -- 人行机构审批人编号
    ,pbc_org_apver_name varchar2(150) -- 人行机构审批人名称
    ,apver_apv_opinion varchar2(750) -- 审批人审批意见
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_cnt number(10) -- 票据张数
    ,bill_tot number(30,2) -- 票据总额
    ,repo_amt number(30,2) -- 回购金额
    ,hold_tenor number(10) -- 持票期限
    ,clear_speed_cd varchar2(10) -- 清算速度代码
    ,clear_type_cd varchar2(10) -- 清算类型代码
    ,stl_way_cd varchar2(10) -- 结算方式代码
    ,stl_amt number(30,2) -- 转贴现金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,stl_dt date -- 结算日期
    ,exp_stl_dt date -- 到期结算日期
    ,int_rat number(18,8) -- 利率
    ,int_paybl number(30,2) -- 应付利息
    ,dept_id varchar2(60) -- 部门编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,apv_rest_cd varchar2(10) -- 审批结果代码
    ,apv_status_cd varchar2(10) -- 审批状态代码
    ,msg_status_cd varchar2(10) -- 报文状态代码
    ,clear_status_cd varchar2(10) -- 清算状态代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,final_modif_tm timestamp -- 最后修改时间
    ,creator_id varchar2(60) -- 创建人编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_bill_redcst_batch to ${icl_schema};
grant select on ${iml_schema}.agt_bill_redcst_batch to ${idl_schema};
grant select on ${iml_schema}.agt_bill_redcst_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_redcst_batch is '票据再贴现批次';
comment on column ${iml_schema}.agt_bill_redcst_batch.batch_id is '批次编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.cont_id is '合同编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.prod_id is '产品编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.quot_bill_id is '报价单编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.appl_form_modif_rela_id is '申请单修改关联编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.org_id is '机构编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.cfm_ps_id is '确认人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_cd is '人行机构代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_acquirer_id is '人行机构受理人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_acquirer_name is '人行机构受理人名称';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_checker_id is '人行机构复核人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_checker_name is '人行机构复核人名称';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_apver_id is '人行机构审批人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.pbc_org_apver_name is '人行机构审批人名称';
comment on column ${iml_schema}.agt_bill_redcst_batch.apver_apv_opinion is '审批人审批意见';
comment on column ${iml_schema}.agt_bill_redcst_batch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.bill_cnt is '票据张数';
comment on column ${iml_schema}.agt_bill_redcst_batch.bill_tot is '票据总额';
comment on column ${iml_schema}.agt_bill_redcst_batch.repo_amt is '回购金额';
comment on column ${iml_schema}.agt_bill_redcst_batch.hold_tenor is '持票期限';
comment on column ${iml_schema}.agt_bill_redcst_batch.clear_speed_cd is '清算速度代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.clear_type_cd is '清算类型代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.stl_amt is '转贴现金额';
comment on column ${iml_schema}.agt_bill_redcst_batch.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.agt_bill_redcst_batch.stl_dt is '结算日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.exp_stl_dt is '到期结算日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.int_rat is '利率';
comment on column ${iml_schema}.agt_bill_redcst_batch.int_paybl is '应付利息';
comment on column ${iml_schema}.agt_bill_redcst_batch.dept_id is '部门编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.apv_rest_cd is '审批结果代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.msg_status_cd is '报文状态代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_bill_redcst_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_bill_redcst_batch.creator_id is '创建人编号';
comment on column ${iml_schema}.agt_bill_redcst_batch.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bill_redcst_batch.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_redcst_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_redcst_batch.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_redcst_batch.etl_timestamp is 'ETL处理时间戳';
