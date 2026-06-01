/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rpt_mr_sa_rwa_result
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
drop table ${iol_schema}.rwas_rpt_mr_sa_rwa_result_ex purge;
alter table ${iol_schema}.rwas_rpt_mr_sa_rwa_result add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rpt_mr_sa_rwa_result truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rpt_mr_sa_rwa_result_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rpt_mr_sa_rwa_result where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rpt_mr_sa_rwa_result_ex(
    data_date -- 数据日期
    ,loan_ref_no -- 债项编号
    ,loan_ref_desc -- 债项描述
    ,contract_no -- 合同编号
    ,src_system_id -- 来源系统标识
    ,accorg_no -- 账务机构
    ,accorg_name -- 账务机构名称
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_cd -- 五级分类名称
    ,product_name -- 产品名称
    ,bis_product_type_cd -- 监管产品类型代码
    ,bis_product_type_name -- 监管产品类型名称
    ,bis_product_btype_cd -- 监管产品大类代码
    ,bis_product_btype_name -- 监管产品大类名称
    ,buss_type_cd -- 业务类型
    ,buss_type_name -- 业务名称
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,orig_maturity -- 原始期限
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 权重法违约标志
    ,book_type_id -- 账簿类型
    ,book_type_name -- 账簿名称
    ,on_off_id -- 表内外资产标志
    ,bis_ccy_cd -- 计量币种代码
    ,bis_ccy_name -- 计量币种名称
    ,exchange_rate -- 汇率
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,pric_bal_origcurr -- 本金余额（原币）
    ,pric_bal -- 本金余额（本币）
    ,asset_balance -- 资产余额（本币）
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息（本币）
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息（本币）
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整（本币）
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动（本币）
    ,depreamor_subject_cd -- 折旧科目
    ,depreamor_subject_name -- 折旧科目名称
    ,depre_amortizat -- 折旧金额（本币）
    ,other_subject_cd -- 其他科目
    ,other_subject_name -- 其他科目名称
    ,other_amt -- 其他金额（本币）
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金（本币）
    ,provesion_ratio -- 准备金计提比例
    ,account_classification -- 金融资产分类
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型代码
    ,ccp_type_name -- 交易对手类型名称
    ,ccp_btype_cd -- 交易对手大类代码
    ,ccp_btype_name -- 交易对手大类名称
    ,spe_lending_flag -- 专业贷款标志
    ,spe_lending_type -- 专业贷款分类
    ,bis_country_name -- 注册国名称
    ,sov_sp_lt_rating_cd -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd -- 客户标普评级
    ,scra_rating -- SCRA评级
    ,int_trade_flag -- 内部交易标志
    ,solo_int_trade_flag -- 法人内部交易标志
    ,investment_cust_flag -- 投资级客户标志
    ,ccy_mismatch_flag -- 币种错配标志
    ,accept_credit_self_flag -- 自开信用证标志
    ,real_estate_type_cd -- 房地产风险暴露类型名称
    ,ltv -- LTV规则
    ,accept_discount_self_flag -- 自承自贴标志
    ,operation_pf_flag -- 项目融资运营阶段标识
    ,cancel_flag -- 随时可撤销标志
    ,off_asset_unmeasured_flag -- 表外资产不计量标志
    ,unused_prl_tmeet_flag -- 符合标准的未使用额度标志
    ,ead_orig -- 原始风险暴露
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露
    ,ead_afterpro -- 扣减准备金后的风险暴露
    ,rw -- 权重
    ,crm_ccy_mis_flag -- 是否存在缓释币种错配
    ,crm_amt_rmb -- 缓释金额折本币
    ,crm_amt_split -- 缓释金额拆分本币
    ,crm_weighting_rw -- 缓释加权权重
    ,rwa_ucovered -- 缓释未覆盖部分的RWA
    ,rwa_covered -- 缓释覆盖部分的RWA
    ,rwa -- 风险加权资产
    ,c_item_e -- 现金类资产
    ,c_item_f -- 我国中央政府
    ,c_item_g -- 中国人民银行
    ,c_item_h -- 我国开发性金融机构和政策性银行
    ,c_item_i -- 省级（自治区、直辖市）及计划单列市人民政府-一般债券
    ,c_item_j -- 省级（自治区、直辖市）及计划单列市人民政府-专项债券
    ,c_item_k -- 其他收入主要源于中央财政的公共部门实体
    ,c_item_l -- 经金融监管总局认定的我国一般公共部门实体
    ,c_item_m -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券
    ,c_item_n -- 评级AA-以上（含）的国家和地区的中央政府和中央银行
    ,c_item_o -- 评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_p -- 评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_q -- 评级AA-（含）及以上国家和地区注册的公共部门实体
    ,c_item_r -- 评级AA-以下，A-（含）以上国家和地区注册的公共部门实体
    ,c_item_s -- A+级和A级境内外商业银行（短期）
    ,c_item_t -- A+级境内外商业银行
    ,c_item_u -- A级境内外商业银行
    ,c_item_v -- 合格多边开发银行
    ,c_item_w -- 评级AA-（含）以上的其他多边开发银行
    ,c_item_x -- 对评级AA-以下，A-（含）以上的其他多边开发银行
    ,c_item_y -- 评级A-以下，BBB-（含）以上的其他多边开发银行
    ,c_item_z -- 国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,report_line_name -- G4B栏位名称
    ,crm_ccy_mis_coeff -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff -- 缓释期限错配系数
    ,crm_floor_mis_coeff -- 底线折扣系数
    ,investment_vaild_flag -- 投资级认定是否在有效期内
    ,recognition_date -- 认定日期
    ,load_date -- 加载日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_no -- 债项编号
    ,loan_ref_desc -- 债项描述
    ,contract_no -- 合同编号
    ,src_system_id -- 来源系统标识
    ,accorg_no -- 账务机构
    ,accorg_name -- 账务机构名称
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_cd -- 五级分类名称
    ,product_name -- 产品名称
    ,bis_product_type_cd -- 监管产品类型代码
    ,bis_product_type_name -- 监管产品类型名称
    ,bis_product_btype_cd -- 监管产品大类代码
    ,bis_product_btype_name -- 监管产品大类名称
    ,buss_type_cd -- 业务类型
    ,buss_type_name -- 业务名称
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,orig_maturity -- 原始期限
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 权重法违约标志
    ,book_type_id -- 账簿类型
    ,book_type_name -- 账簿名称
    ,on_off_id -- 表内外资产标志
    ,bis_ccy_cd -- 计量币种代码
    ,bis_ccy_name -- 计量币种名称
    ,exchange_rate -- 汇率
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,pric_bal_origcurr -- 本金余额（原币）
    ,pric_bal -- 本金余额（本币）
    ,asset_balance -- 资产余额（本币）
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息（本币）
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息（本币）
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整（本币）
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动（本币）
    ,depreamor_subject_cd -- 折旧科目
    ,depreamor_subject_name -- 折旧科目名称
    ,depre_amortizat -- 折旧金额（本币）
    ,other_subject_cd -- 其他科目
    ,other_subject_name -- 其他科目名称
    ,other_amt -- 其他金额（本币）
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金（本币）
    ,provesion_ratio -- 准备金计提比例
    ,account_classification -- 金融资产分类
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型代码
    ,ccp_type_name -- 交易对手类型名称
    ,ccp_btype_cd -- 交易对手大类代码
    ,ccp_btype_name -- 交易对手大类名称
    ,spe_lending_flag -- 专业贷款标志
    ,spe_lending_type -- 专业贷款分类
    ,bis_country_name -- 注册国名称
    ,sov_sp_lt_rating_cd -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd -- 客户标普评级
    ,scra_rating -- SCRA评级
    ,int_trade_flag -- 内部交易标志
    ,solo_int_trade_flag -- 法人内部交易标志
    ,investment_cust_flag -- 投资级客户标志
    ,ccy_mismatch_flag -- 币种错配标志
    ,accept_credit_self_flag -- 自开信用证标志
    ,real_estate_type_cd -- 房地产风险暴露类型名称
    ,ltv -- LTV规则
    ,accept_discount_self_flag -- 自承自贴标志
    ,operation_pf_flag -- 项目融资运营阶段标识
    ,cancel_flag -- 随时可撤销标志
    ,off_asset_unmeasured_flag -- 表外资产不计量标志
    ,unused_prl_tmeet_flag -- 符合标准的未使用额度标志
    ,ead_orig -- 原始风险暴露
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露
    ,ead_afterpro -- 扣减准备金后的风险暴露
    ,rw -- 权重
    ,crm_ccy_mis_flag -- 是否存在缓释币种错配
    ,crm_amt_rmb -- 缓释金额折本币
    ,crm_amt_split -- 缓释金额拆分本币
    ,crm_weighting_rw -- 缓释加权权重
    ,rwa_ucovered -- 缓释未覆盖部分的RWA
    ,rwa_covered -- 缓释覆盖部分的RWA
    ,rwa -- 风险加权资产
    ,c_item_e -- 现金类资产
    ,c_item_f -- 我国中央政府
    ,c_item_g -- 中国人民银行
    ,c_item_h -- 我国开发性金融机构和政策性银行
    ,c_item_i -- 省级（自治区、直辖市）及计划单列市人民政府-一般债券
    ,c_item_j -- 省级（自治区、直辖市）及计划单列市人民政府-专项债券
    ,c_item_k -- 其他收入主要源于中央财政的公共部门实体
    ,c_item_l -- 经金融监管总局认定的我国一般公共部门实体
    ,c_item_m -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券
    ,c_item_n -- 评级AA-以上（含）的国家和地区的中央政府和中央银行
    ,c_item_o -- 评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_p -- 评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_q -- 评级AA-（含）及以上国家和地区注册的公共部门实体
    ,c_item_r -- 评级AA-以下，A-（含）以上国家和地区注册的公共部门实体
    ,c_item_s -- A+级和A级境内外商业银行（短期）
    ,c_item_t -- A+级境内外商业银行
    ,c_item_u -- A级境内外商业银行
    ,c_item_v -- 合格多边开发银行
    ,c_item_w -- 评级AA-（含）以上的其他多边开发银行
    ,c_item_x -- 对评级AA-以下，A-（含）以上的其他多边开发银行
    ,c_item_y -- 评级A-以下，BBB-（含）以上的其他多边开发银行
    ,c_item_z -- 国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,report_line_name -- G4B栏位名称
    ,crm_ccy_mis_coeff -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff -- 缓释期限错配系数
    ,crm_floor_mis_coeff -- 底线折扣系数
    ,investment_vaild_flag -- 投资级认定是否在有效期内
    ,recognition_date -- 认定日期
    ,load_date -- 加载日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rpt_mr_sa_rwa_result
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rpt_mr_sa_rwa_result exchange partition p_${batch_date} with table ${iol_schema}.rwas_rpt_mr_sa_rwa_result_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rpt_mr_sa_rwa_result to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rpt_mr_sa_rwa_result_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rpt_mr_sa_rwa_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);