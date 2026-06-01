/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rpt_bond_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rpt_bond_invest
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rpt_bond_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rpt_bond_invest(
    data_date date -- 数据日期
    ,loan_ref_no varchar2(150) -- 债项编号
    ,loan_ref_desc varchar2(600) -- 债项描述
    ,contract_no varchar2(150) -- 合同编号
    ,src_system_id varchar2(30) -- 来源系统标识
    ,accorg_no varchar2(30) -- 账务机构
    ,accorg_name varchar2(383) -- 账务机构名称
    ,five_class_cd varchar2(30) -- 五级分类代码
    ,five_class_name varchar2(30) -- 五级分类名称
    ,product_cd varchar2(60) -- 产品代码
    ,product_name varchar2(600) -- 产品名称
    ,bis_product_type_cd varchar2(120) -- 监管产品类型代码
    ,bis_product_type_name varchar2(300) -- 监管产品类型名称
    ,bis_product_btype_cd varchar2(60) -- 监管产品大类代码
    ,bis_product_btype_name varchar2(300) -- 监管产品大类名称
    ,buss_type_cd varchar2(75) -- 业务类型
    ,buss_type_name varchar2(300) -- 业务名称
    ,start_date date -- 起息日
    ,due_date date -- 到期日期
    ,orig_maturity number(18,2) -- 原始期限
    ,overdue_days number(22) -- 逾期天数
    ,std_default_flag varchar2(15) -- 权重法违约标志
    ,book_type_id varchar2(15) -- 账簿类型
    ,book_type_name varchar2(30) -- 账簿名称
    ,on_off_id varchar2(15) -- 表内外资产标志
    ,bis_ccy_cd varchar2(15) -- 计量币种代码
    ,bis_ccy_name varchar2(96) -- 计量币种名称
    ,exchange_rate number(18,8) -- 汇率
    ,subject_cd varchar2(24) -- 本金科目代码
    ,subject_name varchar2(300) -- 本金科目名称
    ,pric_bal_origcurr number(18,2) -- 本金余额（原币）
    ,pric_bal number(18,2) -- 本金余额（本币）
    ,asset_balance number(18,2) -- 资产余额（本币）
    ,accrued_subject_cd varchar2(24) -- 应计利息科目
    ,accrued_subject_name varchar2(300) -- 应计利息科目名称
    ,accrued_int number(18,2) -- 应计利息（本币）
    ,receivable_subject_cd varchar2(24) -- 应收利息科目
    ,receivable_subject_name varchar2(300) -- 应收利息科目名称
    ,receivable_int number(18,2) -- 应收利息（本币）
    ,accrued_receiv_subject_cd varchar2(24) -- 应收未收利息科目
    ,accrued_receiv_subject_name varchar2(300) -- 应收未收利息名称
    ,accrued_receiv_int number(18,2) -- 应收未收利息（本币）
    ,intadj_subject_cd varchar2(24) -- 利息调整科目
    ,intadj_subject_name varchar2(300) -- 利息调整科目名称
    ,int_adj number(18,2) -- 利息调整（本币）
    ,fairchange_subject_cd varchar2(24) -- 公允价值变动科目
    ,fairchange_subject_name varchar2(300) -- 公允价值变动科目名称
    ,fairvalue_changes number(18,2) -- 公允价值变动（本币）
    ,depreamor_subject_cd varchar2(24) -- 折旧科目
    ,depreamor_subject_name varchar2(300) -- 折旧科目名称
    ,depre_amortizat number(18,2) -- 折旧金额（本币）
    ,other_subject_cd varchar2(24) -- 其他科目
    ,other_subject_name varchar2(300) -- 其他科目名称
    ,other_amt number(18,2) -- 其他金额（本币）
    ,provision_subject_cd varchar2(24) -- 准备金科目代码
    ,provision_subject_name varchar2(300) -- 准备金科目名称
    ,provision number(18,2) -- 准备金（本币）
    ,provesion_ratio number(18,6) -- 准备金计提比例
    ,account_classification varchar2(15) -- 金融资产分类
    ,cust_no varchar2(150) -- 客户号
    ,cust_name varchar2(384) -- 客户名称
    ,ccp_type_cd varchar2(60) -- 交易对手类型代码
    ,ccp_type_name varchar2(300) -- 交易对手类型名称
    ,ccp_btype_cd varchar2(60) -- 交易对手大类代码
    ,ccp_btype_name varchar2(150) -- 交易对手大类名称
    ,spe_lending_flag varchar2(15) -- 专业贷款标志
    ,spe_lending_type varchar2(150) -- 专业贷款分类
    ,bis_country_name varchar2(300) -- 注册国名称
    ,sov_sp_lt_rating_cd varchar2(30) -- 注册国标普评级代码
    ,cust_sp_lt_rating_cd varchar2(30) -- 客户标普评级
    ,scra_rating varchar2(15) -- SCRA评级
    ,int_trade_flag varchar2(3) -- 内部交易标志
    ,solo_int_trade_flag varchar2(3) -- 法人内部交易标志
    ,investment_cust_flag varchar2(15) -- 投资级客户标志
    ,ccy_mismatch_flag varchar2(3) -- 币种错配标志
    ,accept_credit_self_flag varchar2(3) -- 自开信用证标志
    ,real_estate_type_cd varchar2(300) -- 房地产风险暴露类型名称
    ,ltv number(18,6) -- LTV规则
    ,accept_discount_self_flag varchar2(3) -- 自承自贴标志
    ,operation_pf_flag varchar2(3) -- 项目融资运营阶段标识
    ,cancel_flag varchar2(3) -- 随时可撤销标志
    ,off_asset_unmeasured_flag varchar2(3) -- 表外资产不计量标志
    ,unused_prl_tmeet_flag varchar2(3) -- 符合标准的未使用额度标志
    ,ead_orig number(18,2) -- 原始风险暴露
    ,ccf number(18,6) -- 表外信用风险转换系数
    ,ead_afterccf number(18,2) -- 转换后的风险暴露
    ,ead_afterpro number(18,2) -- 扣减准备金后的风险暴露
    ,rw number(18,6) -- 权重
    ,crm_ccy_mis_flag varchar2(15) -- 是否存在缓释币种错配
    ,crm_amt_rmb number(18,2) -- 缓释金额折本币
    ,crm_amt_split number(18,2) -- 缓释金额拆分本币
    ,crm_ccy_mis_coeff number(18,6) -- 缓释币种错配折扣系数
    ,crm_mat_mis_coeff number(18,6) -- 缓释期限错配系数
    ,crm_floor_mis_coeff number(18,6) -- 底线折扣系数
    ,crm_weighting_rw number(18,6) -- 缓释加权权重
    ,rwa_ucovered number(18,6) -- 缓释未覆盖部分的RWA
    ,rwa_covered number(18,6) -- 缓释覆盖部分的RWA
    ,rwa number(18,2) -- 风险加权资产
    ,c_item_e number(18,6) -- 现金类资产
    ,c_item_f number(18,6) -- 我国中央政府
    ,c_item_g number(18,6) -- 中国人民银行
    ,c_item_h number(18,6) -- 我国开发性金融机构和政策性银行
    ,c_item_i number(18,6) -- 省级（自治区、直辖市）及计划单列市人民政府-一般债券
    ,c_item_j number(18,6) -- 省级（自治区、直辖市）及计划单列市人民政府-专项债券
    ,c_item_k number(18,6) -- 其他收入主要源于中央财政的公共部门实体
    ,c_item_l number(18,6) -- 经金融监管总局认定的我国一般公共部门实体
    ,c_item_m number(18,6) -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券
    ,c_item_n number(18,6) -- 评级AA-以上（含）的国家和地区的中央政府和中央银行
    ,c_item_o number(18,6) -- 评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_p number(18,6) -- 评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行
    ,c_item_q number(18,6) -- 评级AA-（含）及以上国家和地区注册的公共部门实体
    ,c_item_r number(18,6) -- 评级AA-以下，A-（含）以上国家和地区注册的公共部门实体
    ,c_item_s number(18,6) -- A+级和A级境内外商业银行（短期）
    ,c_item_t number(18,6) -- A+级境内外商业银行
    ,c_item_u number(18,6) -- A级境内外商业银行
    ,c_item_v number(18,6) -- 合格多边开发银行
    ,c_item_w number(18,6) -- 评级AA-（含）以上的其他多边开发银行
    ,c_item_x number(18,6) -- 对评级AA-以下，A-（含）以上的其他多边开发银行
    ,c_item_y number(18,6) -- 评级A-以下，BBB-（含）以上的其他多边开发银行
    ,c_item_z number(18,6) -- 国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制
    ,report_no varchar2(30) -- 报表编号
    ,report_line_no varchar2(60) -- 报表栏位号
    ,report_line_name varchar2(300) -- G4B栏位名称
    ,investment_vaild_flag varchar2(15) -- 投资级认定是否在有效期内
    ,recognition_date date -- 认定日期
    ,sec_no varchar2(90) -- 债券编号
    ,sec_name varchar2(150) -- 债券名称
    ,load_date varchar2(30) -- 加载日期
    ,final_weight varchar2(15) -- 最终风险权重
    ,nvestment_rema_maturity number(18) -- 投资级认定剩余有效期限天数
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
grant select on ${iol_schema}.rwas_rpt_bond_invest to ${iml_schema};
grant select on ${iol_schema}.rwas_rpt_bond_invest to ${icl_schema};
grant select on ${iol_schema}.rwas_rpt_bond_invest to ${idl_schema};
grant select on ${iol_schema}.rwas_rpt_bond_invest to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rpt_bond_invest is '内部管理报表_债券投资';
comment on column ${iol_schema}.rwas_rpt_bond_invest.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rpt_bond_invest.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.loan_ref_desc is '债项描述';
comment on column ${iol_schema}.rwas_rpt_bond_invest.contract_no is '合同编号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.src_system_id is '来源系统标识';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accorg_no is '账务机构';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accorg_name is '账务机构名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.five_class_cd is '五级分类代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.five_class_name is '五级分类名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.product_cd is '产品代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.product_name is '产品名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_product_type_cd is '监管产品类型代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_product_type_name is '监管产品类型名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_product_btype_cd is '监管产品大类代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_product_btype_name is '监管产品大类名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.buss_type_cd is '业务类型';
comment on column ${iol_schema}.rwas_rpt_bond_invest.buss_type_name is '业务名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.start_date is '起息日';
comment on column ${iol_schema}.rwas_rpt_bond_invest.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rpt_bond_invest.orig_maturity is '原始期限';
comment on column ${iol_schema}.rwas_rpt_bond_invest.overdue_days is '逾期天数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.std_default_flag is '权重法违约标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.book_type_id is '账簿类型';
comment on column ${iol_schema}.rwas_rpt_bond_invest.book_type_name is '账簿名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.on_off_id is '表内外资产标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_ccy_cd is '计量币种代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_ccy_name is '计量币种名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.exchange_rate is '汇率';
comment on column ${iol_schema}.rwas_rpt_bond_invest.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.subject_name is '本金科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.pric_bal_origcurr is '本金余额（原币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.pric_bal is '本金余额（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.asset_balance is '资产余额（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_subject_cd is '应计利息科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_subject_name is '应计利息科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_int is '应计利息（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.receivable_subject_cd is '应收利息科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.receivable_subject_name is '应收利息科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.receivable_int is '应收利息（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_receiv_subject_cd is '应收未收利息科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_receiv_subject_name is '应收未收利息名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accrued_receiv_int is '应收未收利息（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.intadj_subject_cd is '利息调整科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.intadj_subject_name is '利息调整科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.int_adj is '利息调整（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.fairchange_subject_cd is '公允价值变动科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.fairchange_subject_name is '公允价值变动科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.fairvalue_changes is '公允价值变动（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.depreamor_subject_cd is '折旧科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.depreamor_subject_name is '折旧科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.depre_amortizat is '折旧金额（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.other_subject_cd is '其他科目';
comment on column ${iol_schema}.rwas_rpt_bond_invest.other_subject_name is '其他科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.other_amt is '其他金额（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.provision_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.provision_subject_name is '准备金科目名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.provision is '准备金（本币）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.provesion_ratio is '准备金计提比例';
comment on column ${iol_schema}.rwas_rpt_bond_invest.account_classification is '金融资产分类';
comment on column ${iol_schema}.rwas_rpt_bond_invest.cust_no is '客户号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.cust_name is '客户名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccp_type_cd is '交易对手类型代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccp_type_name is '交易对手类型名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccp_btype_cd is '交易对手大类代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccp_btype_name is '交易对手大类名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.spe_lending_flag is '专业贷款标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.spe_lending_type is '专业贷款分类';
comment on column ${iol_schema}.rwas_rpt_bond_invest.bis_country_name is '注册国名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.sov_sp_lt_rating_cd is '注册国标普评级代码';
comment on column ${iol_schema}.rwas_rpt_bond_invest.cust_sp_lt_rating_cd is '客户标普评级';
comment on column ${iol_schema}.rwas_rpt_bond_invest.scra_rating is 'SCRA评级';
comment on column ${iol_schema}.rwas_rpt_bond_invest.int_trade_flag is '内部交易标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.solo_int_trade_flag is '法人内部交易标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.investment_cust_flag is '投资级客户标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccy_mismatch_flag is '币种错配标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accept_credit_self_flag is '自开信用证标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.real_estate_type_cd is '房地产风险暴露类型名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ltv is 'LTV规则';
comment on column ${iol_schema}.rwas_rpt_bond_invest.accept_discount_self_flag is '自承自贴标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.operation_pf_flag is '项目融资运营阶段标识';
comment on column ${iol_schema}.rwas_rpt_bond_invest.cancel_flag is '随时可撤销标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.off_asset_unmeasured_flag is '表外资产不计量标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.unused_prl_tmeet_flag is '符合标准的未使用额度标志';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ead_orig is '原始风险暴露';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ccf is '表外信用风险转换系数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ead_afterccf is '转换后的风险暴露';
comment on column ${iol_schema}.rwas_rpt_bond_invest.ead_afterpro is '扣减准备金后的风险暴露';
comment on column ${iol_schema}.rwas_rpt_bond_invest.rw is '权重';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_ccy_mis_flag is '是否存在缓释币种错配';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_amt_rmb is '缓释金额折本币';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_amt_split is '缓释金额拆分本币';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_ccy_mis_coeff is '缓释币种错配折扣系数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_mat_mis_coeff is '缓释期限错配系数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_floor_mis_coeff is '底线折扣系数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.crm_weighting_rw is '缓释加权权重';
comment on column ${iol_schema}.rwas_rpt_bond_invest.rwa_ucovered is '缓释未覆盖部分的RWA';
comment on column ${iol_schema}.rwas_rpt_bond_invest.rwa_covered is '缓释覆盖部分的RWA';
comment on column ${iol_schema}.rwas_rpt_bond_invest.rwa is '风险加权资产';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_e is '现金类资产';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_f is '我国中央政府';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_g is '中国人民银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_h is '我国开发性金融机构和政策性银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_i is '省级（自治区、直辖市）及计划单列市人民政府-一般债券';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_j is '省级（自治区、直辖市）及计划单列市人民政府-专项债券';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_k is '其他收入主要源于中央财政的公共部门实体';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_l is '经金融监管总局认定的我国一般公共部门实体';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_m is '金融资产管理公司为收购国有银行不良贷款而定向发行的债券';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_n is '评级AA-以上（含）的国家和地区的中央政府和中央银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_o is '评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_p is '评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_q is '评级AA-（含）及以上国家和地区注册的公共部门实体';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_r is '评级AA-以下，A-（含）以上国家和地区注册的公共部门实体';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_s is 'A+级和A级境内外商业银行（短期）';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_t is 'A+级境内外商业银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_u is 'A级境内外商业银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_v is '合格多边开发银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_w is '评级AA-（含）以上的其他多边开发银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_x is '对评级AA-以下，A-（含）以上的其他多边开发银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_y is '评级A-以下，BBB-（含）以上的其他多边开发银行';
comment on column ${iol_schema}.rwas_rpt_bond_invest.c_item_z is '国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制';
comment on column ${iol_schema}.rwas_rpt_bond_invest.report_no is '报表编号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.report_line_no is '报表栏位号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.report_line_name is 'G4B栏位名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.investment_vaild_flag is '投资级认定是否在有效期内';
comment on column ${iol_schema}.rwas_rpt_bond_invest.recognition_date is '认定日期';
comment on column ${iol_schema}.rwas_rpt_bond_invest.sec_no is '债券编号';
comment on column ${iol_schema}.rwas_rpt_bond_invest.sec_name is '债券名称';
comment on column ${iol_schema}.rwas_rpt_bond_invest.load_date is '加载日期';
comment on column ${iol_schema}.rwas_rpt_bond_invest.final_weight is '最终风险权重';
comment on column ${iol_schema}.rwas_rpt_bond_invest.nvestment_rema_maturity is '投资级认定剩余有效期限天数';
comment on column ${iol_schema}.rwas_rpt_bond_invest.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rpt_bond_invest.etl_timestamp is 'ETL处理时间戳';
