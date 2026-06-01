/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_cm_aum_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdws_a_cm_aum_info_ex purge;
alter table ${iol_schema}.bdws_a_cm_aum_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_a_cm_aum_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_a_cm_aum_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_a_cm_aum_info where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_a_cm_aum_info_ex(
    cust_id -- 客户ID
    ,cust_name -- 客户名称
    ,cur_acct_bal -- 活期存款余额
    ,dep_acct_bal -- 定期存款余额
    ,sdp_acct_bal -- 智能存款余额
    ,sdp_m_avg_bal -- 智能存款月日均
    ,sdp_y_avg_bal -- 智能存款年日均
    ,cur_y_cp_bal -- 活期存款较上年新增余额
    ,dept_acct_bal -- 零售存款余额（活期存款余额+定期存款余额）
    ,dept_acct_mavg -- 零售存款月日均
    ,insure_acct_bal -- 保险余额（包括理财系统提供的保险和CRM提供保险台账，只有承保的保险台账才计入AUM）
    ,fin_acct_bal -- 理财余额（保本理财余额+非保本理财余额，不包含分销理财余额）
    ,fin_acct_mavg -- 理财月日均
    ,fin_acct_yavg -- 理财年日均
    ,sr_acct_bal -- 非保本理财余额
    ,sr_acct_mavg -- 非保本理财月日均
    ,sr_acct_yavg -- 非保本理财年日均
    ,nsr_acct_bal -- 保本理财余额
    ,nsr_acct_mavg -- 保本理财月日均
    ,nsr_acct_yavg -- 保本理财年日均
    ,t0_sr_acct_bal -- T0非保本理财余额
    ,nt0_acct_bal -- 非T0理财余额
    ,fund_acct_bal -- 基金余额（统计认购成功、委托状态、在途的基金余额）
    ,fund_acct_mavg -- 基金月日均
    ,fund_acct_yavg -- 基金年日均
    ,mone_acct_bal -- 货币基金余额
    ,fmone_acct_bal -- 非货币基金余额
    ,metals_acct_bal -- 实物贵金属余额（统计客户名下生效的实物贵金属台账，数据由CRM提供）
    ,t_agent_acct_bal -- 第三方存管余额（第三方存管的保证金总金额）
    ,t_agent_acct_mavg -- 第三方存管月日均
    ,t_agent_acct_yavg -- 第三方存管年日均
    ,trust_acct_bal -- 资管信托余额（统计认购成功、委托状态、在途的基金余额）
    ,trust_acct_mavg -- 资管信托月日均
    ,trust_acct_yavg -- 资管信托年日均
    ,loan_acct_bal -- 零售贷款余额
    ,loan_acct_mavg -- 零售贷款月日均
    ,loan_acct_yavg -- 零售贷款年日均
    ,loan_consum_acct_bal -- 消费贷余额 贷款业务类型
    ,loan_business_acct_bal -- 经营贷余额
    ,loan_mortgage_acct_bal -- 按揭贷余额
    ,loan_other_acct_bal -- 其他贷款余额
    ,aum_acct_bal -- AUM余额（保险余额+基金余额+零售存款余额+理财余额+实物贵金属余额+第三方存管保证金余额+资管信托余额）
    ,aum_m_avg_bal -- AUM月均值
    ,aum_q_avg_bal -- AUM季均值
    ,aum_y_avg_bal -- AUM年均值
    ,aum_cp_d_bal -- AUM较昨日新增余额
    ,aum_cp_m_bal -- AUM较上月末新增余额
    ,aum_cp_y_bal -- AUM较上年末新增余额
    ,aum_cp_m_mavg -- AUM月均值较上月
    ,aum_cp_y_mavg -- AUM月均值较上年
    ,et_dt -- 数据日期
    ,sdp_q_avg_bal -- 智能存款季日均
    ,fin_acct_qavg -- 理财季日均
    ,nsr_acct_qavg -- 保本理财季日均
    ,sr_acct_qavg -- 非保本理财季日均
    ,t_agent_acct_qavg -- 第三方存管季日均
    ,trust_acct_qavg -- 资管信托季日均
    ,fund_acct_qavg -- 基金季日均
    ,insure_m_avg_bal -- 保险月日均
    ,aum_cp_q_mavg -- AUM季均值较上季度
    ,aum_cp_q_bal -- AUM较上季度末新增余额
    ,insure_y_avg_bal -- 保险余额年日均
    ,insure_q_avg_bal -- 保险余额季日均
    ,insure_cp_d_bal -- 保险余额比上日
    ,insure_cp_y_bal -- 保险余额比上年
    ,insure_cp_m_bal -- 保险余额比上月
    ,insure_cp_q_bal -- 保险余额比上季度
    ,insure_cp_y_avg -- 保险余额年均比上年
    ,insure_cp_q_avg -- 保险余额季均比上季度
    ,insure_cp_m_avg -- 保险余额月月均比上月
    ,mone_y_avg_bal -- 货币基金余额年日均
    ,mone_q_avg_bal -- 货币基金余额季日均
    ,mone_m_avg_bal -- 货币基金余额月日均
    ,mone_cp_d_bal -- 货币基金余额比上日
    ,mone_cp_y_bal -- 货币基金余额比上年
    ,mone_cp_m_bal -- 货币基金余额比上月
    ,mone_cp_q_bal -- 货币基金余额比上季度
    ,mone_cp_y_avg -- 货币基金余额年均比上年
    ,mone_cp_q_avg -- 货币基金余额季均比上季度
    ,mone_cp_m_avg -- 货币基金余额月均比上月
    ,dept_y_avg_bal -- 零售存款余额年日均
    ,dept_q_avg_bal -- 零售存款余额季日均
    ,dept_cp_d_bal -- 零售存款余额比上日
    ,dept_cp_y_bal -- 零售存款余额比上年
    ,dept_p_m_bal -- 
    ,dept_cp_m_bal -- 
    ,dept_cp_q_bal -- 
    ,dept_cp_y_avg -- 
    ,dept_cp_q_avg -- 
    ,dept_cp_m_avg -- 
    ,t0_y_avg_bal -- 
    ,t0_q_avg_bal -- 
    ,t0_m_avg_bal -- 
    ,t0_cp_d_bal -- 
    ,t0_cp_y_bal -- 
    ,t0_cp_m_bal -- 
    ,t0_cp_q_bal -- 
    ,t0_cp_y_avg -- 
    ,t0_cp_q_avg -- 
    ,t0_cp_m_avg -- 
    ,nt0_y_avg_bal -- 
    ,nt0_q_avg_bal -- 
    ,nt0_m_avg_bal -- 
    ,nt0_cp_d_bal -- 
    ,nt0_cp_y_bal -- 
    ,nt0_cp_m_bal -- 
    ,nt0_cp_q_bal -- 
    ,nt0_cp_y_avg -- 
    ,nt0_cp_q_avg -- 
    ,nt0_cp_m_avg -- 
    ,fund_cp_d_bal -- 
    ,fund_cp_y_bal -- 
    ,fund_cp_m_bal -- 
    ,fund_cp_q_bal -- 
    ,fund_cp_y_avg -- 
    ,fund_cp_q_avg -- 
    ,fund_cp_m_avg -- 
    ,trust_cp_d_bal -- 
    ,trust_cp_y_bal -- 
    ,trust_cp_m_bal -- 
    ,trust_cp_q_bal -- 
    ,trust_cp_y_avg -- 
    ,trust_cp_q_avg -- 
    ,trust_cp_m_avg -- 
    ,loan_q_avg_bal -- 
    ,loan_cp_d_bal -- 
    ,loan_cp_y_bal -- 
    ,loan_cp_m_bal -- 
    ,loan_cp_q_bal -- 
    ,loan_cp_y_avg -- 
    ,loan_cp_q_avg -- 
    ,loan_cp_m_avg -- 
    ,fin_cp_d_bal -- 
    ,fin_cp_y_bal -- 
    ,fin_cp_m_bal -- 
    ,fin_cp_q_bal -- 
    ,fin_cp_y_avg -- 
    ,fin_cp_q_avg -- 
    ,fincp_m_avg -- 
    ,fin_cp_m_avg -- 
    ,metals_y_avg_bal -- 
    ,metals_q_avg_bal -- 
    ,metals_m_avg_bal -- 
    ,metals_cp_d_bal -- 
    ,metals_cp_y_bal -- 
    ,metals_cp_m_bal -- 
    ,metals_cp_q_bal -- 
    ,metals_cp_y_avg -- 
    ,metals_cp_q_avg -- 
    ,metals_cp_m_avg -- 
    ,third_acct_bal -- 
    ,third_y_avg_bal -- 
    ,third_m_avg_bal -- 
    ,third_cp_d_bal -- 
    ,third_cp_y_bal -- 
    ,third_cp_m_bal -- 
    ,third_cp_q_bal -- 
    ,third_cp_y_avg -- 
    ,third_cp_q_avg -- 
    ,third_cp_m_avg -- 
    ,cur_y_avg_bal -- 
    ,cur_q_avg_bal -- 
    ,cur_m_avg_bal -- 
    ,dep_y_avg_bal -- 
    ,dep_q_avg_bal -- 
    ,dep_m_avg_bal -- 
    ,fmone_y_avg_bal -- 
    ,fmone_q_avg_bal -- 
    ,fmone_m_avg_bal -- 
    ,asset_level -- 
    ,cur_acct_jz_bal -- 
    ,dep_acct_jz_bal -- 
    ,fin_acct_jz_bal -- 
    ,fund_acct_jz_bal -- 
    ,insure_acct_jz_bal -- 
    ,trust_acct_jz_bal -- 
    ,t_agent_acct_jz_bal -- 
    ,metals_acct_jz_bal -- 
    ,sr_acct_jz_bal -- 
    ,fmone_cp_d_bal -- 
    ,fmone_cp_m_bal -- 
    ,fmone_cp_q_bal -- 
    ,fmone_cp_y_bal -- 
    ,fmone_cp_m_avg -- 
    ,fmone_cp_q_avg -- 
    ,fmone_cp_y_avg -- 
    ,new_acct_bal -- 
    ,new_m_avg_bal -- 
    ,new_q_avg_bal -- 
    ,new_y_avg_bal -- 
    ,cds_acct_bal -- 
    ,cds_m_avg_bal -- 
    ,cds_q_avg_bal -- 
    ,cds_y_avg_bal -- 
    ,decd_zr_sum -- 
    ,ensure_fee -- 
    ,lc_zr_bal -- 
    ,fin_lj_profit -- 
    ,fin_profit_ratio -- 
    ,fin_fdyk -- 
    ,aum_cp_y_yavg -- 
    ,cur_m_cp_bal -- 
    ,cur_q_cp_bal -- 
    ,dep_m_cp_bal -- 
    ,dep_q_cp_bal -- 
    ,dep_y_cp_bal -- 
    ,dep_cp_m_avg -- 
    ,dep_cp_q_avg -- 
    ,dep_cp_y_avg -- 
    ,cds_m_cp_bal -- 
    ,cds_q_cp_bal -- 
    ,cds_y_cp_bal -- 
    ,cds_cp_m_avg -- 
    ,cds_cp_q_avg -- 
    ,cds_cp_y_avg -- 
    ,nsr_m_cp_bal -- 
    ,nsr_q_cp_bal -- 
    ,nsr_y_cp_bal -- 
    ,nsr_cp_m_avg -- 
    ,nsr_cp_q_avg -- 
    ,nsr_cp_y_avg -- 
    ,sr_m_cp_bal -- 
    ,sr_q_cp_bal -- 
    ,sr_y_cp_bal -- 
    ,sr_cp_m_avg -- 
    ,sr_cp_q_avg -- 
    ,sr_cp_y_avg -- 
    ,fund_m_cp_bal -- 
    ,fund_q_cp_bal -- 
    ,fund_y_cp_bal -- 
    ,t0_acct_bal -- 
    ,rm_acct_bal -- 
    ,rm_m_avg_bal -- 
    ,rm_q_avg_bal -- 
    ,rm_y_avg_bal -- 
    ,e_fund_acct_bal -- 
    ,e_fund_m_avg_bal -- 
    ,e_fund_q_avg_bal -- 
    ,e_fund_y_avg_bal -- 
    ,depfinc_bal -- 
    ,depfinc_cpy_bal -- 
    ,depfinc_cpq_bal -- 
    ,depfinc_cpm_bal -- 
    ,depfinc_cpd_bal -- 
    ,depfinc_cpw_bal -- 
    ,depfinc_avgm_bal -- 
    ,depfinc_avgq_bal -- 
    ,depfinc_avgy_bal -- 
    ,depfinc_avgycpy_bal -- 
    ,depfinc_avgqcpq_bal -- 
    ,depfinc_avgmcpm_bal -- 
    ,aum_cp_w_bal -- 
    ,fin_cp_w_bal -- 
    ,sr_d_cp_bal -- 
    ,sr_w_cp_bal -- 
    ,trust_cp_w_bal -- 
    ,fund_cp_w_bal -- 
    ,insure_cp_w_bal -- 
    ,metals_cp_w_bal -- 
    ,asset_level1 -- 
    ,t0_sr_m_avg_bal -- 
    ,t0_sr_q_avg_bal -- 
    ,t0_sr_y_avg_bal -- 
    ,ft_bal -- 
    ,ft_m_avg -- 
    ,ft_q_avg -- 
    ,ft_y_avg -- 
    ,ft_cp_d_bal -- 
    ,ft_cp_m_bal -- 
    ,ft_cp_q_bal -- 
    ,ft_cp_y_bal -- 
    ,ft_cp_m_avg -- 
    ,ft_cp_q_avg -- 
    ,ft_cp_y_avg -- 
    ,zy_finc_bal -- 
    ,zy_m_avg_bal -- 
    ,zy_q_avg_bal -- 
    ,zy_y_avg_bal -- 
    ,dx_finc_bal -- 
    ,dx_m_avg_bal -- 
    ,dx_q_avg_bal -- 
    ,dx_y_avg_bal -- 
    ,sr_y_zy_finc_bal -- 
    ,sr_q_zy_finc_bal -- 
    ,sr_m_zy_finc_bal -- 
    ,sr_d_zy_finc_bal -- 
    ,sr_w_zy_finc_bal -- 
    ,sr_y_dx_finc_bal -- 
    ,sr_q_dx_finc_bal -- 
    ,sr_m_dx_finc_bal -- 
    ,sr_d_dx_finc_bal -- 
    ,sr_w_dx_finc_bal -- 
    ,sr_y_zy_y_avg_bal -- 
    ,sr_q_zy_q_avg_bal -- 
    ,sr_m_zy_m_avg_bal -- 
    ,sr_y_dx_y_avg_bal -- 
    ,sr_q_dx_q_avg_bal -- 
    ,sr_m_dx_m_avg_bal -- 
    ,new_cp_d_bal -- 
    ,new_cp_m_bal -- 
    ,new_cp_q_bal -- 
    ,new_cp_y_bal -- 
    ,new_cp_m_avg -- 
    ,new_cp_q_avg -- 
    ,new_cp_y_avg -- 
    ,t0_acct_cp_d_bal -- 
    ,t0_acct_cp_m_bal -- 
    ,t0_acct_cp_q_bal -- 
    ,t0_acct_cp_y_bal -- 
    ,t0_acct_cp_m_avg -- 
    ,t0_acct_cp_q_avg -- 
    ,t0_acct_cp_y_avg -- 
    ,axc_acct_bal -- 
    ,axc_m_avg_bal -- 
    ,axc_q_avg_bal -- 
    ,axc_y_avg_bal -- 
    ,axc_cp_d_bal -- 
    ,axc_cp_m_bal -- 
    ,axc_cp_q_bal -- 
    ,axc_cp_y_bal -- 
    ,axc_cp_m_avg -- 
    ,axc_cp_q_avg -- 
    ,axc_cp_y_avg -- 
    ,jsy_acct_bal -- 
    ,jsy_m_avg_bal -- 
    ,jsy_q_avg_bal -- 
    ,jsy_y_avg_bal -- 
    ,jsy_cp_d_bal -- 
    ,jsy_cp_m_bal -- 
    ,jsy_cp_q_bal -- 
    ,jsy_cp_y_bal -- 
    ,jsy_cp_m_avg -- 
    ,jsy_cp_q_avg -- 
    ,jsy_cp_y_avg -- 
    ,load_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_id -- 客户ID
    ,cust_name -- 客户名称
    ,cur_acct_bal -- 活期存款余额
    ,dep_acct_bal -- 定期存款余额
    ,sdp_acct_bal -- 智能存款余额
    ,sdp_m_avg_bal -- 智能存款月日均
    ,sdp_y_avg_bal -- 智能存款年日均
    ,cur_y_cp_bal -- 活期存款较上年新增余额
    ,dept_acct_bal -- 零售存款余额（活期存款余额+定期存款余额）
    ,dept_acct_mavg -- 零售存款月日均
    ,insure_acct_bal -- 保险余额（包括理财系统提供的保险和CRM提供保险台账，只有承保的保险台账才计入AUM）
    ,fin_acct_bal -- 理财余额（保本理财余额+非保本理财余额，不包含分销理财余额）
    ,fin_acct_mavg -- 理财月日均
    ,fin_acct_yavg -- 理财年日均
    ,sr_acct_bal -- 非保本理财余额
    ,sr_acct_mavg -- 非保本理财月日均
    ,sr_acct_yavg -- 非保本理财年日均
    ,nsr_acct_bal -- 保本理财余额
    ,nsr_acct_mavg -- 保本理财月日均
    ,nsr_acct_yavg -- 保本理财年日均
    ,t0_sr_acct_bal -- T0非保本理财余额
    ,nt0_acct_bal -- 非T0理财余额
    ,fund_acct_bal -- 基金余额（统计认购成功、委托状态、在途的基金余额）
    ,fund_acct_mavg -- 基金月日均
    ,fund_acct_yavg -- 基金年日均
    ,mone_acct_bal -- 货币基金余额
    ,fmone_acct_bal -- 非货币基金余额
    ,metals_acct_bal -- 实物贵金属余额（统计客户名下生效的实物贵金属台账，数据由CRM提供）
    ,t_agent_acct_bal -- 第三方存管余额（第三方存管的保证金总金额）
    ,t_agent_acct_mavg -- 第三方存管月日均
    ,t_agent_acct_yavg -- 第三方存管年日均
    ,trust_acct_bal -- 资管信托余额（统计认购成功、委托状态、在途的基金余额）
    ,trust_acct_mavg -- 资管信托月日均
    ,trust_acct_yavg -- 资管信托年日均
    ,loan_acct_bal -- 零售贷款余额
    ,loan_acct_mavg -- 零售贷款月日均
    ,loan_acct_yavg -- 零售贷款年日均
    ,loan_consum_acct_bal -- 消费贷余额 贷款业务类型
    ,loan_business_acct_bal -- 经营贷余额
    ,loan_mortgage_acct_bal -- 按揭贷余额
    ,loan_other_acct_bal -- 其他贷款余额
    ,aum_acct_bal -- AUM余额（保险余额+基金余额+零售存款余额+理财余额+实物贵金属余额+第三方存管保证金余额+资管信托余额）
    ,aum_m_avg_bal -- AUM月均值
    ,aum_q_avg_bal -- AUM季均值
    ,aum_y_avg_bal -- AUM年均值
    ,aum_cp_d_bal -- AUM较昨日新增余额
    ,aum_cp_m_bal -- AUM较上月末新增余额
    ,aum_cp_y_bal -- AUM较上年末新增余额
    ,aum_cp_m_mavg -- AUM月均值较上月
    ,aum_cp_y_mavg -- AUM月均值较上年
    ,et_dt -- 数据日期
    ,sdp_q_avg_bal -- 智能存款季日均
    ,fin_acct_qavg -- 理财季日均
    ,nsr_acct_qavg -- 保本理财季日均
    ,sr_acct_qavg -- 非保本理财季日均
    ,t_agent_acct_qavg -- 第三方存管季日均
    ,trust_acct_qavg -- 资管信托季日均
    ,fund_acct_qavg -- 基金季日均
    ,insure_m_avg_bal -- 保险月日均
    ,aum_cp_q_mavg -- AUM季均值较上季度
    ,aum_cp_q_bal -- AUM较上季度末新增余额
    ,insure_y_avg_bal -- 保险余额年日均
    ,insure_q_avg_bal -- 保险余额季日均
    ,insure_cp_d_bal -- 保险余额比上日
    ,insure_cp_y_bal -- 保险余额比上年
    ,insure_cp_m_bal -- 保险余额比上月
    ,insure_cp_q_bal -- 保险余额比上季度
    ,insure_cp_y_avg -- 保险余额年均比上年
    ,insure_cp_q_avg -- 保险余额季均比上季度
    ,insure_cp_m_avg -- 保险余额月月均比上月
    ,mone_y_avg_bal -- 货币基金余额年日均
    ,mone_q_avg_bal -- 货币基金余额季日均
    ,mone_m_avg_bal -- 货币基金余额月日均
    ,mone_cp_d_bal -- 货币基金余额比上日
    ,mone_cp_y_bal -- 货币基金余额比上年
    ,mone_cp_m_bal -- 货币基金余额比上月
    ,mone_cp_q_bal -- 货币基金余额比上季度
    ,mone_cp_y_avg -- 货币基金余额年均比上年
    ,mone_cp_q_avg -- 货币基金余额季均比上季度
    ,mone_cp_m_avg -- 货币基金余额月均比上月
    ,dept_y_avg_bal -- 零售存款余额年日均
    ,dept_q_avg_bal -- 零售存款余额季日均
    ,dept_cp_d_bal -- 零售存款余额比上日
    ,dept_cp_y_bal -- 零售存款余额比上年
    ,dept_p_m_bal -- 
    ,dept_cp_m_bal -- 
    ,dept_cp_q_bal -- 
    ,dept_cp_y_avg -- 
    ,dept_cp_q_avg -- 
    ,dept_cp_m_avg -- 
    ,t0_y_avg_bal -- 
    ,t0_q_avg_bal -- 
    ,t0_m_avg_bal -- 
    ,t0_cp_d_bal -- 
    ,t0_cp_y_bal -- 
    ,t0_cp_m_bal -- 
    ,t0_cp_q_bal -- 
    ,t0_cp_y_avg -- 
    ,t0_cp_q_avg -- 
    ,t0_cp_m_avg -- 
    ,nt0_y_avg_bal -- 
    ,nt0_q_avg_bal -- 
    ,nt0_m_avg_bal -- 
    ,nt0_cp_d_bal -- 
    ,nt0_cp_y_bal -- 
    ,nt0_cp_m_bal -- 
    ,nt0_cp_q_bal -- 
    ,nt0_cp_y_avg -- 
    ,nt0_cp_q_avg -- 
    ,nt0_cp_m_avg -- 
    ,fund_cp_d_bal -- 
    ,fund_cp_y_bal -- 
    ,fund_cp_m_bal -- 
    ,fund_cp_q_bal -- 
    ,fund_cp_y_avg -- 
    ,fund_cp_q_avg -- 
    ,fund_cp_m_avg -- 
    ,trust_cp_d_bal -- 
    ,trust_cp_y_bal -- 
    ,trust_cp_m_bal -- 
    ,trust_cp_q_bal -- 
    ,trust_cp_y_avg -- 
    ,trust_cp_q_avg -- 
    ,trust_cp_m_avg -- 
    ,loan_q_avg_bal -- 
    ,loan_cp_d_bal -- 
    ,loan_cp_y_bal -- 
    ,loan_cp_m_bal -- 
    ,loan_cp_q_bal -- 
    ,loan_cp_y_avg -- 
    ,loan_cp_q_avg -- 
    ,loan_cp_m_avg -- 
    ,fin_cp_d_bal -- 
    ,fin_cp_y_bal -- 
    ,fin_cp_m_bal -- 
    ,fin_cp_q_bal -- 
    ,fin_cp_y_avg -- 
    ,fin_cp_q_avg -- 
    ,fincp_m_avg -- 
    ,fin_cp_m_avg -- 
    ,metals_y_avg_bal -- 
    ,metals_q_avg_bal -- 
    ,metals_m_avg_bal -- 
    ,metals_cp_d_bal -- 
    ,metals_cp_y_bal -- 
    ,metals_cp_m_bal -- 
    ,metals_cp_q_bal -- 
    ,metals_cp_y_avg -- 
    ,metals_cp_q_avg -- 
    ,metals_cp_m_avg -- 
    ,third_acct_bal -- 
    ,third_y_avg_bal -- 
    ,third_m_avg_bal -- 
    ,third_cp_d_bal -- 
    ,third_cp_y_bal -- 
    ,third_cp_m_bal -- 
    ,third_cp_q_bal -- 
    ,third_cp_y_avg -- 
    ,third_cp_q_avg -- 
    ,third_cp_m_avg -- 
    ,cur_y_avg_bal -- 
    ,cur_q_avg_bal -- 
    ,cur_m_avg_bal -- 
    ,dep_y_avg_bal -- 
    ,dep_q_avg_bal -- 
    ,dep_m_avg_bal -- 
    ,fmone_y_avg_bal -- 
    ,fmone_q_avg_bal -- 
    ,fmone_m_avg_bal -- 
    ,asset_level -- 
    ,cur_acct_jz_bal -- 
    ,dep_acct_jz_bal -- 
    ,fin_acct_jz_bal -- 
    ,fund_acct_jz_bal -- 
    ,insure_acct_jz_bal -- 
    ,trust_acct_jz_bal -- 
    ,t_agent_acct_jz_bal -- 
    ,metals_acct_jz_bal -- 
    ,sr_acct_jz_bal -- 
    ,fmone_cp_d_bal -- 
    ,fmone_cp_m_bal -- 
    ,fmone_cp_q_bal -- 
    ,fmone_cp_y_bal -- 
    ,fmone_cp_m_avg -- 
    ,fmone_cp_q_avg -- 
    ,fmone_cp_y_avg -- 
    ,new_acct_bal -- 
    ,new_m_avg_bal -- 
    ,new_q_avg_bal -- 
    ,new_y_avg_bal -- 
    ,cds_acct_bal -- 
    ,cds_m_avg_bal -- 
    ,cds_q_avg_bal -- 
    ,cds_y_avg_bal -- 
    ,decd_zr_sum -- 
    ,ensure_fee -- 
    ,lc_zr_bal -- 
    ,fin_lj_profit -- 
    ,fin_profit_ratio -- 
    ,fin_fdyk -- 
    ,aum_cp_y_yavg -- 
    ,cur_m_cp_bal -- 
    ,cur_q_cp_bal -- 
    ,dep_m_cp_bal -- 
    ,dep_q_cp_bal -- 
    ,dep_y_cp_bal -- 
    ,dep_cp_m_avg -- 
    ,dep_cp_q_avg -- 
    ,dep_cp_y_avg -- 
    ,cds_m_cp_bal -- 
    ,cds_q_cp_bal -- 
    ,cds_y_cp_bal -- 
    ,cds_cp_m_avg -- 
    ,cds_cp_q_avg -- 
    ,cds_cp_y_avg -- 
    ,nsr_m_cp_bal -- 
    ,nsr_q_cp_bal -- 
    ,nsr_y_cp_bal -- 
    ,nsr_cp_m_avg -- 
    ,nsr_cp_q_avg -- 
    ,nsr_cp_y_avg -- 
    ,sr_m_cp_bal -- 
    ,sr_q_cp_bal -- 
    ,sr_y_cp_bal -- 
    ,sr_cp_m_avg -- 
    ,sr_cp_q_avg -- 
    ,sr_cp_y_avg -- 
    ,fund_m_cp_bal -- 
    ,fund_q_cp_bal -- 
    ,fund_y_cp_bal -- 
    ,t0_acct_bal -- 
    ,rm_acct_bal -- 
    ,rm_m_avg_bal -- 
    ,rm_q_avg_bal -- 
    ,rm_y_avg_bal -- 
    ,e_fund_acct_bal -- 
    ,e_fund_m_avg_bal -- 
    ,e_fund_q_avg_bal -- 
    ,e_fund_y_avg_bal -- 
    ,depfinc_bal -- 
    ,depfinc_cpy_bal -- 
    ,depfinc_cpq_bal -- 
    ,depfinc_cpm_bal -- 
    ,depfinc_cpd_bal -- 
    ,depfinc_cpw_bal -- 
    ,depfinc_avgm_bal -- 
    ,depfinc_avgq_bal -- 
    ,depfinc_avgy_bal -- 
    ,depfinc_avgycpy_bal -- 
    ,depfinc_avgqcpq_bal -- 
    ,depfinc_avgmcpm_bal -- 
    ,aum_cp_w_bal -- 
    ,fin_cp_w_bal -- 
    ,sr_d_cp_bal -- 
    ,sr_w_cp_bal -- 
    ,trust_cp_w_bal -- 
    ,fund_cp_w_bal -- 
    ,insure_cp_w_bal -- 
    ,metals_cp_w_bal -- 
    ,asset_level1 -- 
    ,t0_sr_m_avg_bal -- 
    ,t0_sr_q_avg_bal -- 
    ,t0_sr_y_avg_bal -- 
    ,ft_bal -- 
    ,ft_m_avg -- 
    ,ft_q_avg -- 
    ,ft_y_avg -- 
    ,ft_cp_d_bal -- 
    ,ft_cp_m_bal -- 
    ,ft_cp_q_bal -- 
    ,ft_cp_y_bal -- 
    ,ft_cp_m_avg -- 
    ,ft_cp_q_avg -- 
    ,ft_cp_y_avg -- 
    ,zy_finc_bal -- 
    ,zy_m_avg_bal -- 
    ,zy_q_avg_bal -- 
    ,zy_y_avg_bal -- 
    ,dx_finc_bal -- 
    ,dx_m_avg_bal -- 
    ,dx_q_avg_bal -- 
    ,dx_y_avg_bal -- 
    ,sr_y_zy_finc_bal -- 
    ,sr_q_zy_finc_bal -- 
    ,sr_m_zy_finc_bal -- 
    ,sr_d_zy_finc_bal -- 
    ,sr_w_zy_finc_bal -- 
    ,sr_y_dx_finc_bal -- 
    ,sr_q_dx_finc_bal -- 
    ,sr_m_dx_finc_bal -- 
    ,sr_d_dx_finc_bal -- 
    ,sr_w_dx_finc_bal -- 
    ,sr_y_zy_y_avg_bal -- 
    ,sr_q_zy_q_avg_bal -- 
    ,sr_m_zy_m_avg_bal -- 
    ,sr_y_dx_y_avg_bal -- 
    ,sr_q_dx_q_avg_bal -- 
    ,sr_m_dx_m_avg_bal -- 
    ,new_cp_d_bal -- 
    ,new_cp_m_bal -- 
    ,new_cp_q_bal -- 
    ,new_cp_y_bal -- 
    ,new_cp_m_avg -- 
    ,new_cp_q_avg -- 
    ,new_cp_y_avg -- 
    ,t0_acct_cp_d_bal -- 
    ,t0_acct_cp_m_bal -- 
    ,t0_acct_cp_q_bal -- 
    ,t0_acct_cp_y_bal -- 
    ,t0_acct_cp_m_avg -- 
    ,t0_acct_cp_q_avg -- 
    ,t0_acct_cp_y_avg -- 
    ,axc_acct_bal -- 
    ,axc_m_avg_bal -- 
    ,axc_q_avg_bal -- 
    ,axc_y_avg_bal -- 
    ,axc_cp_d_bal -- 
    ,axc_cp_m_bal -- 
    ,axc_cp_q_bal -- 
    ,axc_cp_y_bal -- 
    ,axc_cp_m_avg -- 
    ,axc_cp_q_avg -- 
    ,axc_cp_y_avg -- 
    ,jsy_acct_bal -- 
    ,jsy_m_avg_bal -- 
    ,jsy_q_avg_bal -- 
    ,jsy_y_avg_bal -- 
    ,jsy_cp_d_bal -- 
    ,jsy_cp_m_bal -- 
    ,jsy_cp_q_bal -- 
    ,jsy_cp_y_bal -- 
    ,jsy_cp_m_avg -- 
    ,jsy_cp_q_avg -- 
    ,jsy_cp_y_avg -- 
    ,load_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_a_cm_aum_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_a_cm_aum_info exchange partition p_${batch_date} with table ${iol_schema}.bdws_a_cm_aum_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_a_cm_aum_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_a_cm_aum_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_a_cm_aum_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);