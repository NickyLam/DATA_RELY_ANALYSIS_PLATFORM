/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharefinancialindicator
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
drop table ${iol_schema}.wind_asharefinancialindicator_ex purge;
alter table ${iol_schema}.wind_asharefinancialindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.wind_asharefinancialindicator;

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_asharefinancialindicator_ex nologging
compress
as
select * from ${iol_schema}.wind_asharefinancialindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_asharefinancialindicator_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,wind_code -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,crncy_code -- 货币代码
    ,s_fa_extraordinary -- 非经常性损益
    ,s_fa_deductedprofit -- 扣除非经常性损益后的净利润
    ,s_fa_grossmargin -- 毛利
    ,s_fa_operateincome -- 经营活动净收益
    ,s_fa_investincome -- 价值变动净收益
    ,s_stmnote_finexp -- 利息费用
    ,s_stm_is -- 折旧与摊销
    ,s_fa_ebit -- 息税前利润
    ,s_fa_ebitda -- 息税折旧摊销前利润
    ,s_fa_fcff -- 企业自由现金流量(FCFF)
    ,s_fa_fcfe -- 股权自由现金流量(FCFE)
    ,s_fa_exinterestdebt_current -- 无息流动负债
    ,s_fa_exinterestdebt_noncurrent -- 无息非流动负债
    ,s_fa_interestdebt -- 带息债务
    ,s_fa_netdebt -- 净债务
    ,s_fa_tangibleasset -- 有形资产
    ,s_fa_workingcapital -- 营运资金
    ,s_fa_networkingcapital -- 营运流动资本
    ,s_fa_investcapital -- 全部投入资本
    ,s_fa_retainedearnings -- 留存收益
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,s_fa_eps_diluted2 -- 期末摊薄每股收益
    ,s_fa_bps -- 每股净资产
    ,s_fa_ocfps -- 每股经营活动产生的现金流量净额
    ,s_fa_grps -- 每股营业总收入
    ,s_fa_orps -- 每股营业收入
    ,s_fa_surpluscapitalps -- 每股资本公积
    ,s_fa_surplusreserveps -- 每股盈余公积
    ,s_fa_undistributedps -- 每股未分配利润
    ,s_fa_retainedps -- 每股留存收益
    ,s_fa_cfps -- 每股现金流量净额
    ,s_fa_ebitps -- 每股息税前利润
    ,s_fa_fcffps -- 每股企业自由现金流量
    ,s_fa_fcfeps -- 每股股东自由现金流量
    ,s_fa_netprofitmargin -- 销售净利率
    ,s_fa_grossprofitmargin -- 销售毛利率
    ,s_fa_cogstosales -- 销售成本率
    ,s_fa_expensetosales -- 销售期间费用率
    ,s_fa_profittogr -- 净利润/营业总收入
    ,s_fa_saleexpensetogr -- 销售费用/营业总收入
    ,s_fa_adminexpensetogr -- 管理费用/营业总收入
    ,s_fa_finaexpensetogr -- 财务费用/营业总收入
    ,s_fa_impairtogr_ttm -- 资产减值损失/营业总收入
    ,s_fa_gctogr -- 营业总成本/营业总收入
    ,s_fa_optogr -- 营业利润/营业总收入
    ,s_fa_ebittogr -- 息税前利润/营业总收入
    ,s_fa_roe -- 净资产收益率
    ,s_fa_roe_deducted -- 净资产收益率(扣除非经常损益)
    ,s_fa_roa2 -- 总资产报酬率
    ,s_fa_roa -- 总资产净利润
    ,s_fa_roic -- 投入资本回报率
    ,s_fa_roe_yearly -- 年化净资产收益率
    ,s_fa_roa2_yearly -- 年化总资产报酬率
    ,s_fa_roe_avg -- 平均净资产收益率(增发条件)
    ,s_fa_operateincometoebt -- 经营活动净收益/利润总额
    ,s_fa_investincometoebt -- 价值变动净收益/利润总额
    ,s_fa_nonoperateprofittoebt -- 营业外收支净额/利润总额
    ,s_fa_taxtoebt -- 所得税/利润总额
    ,s_fa_deductedprofittoprofit -- 扣除非经常损益后的净利润/净利润
    ,s_fa_salescashintoor -- 销售商品提供劳务收到的现金/营业收入
    ,s_fa_ocftoor -- 经营活动产生的现金流量净额/营业收入
    ,s_fa_ocftooperateincome -- 经营活动产生的现金流量净额/经营活动净收益
    ,s_fa_capitalizedtoda -- 资本支出/折旧和摊销
    ,s_fa_debttoassets -- 资产负债率
    ,s_fa_assetstoequity -- 权益乘数
    ,s_fa_dupont_assetstoequity -- 权益乘数(用于杜邦分析)
    ,s_fa_catoassets -- 流动资产/总资产
    ,s_fa_ncatoassets -- 非流动资产/总资产
    ,s_fa_tangibleassetstoassets -- 有形资产/总资产
    ,s_fa_intdebttototalcap -- 带息债务/全部投入资本
    ,s_fa_equitytototalcapital -- 归属于母公司的股东权益/全部投入资本
    ,s_fa_currentdebttodebt -- 流动负债/负债合计
    ,s_fa_longdebtodebt -- 非流动负债/负债合计
    ,s_fa_current -- 流动比率
    ,s_fa_quick -- 速动比率
    ,s_fa_cashratio -- 保守速动比率
    ,s_fa_ocftoshortdebt -- 经营活动产生的现金流量净额/流动负债
    ,s_fa_debttoequity -- 产权比率
    ,s_fa_equitytodebt -- 归属于母公司的股东权益/负债合计
    ,s_fa_equitytointerestdebt -- 归属于母公司的股东权益/带息债务
    ,s_fa_tangibleassettodebt -- 有形资产/负债合计
    ,s_fa_tangassettointdebt -- 有形资产/带息债务
    ,s_fa_tangibleassettonetdebt -- 有形资产/净债务
    ,s_fa_ocftodebt -- 经营活动产生的现金流量净额/负债合计
    ,s_fa_ocftointerestdebt -- 经营活动产生的现金流量净额/带息债务
    ,s_fa_ocftonetdebt -- 经营活动产生的现金流量净额/净债务
    ,s_fa_ebittointerest -- 已获利息倍数(EBIT/利息费用)
    ,s_fa_longdebttoworkingcapital -- 长期债务与营运资金比率
    ,s_fa_ebitdatodebt -- 息税折旧摊销前利润/负债合计
    ,s_fa_turndays -- 营业周期
    ,s_fa_invturndays -- 存货周转天数
    ,s_fa_arturndays -- 应收账款周转天数
    ,s_fa_invturn -- 存货周转率
    ,s_fa_arturn -- 应收账款周转率
    ,s_fa_caturn -- 流动资产周转率
    ,s_fa_faturn -- 固定资产周转率
    ,s_fa_assetsturn -- 总资产周转率
    ,s_fa_roa_yearly -- 年化总资产净利率
    ,s_fa_dupont_roa -- 总资产净利率(杜邦分析)
    ,s_stm_bs -- 固定资产合计
    ,s_fa_prefinexpense_opprofit -- 扣除财务费用前营业利润
    ,s_fa_nonopprofit -- 非营业利润
    ,s_fa_optoebt -- 营业利润／利润总额
    ,s_fa_noptoebt -- 非营业利润／利润总额
    ,s_fa_ocftoprofit -- 经营活动产生的现金流量净额／营业利润
    ,s_fa_cashtoliqdebt -- 货币资金／流动负债
    ,s_fa_cashtoliqdebtwithinterest -- 货币资金／带息流动负债
    ,s_fa_optoliqdebt -- 营业利润／流动负债
    ,s_fa_optodebt -- 营业利润／负债合计
    ,s_fa_roic_yearly -- 年化投入资本回报率
    ,s_fa_tot_faturn -- 固定资产合计周转率
    ,s_fa_profittoop -- 利润总额／营业收入
    ,s_qfa_operateincome -- 单季度.经营活动净收益
    ,s_qfa_investincome -- 单季度.价值变动净收益
    ,s_qfa_deductedprofit -- 单季度.扣除非经常损益后的净利润
    ,s_qfa_eps -- 单季度.每股收益
    ,s_qfa_netprofitmargin -- 单季度.销售净利率
    ,s_qfa_grossprofitmargin -- 单季度.销售毛利率
    ,s_qfa_expensetosales -- 单季度.销售期间费用率
    ,s_qfa_profittogr -- 单季度.净利润／营业总收入
    ,s_qfa_saleexpensetogr -- 单季度.销售费用／营业总收入
    ,s_qfa_adminexpensetogr -- 单季度.管理费用／营业总收入
    ,s_qfa_finaexpensetogr -- 单季度.财务费用／营业总收入
    ,s_qfa_impairtogr_ttm -- 单季度.资产减值损失／营业总收入
    ,s_qfa_gctogr -- 单季度.营业总成本／营业总收入
    ,s_qfa_optogr -- 单季度.营业利润／营业总收入
    ,s_qfa_roe -- 单季度.净资产收益率
    ,s_qfa_roe_deducted -- 单季度.净资产收益率(扣除非经常损益)
    ,s_qfa_roa -- 单季度.总资产净利润
    ,s_qfa_operateincometoebt -- 单季度.经营活动净收益／利润总额
    ,s_qfa_investincometoebt -- 单季度.价值变动净收益／利润总额
    ,s_qfa_deductedprofittoprofit -- 单季度.扣除非经常损益后的净利润／净利润
    ,s_qfa_salescashintoor -- 单季度.销售商品提供劳务收到的现金／营业收入
    ,s_qfa_ocftosales -- 单季度.经营活动产生的现金流量净额／营业收入
    ,s_qfa_ocftoor -- 单季度.经营活动产生的现金流量净额／经营活动净收益
    ,s_fa_yoyeps_basic -- 同比增长率-基本每股收益(%)
    ,s_fa_yoyeps_diluted -- 同比增长率-稀释每股收益(%)
    ,s_fa_yoyocfps -- 同比增长率-每股经营活动产生的现金流量净额(%)
    ,s_fa_yoyop -- 同比增长率-营业利润(%)
    ,s_fa_yoyebt -- 同比增长率-利润总额(%)
    ,s_fa_yoynetprofit -- 同比增长率-归属母公司股东的净利润(%)
    ,s_fa_yoynetprofit_deducted -- 同比增长率-归属母公司股东的净利润-扣除非经常损益(%)
    ,s_fa_yoyocf -- 同比增长率-经营活动产生的现金流量净额(%)
    ,s_fa_yoyroe -- 同比增长率-净资产收益率(摊薄)(%)
    ,s_fa_yoybps -- 相对年初增长率-每股净资产(%)
    ,s_fa_yoyassets -- 相对年初增长率-资产总计(%)
    ,s_fa_yoyequity -- 相对年初增长率-归属母公司的股东权益(%)
    ,s_fa_yoy_tr -- 营业总收入同比增长率(%)
    ,s_fa_yoy_or -- 营业收入同比增长率(%)
    ,s_qfa_yoygr -- 单季度.营业总收入同比增长率(%)
    ,s_qfa_cgrgr -- 单季度.营业总收入环比增长率(%)
    ,s_qfa_yoysales -- 单季度.营业收入同比增长率(%)
    ,s_qfa_cgrsales -- 单季度.营业收入环比增长率(%)
    ,s_qfa_yoyop -- 单季度.营业利润同比增长率(%)
    ,s_qfa_cgrop -- 单季度.营业利润环比增长率(%)
    ,s_qfa_yoyprofit -- 单季度.净利润同比增长率(%)
    ,s_qfa_cgrprofit -- 单季度.净利润环比增长率(%)
    ,s_qfa_yoynetprofit -- 单季度.归属母公司股东的净利润同比增长率(%)
    ,s_qfa_cgrnetprofit -- 单季度.归属母公司股东的净利润环比增长率(%)
    ,s_fa_yoy_equity -- 净资产(同比增长率)
    ,rd_expense -- 研发费用
    ,waa_roe -- 加权平均净资产收益率
    ,s_info_compcode -- 公司ID
    ,opdate -- 
    ,opmode -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,wind_code -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,crncy_code -- 货币代码
    ,s_fa_extraordinary -- 非经常性损益
    ,s_fa_deductedprofit -- 扣除非经常性损益后的净利润
    ,s_fa_grossmargin -- 毛利
    ,s_fa_operateincome -- 经营活动净收益
    ,s_fa_investincome -- 价值变动净收益
    ,s_stmnote_finexp -- 利息费用
    ,s_stm_is -- 折旧与摊销
    ,s_fa_ebit -- 息税前利润
    ,s_fa_ebitda -- 息税折旧摊销前利润
    ,s_fa_fcff -- 企业自由现金流量(FCFF)
    ,s_fa_fcfe -- 股权自由现金流量(FCFE)
    ,s_fa_exinterestdebt_current -- 无息流动负债
    ,s_fa_exinterestdebt_noncurrent -- 无息非流动负债
    ,s_fa_interestdebt -- 带息债务
    ,s_fa_netdebt -- 净债务
    ,s_fa_tangibleasset -- 有形资产
    ,s_fa_workingcapital -- 营运资金
    ,s_fa_networkingcapital -- 营运流动资本
    ,s_fa_investcapital -- 全部投入资本
    ,s_fa_retainedearnings -- 留存收益
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,s_fa_eps_diluted2 -- 期末摊薄每股收益
    ,s_fa_bps -- 每股净资产
    ,s_fa_ocfps -- 每股经营活动产生的现金流量净额
    ,s_fa_grps -- 每股营业总收入
    ,s_fa_orps -- 每股营业收入
    ,s_fa_surpluscapitalps -- 每股资本公积
    ,s_fa_surplusreserveps -- 每股盈余公积
    ,s_fa_undistributedps -- 每股未分配利润
    ,s_fa_retainedps -- 每股留存收益
    ,s_fa_cfps -- 每股现金流量净额
    ,s_fa_ebitps -- 每股息税前利润
    ,s_fa_fcffps -- 每股企业自由现金流量
    ,s_fa_fcfeps -- 每股股东自由现金流量
    ,s_fa_netprofitmargin -- 销售净利率
    ,s_fa_grossprofitmargin -- 销售毛利率
    ,s_fa_cogstosales -- 销售成本率
    ,s_fa_expensetosales -- 销售期间费用率
    ,s_fa_profittogr -- 净利润/营业总收入
    ,s_fa_saleexpensetogr -- 销售费用/营业总收入
    ,s_fa_adminexpensetogr -- 管理费用/营业总收入
    ,s_fa_finaexpensetogr -- 财务费用/营业总收入
    ,s_fa_impairtogr_ttm -- 资产减值损失/营业总收入
    ,s_fa_gctogr -- 营业总成本/营业总收入
    ,s_fa_optogr -- 营业利润/营业总收入
    ,s_fa_ebittogr -- 息税前利润/营业总收入
    ,s_fa_roe -- 净资产收益率
    ,s_fa_roe_deducted -- 净资产收益率(扣除非经常损益)
    ,s_fa_roa2 -- 总资产报酬率
    ,s_fa_roa -- 总资产净利润
    ,s_fa_roic -- 投入资本回报率
    ,s_fa_roe_yearly -- 年化净资产收益率
    ,s_fa_roa2_yearly -- 年化总资产报酬率
    ,s_fa_roe_avg -- 平均净资产收益率(增发条件)
    ,s_fa_operateincometoebt -- 经营活动净收益/利润总额
    ,s_fa_investincometoebt -- 价值变动净收益/利润总额
    ,s_fa_nonoperateprofittoebt -- 营业外收支净额/利润总额
    ,s_fa_taxtoebt -- 所得税/利润总额
    ,s_fa_deductedprofittoprofit -- 扣除非经常损益后的净利润/净利润
    ,s_fa_salescashintoor -- 销售商品提供劳务收到的现金/营业收入
    ,s_fa_ocftoor -- 经营活动产生的现金流量净额/营业收入
    ,s_fa_ocftooperateincome -- 经营活动产生的现金流量净额/经营活动净收益
    ,s_fa_capitalizedtoda -- 资本支出/折旧和摊销
    ,s_fa_debttoassets -- 资产负债率
    ,s_fa_assetstoequity -- 权益乘数
    ,s_fa_dupont_assetstoequity -- 权益乘数(用于杜邦分析)
    ,s_fa_catoassets -- 流动资产/总资产
    ,s_fa_ncatoassets -- 非流动资产/总资产
    ,s_fa_tangibleassetstoassets -- 有形资产/总资产
    ,s_fa_intdebttototalcap -- 带息债务/全部投入资本
    ,s_fa_equitytototalcapital -- 归属于母公司的股东权益/全部投入资本
    ,s_fa_currentdebttodebt -- 流动负债/负债合计
    ,s_fa_longdebtodebt -- 非流动负债/负债合计
    ,s_fa_current -- 流动比率
    ,s_fa_quick -- 速动比率
    ,s_fa_cashratio -- 保守速动比率
    ,s_fa_ocftoshortdebt -- 经营活动产生的现金流量净额/流动负债
    ,s_fa_debttoequity -- 产权比率
    ,s_fa_equitytodebt -- 归属于母公司的股东权益/负债合计
    ,s_fa_equitytointerestdebt -- 归属于母公司的股东权益/带息债务
    ,s_fa_tangibleassettodebt -- 有形资产/负债合计
    ,s_fa_tangassettointdebt -- 有形资产/带息债务
    ,s_fa_tangibleassettonetdebt -- 有形资产/净债务
    ,s_fa_ocftodebt -- 经营活动产生的现金流量净额/负债合计
    ,s_fa_ocftointerestdebt -- 经营活动产生的现金流量净额/带息债务
    ,s_fa_ocftonetdebt -- 经营活动产生的现金流量净额/净债务
    ,s_fa_ebittointerest -- 已获利息倍数(EBIT/利息费用)
    ,s_fa_longdebttoworkingcapital -- 长期债务与营运资金比率
    ,s_fa_ebitdatodebt -- 息税折旧摊销前利润/负债合计
    ,s_fa_turndays -- 营业周期
    ,s_fa_invturndays -- 存货周转天数
    ,s_fa_arturndays -- 应收账款周转天数
    ,s_fa_invturn -- 存货周转率
    ,s_fa_arturn -- 应收账款周转率
    ,s_fa_caturn -- 流动资产周转率
    ,s_fa_faturn -- 固定资产周转率
    ,s_fa_assetsturn -- 总资产周转率
    ,s_fa_roa_yearly -- 年化总资产净利率
    ,s_fa_dupont_roa -- 总资产净利率(杜邦分析)
    ,s_stm_bs -- 固定资产合计
    ,s_fa_prefinexpense_opprofit -- 扣除财务费用前营业利润
    ,s_fa_nonopprofit -- 非营业利润
    ,s_fa_optoebt -- 营业利润／利润总额
    ,s_fa_noptoebt -- 非营业利润／利润总额
    ,s_fa_ocftoprofit -- 经营活动产生的现金流量净额／营业利润
    ,s_fa_cashtoliqdebt -- 货币资金／流动负债
    ,s_fa_cashtoliqdebtwithinterest -- 货币资金／带息流动负债
    ,s_fa_optoliqdebt -- 营业利润／流动负债
    ,s_fa_optodebt -- 营业利润／负债合计
    ,s_fa_roic_yearly -- 年化投入资本回报率
    ,s_fa_tot_faturn -- 固定资产合计周转率
    ,s_fa_profittoop -- 利润总额／营业收入
    ,s_qfa_operateincome -- 单季度.经营活动净收益
    ,s_qfa_investincome -- 单季度.价值变动净收益
    ,s_qfa_deductedprofit -- 单季度.扣除非经常损益后的净利润
    ,s_qfa_eps -- 单季度.每股收益
    ,s_qfa_netprofitmargin -- 单季度.销售净利率
    ,s_qfa_grossprofitmargin -- 单季度.销售毛利率
    ,s_qfa_expensetosales -- 单季度.销售期间费用率
    ,s_qfa_profittogr -- 单季度.净利润／营业总收入
    ,s_qfa_saleexpensetogr -- 单季度.销售费用／营业总收入
    ,s_qfa_adminexpensetogr -- 单季度.管理费用／营业总收入
    ,s_qfa_finaexpensetogr -- 单季度.财务费用／营业总收入
    ,s_qfa_impairtogr_ttm -- 单季度.资产减值损失／营业总收入
    ,s_qfa_gctogr -- 单季度.营业总成本／营业总收入
    ,s_qfa_optogr -- 单季度.营业利润／营业总收入
    ,s_qfa_roe -- 单季度.净资产收益率
    ,s_qfa_roe_deducted -- 单季度.净资产收益率(扣除非经常损益)
    ,s_qfa_roa -- 单季度.总资产净利润
    ,s_qfa_operateincometoebt -- 单季度.经营活动净收益／利润总额
    ,s_qfa_investincometoebt -- 单季度.价值变动净收益／利润总额
    ,s_qfa_deductedprofittoprofit -- 单季度.扣除非经常损益后的净利润／净利润
    ,s_qfa_salescashintoor -- 单季度.销售商品提供劳务收到的现金／营业收入
    ,s_qfa_ocftosales -- 单季度.经营活动产生的现金流量净额／营业收入
    ,s_qfa_ocftoor -- 单季度.经营活动产生的现金流量净额／经营活动净收益
    ,s_fa_yoyeps_basic -- 同比增长率-基本每股收益(%)
    ,s_fa_yoyeps_diluted -- 同比增长率-稀释每股收益(%)
    ,s_fa_yoyocfps -- 同比增长率-每股经营活动产生的现金流量净额(%)
    ,s_fa_yoyop -- 同比增长率-营业利润(%)
    ,s_fa_yoyebt -- 同比增长率-利润总额(%)
    ,s_fa_yoynetprofit -- 同比增长率-归属母公司股东的净利润(%)
    ,s_fa_yoynetprofit_deducted -- 同比增长率-归属母公司股东的净利润-扣除非经常损益(%)
    ,s_fa_yoyocf -- 同比增长率-经营活动产生的现金流量净额(%)
    ,s_fa_yoyroe -- 同比增长率-净资产收益率(摊薄)(%)
    ,s_fa_yoybps -- 相对年初增长率-每股净资产(%)
    ,s_fa_yoyassets -- 相对年初增长率-资产总计(%)
    ,s_fa_yoyequity -- 相对年初增长率-归属母公司的股东权益(%)
    ,s_fa_yoy_tr -- 营业总收入同比增长率(%)
    ,s_fa_yoy_or -- 营业收入同比增长率(%)
    ,s_qfa_yoygr -- 单季度.营业总收入同比增长率(%)
    ,s_qfa_cgrgr -- 单季度.营业总收入环比增长率(%)
    ,s_qfa_yoysales -- 单季度.营业收入同比增长率(%)
    ,s_qfa_cgrsales -- 单季度.营业收入环比增长率(%)
    ,s_qfa_yoyop -- 单季度.营业利润同比增长率(%)
    ,s_qfa_cgrop -- 单季度.营业利润环比增长率(%)
    ,s_qfa_yoyprofit -- 单季度.净利润同比增长率(%)
    ,s_qfa_cgrprofit -- 单季度.净利润环比增长率(%)
    ,s_qfa_yoynetprofit -- 单季度.归属母公司股东的净利润同比增长率(%)
    ,s_qfa_cgrnetprofit -- 单季度.归属母公司股东的净利润环比增长率(%)
    ,s_fa_yoy_equity -- 净资产(同比增长率)
    ,rd_expense -- 研发费用
    ,waa_roe -- 加权平均净资产收益率
    ,s_info_compcode -- 公司ID
    ,opdate -- 
    ,opmode -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_asharefinancialindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_asharefinancialindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_asharefinancialindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharefinancialindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_asharefinancialindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharefinancialindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);