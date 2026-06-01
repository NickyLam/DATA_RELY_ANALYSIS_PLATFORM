/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharefinancialindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharefinancialindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharefinancialindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharefinancialindicator(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,wind_code varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,crncy_code varchar2(15) -- 货币代码
    ,s_fa_extraordinary number(20,4) -- 非经常性损益
    ,s_fa_deductedprofit number(20,4) -- 扣除非经常性损益后的净利润
    ,s_fa_grossmargin number(20,4) -- 毛利
    ,s_fa_operateincome number(20,4) -- 经营活动净收益
    ,s_fa_investincome number(20,4) -- 价值变动净收益
    ,s_stmnote_finexp number(20,4) -- 利息费用
    ,s_stm_is number(20,4) -- 折旧与摊销
    ,s_fa_ebit number(20,4) -- 息税前利润
    ,s_fa_ebitda number(20,4) -- 息税折旧摊销前利润
    ,s_fa_fcff number(20,4) -- 企业自由现金流量(FCFF)
    ,s_fa_fcfe number(20,4) -- 股权自由现金流量(FCFE)
    ,s_fa_exinterestdebt_current number(20,4) -- 无息流动负债
    ,s_fa_exinterestdebt_noncurrent number(20,4) -- 无息非流动负债
    ,s_fa_interestdebt number(20,4) -- 带息债务
    ,s_fa_netdebt number(20,4) -- 净债务
    ,s_fa_tangibleasset number(20,4) -- 有形资产
    ,s_fa_workingcapital number(20,4) -- 营运资金
    ,s_fa_networkingcapital number(20,4) -- 营运流动资本
    ,s_fa_investcapital number(20,4) -- 全部投入资本
    ,s_fa_retainedearnings number(20,4) -- 留存收益
    ,s_fa_eps_basic number(20,4) -- 基本每股收益
    ,s_fa_eps_diluted number(20,4) -- 稀释每股收益
    ,s_fa_eps_diluted2 number(20,4) -- 期末摊薄每股收益
    ,s_fa_bps number(20,4) -- 每股净资产
    ,s_fa_ocfps number(20,4) -- 每股经营活动产生的现金流量净额
    ,s_fa_grps number(20,4) -- 每股营业总收入
    ,s_fa_orps number(20,4) -- 每股营业收入
    ,s_fa_surpluscapitalps number(20,4) -- 每股资本公积
    ,s_fa_surplusreserveps number(20,4) -- 每股盈余公积
    ,s_fa_undistributedps number(20,4) -- 每股未分配利润
    ,s_fa_retainedps number(20,4) -- 每股留存收益
    ,s_fa_cfps number(20,4) -- 每股现金流量净额
    ,s_fa_ebitps number(20,4) -- 每股息税前利润
    ,s_fa_fcffps number(20,4) -- 每股企业自由现金流量
    ,s_fa_fcfeps number(20,4) -- 每股股东自由现金流量
    ,s_fa_netprofitmargin number(20,4) -- 销售净利率
    ,s_fa_grossprofitmargin number(20,4) -- 销售毛利率
    ,s_fa_cogstosales number(20,4) -- 销售成本率
    ,s_fa_expensetosales number(20,4) -- 销售期间费用率
    ,s_fa_profittogr number(20,4) -- 净利润/营业总收入
    ,s_fa_saleexpensetogr number(20,4) -- 销售费用/营业总收入
    ,s_fa_adminexpensetogr number(20,4) -- 管理费用/营业总收入
    ,s_fa_finaexpensetogr number(20,4) -- 财务费用/营业总收入
    ,s_fa_impairtogr_ttm number(20,4) -- 资产减值损失/营业总收入
    ,s_fa_gctogr number(20,4) -- 营业总成本/营业总收入
    ,s_fa_optogr number(20,4) -- 营业利润/营业总收入
    ,s_fa_ebittogr number(20,4) -- 息税前利润/营业总收入
    ,s_fa_roe number(20,4) -- 净资产收益率
    ,s_fa_roe_deducted number(20,4) -- 净资产收益率(扣除非经常损益)
    ,s_fa_roa2 number(20,4) -- 总资产报酬率
    ,s_fa_roa number(20,4) -- 总资产净利润
    ,s_fa_roic number(20,4) -- 投入资本回报率
    ,s_fa_roe_yearly number(20,4) -- 年化净资产收益率
    ,s_fa_roa2_yearly number(20,4) -- 年化总资产报酬率
    ,s_fa_roe_avg number(20,4) -- 平均净资产收益率(增发条件)
    ,s_fa_operateincometoebt number(20,4) -- 经营活动净收益/利润总额
    ,s_fa_investincometoebt number(20,4) -- 价值变动净收益/利润总额
    ,s_fa_nonoperateprofittoebt number(20,4) -- 营业外收支净额/利润总额
    ,s_fa_taxtoebt number(20,4) -- 所得税/利润总额
    ,s_fa_deductedprofittoprofit number(20,4) -- 扣除非经常损益后的净利润/净利润
    ,s_fa_salescashintoor number(20,4) -- 销售商品提供劳务收到的现金/营业收入
    ,s_fa_ocftoor number(20,4) -- 经营活动产生的现金流量净额/营业收入
    ,s_fa_ocftooperateincome number(20,4) -- 经营活动产生的现金流量净额/经营活动净收益
    ,s_fa_capitalizedtoda number(20,4) -- 资本支出/折旧和摊销
    ,s_fa_debttoassets number(20,4) -- 资产负债率
    ,s_fa_assetstoequity number(20,4) -- 权益乘数
    ,s_fa_dupont_assetstoequity number(20,4) -- 权益乘数(用于杜邦分析)
    ,s_fa_catoassets number(20,4) -- 流动资产/总资产
    ,s_fa_ncatoassets number(20,4) -- 非流动资产/总资产
    ,s_fa_tangibleassetstoassets number(20,4) -- 有形资产/总资产
    ,s_fa_intdebttototalcap number(20,4) -- 带息债务/全部投入资本
    ,s_fa_equitytototalcapital number(20,4) -- 归属于母公司的股东权益/全部投入资本
    ,s_fa_currentdebttodebt number(20,4) -- 流动负债/负债合计
    ,s_fa_longdebtodebt number(20,4) -- 非流动负债/负债合计
    ,s_fa_current number(20,4) -- 流动比率
    ,s_fa_quick number(20,4) -- 速动比率
    ,s_fa_cashratio number(20,4) -- 保守速动比率
    ,s_fa_ocftoshortdebt number(20,4) -- 经营活动产生的现金流量净额/流动负债
    ,s_fa_debttoequity number(20,4) -- 产权比率
    ,s_fa_equitytodebt number(20,4) -- 归属于母公司的股东权益/负债合计
    ,s_fa_equitytointerestdebt number(20,4) -- 归属于母公司的股东权益/带息债务
    ,s_fa_tangibleassettodebt number(20,4) -- 有形资产/负债合计
    ,s_fa_tangassettointdebt number(20,4) -- 有形资产/带息债务
    ,s_fa_tangibleassettonetdebt number(20,4) -- 有形资产/净债务
    ,s_fa_ocftodebt number(20,4) -- 经营活动产生的现金流量净额/负债合计
    ,s_fa_ocftointerestdebt number(20,4) -- 经营活动产生的现金流量净额/带息债务
    ,s_fa_ocftonetdebt number(20,4) -- 经营活动产生的现金流量净额/净债务
    ,s_fa_ebittointerest number(20,4) -- 已获利息倍数(EBIT/利息费用)
    ,s_fa_longdebttoworkingcapital number(20,4) -- 长期债务与营运资金比率
    ,s_fa_ebitdatodebt number(20,4) -- 息税折旧摊销前利润/负债合计
    ,s_fa_turndays number(20,4) -- 营业周期
    ,s_fa_invturndays number(20,4) -- 存货周转天数
    ,s_fa_arturndays number(20,4) -- 应收账款周转天数
    ,s_fa_invturn number(20,4) -- 存货周转率
    ,s_fa_arturn number(20,4) -- 应收账款周转率
    ,s_fa_caturn number(20,4) -- 流动资产周转率
    ,s_fa_faturn number(20,4) -- 固定资产周转率
    ,s_fa_assetsturn number(20,4) -- 总资产周转率
    ,s_fa_roa_yearly number(20,4) -- 年化总资产净利率
    ,s_fa_dupont_roa number(20,4) -- 总资产净利率(杜邦分析)
    ,s_stm_bs number(20,4) -- 固定资产合计
    ,s_fa_prefinexpense_opprofit number(20,4) -- 扣除财务费用前营业利润
    ,s_fa_nonopprofit number(20,4) -- 非营业利润
    ,s_fa_optoebt number(20,4) -- 营业利润／利润总额
    ,s_fa_noptoebt number(20,4) -- 非营业利润／利润总额
    ,s_fa_ocftoprofit number(20,4) -- 经营活动产生的现金流量净额／营业利润
    ,s_fa_cashtoliqdebt number(20,4) -- 货币资金／流动负债
    ,s_fa_cashtoliqdebtwithinterest number(20,4) -- 货币资金／带息流动负债
    ,s_fa_optoliqdebt number(20,4) -- 营业利润／流动负债
    ,s_fa_optodebt number(20,4) -- 营业利润／负债合计
    ,s_fa_roic_yearly number(20,4) -- 年化投入资本回报率
    ,s_fa_tot_faturn number(20,4) -- 固定资产合计周转率
    ,s_fa_profittoop number(20,4) -- 利润总额／营业收入
    ,s_qfa_operateincome number(20,4) -- 单季度.经营活动净收益
    ,s_qfa_investincome number(20,4) -- 单季度.价值变动净收益
    ,s_qfa_deductedprofit number(20,4) -- 单季度.扣除非经常损益后的净利润
    ,s_qfa_eps number(24,6) -- 单季度.每股收益
    ,s_qfa_netprofitmargin number(20,4) -- 单季度.销售净利率
    ,s_qfa_grossprofitmargin number(20,4) -- 单季度.销售毛利率
    ,s_qfa_expensetosales number(20,4) -- 单季度.销售期间费用率
    ,s_qfa_profittogr number(20,4) -- 单季度.净利润／营业总收入
    ,s_qfa_saleexpensetogr number(20,4) -- 单季度.销售费用／营业总收入
    ,s_qfa_adminexpensetogr number(20,4) -- 单季度.管理费用／营业总收入
    ,s_qfa_finaexpensetogr number(20,4) -- 单季度.财务费用／营业总收入
    ,s_qfa_impairtogr_ttm number(20,4) -- 单季度.资产减值损失／营业总收入
    ,s_qfa_gctogr number(20,4) -- 单季度.营业总成本／营业总收入
    ,s_qfa_optogr number(20,4) -- 单季度.营业利润／营业总收入
    ,s_qfa_roe number(24,6) -- 单季度.净资产收益率
    ,s_qfa_roe_deducted number(24,6) -- 单季度.净资产收益率(扣除非经常损益)
    ,s_qfa_roa number(20,4) -- 单季度.总资产净利润
    ,s_qfa_operateincometoebt number(20,4) -- 单季度.经营活动净收益／利润总额
    ,s_qfa_investincometoebt number(20,4) -- 单季度.价值变动净收益／利润总额
    ,s_qfa_deductedprofittoprofit number(20,4) -- 单季度.扣除非经常损益后的净利润／净利润
    ,s_qfa_salescashintoor number(20,4) -- 单季度.销售商品提供劳务收到的现金／营业收入
    ,s_qfa_ocftosales number(20,4) -- 单季度.经营活动产生的现金流量净额／营业收入
    ,s_qfa_ocftoor number(20,4) -- 单季度.经营活动产生的现金流量净额／经营活动净收益
    ,s_fa_yoyeps_basic number(20,4) -- 同比增长率-基本每股收益(%)
    ,s_fa_yoyeps_diluted number(20,4) -- 同比增长率-稀释每股收益(%)
    ,s_fa_yoyocfps number(20,4) -- 同比增长率-每股经营活动产生的现金流量净额(%)
    ,s_fa_yoyop number(20,4) -- 同比增长率-营业利润(%)
    ,s_fa_yoyebt number(20,4) -- 同比增长率-利润总额(%)
    ,s_fa_yoynetprofit number(20,4) -- 同比增长率-归属母公司股东的净利润(%)
    ,s_fa_yoynetprofit_deducted number(20,4) -- 同比增长率-归属母公司股东的净利润-扣除非经常损益(%)
    ,s_fa_yoyocf number(20,4) -- 同比增长率-经营活动产生的现金流量净额(%)
    ,s_fa_yoyroe number(20,4) -- 同比增长率-净资产收益率(摊薄)(%)
    ,s_fa_yoybps number(20,4) -- 相对年初增长率-每股净资产(%)
    ,s_fa_yoyassets number(20,4) -- 相对年初增长率-资产总计(%)
    ,s_fa_yoyequity number(20,4) -- 相对年初增长率-归属母公司的股东权益(%)
    ,s_fa_yoy_tr number(20,4) -- 营业总收入同比增长率(%)
    ,s_fa_yoy_or number(20,4) -- 营业收入同比增长率(%)
    ,s_qfa_yoygr number(20,4) -- 单季度.营业总收入同比增长率(%)
    ,s_qfa_cgrgr number(20,4) -- 单季度.营业总收入环比增长率(%)
    ,s_qfa_yoysales number(20,4) -- 单季度.营业收入同比增长率(%)
    ,s_qfa_cgrsales number(20,4) -- 单季度.营业收入环比增长率(%)
    ,s_qfa_yoyop number(20,4) -- 单季度.营业利润同比增长率(%)
    ,s_qfa_cgrop number(20,4) -- 单季度.营业利润环比增长率(%)
    ,s_qfa_yoyprofit number(20,4) -- 单季度.净利润同比增长率(%)
    ,s_qfa_cgrprofit number(20,4) -- 单季度.净利润环比增长率(%)
    ,s_qfa_yoynetprofit number(20,4) -- 单季度.归属母公司股东的净利润同比增长率(%)
    ,s_qfa_cgrnetprofit number(20,4) -- 单季度.归属母公司股东的净利润环比增长率(%)
    ,s_fa_yoy_equity number(20,4) -- 净资产(同比增长率)
    ,rd_expense number(20,4) -- 研发费用
    ,waa_roe number(24,6) -- 加权平均净资产收益率
    ,s_info_compcode varchar2(15) -- 公司ID
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_asharefinancialindicator to ${iml_schema};
grant select on ${iol_schema}.wind_asharefinancialindicator to ${icl_schema};
grant select on ${iol_schema}.wind_asharefinancialindicator to ${idl_schema};
grant select on ${iol_schema}.wind_asharefinancialindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharefinancialindicator is '中国a股财务指标';
comment on column ${iol_schema}.wind_asharefinancialindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharefinancialindicator.wind_code is 'Wind代码';
comment on column ${iol_schema}.wind_asharefinancialindicator.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharefinancialindicator.report_period is '报告期';
comment on column ${iol_schema}.wind_asharefinancialindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_extraordinary is '非经常性损益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_deductedprofit is '扣除非经常性损益后的净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_grossmargin is '毛利';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_operateincome is '经营活动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_investincome is '价值变动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_stmnote_finexp is '利息费用';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_stm_is is '折旧与摊销';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebit is '息税前利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebitda is '息税折旧摊销前利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_fcff is '企业自由现金流量(FCFF)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_fcfe is '股权自由现金流量(FCFE)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_exinterestdebt_current is '无息流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_exinterestdebt_noncurrent is '无息非流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_interestdebt is '带息债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_netdebt is '净债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tangibleasset is '有形资产';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_workingcapital is '营运资金';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_networkingcapital is '营运流动资本';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_investcapital is '全部投入资本';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_retainedearnings is '留存收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_eps_basic is '基本每股收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_eps_diluted is '稀释每股收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_eps_diluted2 is '期末摊薄每股收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_bps is '每股净资产';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocfps is '每股经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_grps is '每股营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_orps is '每股营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_surpluscapitalps is '每股资本公积';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_surplusreserveps is '每股盈余公积';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_undistributedps is '每股未分配利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_retainedps is '每股留存收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_cfps is '每股现金流量净额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebitps is '每股息税前利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_fcffps is '每股企业自由现金流量';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_fcfeps is '每股股东自由现金流量';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_netprofitmargin is '销售净利率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_grossprofitmargin is '销售毛利率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_cogstosales is '销售成本率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_expensetosales is '销售期间费用率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_profittogr is '净利润/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_saleexpensetogr is '销售费用/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_adminexpensetogr is '管理费用/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_finaexpensetogr is '财务费用/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_impairtogr_ttm is '资产减值损失/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_gctogr is '营业总成本/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_optogr is '营业利润/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebittogr is '息税前利润/营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roe is '净资产收益率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roe_deducted is '净资产收益率(扣除非经常损益)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roa2 is '总资产报酬率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roa is '总资产净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roic is '投入资本回报率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roe_yearly is '年化净资产收益率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roa2_yearly is '年化总资产报酬率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roe_avg is '平均净资产收益率(增发条件)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_operateincometoebt is '经营活动净收益/利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_investincometoebt is '价值变动净收益/利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_nonoperateprofittoebt is '营业外收支净额/利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_taxtoebt is '所得税/利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_deductedprofittoprofit is '扣除非经常损益后的净利润/净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_salescashintoor is '销售商品提供劳务收到的现金/营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftoor is '经营活动产生的现金流量净额/营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftooperateincome is '经营活动产生的现金流量净额/经营活动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_capitalizedtoda is '资本支出/折旧和摊销';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_debttoassets is '资产负债率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_assetstoequity is '权益乘数';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_dupont_assetstoequity is '权益乘数(用于杜邦分析)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_catoassets is '流动资产/总资产';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ncatoassets is '非流动资产/总资产';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tangibleassetstoassets is '有形资产/总资产';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_intdebttototalcap is '带息债务/全部投入资本';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_equitytototalcapital is '归属于母公司的股东权益/全部投入资本';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_currentdebttodebt is '流动负债/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_longdebtodebt is '非流动负债/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_current is '流动比率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_quick is '速动比率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_cashratio is '保守速动比率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftoshortdebt is '经营活动产生的现金流量净额/流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_debttoequity is '产权比率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_equitytodebt is '归属于母公司的股东权益/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_equitytointerestdebt is '归属于母公司的股东权益/带息债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tangibleassettodebt is '有形资产/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tangassettointdebt is '有形资产/带息债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tangibleassettonetdebt is '有形资产/净债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftodebt is '经营活动产生的现金流量净额/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftointerestdebt is '经营活动产生的现金流量净额/带息债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftonetdebt is '经营活动产生的现金流量净额/净债务';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebittointerest is '已获利息倍数(EBIT/利息费用)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_longdebttoworkingcapital is '长期债务与营运资金比率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ebitdatodebt is '息税折旧摊销前利润/负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_turndays is '营业周期';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_invturndays is '存货周转天数';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_arturndays is '应收账款周转天数';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_invturn is '存货周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_arturn is '应收账款周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_caturn is '流动资产周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_faturn is '固定资产周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_assetsturn is '总资产周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roa_yearly is '年化总资产净利率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_dupont_roa is '总资产净利率(杜邦分析)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_stm_bs is '固定资产合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_prefinexpense_opprofit is '扣除财务费用前营业利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_nonopprofit is '非营业利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_optoebt is '营业利润／利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_noptoebt is '非营业利润／利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_ocftoprofit is '经营活动产生的现金流量净额／营业利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_cashtoliqdebt is '货币资金／流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_cashtoliqdebtwithinterest is '货币资金／带息流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_optoliqdebt is '营业利润／流动负债';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_optodebt is '营业利润／负债合计';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_roic_yearly is '年化投入资本回报率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_tot_faturn is '固定资产合计周转率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_profittoop is '利润总额／营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_operateincome is '单季度.经营活动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_investincome is '单季度.价值变动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_deductedprofit is '单季度.扣除非经常损益后的净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_eps is '单季度.每股收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_netprofitmargin is '单季度.销售净利率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_grossprofitmargin is '单季度.销售毛利率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_expensetosales is '单季度.销售期间费用率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_profittogr is '单季度.净利润／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_saleexpensetogr is '单季度.销售费用／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_adminexpensetogr is '单季度.管理费用／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_finaexpensetogr is '单季度.财务费用／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_impairtogr_ttm is '单季度.资产减值损失／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_gctogr is '单季度.营业总成本／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_optogr is '单季度.营业利润／营业总收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_roe is '单季度.净资产收益率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_roe_deducted is '单季度.净资产收益率(扣除非经常损益)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_roa is '单季度.总资产净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_operateincometoebt is '单季度.经营活动净收益／利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_investincometoebt is '单季度.价值变动净收益／利润总额';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_deductedprofittoprofit is '单季度.扣除非经常损益后的净利润／净利润';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_salescashintoor is '单季度.销售商品提供劳务收到的现金／营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_ocftosales is '单季度.经营活动产生的现金流量净额／营业收入';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_ocftoor is '单季度.经营活动产生的现金流量净额／经营活动净收益';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyeps_basic is '同比增长率-基本每股收益(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyeps_diluted is '同比增长率-稀释每股收益(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyocfps is '同比增长率-每股经营活动产生的现金流量净额(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyop is '同比增长率-营业利润(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyebt is '同比增长率-利润总额(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoynetprofit is '同比增长率-归属母公司股东的净利润(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoynetprofit_deducted is '同比增长率-归属母公司股东的净利润-扣除非经常损益(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyocf is '同比增长率-经营活动产生的现金流量净额(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyroe is '同比增长率-净资产收益率(摊薄)(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoybps is '相对年初增长率-每股净资产(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyassets is '相对年初增长率-资产总计(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoyequity is '相对年初增长率-归属母公司的股东权益(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoy_tr is '营业总收入同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoy_or is '营业收入同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_yoygr is '单季度.营业总收入同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_cgrgr is '单季度.营业总收入环比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_yoysales is '单季度.营业收入同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_cgrsales is '单季度.营业收入环比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_yoyop is '单季度.营业利润同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_cgrop is '单季度.营业利润环比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_yoyprofit is '单季度.净利润同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_cgrprofit is '单季度.净利润环比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_yoynetprofit is '单季度.归属母公司股东的净利润同比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_qfa_cgrnetprofit is '单季度.归属母公司股东的净利润环比增长率(%)';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_fa_yoy_equity is '净资产(同比增长率)';
comment on column ${iol_schema}.wind_asharefinancialindicator.rd_expense is '研发费用';
comment on column ${iol_schema}.wind_asharefinancialindicator.waa_roe is '加权平均净资产收益率';
comment on column ${iol_schema}.wind_asharefinancialindicator.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_asharefinancialindicator.opdate is '';
comment on column ${iol_schema}.wind_asharefinancialindicator.opmode is '';
comment on column ${iol_schema}.wind_asharefinancialindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharefinancialindicator.etl_timestamp is 'ETL处理时间戳';
