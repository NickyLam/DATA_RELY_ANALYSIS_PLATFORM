/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lx_dubil_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lx_dubil_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lx_dubil_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_dubil_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,dubil_amt number(30,8) -- 借据金额
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,loan_status_cd varchar2(30) -- 贷款状态代码
    ,loan_modal_cd varchar2(30) -- 贷款形态代码
    ,mon_tenor number(10) -- 月期限
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,exec_int_rat number(30,8) -- 执行利率
    ,ovdue_int_rat number(30,8) -- 逾期利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(100) -- 利率调整周期代码
    ,float_range number(18,8) -- 浮动点数
    ,ovdue_int_rat_float_way_cd varchar2(100) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(30,8) -- 逾期利率浮动值
    ,nomal_int_rat number(18,8) -- 正常利率
    ,nomal_int_rat_type_cd varchar2(30) -- 正常利率类型代码
    ,pnlt_int_rat number(18,8) -- 罚息利率
    ,pnlt_int_rat_type_cd varchar2(30) -- 罚息利率类型代码
    ,adv_repay_comm_fee_rat number(18,8) -- 提前还款手续费率
    ,loan_level5_cls_cd varchar2(30) -- 五级分类代码
    ,loan_level5_cls_dt date -- 五级分类日期
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,dir_indus_cd varchar2(30) -- 贷款投向行业代码
    ,appl_dt date -- 申请日期
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,ovdue_dt date -- 逾期日期
    ,payoff_dt date -- 结清日期
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_cd varchar2(30) -- 还款周期代码
    ,guar_way_cd varchar2(30) -- 主担保方式代码
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,tot_perds number(10) -- 总期数
    ,curr_perds number(10) -- 当前期数
    ,repay_day number(10) -- 还款日
    ,grace_period number(10) -- 宽限期
    ,ovdue_days number(22) -- 贷款逾期天数
    ,rpbl_pric number(30,8) -- 应还本金
    ,paid_pric number(30,8) -- 已还本金
    ,nomal_pric_bal number(30,8) -- 正常本金余额
    ,ovdue_pric_bal number(30,8) -- 逾期本金余额
    ,plan_int number(30,8) -- 计划利息
    ,rpbl_int number(30,8) -- 应还利息
    ,paid_int number(30,8) -- 已还利息
    ,derate_int number(30,8) -- 减免利息
    ,currt_int_bal number(30,8) -- 当期利息余额
    ,ovdue_int_bal number(30,8) -- 逾期利息余额
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,paid_pnlt number(30,8) -- 已还罚息
    ,derate_pnlt number(30,8) -- 减免罚息
    ,pnlt_bal number(30,8) -- 罚息余额
    ,td_provi_int number(30,8) -- 当日计提利息
    ,td_provi_pnlt number(30,8) -- 当日计提罚息
    ,paid_adv_repay_comm_fee number(30,8) -- 已还提前还款手续费
    ,plat_order_no varchar2(100) -- 平台订单号
    ,acru_non_acru_idf_cd varchar2(30) -- 应计非应计标识代码
    ,wrt_off_status_cd varchar2(30) -- 核销状态代码
    ,wrt_off_dt date -- 核销日期
    ,start_pd number(10) -- 开始期次
    ,end_pd number(10) -- 结束期次
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_type_cd varchar2(100) -- 还款账户类型代码
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_type_cd varchar2(100) -- 入账账户类型代码
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,rgst_dt date -- 登记日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,final_update_dt date -- 最后更新日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
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
grant select on ${iml_schema}.agt_lx_dubil_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_lx_dubil_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_lx_dubil_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lx_dubil_info_h is '乐信借据信息历史';
comment on column ${iml_schema}.agt_lx_dubil_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lx_dubil_info_h.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.loan_modal_cd is '贷款形态代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_lx_dubil_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.float_range is '浮动点数';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_lx_dubil_info_h.nomal_int_rat is '正常利率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.nomal_int_rat_type_cd is '正常利率类型代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.pnlt_int_rat is '罚息利率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.pnlt_int_rat_type_cd is '罚息利率类型代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.adv_repay_comm_fee_rat is '提前还款手续费率';
comment on column ${iml_schema}.agt_lx_dubil_info_h.loan_level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.loan_level5_cls_dt is '五级分类日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.dir_indus_cd is '贷款投向行业代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.tot_perds is '总期数';
comment on column ${iml_schema}.agt_lx_dubil_info_h.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_lx_dubil_info_h.repay_day is '还款日';
comment on column ${iml_schema}.agt_lx_dubil_info_h.grace_period is '宽限期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_lx_dubil_info_h.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_lx_dubil_info_h.paid_pric is '已还本金';
comment on column ${iml_schema}.agt_lx_dubil_info_h.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.plan_int is '计划利息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.paid_int is '已还利息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.derate_int is '减免利息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.currt_int_bal is '当期利息余额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.paid_pnlt is '已还罚息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.derate_pnlt is '减免罚息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_lx_dubil_info_h.td_provi_int is '当日计提利息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.td_provi_pnlt is '当日计提罚息';
comment on column ${iml_schema}.agt_lx_dubil_info_h.paid_adv_repay_comm_fee is '已还提前还款手续费';
comment on column ${iml_schema}.agt_lx_dubil_info_h.plat_order_no is '平台订单号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.acru_non_acru_idf_cd is '应计非应计标识代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.wrt_off_status_cd is '核销状态代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.start_pd is '开始期次';
comment on column ${iml_schema}.agt_lx_dubil_info_h.end_pd is '结束期次';
comment on column ${iml_schema}.agt_lx_dubil_info_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.enter_type_cd is '入账账户类型代码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_lx_dubil_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lx_dubil_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lx_dubil_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lx_dubil_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lx_dubil_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lx_dubil_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lx_dubil_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lx_dubil_info_h.etl_timestamp is 'ETL处理时间戳';
