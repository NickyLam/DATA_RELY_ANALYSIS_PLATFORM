/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rcrs_acc_loan
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.rcrs_acc_loan drop partition p_${last_date};
alter table ${idl_schema}.rcrs_acc_loan drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rcrs_acc_loan add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rcrs_acc_loan (
    etl_dt  -- 数据日期
    ,bill_no  -- 借据号
    ,cont_no  -- 合同编号
    ,cn_cont_no  -- 中文合同编号
    ,prd_pk  -- 产品主键
    ,biz_type  -- 产品编号
    ,prd_name  -- 产品名称
    ,prd_type  -- 产品类型
    ,cus_id  -- 客户编号
    ,cus_name  -- 客户名称
    ,biz_type_sub  -- 业务品种
    ,account_class  -- 业务品种名称
    ,loan_account  -- 贷款账号
    ,loan_form  -- 贷款形式
    ,loan_nature  -- 贷款性质
    ,loan_type_ext  -- 关联交易类型
    ,assure_means_main  -- 主担保方式
    ,assure_means2  -- 主担保方式2
    ,assure_means3  -- 主担保方式3
    ,cur_type  -- 币种
    ,loan_amount  -- 借据金额
    ,loan_balance  -- 借据余额
    ,loan_start_date  -- 贷款起始日
    ,loan_end_date  -- 贷款终止日
    ,term_type  -- 期限类型
    ,orig_expi_date  -- 原到期日期
    ,ruling_ir  -- 基准利率(月)
    ,floating_rate  -- 利率浮动值
    ,reality_ir_y  -- 执行月利率
    ,overdue_rate  -- 逾期利率浮动比
    ,overdue_ir  -- 逾期加月利率
    ,default_rate  -- 挤占挪用利率浮动比例
    ,default_ir  -- 违约月利率
    ,ci_rate  -- 复利加罚率
    ,ci_ir  -- 复利月利率
    ,rece_int_cumu  -- 应收利息累计
    ,actual_int_cumu  -- 实收利息累计
    ,delay_int_cumu  -- 欠息累计
    ,inner_int_cumu  -- 表内欠息
    ,off_int_cumu  -- 表外欠息
    ,inner_rece_int  -- 表内应收
    ,overdue_rece_int  -- 逾期应收
    ,off_rece_int  -- 表外利息应收
    ,compound_rece_int  -- 利息复息应收
    ,inner_off_rece_int  -- 表内转表外利息应收
    ,inner_actl_int  -- 表内实收
    ,overdue_actl_int  -- 逾期实收
    ,off_actl_int  -- 表外利息实收
    ,compound_actl_int  -- 利息复息实收
    ,inner_off_actl_int  -- 表内转表外利息实收
    ,normal_balance  -- 正常贷款余额(元)
    ,overdue_balance  -- 逾期贷款余额(元)
    ,sluggish_balance  -- 呆滞贷款余额(元)
    ,doubtful_balance  -- 呆账贷款余额(元)
    ,integral_y  -- 积数_年
    ,integral_q  -- 积数_季
    ,integral_m  -- 积数_月
    ,nor_rec_accu  -- 正常回收累计
    ,reo_rec_accu  -- 资产重组累计
    ,peel_rec_accu  -- 资产剥离累计
    ,asset_rec_accu  -- 以资抵债累计
    ,assure_rec_accu  -- 担保代偿累计
    ,cancel_rec_accu  -- 核损核销累计
    ,policy_rec_accu  -- 政策性还款累计
    ,dte_rec_accu  -- 债转股累计
    ,roll_rec_accu  -- 转出累计
    ,max_balance_y  -- 本年最高余额
    ,max_balance_q  -- 本季最高余额
    ,max_balance_m  -- 本月最高余额
    ,mortgage_flg  -- 按揭标识
    ,repayment_mode  -- 还款方式
    ,first_disb_date  -- 首次放款日期
    ,loan_direction  -- 贷款投向
    ,revolving_times  -- 借新还旧次数
    ,extension_times  -- 展期次数
    ,cap_overdue_date  -- 本金逾期起始日期
    ,int_overdue_date  -- 利息逾期起始日期
    ,over_times_current  -- 当前逾期期数
    ,over_times_total  -- 累计逾期期数
    ,max_times_total  -- 最高逾期期数
    ,bad_loan_flag  -- 转不良标志
    ,default_flag  -- 违约标识
    ,limit_ind  -- 授信额度使用标志
    ,loan_form4  -- 四级分类标志
    ,cla  -- 五级分类结果
    ,cla_date  -- 五级分类完成日期
    ,cla_pre  -- 上期五级分类结果
    ,cla_date_pre  -- 上期五级分类完成日期
    ,latest_repay_date  -- 最近还款日期
    ,cus_manager  -- 客户经理
    ,input_br_id  -- 录入机构
    ,fina_br_id  -- 账务机构
    ,main_br_id  -- 主管机构
    ,settl_date  -- 结清日期
    ,latest_date  -- 最近修改日期
    ,account_status  -- 台帐状态
    ,biz_type_detail  -- 业务品种名称
    ,int_rate_type  -- 利率类型
    ,int_rate_inc_opt  -- 利率增量选项
    ,int_rate_inc  -- 利率增量
    ,fixed_rate  -- 固定利率
    ,prd_userdf_name  -- 产品自定义名称
    ,prd_userdf_type  -- 产品自定义类别
    ,syndicated_ind  -- 银团标识
    ,unpd_int_arr_prn  -- 应收利息的罚息(应收未收)
    ,unpd_arrs_int_bal  -- 拖欠本金的罚息(应收未收)
    ,unpd_arr_prn_bal  -- 应收复利(应收未收)
    ,act_int_arr_prn  -- 实收利息的罚息
    ,act_arrs_int_bal  -- 实收拖欠本金的罚息
    ,act_arr_prn_bal  -- 实收复利
    ,gl_class  -- 科目号
    ,iscircle  -- 循环贷款标识
    ,return_date  -- 还款日
    ,act_write_off_int_rec  -- 实收待核销利息
    ,unpd_write_off_int_rec  -- 应收待核销利息
    ,unpd_prin_bal  -- 拖欠本金
    ,remark  -- 备注
    ,consign_fund_protocol_no  -- 资金协议号
    ,psp_task_crt_date  -- 贷后检查任务生成日期
    ,psp_task_cpt_date  -- 贷后检查任务完成日期
    ,rsc_task_crt_date  -- 五级分类任务生成日期
    ,com_scale  -- 企业规模
    ,cus_type  -- 客户类型
    ,opt_cus_mgr  -- 托管客户经理
    ,ten_cla  -- 十级分类结果
    ,ten_cla_pre  -- 上期十级分类结果
    ,loan_card_ind  -- 使用农户贷款证标志
    ,agriculture_type  -- 涉农情况
    ,agriculture_use  -- 涉农用途
    ,minor_entrp_range  -- 小企业统计口径(银监)
    ,government_ind  -- 涉政类型
    ,government_org_attribute  -- 涉政机构属性
    ,government_platform  -- 是否为涉政平台
    ,overdue_type  -- 逾期利率浮动类型
    ,default_type  -- 挤占利率浮动类型
    ,ir_exe_type  -- 利率变更生效方式
    ,guarantora_grp_ind  -- 联保贷款标志
    ,jz  -- 
    ,core_account_status  -- 
    ,interest_date  -- 结息日
    ,join_role  -- 参与角色：01牵头行 02代理行   03参与行
    ,syndicated_type  -- 银/社团类型： 01银团  02社团
    ,lead_arranger_ind  -- 是否主办行：1 是 2 否
    ,machine_cla_result  -- 
    ,machine_ten_cla_result  -- 
    ,period_ind  -- 
    ,period_term  -- 
    ,period_type  -- 
    ,distance_term  -- 调整间隔期
    ,proportion_scale  -- 增减单位(%)
    ,devalue_sign  -- 贷款减值标志
    ,accrue_money  -- 计提金额
    ,cla_cf  -- 五级分类初分结果
    ,cla_cf_date  -- 五级分类初分日期
    ,cla_cf_pre  -- 上期五级分类初分结果
    ,cla_cf_date_pre  -- 上期五级分类初分日期
    ,ten_cla_cf  -- 十级分类初分结果
    ,ten_cla_cf_date  -- 十级分类初分日期
    ,ten_cla_cf_pre  -- 上期十级分类初分结果
    ,ten_cla_cf_date_pre  -- 上期十级分类初分日期
    ,rsc_task_crt_date_pre  -- 上期五级任务生成日期
    ,ten_rsc_task_crt_date  -- 十级分类任务生成日期
    ,ten_rsc_task_crt_date_pre  -- 上期十级任务生成日期
    ,ten_cla_date  -- 十级分类完成日期
    ,ten_cla_date_pre  -- 上期十级分类完成日期
    ,rsc_model_id  -- 风险分类认定模型
    ,rsc_model_id_cf  -- 风险分类初分模型编号
    ,rsc_model_name  -- 风险分类认定模型名称
    ,rsc_model_name_cf  -- 风险分类初分模型名称
    ,auto_rate_reason  -- 五级分类初分理由
    ,auto_ten_rate_reason  -- 十级分类初分理由
    ,cla_rp  -- 五级分类结果(报表统计)
    ,ten_cla_rp  -- 十级分类结果(报表统计)
    ,int_repayment_total  -- 
    ,cap_repayment_curmonth  -- 
    ,int_repayment_curmonth  -- 
    ,inner_int_repayment_total  -- 
    ,inner_int_curmonth  -- 
    ,off_int_repayment_total  -- 
    ,off_int_repayment_curmonth  -- 
    ,repla_repayment_total  -- 
    ,repla_repayment_curmonth  -- 
    ,wrpff_prin_repayment_total  -- 
    ,wrpff_repayment_curmonth  -- 
    ,is_company  -- 
    ,cla_rp_lastyear  -- 
    ,cla_rp_lastmonth  -- 
    ,cla_rp_lastquarter  -- 
    ,ten_cla_rp_lastyear  -- 
    ,ten_cla_rp_lastmonth  -- 
    ,ten_cla_rp_lastquarter  -- 
    ,cap_overdue_days  -- 本金逾期天数
    ,int_overdue_days  -- 
    ,max_overdue_days  -- 
    ,use_dec  -- 借款用途
    ,loan_balance_lastyear_end  -- 
    ,repayment_account  -- 
    ,precalcintdate  -- 上次结息日期
    ,tourism_flag  -- 
    ,delay_deduct_type  -- 扣款方式
    ,moweput  -- 本月本金累放
    ,qoweput  -- 本季本金累放
    ,yoweput  -- 本年本金累放
    ,moweaccept  -- 本月本金累收
    ,qoweaccept  -- 本季本金累收
    ,yoweaccept  -- 本年本金累收
    ,mintaccept  -- 本月利息累收
    ,qintaccept  -- 本季利息累收
    ,yintaccept  -- 本年利息累收
    ,mshloudint  -- 本月应收利息
    ,qshloudint  -- 本季应收利息
    ,yshloudint  -- 本年应收利息
    ,pay_way  -- 支付方式
    ,src_account  -- 公积金贷款账号
    ,repayment_acc_name  -- 结算账户名称
    ,ir_floating_term  -- 利率浮动期限
    ,cancel_date  -- 核销日期
    ,input_id  -- 登记人
    ,last_upd_date  -- 
    ,cap_repayment_total  -- 
    ,enter_account  -- 入账账号
    ,enter_account_name  -- 入账账户名称
    ,interest_acc_mode  -- 结息方式
    ,enter_account_type  -- 入账账户支付工具类型
    ,repayment_account_type  -- 还款账户支付工具类型
    ,create_user_id  -- 创建台账用户id
    ,ir_adjust_mode  -- 利率调整方式
    ,ten_cla_ind  -- 十级分类人工干预标志
    ,is_cl  -- 
    ,is_balloon  -- 是否选择气球贷
    ,last_term_amount  -- 最后一期保留金额
    ,cla_fina_update_id  -- 风险分类终审人
    ,cla_update_reason  -- 最近一次风险分类调整原因
    ,inner_account  -- 内部账户
    ,interest  -- 利息
    ,penalty_interest  -- 罚息
    ,recipe  -- 复息
    ,advance_payment  -- 垫付费用
    ,debts_status  -- 呆账核销状态
    ,off_balance_interest  -- 表外利息
    ,inner_balance_interest  -- 表内利息
    ,asset_three_type_cd  -- 业务模式 AC - AC模式-持有以收取合同现金流 FVOCI - FVOCI模式-既收取合同现金流量又可以出售
    ,rate_type  -- 利率类型
    ,zxz_flag  -- 0：待审批，1：有效，2：失效
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.bill_no,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.cont_no,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.cn_cont_no,chr(13),''),chr(10),'')  -- 中文合同编号
    ,replace(replace(t1.prd_pk,chr(13),''),chr(10),'')  -- 产品主键
    ,replace(replace(t1.biz_type,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.prd_name,chr(13),''),chr(10),'')  -- 产品名称
    ,replace(replace(t1.prd_type,chr(13),''),chr(10),'')  -- 产品类型
    ,replace(replace(t1.cus_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cus_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.biz_type_sub,chr(13),''),chr(10),'')  -- 业务品种
    ,replace(replace(t1.account_class,chr(13),''),chr(10),'')  -- 业务品种名称
    ,replace(replace(t1.loan_account,chr(13),''),chr(10),'')  -- 贷款账号
    ,replace(replace(t1.loan_form,chr(13),''),chr(10),'')  -- 贷款形式
    ,replace(replace(t1.loan_nature,chr(13),''),chr(10),'')  -- 贷款性质
    ,replace(replace(t1.loan_type_ext,chr(13),''),chr(10),'')  -- 关联交易类型
    ,replace(replace(t1.assure_means_main,chr(13),''),chr(10),'')  -- 主担保方式
    ,replace(replace(t1.assure_means2,chr(13),''),chr(10),'')  -- 主担保方式2
    ,replace(replace(t1.assure_means3,chr(13),''),chr(10),'')  -- 主担保方式3
    ,replace(replace(t1.cur_type,chr(13),''),chr(10),'')  -- 币种
    ,t1.loan_amount  -- 借据金额
    ,t1.loan_balance  -- 借据余额
    ,replace(replace(t1.loan_start_date,chr(13),''),chr(10),'')  -- 贷款起始日
    ,replace(replace(t1.loan_end_date,chr(13),''),chr(10),'')  -- 贷款终止日
    ,replace(replace(t1.term_type,chr(13),''),chr(10),'')  -- 期限类型
    ,replace(replace(t1.orig_expi_date,chr(13),''),chr(10),'')  -- 原到期日期
    ,t1.ruling_ir  -- 基准利率(月)
    ,t1.floating_rate  -- 利率浮动值
    ,t1.reality_ir_y  -- 执行月利率
    ,t1.overdue_rate  -- 逾期利率浮动比
    ,t1.overdue_ir  -- 逾期加月利率
    ,t1.default_rate  -- 挤占挪用利率浮动比例
    ,t1.default_ir  -- 违约月利率
    ,t1.ci_rate  -- 复利加罚率
    ,t1.ci_ir  -- 复利月利率
    ,t1.rece_int_cumu  -- 应收利息累计
    ,t1.actual_int_cumu  -- 实收利息累计
    ,t1.delay_int_cumu  -- 欠息累计
    ,t1.inner_int_cumu  -- 表内欠息
    ,t1.off_int_cumu  -- 表外欠息
    ,t1.inner_rece_int  -- 表内应收
    ,t1.overdue_rece_int  -- 逾期应收
    ,t1.off_rece_int  -- 表外利息应收
    ,t1.compound_rece_int  -- 利息复息应收
    ,t1.inner_off_rece_int  -- 表内转表外利息应收
    ,t1.inner_actl_int  -- 表内实收
    ,t1.overdue_actl_int  -- 逾期实收
    ,t1.off_actl_int  -- 表外利息实收
    ,t1.compound_actl_int  -- 利息复息实收
    ,t1.inner_off_actl_int  -- 表内转表外利息实收
    ,t1.normal_balance  -- 正常贷款余额(元)
    ,t1.overdue_balance  -- 逾期贷款余额(元)
    ,t1.sluggish_balance  -- 呆滞贷款余额(元)
    ,t1.doubtful_balance  -- 呆账贷款余额(元)
    ,t1.integral_y  -- 积数_年
    ,t1.integral_q  -- 积数_季
    ,t1.integral_m  -- 积数_月
    ,t1.nor_rec_accu  -- 正常回收累计
    ,t1.reo_rec_accu  -- 资产重组累计
    ,t1.peel_rec_accu  -- 资产剥离累计
    ,t1.asset_rec_accu  -- 以资抵债累计
    ,t1.assure_rec_accu  -- 担保代偿累计
    ,t1.cancel_rec_accu  -- 核损核销累计
    ,t1.policy_rec_accu  -- 政策性还款累计
    ,t1.dte_rec_accu  -- 债转股累计
    ,t1.roll_rec_accu  -- 转出累计
    ,t1.max_balance_y  -- 本年最高余额
    ,t1.max_balance_q  -- 本季最高余额
    ,t1.max_balance_m  -- 本月最高余额
    ,replace(replace(t1.mortgage_flg,chr(13),''),chr(10),'')  -- 按揭标识
    ,replace(replace(t1.repayment_mode,chr(13),''),chr(10),'')  -- 还款方式
    ,replace(replace(t1.first_disb_date,chr(13),''),chr(10),'')  -- 首次放款日期
    ,replace(replace(t1.loan_direction,chr(13),''),chr(10),'')  -- 贷款投向
    ,t1.revolving_times  -- 借新还旧次数
    ,t1.extension_times  -- 展期次数
    ,replace(replace(t1.cap_overdue_date,chr(13),''),chr(10),'')  -- 本金逾期起始日期
    ,replace(replace(t1.int_overdue_date,chr(13),''),chr(10),'')  -- 利息逾期起始日期
    ,t1.over_times_current  -- 当前逾期期数
    ,t1.over_times_total  -- 累计逾期期数
    ,t1.max_times_total  -- 最高逾期期数
    ,replace(replace(t1.bad_loan_flag,chr(13),''),chr(10),'')  -- 转不良标志
    ,replace(replace(t1.default_flag,chr(13),''),chr(10),'')  -- 违约标识
    ,replace(replace(t1.limit_ind,chr(13),''),chr(10),'')  -- 授信额度使用标志
    ,replace(replace(t1.loan_form4,chr(13),''),chr(10),'')  -- 四级分类标志
    ,replace(replace(t1.cla,chr(13),''),chr(10),'')  -- 五级分类结果
    ,replace(replace(t1.cla_date,chr(13),''),chr(10),'')  -- 五级分类完成日期
    ,replace(replace(t1.cla_pre,chr(13),''),chr(10),'')  -- 上期五级分类结果
    ,replace(replace(t1.cla_date_pre,chr(13),''),chr(10),'')  -- 上期五级分类完成日期
    ,replace(replace(t1.latest_repay_date,chr(13),''),chr(10),'')  -- 最近还款日期
    ,replace(replace(t1.cus_manager,chr(13),''),chr(10),'')  -- 客户经理
    ,replace(replace(t1.input_br_id,chr(13),''),chr(10),'')  -- 录入机构
    ,replace(replace(t1.fina_br_id,chr(13),''),chr(10),'')  -- 账务机构
    ,replace(replace(t1.main_br_id,chr(13),''),chr(10),'')  -- 主管机构
    ,replace(replace(t1.settl_date,chr(13),''),chr(10),'')  -- 结清日期
    ,replace(replace(t1.latest_date,chr(13),''),chr(10),'')  -- 最近修改日期
    ,replace(replace(t1.account_status,chr(13),''),chr(10),'')  -- 台帐状态
    ,replace(replace(t1.biz_type_detail,chr(13),''),chr(10),'')  -- 业务品种名称
    ,replace(replace(t1.int_rate_type,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.int_rate_inc_opt,chr(13),''),chr(10),'')  -- 利率增量选项
    ,t1.int_rate_inc  -- 利率增量
    ,t1.fixed_rate  -- 固定利率
    ,replace(replace(t1.prd_userdf_name,chr(13),''),chr(10),'')  -- 产品自定义名称
    ,replace(replace(t1.prd_userdf_type,chr(13),''),chr(10),'')  -- 产品自定义类别
    ,replace(replace(t1.syndicated_ind,chr(13),''),chr(10),'')  -- 银团标识
    ,t1.unpd_int_arr_prn  -- 应收利息的罚息(应收未收)
    ,t1.unpd_arrs_int_bal  -- 拖欠本金的罚息(应收未收)
    ,t1.unpd_arr_prn_bal  -- 应收复利(应收未收)
    ,t1.act_int_arr_prn  -- 实收利息的罚息
    ,t1.act_arrs_int_bal  -- 实收拖欠本金的罚息
    ,t1.act_arr_prn_bal  -- 实收复利
    ,replace(replace(t1.gl_class,chr(13),''),chr(10),'')  -- 科目号
    ,replace(replace(t1.iscircle,chr(13),''),chr(10),'')  -- 循环贷款标识
    ,replace(replace(t1.return_date,chr(13),''),chr(10),'')  -- 还款日
    ,t1.act_write_off_int_rec  -- 实收待核销利息
    ,t1.unpd_write_off_int_rec  -- 应收待核销利息
    ,t1.unpd_prin_bal  -- 拖欠本金
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.consign_fund_protocol_no,chr(13),''),chr(10),'')  -- 资金协议号
    ,replace(replace(t1.psp_task_crt_date,chr(13),''),chr(10),'')  -- 贷后检查任务生成日期
    ,replace(replace(t1.psp_task_cpt_date,chr(13),''),chr(10),'')  -- 贷后检查任务完成日期
    ,replace(replace(t1.rsc_task_crt_date,chr(13),''),chr(10),'')  -- 五级分类任务生成日期
    ,replace(replace(t1.com_scale,chr(13),''),chr(10),'')  -- 企业规模
    ,replace(replace(t1.cus_type,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(t1.opt_cus_mgr,chr(13),''),chr(10),'')  -- 托管客户经理
    ,replace(replace(t1.ten_cla,chr(13),''),chr(10),'')  -- 十级分类结果
    ,replace(replace(t1.ten_cla_pre,chr(13),''),chr(10),'')  -- 上期十级分类结果
    ,replace(replace(t1.loan_card_ind,chr(13),''),chr(10),'')  -- 使用农户贷款证标志
    ,replace(replace(t1.agriculture_type,chr(13),''),chr(10),'')  -- 涉农情况
    ,replace(replace(t1.agriculture_use,chr(13),''),chr(10),'')  -- 涉农用途
    ,replace(replace(t1.minor_entrp_range,chr(13),''),chr(10),'')  -- 小企业统计口径(银监)
    ,replace(replace(t1.government_ind,chr(13),''),chr(10),'')  -- 涉政类型
    ,replace(replace(t1.government_org_attribute,chr(13),''),chr(10),'')  -- 涉政机构属性
    ,replace(replace(t1.government_platform,chr(13),''),chr(10),'')  -- 是否为涉政平台
    ,replace(replace(t1.overdue_type,chr(13),''),chr(10),'')  -- 逾期利率浮动类型
    ,replace(replace(t1.default_type,chr(13),''),chr(10),'')  -- 挤占利率浮动类型
    ,replace(replace(t1.ir_exe_type,chr(13),''),chr(10),'')  -- 利率变更生效方式
    ,replace(replace(t1.guarantora_grp_ind,chr(13),''),chr(10),'')  -- 联保贷款标志
    ,replace(replace(t1.jz,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.core_account_status,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interest_date,chr(13),''),chr(10),'')  -- 结息日
    ,replace(replace(t1.join_role,chr(13),''),chr(10),'')  -- 参与角色：01牵头行 02代理行   03参与行
    ,replace(replace(t1.syndicated_type,chr(13),''),chr(10),'')  -- 银/社团类型： 01银团  02社团
    ,replace(replace(t1.lead_arranger_ind,chr(13),''),chr(10),'')  -- 是否主办行：1 是 2 否
    ,replace(replace(t1.machine_cla_result,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.machine_ten_cla_result,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.period_ind,chr(13),''),chr(10),'')  -- 
    ,t1.period_term  -- 
    ,replace(replace(t1.period_type,chr(13),''),chr(10),'')  -- 
    ,t1.distance_term  -- 调整间隔期
    ,t1.proportion_scale  -- 增减单位(%)
    ,replace(replace(t1.devalue_sign,chr(13),''),chr(10),'')  -- 贷款减值标志
    ,t1.accrue_money  -- 计提金额
    ,replace(replace(t1.cla_cf,chr(13),''),chr(10),'')  -- 五级分类初分结果
    ,replace(replace(t1.cla_cf_date,chr(13),''),chr(10),'')  -- 五级分类初分日期
    ,replace(replace(t1.cla_cf_pre,chr(13),''),chr(10),'')  -- 上期五级分类初分结果
    ,replace(replace(t1.cla_cf_date_pre,chr(13),''),chr(10),'')  -- 上期五级分类初分日期
    ,replace(replace(t1.ten_cla_cf,chr(13),''),chr(10),'')  -- 十级分类初分结果
    ,replace(replace(t1.ten_cla_cf_date,chr(13),''),chr(10),'')  -- 十级分类初分日期
    ,replace(replace(t1.ten_cla_cf_pre,chr(13),''),chr(10),'')  -- 上期十级分类初分结果
    ,replace(replace(t1.ten_cla_cf_date_pre,chr(13),''),chr(10),'')  -- 上期十级分类初分日期
    ,replace(replace(t1.rsc_task_crt_date_pre,chr(13),''),chr(10),'')  -- 上期五级任务生成日期
    ,replace(replace(t1.ten_rsc_task_crt_date,chr(13),''),chr(10),'')  -- 十级分类任务生成日期
    ,replace(replace(t1.ten_rsc_task_crt_date_pre,chr(13),''),chr(10),'')  -- 上期十级任务生成日期
    ,replace(replace(t1.ten_cla_date,chr(13),''),chr(10),'')  -- 十级分类完成日期
    ,replace(replace(t1.ten_cla_date_pre,chr(13),''),chr(10),'')  -- 上期十级分类完成日期
    ,replace(replace(t1.rsc_model_id,chr(13),''),chr(10),'')  -- 风险分类认定模型
    ,replace(replace(t1.rsc_model_id_cf,chr(13),''),chr(10),'')  -- 风险分类初分模型编号
    ,replace(replace(t1.rsc_model_name,chr(13),''),chr(10),'')  -- 风险分类认定模型名称
    ,replace(replace(t1.rsc_model_name_cf,chr(13),''),chr(10),'')  -- 风险分类初分模型名称
    ,replace(replace(t1.auto_rate_reason,chr(13),''),chr(10),'')  -- 五级分类初分理由
    ,replace(replace(t1.auto_ten_rate_reason,chr(13),''),chr(10),'')  -- 十级分类初分理由
    ,replace(replace(t1.cla_rp,chr(13),''),chr(10),'')  -- 五级分类结果(报表统计)
    ,replace(replace(t1.ten_cla_rp,chr(13),''),chr(10),'')  -- 十级分类结果(报表统计)
    ,t1.int_repayment_total  -- 
    ,t1.cap_repayment_curmonth  -- 
    ,t1.int_repayment_curmonth  -- 
    ,t1.inner_int_repayment_total  -- 
    ,t1.inner_int_curmonth  -- 
    ,t1.off_int_repayment_total  -- 
    ,t1.off_int_repayment_curmonth  -- 
    ,t1.repla_repayment_total  -- 
    ,t1.repla_repayment_curmonth  -- 
    ,t1.wrpff_prin_repayment_total  -- 
    ,t1.wrpff_repayment_curmonth  -- 
    ,replace(replace(t1.is_company,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cla_rp_lastyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cla_rp_lastmonth,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cla_rp_lastquarter,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ten_cla_rp_lastyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ten_cla_rp_lastmonth,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ten_cla_rp_lastquarter,chr(13),''),chr(10),'')  -- 
    ,t1.cap_overdue_days  -- 本金逾期天数
    ,t1.int_overdue_days  -- 
    ,t1.max_overdue_days  -- 
    ,replace(replace(t1.use_dec,chr(13),''),chr(10),'')  -- 借款用途
    ,t1.loan_balance_lastyear_end  -- 
    ,replace(replace(t1.repayment_account,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.precalcintdate,chr(13),''),chr(10),'')  -- 上次结息日期
    ,replace(replace(t1.tourism_flag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.delay_deduct_type,chr(13),''),chr(10),'')  -- 扣款方式
    ,t1.moweput  -- 本月本金累放
    ,t1.qoweput  -- 本季本金累放
    ,t1.yoweput  -- 本年本金累放
    ,t1.moweaccept  -- 本月本金累收
    ,t1.qoweaccept  -- 本季本金累收
    ,t1.yoweaccept  -- 本年本金累收
    ,t1.mintaccept  -- 本月利息累收
    ,t1.qintaccept  -- 本季利息累收
    ,t1.yintaccept  -- 本年利息累收
    ,t1.mshloudint  -- 本月应收利息
    ,t1.qshloudint  -- 本季应收利息
    ,t1.yshloudint  -- 本年应收利息
    ,replace(replace(t1.pay_way,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.src_account,chr(13),''),chr(10),'')  -- 公积金贷款账号
    ,replace(replace(t1.repayment_acc_name,chr(13),''),chr(10),'')  -- 结算账户名称
    ,replace(replace(t1.ir_floating_term,chr(13),''),chr(10),'')  -- 利率浮动期限
    ,replace(replace(t1.cancel_date,chr(13),''),chr(10),'')  -- 核销日期
    ,replace(replace(t1.input_id,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.last_upd_date,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cap_repayment_total,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.enter_account,chr(13),''),chr(10),'')  -- 入账账号
    ,replace(replace(t1.enter_account_name,chr(13),''),chr(10),'')  -- 入账账户名称
    ,replace(replace(t1.interest_acc_mode,chr(13),''),chr(10),'')  -- 结息方式
    ,replace(replace(t1.enter_account_type,chr(13),''),chr(10),'')  -- 入账账户支付工具类型
    ,replace(replace(t1.repayment_account_type,chr(13),''),chr(10),'')  -- 还款账户支付工具类型
    ,replace(replace(t1.create_user_id,chr(13),''),chr(10),'')  -- 创建台账用户id
    ,replace(replace(t1.ir_adjust_mode,chr(13),''),chr(10),'')  -- 利率调整方式
    ,replace(replace(t1.ten_cla_ind,chr(13),''),chr(10),'')  -- 十级分类人工干预标志
    ,replace(replace(t1.is_cl,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.is_balloon,chr(13),''),chr(10),'')  -- 是否选择气球贷
    ,t1.last_term_amount  -- 最后一期保留金额
    ,replace(replace(t1.cla_fina_update_id,chr(13),''),chr(10),'')  -- 风险分类终审人
    ,replace(replace(t1.cla_update_reason,chr(13),''),chr(10),'')  -- 最近一次风险分类调整原因
    ,replace(replace(t1.inner_account,chr(13),''),chr(10),'')  -- 内部账户
    ,t1.interest  -- 利息
    ,t1.penalty_interest  -- 罚息
    ,t1.recipe  -- 复息
    ,t1.advance_payment  -- 垫付费用
    ,replace(replace(t1.debts_status,chr(13),''),chr(10),'')  -- 呆账核销状态
    ,t1.off_balance_interest  -- 表外利息
    ,t1.inner_balance_interest  -- 表内利息
    ,replace(replace(t1.asset_three_type_cd,chr(13),''),chr(10),'')  -- 业务模式    AC - AC模式-持有以收取合同现金流  FVOCI - FVOCI模式-既收取合同现金流量又可以出售
    ,replace(replace(t1.rate_type,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.zxz_flag,chr(13),''),chr(10),'')  -- 0：待审批，1：有效，2：失效
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rcrs_acc_loan t1    --贷款台账
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rcrs_acc_loan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);