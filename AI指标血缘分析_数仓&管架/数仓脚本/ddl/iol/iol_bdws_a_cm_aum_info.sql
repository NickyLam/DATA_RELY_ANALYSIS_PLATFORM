/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cm_aum_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cm_aum_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cm_aum_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cm_aum_info(
    cust_id varchar2(4000) -- 客户ID
    ,cust_name varchar2(4000) -- 客户名称
    ,cur_acct_bal number(22,6) -- 活期存款余额
    ,dep_acct_bal number(22,6) -- 定期存款余额
    ,sdp_acct_bal number(22,6) -- 智能存款余额
    ,sdp_m_avg_bal number(22,6) -- 智能存款月日均
    ,sdp_y_avg_bal number(22,6) -- 智能存款年日均
    ,cur_y_cp_bal number(22,6) -- 活期存款较上年新增余额
    ,dept_acct_bal number(22,6) -- 零售存款余额（活期存款余额+定期存款余额）
    ,dept_acct_mavg number(22,6) -- 零售存款月日均
    ,insure_acct_bal number(22,6) -- 保险余额（包括理财系统提供的保险和CRM提供保险台账，只有承保的保险台账才计入AUM）
    ,fin_acct_bal number(22,6) -- 理财余额（保本理财余额+非保本理财余额，不包含分销理财余额）
    ,fin_acct_mavg number(22,6) -- 理财月日均
    ,fin_acct_yavg number(22,6) -- 理财年日均
    ,sr_acct_bal number(22,6) -- 非保本理财余额
    ,sr_acct_mavg number(22,6) -- 非保本理财月日均
    ,sr_acct_yavg number(22,6) -- 非保本理财年日均
    ,nsr_acct_bal number(22,6) -- 保本理财余额
    ,nsr_acct_mavg number(22,6) -- 保本理财月日均
    ,nsr_acct_yavg number(22,6) -- 保本理财年日均
    ,t0_sr_acct_bal number(22,6) -- T0非保本理财余额
    ,nt0_acct_bal number(22,6) -- 非T0理财余额
    ,fund_acct_bal number(22,6) -- 基金余额（统计认购成功、委托状态、在途的基金余额）
    ,fund_acct_mavg number(22,6) -- 基金月日均
    ,fund_acct_yavg number(22,6) -- 基金年日均
    ,mone_acct_bal number(22,6) -- 货币基金余额
    ,fmone_acct_bal number(22,6) -- 非货币基金余额
    ,metals_acct_bal number(22,6) -- 实物贵金属余额（统计客户名下生效的实物贵金属台账，数据由CRM提供）
    ,t_agent_acct_bal number(22,6) -- 第三方存管余额（第三方存管的保证金总金额）
    ,t_agent_acct_mavg number(22,6) -- 第三方存管月日均
    ,t_agent_acct_yavg number(22,6) -- 第三方存管年日均
    ,trust_acct_bal number(22,6) -- 资管信托余额（统计认购成功、委托状态、在途的基金余额）
    ,trust_acct_mavg number(22,6) -- 资管信托月日均
    ,trust_acct_yavg number(22,6) -- 资管信托年日均
    ,loan_acct_bal number(22,6) -- 零售贷款余额
    ,loan_acct_mavg number(22,6) -- 零售贷款月日均
    ,loan_acct_yavg number(22,6) -- 零售贷款年日均
    ,loan_consum_acct_bal number(22,6) -- 消费贷余额 贷款业务类型
    ,loan_business_acct_bal number(22,6) -- 经营贷余额
    ,loan_mortgage_acct_bal number(22,6) -- 按揭贷余额
    ,loan_other_acct_bal number(22,6) -- 其他贷款余额
    ,aum_acct_bal number(22,6) -- AUM余额（保险余额+基金余额+零售存款余额+理财余额+实物贵金属余额+第三方存管保证金余额+资管信托余额）
    ,aum_m_avg_bal number(22,6) -- AUM月均值
    ,aum_q_avg_bal number(22,6) -- AUM季均值
    ,aum_y_avg_bal number(22,6) -- AUM年均值
    ,aum_cp_d_bal number(22,6) -- AUM较昨日新增余额
    ,aum_cp_m_bal number(22,6) -- AUM较上月末新增余额
    ,aum_cp_y_bal number(22,6) -- AUM较上年末新增余额
    ,aum_cp_m_mavg number(22,6) -- AUM月均值较上月
    ,aum_cp_y_mavg number(22,6) -- AUM月均值较上年
    ,et_dt varchar2(4000) -- 数据日期
    ,sdp_q_avg_bal number(22,6) -- 智能存款季日均
    ,fin_acct_qavg number(22,6) -- 理财季日均
    ,nsr_acct_qavg number(22,6) -- 保本理财季日均
    ,sr_acct_qavg number(22,6) -- 非保本理财季日均
    ,t_agent_acct_qavg number(22,6) -- 第三方存管季日均
    ,trust_acct_qavg number(22,6) -- 资管信托季日均
    ,fund_acct_qavg number(22,6) -- 基金季日均
    ,insure_m_avg_bal number(22,6) -- 保险月日均
    ,aum_cp_q_mavg number(22,6) -- AUM季均值较上季度
    ,aum_cp_q_bal number(16,2) -- AUM较上季度末新增余额
    ,insure_y_avg_bal number(16,2) -- 保险余额年日均
    ,insure_q_avg_bal number(16,2) -- 保险余额季日均
    ,insure_cp_d_bal number(16,2) -- 保险余额比上日
    ,insure_cp_y_bal number(16,2) -- 保险余额比上年
    ,insure_cp_m_bal number(16,2) -- 保险余额比上月
    ,insure_cp_q_bal number(16,2) -- 保险余额比上季度
    ,insure_cp_y_avg number(16,2) -- 保险余额年均比上年
    ,insure_cp_q_avg number(16,2) -- 保险余额季均比上季度
    ,insure_cp_m_avg number(16,2) -- 保险余额月月均比上月
    ,mone_y_avg_bal number(16,2) -- 货币基金余额年日均
    ,mone_q_avg_bal number(16,2) -- 货币基金余额季日均
    ,mone_m_avg_bal number(16,2) -- 货币基金余额月日均
    ,mone_cp_d_bal number(16,2) -- 货币基金余额比上日
    ,mone_cp_y_bal number(16,2) -- 货币基金余额比上年
    ,mone_cp_m_bal number(16,2) -- 货币基金余额比上月
    ,mone_cp_q_bal number(16,2) -- 货币基金余额比上季度
    ,mone_cp_y_avg number(16,2) -- 货币基金余额年均比上年
    ,mone_cp_q_avg number(16,2) -- 货币基金余额季均比上季度
    ,mone_cp_m_avg number(16,2) -- 货币基金余额月均比上月
    ,dept_y_avg_bal number(16,2) -- 零售存款余额年日均
    ,dept_q_avg_bal number(16,2) -- 零售存款余额季日均
    ,dept_cp_d_bal number(16,2) -- 零售存款余额比上日
    ,dept_cp_y_bal number(16,2) -- 零售存款余额比上年
    ,dept_p_m_bal number(16,2) -- 
    ,dept_cp_m_bal number(16,2) -- 零售存款余额比上月
    ,dept_cp_q_bal number(16,2) -- 零售存款余额比上季度
    ,dept_cp_y_avg number(16,2) -- 零售存款余额年均比上年
    ,dept_cp_q_avg number(16,2) -- 零售存款余额季均比上季度
    ,dept_cp_m_avg number(16,2) -- 零售存款余额月均比上月
    ,t0_y_avg_bal number(22,6) -- T0理财年日均
    ,t0_q_avg_bal number(22,6) -- T0理财季日均
    ,t0_m_avg_bal number(22,6) -- T0理财月日均
    ,t0_cp_d_bal number(16,2) -- T0非保本理财余额比上日
    ,t0_cp_y_bal number(16,2) -- T0非保本理财余额比上年
    ,t0_cp_m_bal number(16,2) -- T0非保本理财余额比上月
    ,t0_cp_q_bal number(16,2) -- T0非保本理财余额比上季度
    ,t0_cp_y_avg number(16,2) -- T0非保本理财余额年均比上年
    ,t0_cp_q_avg number(16,2) -- T0非保本理财余额季均比上季度
    ,t0_cp_m_avg number(16,2) -- T0非保本理财余额月月均比上月
    ,nt0_y_avg_bal number(16,2) -- 非T0理财余额年日均
    ,nt0_q_avg_bal number(16,2) -- 非T0理财余额季日均
    ,nt0_m_avg_bal number(16,2) -- 非T0理财余额月日均
    ,nt0_cp_d_bal number(16,2) -- 非T0理财余额比上日
    ,nt0_cp_y_bal number(16,2) -- 非T0理财余额比上年
    ,nt0_cp_m_bal number(16,2) -- 非T0理财余额比上月
    ,nt0_cp_q_bal number(16,2) -- 非T0理财余额比上季度
    ,nt0_cp_y_avg number(16,2) -- 非T0理财余额年均比上年
    ,nt0_cp_q_avg number(16,2) -- 非T0理财余额季均比上季度
    ,nt0_cp_m_avg number(16,2) -- 非T0理财余额月月均比上月
    ,fund_cp_d_bal number(16,2) -- 基金余额比上日
    ,fund_cp_y_bal number(16,2) -- 基金余额比上年
    ,fund_cp_m_bal number(16,2) -- 基金余额比上月
    ,fund_cp_q_bal number(16,2) -- 基金余额比上季度
    ,fund_cp_y_avg number(16,2) -- 基金余额年均比上年
    ,fund_cp_q_avg number(16,2) -- 基金余额季均比上季度
    ,fund_cp_m_avg number(16,2) -- 基金余额月月均比上月
    ,trust_cp_d_bal number(16,2) -- 资管信托余额比上日
    ,trust_cp_y_bal number(16,2) -- 资管信托余额比上年
    ,trust_cp_m_bal number(16,2) -- 资管信托余额比上月
    ,trust_cp_q_bal number(16,2) -- 资管信托余额比上季度
    ,trust_cp_y_avg number(16,2) -- 资管信托余额年均比上年
    ,trust_cp_q_avg number(16,2) -- 资管信托余额季均比上季度
    ,trust_cp_m_avg number(16,2) -- 资管信托余额月月均比上月
    ,loan_q_avg_bal number(16,2) -- 零售贷款余额季日均
    ,loan_cp_d_bal number(16,2) -- 零售贷款余额比上日
    ,loan_cp_y_bal number(16,2) -- 零售贷款余额比上年
    ,loan_cp_m_bal number(16,2) -- 零售贷款余额比上月
    ,loan_cp_q_bal number(16,2) -- 零售贷款余额比上季度
    ,loan_cp_y_avg number(16,2) -- 零售贷款余额年均比上年
    ,loan_cp_q_avg number(16,2) -- 零售贷款余额季均比上季度
    ,loan_cp_m_avg number(16,2) -- 零售贷款余额月月均比上月
    ,fin_cp_d_bal number(16,2) -- 理财余额比上日
    ,fin_cp_y_bal number(16,2) -- 理财余额比上年
    ,fin_cp_m_bal number(16,2) -- 理财余额比上月
    ,fin_cp_q_bal number(16,2) -- 理财余额比上季度
    ,fin_cp_y_avg number(16,2) -- 理财余额年均比上年
    ,fin_cp_q_avg number(16,2) -- 理财余额季均比上季度
    ,fincp_m_avg number(16,2) -- 
    ,fin_cp_m_avg number(16,2) -- 理财余额月月均比上月
    ,metals_y_avg_bal number(16,2) -- 实物贵金属余额年日均
    ,metals_q_avg_bal number(16,2) -- 实物贵金属余额季日均
    ,metals_m_avg_bal number(16,2) -- 实物贵金属余额月日均
    ,metals_cp_d_bal number(16,2) -- 实物贵金属余额比上日
    ,metals_cp_y_bal number(16,2) -- 实物贵金属余额比上年
    ,metals_cp_m_bal number(16,2) -- 实物贵金属余额比上月
    ,metals_cp_q_bal number(16,2) -- 实物贵金属余额比上季度
    ,metals_cp_y_avg number(16,2) -- 实物贵金属余额年均比上年
    ,metals_cp_q_avg number(16,2) -- 实物贵金属余额季均比上季度
    ,metals_cp_m_avg number(16,2) -- 实物贵金属余额月月均比上月
    ,third_acct_bal number(16,2) -- 第三方存款保证金余额
    ,third_y_avg_bal number(16,2) -- 第三方存款保证余额年日均
    ,third_m_avg_bal number(16,2) -- 第三方存款保证余额月日均
    ,third_cp_d_bal number(16,2) -- 第三方存款保证余额比上日
    ,third_cp_y_bal number(16,2) -- 第三方存款保证余额比上年
    ,third_cp_m_bal number(16,2) -- 第三方存款保证余额比上月
    ,third_cp_q_bal number(16,2) -- 第三方存款保证余额比上季度
    ,third_cp_y_avg number(16,2) -- 第三方存款保证余额年均比上年
    ,third_cp_q_avg number(16,2) -- 第三方存款保证余额季均比上季度
    ,third_cp_m_avg number(16,2) -- 第三方存款保证余额月月均比上月
    ,cur_y_avg_bal number(16,2) -- 活期存款余额年日均
    ,cur_q_avg_bal number(16,2) -- 活期存款余额季日均
    ,cur_m_avg_bal number(16,2) -- 活期存款余额月日均
    ,dep_y_avg_bal number(16,2) -- 定期存款余额年日均
    ,dep_q_avg_bal number(16,2) -- 定期存款余额季日均
    ,dep_m_avg_bal number(16,2) -- 定期存款余额余月日均
    ,fmone_y_avg_bal number(16,2) -- 非货币基金余额年日均
    ,fmone_q_avg_bal number(16,2) -- 非货币基金余额季日均
    ,fmone_m_avg_bal number(16,2) -- 非货币基金余额余月日均
    ,asset_level varchar2(4000) -- 客户风险等级
    ,cur_acct_jz_bal number(16,2) -- 活期存款余额净增
    ,dep_acct_jz_bal number(16,2) -- 定期存款余额净增
    ,fin_acct_jz_bal number(16,2) -- 理财余额净增
    ,fund_acct_jz_bal number(16,2) -- 基金余额净增
    ,insure_acct_jz_bal number(16,2) -- 保险余额净增
    ,trust_acct_jz_bal number(16,2) -- 资管信托余额净增
    ,t_agent_acct_jz_bal number(16,2) -- 第三方存管余额净增
    ,metals_acct_jz_bal number(16,2) -- 实物贵金属余额净增
    ,sr_acct_jz_bal number(16,2) -- 非保本理财余额净增
    ,fmone_cp_d_bal number(16,2) -- 非货币基金余额比上日
    ,fmone_cp_m_bal number(16,2) -- 非货币基金余额比上月
    ,fmone_cp_q_bal number(16,2) -- 非货币基金余额比上季
    ,fmone_cp_y_bal number(16,2) -- 非货币基金余额比上年
    ,fmone_cp_m_avg number(16,2) -- 非货币基金月日均比上月
    ,fmone_cp_q_avg number(16,2) -- 非货币基金季日均比上季
    ,fmone_cp_y_avg number(16,2) -- 非货币基金年日均比上年
    ,new_acct_bal number(22,6) -- 新兴存余额
    ,new_m_avg_bal number(22,6) -- 新兴存月日均
    ,new_q_avg_bal number(22,6) -- 新兴存季日均
    ,new_y_avg_bal number(22,6) -- 新兴存年日均
    ,cds_acct_bal number(22,6) -- 大额存单余额
    ,cds_m_avg_bal number(22,6) -- 大额存单月日均
    ,cds_q_avg_bal number(22,6) -- 大额存单季日均
    ,cds_y_avg_bal number(22,6) -- 大额存单年日均
    ,decd_zr_sum number(22,6) -- 大额存单转让金额
    ,ensure_fee number(22,6) -- 保费金额
    ,lc_zr_bal number(22,6) -- 理财产品转让金额
    ,fin_lj_profit number(22,6) -- 客户基金累计收益
    ,fin_profit_ratio number(22,6) -- 客户基金浮动盈亏比率
    ,fin_fdyk number(22,6) -- 客户基金浮动盈亏
    ,aum_cp_y_yavg number(16,2) -- aum年均比上年
    ,cur_m_cp_bal number(22,6) -- 活期存款余额月净增
    ,cur_q_cp_bal number(22,6) -- 活期存款余额季净增
    ,dep_m_cp_bal number(22,6) -- 定期存款余额月净增
    ,dep_q_cp_bal number(22,6) -- 定期存款余额季净增
    ,dep_y_cp_bal number(22,6) -- 定期存款余额年净增
    ,dep_cp_m_avg number(22,6) -- 定期存款月日均月净增
    ,dep_cp_q_avg number(22,6) -- 定期存款季日均季净增
    ,dep_cp_y_avg number(22,6) -- 定期存款年日均年净增
    ,cds_m_cp_bal number(22,6) -- 大额存单余额月净增
    ,cds_q_cp_bal number(22,6) -- 大额存单余额季净增
    ,cds_y_cp_bal number(22,6) -- 大额存单余额年净增
    ,cds_cp_m_avg number(22,6) -- 大额存单月日均月净增
    ,cds_cp_q_avg number(22,6) -- 大额存单季日均季净增
    ,cds_cp_y_avg number(22,6) -- 大额存单年日均年净增
    ,nsr_m_cp_bal number(22,6) -- 保本理财余额月净增
    ,nsr_q_cp_bal number(22,6) -- 保本理财余额季净增
    ,nsr_y_cp_bal number(22,6) -- 保本理财余额年净增
    ,nsr_cp_m_avg number(22,6) -- 保本理财月日均月净增
    ,nsr_cp_q_avg number(22,6) -- 保本理财季日均季净增
    ,nsr_cp_y_avg number(22,6) -- 保本理财年日均年净增
    ,sr_m_cp_bal number(22,6) -- 非保本理财余额月净增
    ,sr_q_cp_bal number(22,6) -- 非保本理财余额季净增
    ,sr_y_cp_bal number(22,6) -- 非保本理财余额年净增
    ,sr_cp_m_avg number(22,6) -- 非保本理财月日均月净增
    ,sr_cp_q_avg number(22,6) -- 非保本理财季日均季净增
    ,sr_cp_y_avg number(22,6) -- 非保本理财年日均年净增
    ,fund_m_cp_bal number(22,6) -- 基金余额月净增
    ,fund_q_cp_bal number(22,6) -- 基金余额季净增
    ,fund_y_cp_bal number(22,6) -- 基金余额年净增
    ,t0_acct_bal number(22,6) -- T0理财余额
    ,rm_acct_bal number(22,6) -- 滚动理财余额
    ,rm_m_avg_bal number(22,6) -- 滚动理财月日均
    ,rm_q_avg_bal number(22,6) -- 滚动理财季日均
    ,rm_y_avg_bal number(22,6) -- 滚动理财年日均
    ,e_fund_acct_bal number(22,6) -- E基金余额
    ,e_fund_m_avg_bal number(22,6) -- E基金月日均
    ,e_fund_q_avg_bal number(22,6) -- E基金季日均
    ,e_fund_y_avg_bal number(22,6) -- E基金年日均
    ,depfinc_bal number(30,6) -- 零售存款余额
    ,depfinc_cpy_bal number(30,6) -- 零售存款余额年净增
    ,depfinc_cpq_bal number(30,6) -- 零售存款余额季净增
    ,depfinc_cpm_bal number(30,6) -- 零售存款余额月净增
    ,depfinc_cpd_bal number(30,6) -- 零售存款余额日净增
    ,depfinc_cpw_bal number(30,6) -- 零售存款余额周净增
    ,depfinc_avgm_bal number(30,6) -- 零售存款月日均
    ,depfinc_avgq_bal number(30,6) -- 零售存款季日均
    ,depfinc_avgy_bal number(30,6) -- 零售存款年日均
    ,depfinc_avgycpy_bal number(30,6) -- 零售存款年日均年净增
    ,depfinc_avgqcpq_bal number(30,6) -- 零售存款季日均季净增
    ,depfinc_avgmcpm_bal number(30,6) -- 零售存款月日均月净增
    ,aum_cp_w_bal number(30,6) -- AUM余额较上周
    ,fin_cp_w_bal number(30,6) -- 个人理财余额周净增
    ,sr_d_cp_bal number(30,6) -- 个人非保本理财余额日净增
    ,sr_w_cp_bal number(30,6) -- 个人非保本理财余额周净增
    ,trust_cp_w_bal number(30,6) -- 资管信托余额周净增
    ,fund_cp_w_bal number(30,6) -- 基金市值周净增
    ,insure_cp_w_bal number(30,6) -- 保险余额周净增
    ,metals_cp_w_bal number(30,6) -- 贵金属产品余额周净增
    ,asset_level1 varchar2(4000) -- 细分资产等级
    ,t0_sr_m_avg_bal number(22,6) -- T0非保本理财月日均
    ,t0_sr_q_avg_bal number(22,6) -- T0非保本理财季日均
    ,t0_sr_y_avg_bal number(22,6) -- T0非保本理财年日均
    ,ft_bal number(22,6) -- 家族信托余额
    ,ft_m_avg number(22,6) -- 家族信托余额月日均
    ,ft_q_avg number(22,6) -- 家族信托余额季日均
    ,ft_y_avg number(22,6) -- 家族信托余额年日均
    ,ft_cp_d_bal number(22,6) -- 家族信托余额比上日
    ,ft_cp_m_bal number(22,6) -- 家族信托余额比上月
    ,ft_cp_q_bal number(22,6) -- 家族信托余额比上季
    ,ft_cp_y_bal number(22,6) -- 家族信托余额比上年
    ,ft_cp_m_avg number(22,6) -- 家族信托余额月均比上月
    ,ft_cp_q_avg number(22,6) -- 家族信托余额季均比上季度
    ,ft_cp_y_avg number(22,6) -- 家族信托余额年均比上年
    ,zy_finc_bal number(22,6) -- 自营理财余额
    ,zy_m_avg_bal number(22,6) -- 自营理财月日均
    ,zy_q_avg_bal number(22,6) -- 自营理财季日均
    ,zy_y_avg_bal number(22,6) -- 自营理财年日均
    ,dx_finc_bal number(22,6) -- 代销理财余额
    ,dx_m_avg_bal number(22,6) -- 代销理财月日均
    ,dx_q_avg_bal number(22,6) -- 代销理财季日均
    ,dx_y_avg_bal number(22,6) -- 代销理财年日均
    ,sr_y_zy_finc_bal number(22,6) -- 自营理财余额年净增
    ,sr_q_zy_finc_bal number(22,6) -- 自营理财余额季净增
    ,sr_m_zy_finc_bal number(22,6) -- 自营理财余额月净增
    ,sr_d_zy_finc_bal number(22,6) -- 自营理财余额日净增
    ,sr_w_zy_finc_bal number(22,6) -- 自营理财余额周净增
    ,sr_y_dx_finc_bal number(22,6) -- 代销理财余额年净增
    ,sr_q_dx_finc_bal number(22,6) -- 代销理财余额季净增
    ,sr_m_dx_finc_bal number(22,6) -- 代销理财余额月净增
    ,sr_d_dx_finc_bal number(22,6) -- 代销理财余额日净增
    ,sr_w_dx_finc_bal number(22,6) -- 代销理财余额周净增
    ,sr_y_zy_y_avg_bal number(22,6) -- 自营理财年日均年净增
    ,sr_q_zy_q_avg_bal number(22,6) -- 自营理财季日均季净增
    ,sr_m_zy_m_avg_bal number(22,6) -- 自营理财月日均月净增
    ,sr_y_dx_y_avg_bal number(22,6) -- 代销理财年日均年净增
    ,sr_q_dx_q_avg_bal number(22,6) -- 代销理财季日均季净增
    ,sr_m_dx_m_avg_bal number(22,6) -- 代销理财月日均月净增
    ,new_cp_d_bal number(22,6) -- 新兴存余额比上日
    ,new_cp_m_bal number(22,6) -- 新兴存余额比上月
    ,new_cp_q_bal number(22,6) -- 新兴存余额比上季
    ,new_cp_y_bal number(22,6) -- 新兴存余额比上年
    ,new_cp_m_avg number(22,6) -- 新兴存月日均比上月
    ,new_cp_q_avg number(22,6) -- 新兴存季日均比上季
    ,new_cp_y_avg number(22,6) -- 新兴存年日均比上年
    ,t0_acct_cp_d_bal number(22,6) -- T0理财余额比上日
    ,t0_acct_cp_m_bal number(22,6) -- T0理财余额比上月
    ,t0_acct_cp_q_bal number(22,6) -- T0理财余额比上季
    ,t0_acct_cp_y_bal number(22,6) -- T0理财余额比上年
    ,t0_acct_cp_m_avg number(22,6) -- T0理财月日均比上月
    ,t0_acct_cp_q_avg number(22,6) -- T0理财季日均比上季
    ,t0_acct_cp_y_avg number(22,6) -- T0理财年日均比上年
    ,axc_acct_bal number(22,6) -- 安兴存余额
    ,axc_m_avg_bal number(22,6) -- 安兴存月日均
    ,axc_q_avg_bal number(22,6) -- 安兴存季日均
    ,axc_y_avg_bal number(22,6) -- 安兴存年日均
    ,axc_cp_d_bal number(22,6) -- 安兴存余额比上日
    ,axc_cp_m_bal number(22,6) -- 安兴存余额比上月
    ,axc_cp_q_bal number(22,6) -- 安兴存余额比上季
    ,axc_cp_y_bal number(22,6) -- 安兴存余额比上年
    ,axc_cp_m_avg number(22,6) -- 安兴存月日均比上月
    ,axc_cp_q_avg number(22,6) -- 安兴存季日均比上季
    ,axc_cp_y_avg number(22,6) -- 安兴存年日均比上年
    ,jsy_acct_bal number(22,6) -- 华兴结算盈余额
    ,jsy_m_avg_bal number(22,6) -- 华兴结算盈月日均
    ,jsy_q_avg_bal number(22,6) -- 华兴结算盈季日均
    ,jsy_y_avg_bal number(22,6) -- 华兴结算盈年日均
    ,jsy_cp_d_bal number(22,6) -- 华兴结算盈余额比上日
    ,jsy_cp_m_bal number(22,6) -- 华兴结算盈余额比上月
    ,jsy_cp_q_bal number(22,6) -- 华兴结算盈余额比上季
    ,jsy_cp_y_bal number(22,6) -- 华兴结算盈余额比上年
    ,jsy_cp_m_avg number(22,6) -- 华兴结算盈月日均比上月
    ,jsy_cp_q_avg number(22,6) -- 华兴结算盈季日均比上季
    ,jsy_cp_y_avg number(22,6) -- 华兴结算盈年日均比上年
    ,load_date varchar2(4000) -- 分区字段
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdws_a_cm_aum_info to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cm_aum_info to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cm_aum_info to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cm_aum_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cm_aum_info is '客户级金融资产汇总信息';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cust_id is '客户ID';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cust_name is '客户名称';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_acct_bal is '活期存款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_acct_bal is '定期存款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sdp_acct_bal is '智能存款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sdp_m_avg_bal is '智能存款月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sdp_y_avg_bal is '智能存款年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_y_cp_bal is '活期存款较上年新增余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_acct_bal is '零售存款余额（活期存款余额+定期存款余额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_acct_mavg is '零售存款月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_acct_bal is '保险余额（包括理财系统提供的保险和CRM提供保险台账，只有承保的保险台账才计入AUM）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_acct_bal is '理财余额（保本理财余额+非保本理财余额，不包含分销理财余额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_acct_mavg is '理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_acct_yavg is '理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_acct_bal is '非保本理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_acct_mavg is '非保本理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_acct_yavg is '非保本理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_acct_bal is '保本理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_acct_mavg is '保本理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_acct_yavg is '保本理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_sr_acct_bal is 'T0非保本理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_acct_bal is '非T0理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_acct_bal is '基金余额（统计认购成功、委托状态、在途的基金余额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_acct_mavg is '基金月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_acct_yavg is '基金年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_acct_bal is '货币基金余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_acct_bal is '非货币基金余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_acct_bal is '实物贵金属余额（统计客户名下生效的实物贵金属台账，数据由CRM提供）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t_agent_acct_bal is '第三方存管余额（第三方存管的保证金总金额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t_agent_acct_mavg is '第三方存管月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t_agent_acct_yavg is '第三方存管年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_acct_bal is '资管信托余额（统计认购成功、委托状态、在途的基金余额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_acct_mavg is '资管信托月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_acct_yavg is '资管信托年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_acct_bal is '零售贷款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_acct_mavg is '零售贷款月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_acct_yavg is '零售贷款年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_consum_acct_bal is '消费贷余额 贷款业务类型';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_business_acct_bal is '经营贷余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_mortgage_acct_bal is '按揭贷余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_other_acct_bal is '其他贷款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_acct_bal is 'AUM余额（保险余额+基金余额+零售存款余额+理财余额+实物贵金属余额+第三方存管保证金余额+资管信托余额）';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_m_avg_bal is 'AUM月均值';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_q_avg_bal is 'AUM季均值';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_y_avg_bal is 'AUM年均值';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_d_bal is 'AUM较昨日新增余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_m_bal is 'AUM较上月末新增余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_y_bal is 'AUM较上年末新增余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_m_mavg is 'AUM月均值较上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_y_mavg is 'AUM月均值较上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.et_dt is '数据日期';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sdp_q_avg_bal is '智能存款季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_acct_qavg is '理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_acct_qavg is '保本理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_acct_qavg is '非保本理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t_agent_acct_qavg is '第三方存管季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_acct_qavg is '资管信托季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_acct_qavg is '基金季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_m_avg_bal is '保险月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_q_mavg is 'AUM季均值较上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_q_bal is 'AUM较上季度末新增余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_y_avg_bal is '保险余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_q_avg_bal is '保险余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_d_bal is '保险余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_y_bal is '保险余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_m_bal is '保险余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_q_bal is '保险余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_y_avg is '保险余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_q_avg is '保险余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_m_avg is '保险余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_y_avg_bal is '货币基金余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_q_avg_bal is '货币基金余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_m_avg_bal is '货币基金余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_d_bal is '货币基金余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_y_bal is '货币基金余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_m_bal is '货币基金余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_q_bal is '货币基金余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_y_avg is '货币基金余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_q_avg is '货币基金余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.mone_cp_m_avg is '货币基金余额月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_y_avg_bal is '零售存款余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_q_avg_bal is '零售存款余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_d_bal is '零售存款余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_y_bal is '零售存款余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_p_m_bal is '';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_m_bal is '零售存款余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_q_bal is '零售存款余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_y_avg is '零售存款余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_q_avg is '零售存款余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dept_cp_m_avg is '零售存款余额月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_y_avg_bal is 'T0理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_q_avg_bal is 'T0理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_m_avg_bal is 'T0理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_d_bal is 'T0非保本理财余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_y_bal is 'T0非保本理财余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_m_bal is 'T0非保本理财余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_q_bal is 'T0非保本理财余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_y_avg is 'T0非保本理财余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_q_avg is 'T0非保本理财余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_cp_m_avg is 'T0非保本理财余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_y_avg_bal is '非T0理财余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_q_avg_bal is '非T0理财余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_m_avg_bal is '非T0理财余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_d_bal is '非T0理财余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_y_bal is '非T0理财余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_m_bal is '非T0理财余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_q_bal is '非T0理财余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_y_avg is '非T0理财余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_q_avg is '非T0理财余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nt0_cp_m_avg is '非T0理财余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_d_bal is '基金余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_y_bal is '基金余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_m_bal is '基金余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_q_bal is '基金余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_y_avg is '基金余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_q_avg is '基金余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_m_avg is '基金余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_d_bal is '资管信托余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_y_bal is '资管信托余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_m_bal is '资管信托余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_q_bal is '资管信托余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_y_avg is '资管信托余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_q_avg is '资管信托余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_m_avg is '资管信托余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_q_avg_bal is '零售贷款余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_d_bal is '零售贷款余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_y_bal is '零售贷款余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_m_bal is '零售贷款余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_q_bal is '零售贷款余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_y_avg is '零售贷款余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_q_avg is '零售贷款余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.loan_cp_m_avg is '零售贷款余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_d_bal is '理财余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_y_bal is '理财余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_m_bal is '理财余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_q_bal is '理财余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_y_avg is '理财余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_q_avg is '理财余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fincp_m_avg is '';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_m_avg is '理财余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_y_avg_bal is '实物贵金属余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_q_avg_bal is '实物贵金属余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_m_avg_bal is '实物贵金属余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_d_bal is '实物贵金属余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_y_bal is '实物贵金属余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_m_bal is '实物贵金属余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_q_bal is '实物贵金属余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_y_avg is '实物贵金属余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_q_avg is '实物贵金属余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_m_avg is '实物贵金属余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_acct_bal is '第三方存款保证金余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_y_avg_bal is '第三方存款保证余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_m_avg_bal is '第三方存款保证余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_d_bal is '第三方存款保证余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_y_bal is '第三方存款保证余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_m_bal is '第三方存款保证余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_q_bal is '第三方存款保证余额比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_y_avg is '第三方存款保证余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_q_avg is '第三方存款保证余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.third_cp_m_avg is '第三方存款保证余额月月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_y_avg_bal is '活期存款余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_q_avg_bal is '活期存款余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_m_avg_bal is '活期存款余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_y_avg_bal is '定期存款余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_q_avg_bal is '定期存款余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_m_avg_bal is '定期存款余额余月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_y_avg_bal is '非货币基金余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_q_avg_bal is '非货币基金余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_m_avg_bal is '非货币基金余额余月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.asset_level is '客户风险等级';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_acct_jz_bal is '活期存款余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_acct_jz_bal is '定期存款余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_acct_jz_bal is '理财余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_acct_jz_bal is '基金余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_acct_jz_bal is '保险余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_acct_jz_bal is '资管信托余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t_agent_acct_jz_bal is '第三方存管余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_acct_jz_bal is '实物贵金属余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_acct_jz_bal is '非保本理财余额净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_d_bal is '非货币基金余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_m_bal is '非货币基金余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_q_bal is '非货币基金余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_y_bal is '非货币基金余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_m_avg is '非货币基金月日均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_q_avg is '非货币基金季日均比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fmone_cp_y_avg is '非货币基金年日均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_acct_bal is '新兴存余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_m_avg_bal is '新兴存月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_q_avg_bal is '新兴存季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_y_avg_bal is '新兴存年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_acct_bal is '大额存单余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_m_avg_bal is '大额存单月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_q_avg_bal is '大额存单季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_y_avg_bal is '大额存单年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.decd_zr_sum is '大额存单转让金额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ensure_fee is '保费金额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.lc_zr_bal is '理财产品转让金额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_lj_profit is '客户基金累计收益';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_profit_ratio is '客户基金浮动盈亏比率';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_fdyk is '客户基金浮动盈亏';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_y_yavg is 'aum年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_m_cp_bal is '活期存款余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cur_q_cp_bal is '活期存款余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_m_cp_bal is '定期存款余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_q_cp_bal is '定期存款余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_y_cp_bal is '定期存款余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_cp_m_avg is '定期存款月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_cp_q_avg is '定期存款季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dep_cp_y_avg is '定期存款年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_m_cp_bal is '大额存单余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_q_cp_bal is '大额存单余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_y_cp_bal is '大额存单余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_cp_m_avg is '大额存单月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_cp_q_avg is '大额存单季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.cds_cp_y_avg is '大额存单年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_m_cp_bal is '保本理财余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_q_cp_bal is '保本理财余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_y_cp_bal is '保本理财余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_cp_m_avg is '保本理财月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_cp_q_avg is '保本理财季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.nsr_cp_y_avg is '保本理财年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_m_cp_bal is '非保本理财余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_q_cp_bal is '非保本理财余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_y_cp_bal is '非保本理财余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_cp_m_avg is '非保本理财月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_cp_q_avg is '非保本理财季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_cp_y_avg is '非保本理财年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_m_cp_bal is '基金余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_q_cp_bal is '基金余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_y_cp_bal is '基金余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_bal is 'T0理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.rm_acct_bal is '滚动理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.rm_m_avg_bal is '滚动理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.rm_q_avg_bal is '滚动理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.rm_y_avg_bal is '滚动理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.e_fund_acct_bal is 'E基金余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.e_fund_m_avg_bal is 'E基金月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.e_fund_q_avg_bal is 'E基金季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.e_fund_y_avg_bal is 'E基金年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_bal is '零售存款余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_cpy_bal is '零售存款余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_cpq_bal is '零售存款余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_cpm_bal is '零售存款余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_cpd_bal is '零售存款余额日净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_cpw_bal is '零售存款余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgm_bal is '零售存款月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgq_bal is '零售存款季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgy_bal is '零售存款年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgycpy_bal is '零售存款年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgqcpq_bal is '零售存款季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.depfinc_avgmcpm_bal is '零售存款月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.aum_cp_w_bal is 'AUM余额较上周';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fin_cp_w_bal is '个人理财余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_d_cp_bal is '个人非保本理财余额日净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_w_cp_bal is '个人非保本理财余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.trust_cp_w_bal is '资管信托余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.fund_cp_w_bal is '基金市值周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.insure_cp_w_bal is '保险余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.metals_cp_w_bal is '贵金属产品余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.asset_level1 is '细分资产等级';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_sr_m_avg_bal is 'T0非保本理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_sr_q_avg_bal is 'T0非保本理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_sr_y_avg_bal is 'T0非保本理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_bal is '家族信托余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_m_avg is '家族信托余额月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_q_avg is '家族信托余额季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_y_avg is '家族信托余额年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_d_bal is '家族信托余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_m_bal is '家族信托余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_q_bal is '家族信托余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_y_bal is '家族信托余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_m_avg is '家族信托余额月均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_q_avg is '家族信托余额季均比上季度';
comment on column ${iol_schema}.bdws_a_cm_aum_info.ft_cp_y_avg is '家族信托余额年均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.zy_finc_bal is '自营理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.zy_m_avg_bal is '自营理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.zy_q_avg_bal is '自营理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.zy_y_avg_bal is '自营理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dx_finc_bal is '代销理财余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dx_m_avg_bal is '代销理财月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dx_q_avg_bal is '代销理财季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.dx_y_avg_bal is '代销理财年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_y_zy_finc_bal is '自营理财余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_q_zy_finc_bal is '自营理财余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_m_zy_finc_bal is '自营理财余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_d_zy_finc_bal is '自营理财余额日净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_w_zy_finc_bal is '自营理财余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_y_dx_finc_bal is '代销理财余额年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_q_dx_finc_bal is '代销理财余额季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_m_dx_finc_bal is '代销理财余额月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_d_dx_finc_bal is '代销理财余额日净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_w_dx_finc_bal is '代销理财余额周净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_y_zy_y_avg_bal is '自营理财年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_q_zy_q_avg_bal is '自营理财季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_m_zy_m_avg_bal is '自营理财月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_y_dx_y_avg_bal is '代销理财年日均年净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_q_dx_q_avg_bal is '代销理财季日均季净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.sr_m_dx_m_avg_bal is '代销理财月日均月净增';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_d_bal is '新兴存余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_m_bal is '新兴存余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_q_bal is '新兴存余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_y_bal is '新兴存余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_m_avg is '新兴存月日均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_q_avg is '新兴存季日均比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.new_cp_y_avg is '新兴存年日均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_d_bal is 'T0理财余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_m_bal is 'T0理财余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_q_bal is 'T0理财余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_y_bal is 'T0理财余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_m_avg is 'T0理财月日均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_q_avg is 'T0理财季日均比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.t0_acct_cp_y_avg is 'T0理财年日均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_acct_bal is '安兴存余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_m_avg_bal is '安兴存月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_q_avg_bal is '安兴存季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_y_avg_bal is '安兴存年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_d_bal is '安兴存余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_m_bal is '安兴存余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_q_bal is '安兴存余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_y_bal is '安兴存余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_m_avg is '安兴存月日均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_q_avg is '安兴存季日均比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.axc_cp_y_avg is '安兴存年日均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_acct_bal is '华兴结算盈余额';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_m_avg_bal is '华兴结算盈月日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_q_avg_bal is '华兴结算盈季日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_y_avg_bal is '华兴结算盈年日均';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_d_bal is '华兴结算盈余额比上日';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_m_bal is '华兴结算盈余额比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_q_bal is '华兴结算盈余额比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_y_bal is '华兴结算盈余额比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_m_avg is '华兴结算盈月日均比上月';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_q_avg is '华兴结算盈季日均比上季';
comment on column ${iol_schema}.bdws_a_cm_aum_info.jsy_cp_y_avg is '华兴结算盈年日均比上年';
comment on column ${iol_schema}.bdws_a_cm_aum_info.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_cm_aum_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cm_aum_info.etl_timestamp is 'ETL处理时间戳';
