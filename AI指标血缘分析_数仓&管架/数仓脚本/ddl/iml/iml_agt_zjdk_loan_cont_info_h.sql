/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_zjdk_loan_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_zjdk_loan_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_loan_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,myloan_appl_flow_num varchar2(100) -- 网商贷申请流水号
    ,stud_loan_appl_flow_num varchar2(100) -- 助贷申请流水号
    ,apv_status_cd varchar2(60) -- 审批状态代码
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,crdt_id varchar2(100) -- 授信编号
    ,crdt_day_int_rat number(30,8) -- 授信日利率
    ,aval_lmt number(30,8) -- 可用额度
    ,estim_lmt number(30,8) -- 预估额度
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,mobile_no varchar2(100) -- 手机号码
    ,prod_id varchar2(100) -- 产品编号
    ,prod_cate_cd varchar2(30) -- 产品类别代码
    ,cont_valid_flg varchar2(10) -- 合同有效标志
    ,cont_amt number(30,8) -- 合同金额
    ,cont_bal number(30,8) -- 合同余额
    ,loan_int_rat number(30,8) -- 贷款利率
    ,curr_cd varchar2(30) -- 币种代码
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,tenor number(10) -- 期限
    ,loan_usage_cd varchar2(60) -- 贷款用途代码
    ,intnal_dubil_id varchar2(100) -- 借据编号
    ,zjck_acct_close_dt date -- 字节账户关闭日期
    ,zjck_acct_close_type_cd varchar2(30) -- 字节账户关闭类型代码
    ,bl_induty_cd varchar2(100) -- 所属行业代码
    ,loan_dir_cd varchar2(100) -- 贷款投向代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
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
grant select on ${iml_schema}.agt_zjdk_loan_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_zjdk_loan_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_zjdk_loan_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_zjdk_loan_cont_info_h is '字节小微贷合同信息历史';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.myloan_appl_flow_num is '网商贷申请流水号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.stud_loan_appl_flow_num is '助贷申请流水号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.crdt_day_int_rat is '授信日利率';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.aval_lmt is '可用额度';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.estim_lmt is '预估额度';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cont_valid_flg is '合同有效标志';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.cont_bal is '合同余额';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.loan_int_rat is '贷款利率';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.tenor is '期限';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.intnal_dubil_id is '借据编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.zjck_acct_close_dt is '字节账户关闭日期';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.zjck_acct_close_type_cd is '字节账户关闭类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.bl_induty_cd is '所属行业代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.loan_dir_cd is '贷款投向代码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_zjdk_loan_cont_info_h.etl_timestamp is 'ETL处理时间戳';
