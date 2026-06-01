/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_hqd_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_hqd_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_hqd_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,crdt_appl_flow_num varchar2(100) -- 信贷申请流水号
    ,lmt_appl_flow_num varchar2(100) -- 授信申请流水号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_abbr varchar2(500) -- 产品简称
    ,appl_amt number(30,8) -- 申请金额
    ,loan_tenor number(22) -- 贷款期限
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,apv_appl_dt date -- 审批申请日期
    ,apv_end_dt date -- 审批结束日期
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,apv_lmt number(30,8) -- 审批额度
    ,advise_flg varchar2(10) -- 通知展业标志
    ,warn_info varchar2(4000) -- 预警信息
    ,refuse_rs_descb varchar2(4000) -- 拒绝原因描述
    ,cust_mgr_opinion varchar2(2000) -- 客户经理意见
    ,th_year_degree_workr_num number(30,8) -- 本年度从业人数
    ,actl_ctrler_work_years number(30,8) -- 实控人从业年限
    ,flow_calcu_year_sell_inco number(30,8) -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal number(30,8) -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke number(30,8) -- 征信未体现的月还款额
    ,corp_mon_second_marke number(30,8) -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg varchar2(10) -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt number(30,8) -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt number(30,8) -- 知识产权质押贷款金额
    ,share_right_inpwn_flg varchar2(10) -- 股权质押标志
    ,share_right_inpwn_loan_amt number(30,8) -- 股权质押贷款金额
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_belong_org_id varchar2(100) -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id varchar2(100) -- 客户经理所属分行机构编号
    ,update_cust_mgr_id varchar2(100) -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id varchar2(100) -- 更新客户经理所属机构编号
    ,up_date date -- 更新日期
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
grant select on ${iml_schema}.agt_loan_appl_hqd_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_hqd_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_hqd_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_hqd_attach_info_h is '贷款申请好企贷附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.crdt_appl_flow_num is '信贷申请流水号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.lmt_appl_flow_num is '授信申请流水号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.prod_abbr is '产品简称';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.appl_amt is '申请金额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.lmt_circl_flg is '额度循环标志';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.apv_appl_dt is '审批申请日期';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.apv_end_dt is '审批结束日期';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.apv_lmt is '审批额度';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.advise_flg is '通知展业标志';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.warn_info is '预警信息';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.refuse_rs_descb is '拒绝原因描述';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.cust_mgr_opinion is '客户经理意见';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.th_year_degree_workr_num is '本年度从业人数';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.actl_ctrler_work_years is '实控人从业年限';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.flow_calcu_year_sell_inco is '流水推算年销售收入';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.crdtc_not_embody_liab_bal is '征信未体现的负债余额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.crdtc_not_mon_second_marke is '征信未体现的月还款额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.corp_mon_second_marke is '企业月还款额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.corp_acct_recvbl_inpwn_flg is '企业应收账款质押标志';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.acct_recvbl_inpwn_loan_amt is '应收账款质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.intel_prop_inpwn_loan_amt is '知识产权质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.share_right_inpwn_flg is '股权质押标志';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.share_right_inpwn_loan_amt is '股权质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.cust_mgr_belong_org_id is '客户经理所属机构编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.cust_mgr_belong_brch_org_id is '客户经理所属分行机构编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.update_cust_mgr_id is '更新客户经理编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.new_cust_mgr_belong_org_id is '更新客户经理所属机构编号';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_hqd_attach_info_h.etl_timestamp is 'ETL处理时间戳';
