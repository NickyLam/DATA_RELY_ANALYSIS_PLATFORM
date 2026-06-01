/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_jd_loan_dubil_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_jd_loan_dubil_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_jd_loan_dubil_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_loan_dubil_info(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,jd_cust_id varchar2(60) -- 外部客户编号
    ,jd_prod_cd varchar2(10) -- 京东产品代码
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,dubil_id varchar2(60) -- 借据编号
    ,curr_cd varchar2(10) -- 币种代码
    ,loan_status_cd varchar2(10) -- 借据状态代码
    ,distr_dt date -- 放款日期
    ,loan_distr_amt number(30,8) -- 放款金额
    ,bus_exp_dt date -- 到期日期
    ,loan_cap_use_position_cd varchar2(10) -- 资金使用位置代码
    ,pric_repay_freq_cd varchar2(10) -- 本金还款频率代码
    ,pric_repay_freq number(10) -- 本金还款频率
    ,pric_repay_ped_corp_cd varchar2(10) -- 本金还款周期单位代码
    ,int_repay_freq_cd varchar2(10) -- 利息还款频率代码
    ,int_repay_freq number(10) -- 利息还款频率
    ,int_repay_ped_corp_cd varchar2(10) -- 利息还款周期单位代码
    ,self_pay_amt number(30,8) -- 自主支付金额
    ,entr_pay_amt number(30,8) -- 受托支付金额
    ,loan_ovdue_flg varchar2(10) -- 逾期标志
    ,ovdue_days number(22) -- 贷款逾期天数
    ,ovdue_grace_days number(10) -- 逾期宽限天数
    ,pric_ovdue_dt date -- 本金逾期日期
    ,int_ovdue_dt date -- 利息逾期日期
    ,next_pay_int_day date -- 下一付息日
    ,jd_loan_int_rat_type_cd varchar2(10) -- 贷款利率类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_freq number(10) -- 利率调整频率
    ,loan_bal number(30,8) -- 贷款余额
    ,ovdue_loan_bal number(30,8) -- 逾期贷款余额
    ,ovdue_int_bal number(30,8) -- 逾期利息
    ,off_bs_over_int_bal number(30,8) -- 表外欠息
    ,int_accr_flg varchar2(10) -- 计息标志
    ,acru_int_amt number(30,8) -- 应计利息
    ,td_int_amt number(30,8) -- 当日应计利息
    ,td_pnlt_amt number(30,8) -- 当日罚息
    ,loan_enter_acct_num varchar2(100) -- 贷款入账账号
    ,loan_repay_num varchar2(100) -- 贷款还款账号
    ,loan_guar_way_cd varchar2(10) -- 担保方式代码
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,loan_int_rat number(30,8) -- 贷款利率
    ,loan_pnlt_int_rat number(30,8) -- 贷款罚息利率
    ,borw_int_rat_type_cd varchar2(10) -- 贷款利率周期代码
    ,pnlt_int_rat_type_cd varchar2(10) -- 罚息利率周期代码
    ,distr_flow_num varchar2(60) -- 放款流水号
    ,loan_usage_cd varchar2(60) -- 贷款用途代码
    ,loan_exec_int_rat number(30,8) -- 贷款执行利率
    ,borw_exec_int_rat_type_cd varchar2(10) -- 执行利率周期代码
    ,loan_perds number(10) -- 贷款期数
    ,prep_repay_perds number(10) -- 待还期数
    ,ovdue_perds number(10) -- 逾期期数
    ,off_bs_perds number(10) -- 表外期数
    ,acru_pnlt_amt number(30,8) -- 应计罚息
    ,cust_id varchar2(60) -- 客户编号
    ,belong_cust_mgr_id varchar2(60) -- 所属客户经理编号
    ,loan_exec_year_int_rat number(18,10) -- 执行年利率
    ,lpr_int_rat number(18,10) -- LPR利率
    ,int_rat_float_spread_val number(18,10) -- 利率浮动点差值
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,prod_id varchar2(60) -- 产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,payoff_dt date -- 结清日期
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
grant select on ${iml_schema}.agt_jd_loan_dubil_info to ${icl_schema};
grant select on ${iml_schema}.agt_jd_loan_dubil_info to ${idl_schema};
grant select on ${iml_schema}.agt_jd_loan_dubil_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_jd_loan_dubil_info is '京东贷款借据信息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.cont_id is '合同编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.jd_cust_id is '外部客户编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.jd_prod_cd is '京东产品代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_status_cd is '借据状态代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_distr_amt is '放款金额';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.bus_exp_dt is '到期日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_cap_use_position_cd is '资金使用位置代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.pric_repay_freq_cd is '本金还款频率代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.pric_repay_freq is '本金还款频率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.pric_repay_ped_corp_cd is '本金还款周期单位代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_repay_freq_cd is '利息还款频率代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_repay_freq is '利息还款频率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_repay_ped_corp_cd is '利息还款周期单位代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.self_pay_amt is '自主支付金额';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.entr_pay_amt is '受托支付金额';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_ovdue_flg is '逾期标志';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.ovdue_grace_days is '逾期宽限天数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.pric_ovdue_dt is '本金逾期日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_ovdue_dt is '利息逾期日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.next_pay_int_day is '下一付息日';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.jd_loan_int_rat_type_cd is '贷款利率类型代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_rat_adj_freq is '利率调整频率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.ovdue_loan_bal is '逾期贷款余额';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.ovdue_int_bal is '逾期利息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.off_bs_over_int_bal is '表外欠息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.acru_int_amt is '应计利息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.td_int_amt is '当日应计利息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.td_pnlt_amt is '当日罚息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_enter_acct_num is '贷款入账账号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_repay_num is '贷款还款账号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_int_rat is '贷款利率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_pnlt_int_rat is '贷款罚息利率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.borw_int_rat_type_cd is '贷款利率周期代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.pnlt_int_rat_type_cd is '罚息利率周期代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_exec_int_rat is '贷款执行利率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.borw_exec_int_rat_type_cd is '执行利率周期代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_perds is '贷款期数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.prep_repay_perds is '待还期数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.ovdue_perds is '逾期期数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.off_bs_perds is '表外期数';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.acru_pnlt_amt is '应计罚息';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.belong_cust_mgr_id is '所属客户经理编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.loan_exec_year_int_rat is '执行年利率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.lpr_int_rat is 'LPR利率';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_rat_float_spread_val is '利率浮动点差值';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_jd_loan_dubil_info.etl_timestamp is 'ETL处理时间戳';
