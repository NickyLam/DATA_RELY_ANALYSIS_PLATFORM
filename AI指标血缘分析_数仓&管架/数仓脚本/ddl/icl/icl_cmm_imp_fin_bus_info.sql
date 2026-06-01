/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_imp_fin_bus_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_imp_fin_bus_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_imp_fin_bus_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_imp_fin_bus_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,agt_id varchar2(60) -- 协议编号
    ,bus_id varchar2(60) -- 业务编号
    ,dubil_id varchar2(60) -- 借据编号
    ,trust_name varchar2(60) -- 信托收据名称
    ,era_pay_bank_cust_id varchar2(60) -- 代付行客户编号
    ,era_pay_bank_cust_name varchar2(100) -- 代付行客户名称
    ,fin_acct_id varchar2(60) -- 融资账户编号
    ,subj_id varchar2(60) -- 科目编号
    ,acru_int_subj_id varchar2(60) -- 应计利息科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,fin_status_cd varchar2(10) -- 融资状态代码
    ,trust_create_dt date -- 信托收据创建日期
    ,trust_open_dt date -- 信托收据开立日期
    ,trust_exp_dt date -- 信托收据到期日期
    ,trust_effect_dt date -- 信托收据生效日期
    ,trust_revo_dt date -- 信托收据撤销日期
    ,actl_repay_dt date -- 实际还款日期
    ,negot_days number(22,0) -- 押汇天数
    ,actl_negot_days number(22,0) -- 实际押汇天数
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,exec_int_rat number(18,6) -- 执行利率
    ,ovdue_int_rat number(18,6) -- 逾期利率
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_rat_adj_ped_cd varchar2(10) -- 利率调整周期代码
    ,payfan_int_amt number(30,6) -- 代付利息金额
    ,payfan_pnlt_int_rat number(18,6) -- 代付罚息利率
    ,payfan_comm_fee_amt number(30,6) -- 代付手续费金额
    ,ths_tm_pay_amt number(30,6) -- 本次付款金额
    ,curr_cd varchar2(10) -- 币种代码
    ,paybl_pric_bal number(30,6) -- 应付本金余额
    ,td_acru_int number(30,8) -- 当日应计利息
    ,td_int_expns number(30,8) -- 当日利息支出
    ,currt_int_amt number(30,8) -- 当期利息发生额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_imp_fin_bus_info to ${idl_schema};
grant select on ${icl_schema}.cmm_imp_fin_bus_info to ${iel_schema};
grant select on ${icl_schema}.cmm_imp_fin_bus_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_imp_fin_bus_info is '进口融资业务信息';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.agt_id is '协议编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_name is '信托收据名称';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.era_pay_bank_cust_id is '代付行客户编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.era_pay_bank_cust_name is '代付行客户名称';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.fin_acct_id is '融资账户编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.acru_int_subj_id is '应计利息科目编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.oper_org_id is '经办机构编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.fin_status_cd is '融资状态代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_create_dt is '信托收据创建日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_open_dt is '信托收据开立日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_exp_dt is '信托收据到期日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_effect_dt is '信托收据生效日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.trust_revo_dt is '信托收据撤销日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.actl_repay_dt is '实际还款日期';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.negot_days is '押汇天数';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.actl_negot_days is '实际押汇天数';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.payfan_int_amt is '代付利息金额';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.payfan_pnlt_int_rat is '代付罚息利率';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.payfan_comm_fee_amt is '代付手续费金额';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.ths_tm_pay_amt is '本次付款金额';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.paybl_pric_bal is '应付本金余额';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.td_int_expns is '当日利息支出';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.currt_int_amt is '当期利息发生额';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_imp_fin_bus_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_imp_fin_bus_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_imp_fin_bus_info.etl_timestamp is 'ETL处理时间戳';
