/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_dubil_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_dubil_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_dubil_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_dubil_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,core_dubil_id varchar2(100) -- 核心借据编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,dubil_amt number(30,8) -- 借据金额
    ,dubil_bal number(30,8) -- 借据余额
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,int_accr_way_cd varchar2(60) -- 计息方式代码
    ,int_set_way_cd varchar2(60) -- 结息方式代码
    ,int_set_ped_cd varchar2(30) -- 结息周期代码
    ,ped_corp_cd varchar2(30) -- 周期单位代码
    ,repay_ped_cd varchar2(30) -- 还款周期代码
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(100) -- 利率调整周期代码
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,float_range number(30,8) -- 浮动点数
    ,ovdue_int_rat_float_way_cd varchar2(100) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(30,8) -- 逾期利率浮动值
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,loan_level5_cls_cd varchar2(30) -- 五级分类代码
    ,tran_dt date -- 交易日期
    ,loan_distr_dt date -- 贷款发放日期
    ,loan_exp_dt date -- 贷款到期日期
    ,mon_tenor number(10) -- 月期限
    ,tot_perds number(10) -- 总期数
    ,curr_perds number(10) -- 当前期数
    ,repay_day number(10) -- 还款日
    ,comp_payoff_dt date -- 代偿结清日期
    ,next_repay_dt date -- 下一还款日期
    ,payoff_dt date -- 结清日期
    ,wrt_off_dt date -- 核销日期
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,wrt_off_amt number(30,2) -- 核销金额
    ,grace_period_days number(10) -- 宽限期天数
    ,ovdue_dt date -- 逾期日期
    ,ovdue_days number(22) -- 贷款逾期天数
    ,ovdue_pric_bal number(30,8) -- 逾期本金余额
    ,ovdue_int_bal number(30,8) -- 逾期利息余额
    ,ovdue_comp_int number(30,2) -- 逾期复利
    ,ovdue_int_rat number(30,8) -- 逾期利率
    ,pnlt_int_rat number(30,8) -- 罚息利率
    ,base_rat number(30,8) -- 基准利率
    ,exec_int_rat number(30,8) -- 执行利率
    ,comp_int_int_rat number(30,8) -- 复利利率
    ,td_provi_int number(30,8) -- 当日计提利息
    ,td_provi_pnlt number(30,8) -- 当日计提罚息
    ,recvbl_over_int number(30,8) -- 应收欠息
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_comp_int number(30,8) -- 应收复利
    ,nomal_int number(30,8) -- 正常利息
    ,pnlt_bal number(30,8) -- 罚息余额
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,nomal_pric number(30,8) -- 正常本金
    ,unexp_pric number(30,2) -- 未到期本金
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,partner_contri_ratio number(18,6) -- 合作方出资比例
    ,enter_id varchar2(250) -- 入账账户编号
    ,enter_open_acct_bank_name varchar2(500) -- 入账账户开户银行名称
    ,repay_num_id varchar2(250) -- 还款账户编号
    ,repay_num_open_acct_bank_id varchar2(250) -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name varchar2(500) -- 还款账户开户机构名称
    ,guar_way_cd varchar2(30) -- 主担保方式代码
    ,fin_guar_mode_cd varchar2(30) -- 融担模式代码
    ,fst_guar_id varchar2(100) -- 第一担保编号
    ,fst_guar_ratio number(18,6) -- 第一担保比例
    ,fst_guar_cont_id varchar2(100) -- 第一担保合同编号
    ,secd_guar_id varchar2(100) -- 第二担保编号
    ,secd_guar_ratio number(18,6) -- 第二担保比例
    ,secd_guar_cont_id varchar2(100) -- 第二担保合同编号
    ,resv_field_two varchar2(500) -- 第二备用字段
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,oper_org_id varchar2(100) -- 经办机构编号
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
grant select on ${iml_schema}.agt_wph_dubil_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wph_dubil_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wph_dubil_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_dubil_info_h is '唯品会借据信息历史';
comment on column ${iml_schema}.agt_wph_dubil_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.core_dubil_id is '核心借据编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.dubil_bal is '借据余额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_set_way_cd is '结息方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_set_ped_cd is '结息周期代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ped_corp_cd is '周期单位代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.float_range is '浮动点数';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_wph_dubil_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.loan_level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.loan_distr_dt is '贷款发放日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_wph_dubil_info_h.tot_perds is '总期数';
comment on column ${iml_schema}.agt_wph_dubil_info_h.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_day is '还款日';
comment on column ${iml_schema}.agt_wph_dubil_info_h.comp_payoff_dt is '代偿结清日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.next_repay_dt is '下一还款日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.wrt_off_flg is '核销标志';
comment on column ${iml_schema}.agt_wph_dubil_info_h.wrt_off_amt is '核销金额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.grace_period_days is '宽限期天数';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_comp_int is '逾期复利';
comment on column ${iml_schema}.agt_wph_dubil_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_wph_dubil_info_h.pnlt_int_rat is '罚息利率';
comment on column ${iml_schema}.agt_wph_dubil_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_wph_dubil_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_wph_dubil_info_h.comp_int_int_rat is '复利利率';
comment on column ${iml_schema}.agt_wph_dubil_info_h.td_provi_int is '当日计提利息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.td_provi_pnlt is '当日计提罚息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.recvbl_over_int is '应收欠息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.int_recvbl is '应收利息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.recvbl_comp_int is '应收复利';
comment on column ${iml_schema}.agt_wph_dubil_info_h.nomal_int is '正常利息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_wph_dubil_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_wph_dubil_info_h.nomal_pric is '正常本金';
comment on column ${iml_schema}.agt_wph_dubil_info_h.unexp_pric is '未到期本金';
comment on column ${iml_schema}.agt_wph_dubil_info_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_wph_dubil_info_h.partner_contri_ratio is '合作方出资比例';
comment on column ${iml_schema}.agt_wph_dubil_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.enter_open_acct_bank_name is '入账账户开户银行名称';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_num_open_acct_bank_id is '还款账户开户银行编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.repay_num_open_acct_org_name is '还款账户开户机构名称';
comment on column ${iml_schema}.agt_wph_dubil_info_h.guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.fin_guar_mode_cd is '融担模式代码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.fst_guar_id is '第一担保编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.fst_guar_ratio is '第一担保比例';
comment on column ${iml_schema}.agt_wph_dubil_info_h.fst_guar_cont_id is '第一担保合同编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.secd_guar_id is '第二担保编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.secd_guar_ratio is '第二担保比例';
comment on column ${iml_schema}.agt_wph_dubil_info_h.secd_guar_cont_id is '第二担保合同编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.resv_field_two is '第二备用字段';
comment on column ${iml_schema}.agt_wph_dubil_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_wph_dubil_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_dubil_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_dubil_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_dubil_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_dubil_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_dubil_info_h.etl_timestamp is 'ETL处理时间戳';
