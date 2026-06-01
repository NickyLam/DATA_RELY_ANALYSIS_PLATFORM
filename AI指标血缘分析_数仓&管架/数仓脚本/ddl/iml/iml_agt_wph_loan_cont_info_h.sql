/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_loan_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_loan_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_loan_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_loan_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,sign_dt date -- 签约日期
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,loan_tenor number(10) -- 贷款期限
    ,cont_amt number(30,8) -- 合同金额
    ,cont_status_cd varchar2(60) -- 合同状态代码
    ,cont_type_cd varchar2(60) -- 合同类型代码
    ,cont_effect_dt date -- 生效日期
    ,cont_exp_dt date -- 到期日期
    ,spec_repay_day number(10) -- 指定还款日
    ,fir_repay_dt date -- 首次还款日期
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,partner_promis_loan_amt number(30,2) -- 合作方承贷金额
    ,plat_crdt_lmt number(30,2) -- 平台对客授信额度
    ,aval_lmt number(30,2) -- 可用额度
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(30,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,exec_int_rat number(30,8) -- 执行利率
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,loan_cont_id varchar2(100) -- 被担保合同编号
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,out_acct_org_id varchar2(100) -- 出账机构编号
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_acct_bank_card_num varchar2(60) -- 入账银行卡号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,risk_mgmt_refuse_rs varchar2(4000) -- 风控拒绝原因
    ,risk_mgmt_rest_cd varchar2(60) -- 风控结果代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
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
grant select on ${iml_schema}.agt_wph_loan_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wph_loan_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wph_loan_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_loan_cont_info_h is '唯品会贷款合同信息历史';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_type_cd is '合同类型代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_effect_dt is '生效日期';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.cont_exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.spec_repay_day is '指定还款日';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.fir_repay_dt is '首次还款日期';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.lmt_circl_flg is '额度循环标志';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.partner_promis_loan_amt is '合作方承贷金额';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.plat_crdt_lmt is '平台对客授信额度';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.aval_lmt is '可用额度';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.low_risk_bus_flg is '低风险业务标志';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.loan_cont_id is '被担保合同编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.out_acct_org_id is '出账机构编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.enter_acct_bank_card_num is '入账银行卡号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.risk_mgmt_refuse_rs is '风控拒绝原因';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.risk_mgmt_rest_cd is '风控结果代码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_loan_cont_info_h.etl_timestamp is 'ETL处理时间戳';
