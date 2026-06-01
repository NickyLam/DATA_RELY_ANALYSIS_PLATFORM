/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_out_acct_lp_od_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cont_id varchar2(100) -- 合同编号
    ,text_cont_id varchar2(100) -- 文本合同编号
    ,cont_amt number(32,2) -- 合同金额
    ,od_cust_id varchar2(100) -- 透支客户编号
    ,od_acct_id varchar2(100) -- 透支账户编号
    ,od_cust_name varchar2(500) -- 透支客户名称
    ,od_sub_acct_num varchar2(60) -- 透支子账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,od_lmt number(30,6) -- 透支额度
    ,od_int_rat number(18,8) -- 透支利率
    ,start_od_amt number(30,6) -- 起透金额
    ,reval_way_cd varchar2(30) -- 重定价方式代码
    ,base_int_rat number(18,8) -- 基准利率
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,nomal_loan_exec_int_rat number(18,8) -- 正常贷款执行利率
    ,nomal_loan_float_int_rat number(24,8) -- 正常贷款浮动利率
    ,comm_fee_fee_rat number(24,8) -- 手续费费率
    ,od_promis_fee number(24,8) -- 透支承诺费用
    ,od_repay_way_cd varchar2(30) -- 透支还款方式代码
    ,recvbl_freq_cd varchar2(30) -- 收款频率代码
    ,charge_dt varchar2(10) -- 收费日
    ,sig_od_valid_days number(10) -- 单笔透支有效天数
    ,ovdue_exec_int_rat number(18,8) -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days number(10) -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt date -- 法透额度起始日期
    ,lp_od_lmt_exp_dt date -- 法透额度到期日期
    ,ovdue_loan_float_int_rat number(18,8) -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd varchar2(30) -- 法透不跨月标识代码
    ,lp_od_type_cd varchar2(30) -- 法人透支类型代码
    ,temp_store_flg varchar2(30) -- 暂存标志
    ,buid_bus_guar_loan_type_cd varchar2(30) -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg varchar2(10) -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg varchar2(10) -- 创业担保贷款标志
    ,nat_std_indus_dir_cd varchar2(30) -- 国标行业投向代码
    ,agclt_flg varchar2(10) -- 涉农贷款标志
    ,agclt_loan_main_type_cd varchar2(30) -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd varchar2(30) -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd varchar2(30) -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd varchar2(30) -- 贷款办理方式代码
    ,int_set_way_cd varchar2(30) -- 结息方式代码
    ,file_int_flg varchar2(10) -- 靠档利息标志
    ,cap_usage_descb varchar2(1000) -- 资金用途描述
    ,move_remark varchar2(500) -- 迁移备注
    ,rgst_dt date -- 登记日期
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,oper_dt date -- 经办日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,loan_org_id varchar2(100) -- 贷款机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,task_status_cd varchar2(30) -- 任务状态代码
    ,int_rat_float_ped varchar2(30) -- 利率浮动周期代码
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,comm_fee_charge_day varchar2(10) -- 手续费收费日
    ,comm_fee_coll_way_cd varchar2(30) -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd varchar2(30) -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg varchar2(10) -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd varchar2(30) -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd varchar2(30) -- 国民经济类型代码
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,risk_cls_rest_cd varchar2(60) -- 风险分类结果代码
    ,dmic_st_msg_send_cd varchar2(30) -- 业务提醒短信发送时机代码
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
grant select on ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h is '贷款出账法人透支附属信息历史';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.text_cont_id is '文本合同编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_cust_id is '透支客户编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_acct_id is '透支账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_cust_name is '透支客户名称';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_sub_acct_num is '透支子账号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_lmt is '透支额度';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_int_rat is '透支利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.start_od_amt is '起透金额';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.reval_way_cd is '重定价方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.base_int_rat is '基准利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.nomal_loan_exec_int_rat is '正常贷款执行利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.nomal_loan_float_int_rat is '正常贷款浮动利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.comm_fee_fee_rat is '手续费费率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_promis_fee is '透支承诺费用';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.od_repay_way_cd is '透支还款方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.recvbl_freq_cd is '收款频率代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.charge_dt is '收费日';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.sig_od_valid_days is '单笔透支有效天数';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.ovdue_exec_int_rat is '逾期执行利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_od_nacrsm_free_int_days is '法透不跨月免息天数';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_od_lmt_begin_dt is '法透额度起始日期';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_od_lmt_exp_dt is '法透额度到期日期';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.ovdue_loan_float_int_rat is '逾期贷款浮动利率';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_od_not_acrs_mon_idf_cd is '法透不跨月标识代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.lp_od_type_cd is '法人透支类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.temp_store_flg is '暂存标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.buid_bus_guar_loan_type_cd is '创业担保贷款类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.prior_use_acct_bal_flg is '优先使用账户余额标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.buid_bus_guar_loan_flg is '创业担保贷款标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.nat_std_indus_dir_cd is '国标行业投向代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.agclt_flg is '涉农贷款标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.agclt_loan_main_type_cd is '涉农贷款主体类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.agclt_loan_dir_cd is '涉农贷款用途类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.land_fin_plat_cap_src_cd is '地方融资平台偿债资金来源代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.pla_trast_way_cd is '贷款办理方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.int_set_way_cd is '结息方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.file_int_flg is '靠档利息标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.cap_usage_descb is '资金用途描述';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.loan_org_id is '贷款机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.task_status_cd is '任务状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.int_rat_float_ped is '利率浮动周期代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.comm_fee_charge_day is '手续费收费日';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.comm_fee_coll_way_cd is '手续费收取方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.comm_fee_charge_freq_cd is '手续费收费频率代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.natnal_econ_type_cd is '国民经济类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.risk_cls_rest_cd is '风险分类结果代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.dmic_st_msg_send_cd is '业务提醒短信发送时机代码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h.etl_timestamp is 'ETL处理时间戳';
