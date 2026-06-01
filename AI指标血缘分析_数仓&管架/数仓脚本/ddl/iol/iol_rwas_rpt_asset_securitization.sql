/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rpt_asset_securitization
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rpt_asset_securitization
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rpt_asset_securitization purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rpt_asset_securitization(
    data_date date -- 数据日期
    ,loan_ref_no varchar2(150) -- 债项编号
    ,sec_items_issue_no varchar2(150) -- 资产证券化发行编号
    ,sec_items_issue_name varchar2(150) -- 资产证券化发行产品名称
    ,items_tranche_no varchar2(60) -- 资产证券化档次编号
    ,items_tranche_name varchar2(150) -- 资产证券化档次名称
    ,on_off_id varchar2(30) -- 表内外资产标志：01 表内,02 表外
    ,sec_priority_rating_flag varchar2(30) -- 证券化优先档次标志：1 优先档，0 非优先档
    ,market_type_id varchar2(15) -- 市场类型代码
    ,org_cd varchar2(45) -- 账务机构
    ,org_name varchar2(150) -- 账务机构名称
    ,overdue_days number(22) -- 逾期天数
    ,five_class_cd varchar2(30) -- 五级分类代码
    ,five_class_name varchar2(30) -- 五级分类名称
    ,product_no varchar2(45) -- 产品代码
    ,product_name varchar2(150) -- 产品名称
    ,sec_sp_rating_cd varchar2(30) -- 外部评级代码
    ,sec_rating_org_cd varchar2(30) -- 证券评级机构代码
    ,sec_rating_org_name varchar2(150) -- 证券评级机构名称
    ,sec_ecternal_rating_cd varchar2(30) -- 债券标普评级
    ,items_tranche_due_day date -- 持有档次的预期到期日
    ,items_seniority varchar2(30) -- 项目档次优先级：1 优先档，0 非优先档
    ,issue_amt_total number(18,2) -- 产品当期总余额
    ,amt_cur number(18,2) -- 产品当期总余额
    ,sec_stc_flag varchar2(30) -- 资产证券化简单透明可比标志：1 STC，0 非STC
    ,anew_asset_sec_flag varchar2(30) -- 再资产证券化标志：1 是，0 否
    ,sec_start_date date -- 证券起息日
    ,sec_end_date date -- 证券到期日
    ,sec_pool_a number(25,9) -- 档次起始点A
    ,sec_pool_d number(25,9) -- 档次分离点D
    ,sec_pool_t number(25,9) -- 厚度T
    ,sec_pool_mr number(25,9) -- 剩余有效期限
    ,sec_rating_floor_rw number(25,9) -- 外部评级1年期权重
    ,sec_rating_ceil_rw number(25,9) -- 外部评级5年期权重
    ,sec_orig_rw number(18,6) -- 资产证券化原始权重
    ,sec_pool_rw number(18,6) -- 资产池平均权重
    ,sec_rw number(18,6) -- 资产证券化调整后权重
    ,sec_rw_adj number(18,6) -- 资产证券化底线调整后的权重
    ,ccy_cd varchar2(15) -- 币种代码
    ,ccy_name varchar2(45) -- 币种名称
    ,subject_cd varchar2(24) -- 本金科目代码
    ,subject_name varchar2(300) -- 本金科目名称
    ,accrued_subject_cd varchar2(24) -- 应计利息科目
    ,accrued_subject_name varchar2(300) -- 应计利息科目名称
    ,receivable_subject_cd varchar2(24) -- 应收利息科目
    ,receivable_subject_name varchar2(300) -- 应收利息科目名称
    ,accrued_receiv_subject_cd varchar2(24) -- 应收未收利息科目
    ,accrued_receiv_subject_name varchar2(300) -- 应收未收利息名称
    ,intadj_subject_cd varchar2(24) -- 利息调整科目
    ,intadj_subject_name varchar2(300) -- 利息调整科目名称
    ,fairchange_subject_cd varchar2(24) -- 公允价值变动科目
    ,fairchange_subject_name varchar2(300) -- 公允价值变动科目名称
    ,provision_subject_cd varchar2(24) -- 准备金科目代码
    ,provision_subject_name varchar2(300) -- 准备金科目名称
    ,balance number(18,2) -- 本金余额（原币）
    ,balance_hcurr number(18,2) -- 本金余额（本币）
    ,receivable_int number(18,2) -- 应收利息(本币)
    ,accrued_receiv_int number(18,2) -- 应收未收利息（本币）
    ,accrued_int number(18,2) -- 应计利息(本币)
    ,int_adj number(18,2) -- 利息调整(本币)
    ,fair_value_change number(18,2) -- 公允价值变动(本币)
    ,provision number(18,2) -- 计提准备金(本币)
    ,asset_balance number(18,2) -- 资产余额(本币）
    ,ead_orig number(18,2) -- 原始风险暴露(本币）
    ,ccf number(18,6) -- 表外信用风险转换系数
    ,ead_afterccf number(18,2) -- 转换后的风险暴露(本币）
    ,ead_afterpro number(18,2) -- 扣减准备金后的风险暴露（本币）
    ,rwa number(18,2) -- 风险加权资产
    ,after_miti_rwa number(18,2) -- 缓释后的风险加权资产
    ,after_adj_rwa number(18,2) -- 考虑监管上限调整后的风险加权资产
    ,report_no varchar2(30) -- 报表编号
    ,report_line_no varchar2(60) -- 报表栏位号
    ,load_date varchar2(30) -- 加载日期
    ,book_type_id varchar2(30) -- 账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿
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
grant select on ${iol_schema}.rwas_rpt_asset_securitization to ${iml_schema};
grant select on ${iol_schema}.rwas_rpt_asset_securitization to ${icl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_securitization to ${idl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_securitization to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rpt_asset_securitization is '内部管理报表_资产证券化';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_items_issue_no is '资产证券化发行编号';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_items_issue_name is '资产证券化发行产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.items_tranche_no is '资产证券化档次编号';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.items_tranche_name is '资产证券化档次名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.on_off_id is '表内外资产标志：01 表内,02 表外';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_priority_rating_flag is '证券化优先档次标志：1 优先档，0 非优先档';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.market_type_id is '市场类型代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.org_cd is '账务机构';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.org_name is '账务机构名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.overdue_days is '逾期天数';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.five_class_cd is '五级分类代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.five_class_name is '五级分类名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.product_no is '产品代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.product_name is '产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_sp_rating_cd is '外部评级代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rating_org_cd is '证券评级机构代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rating_org_name is '证券评级机构名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_ecternal_rating_cd is '债券标普评级';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.items_tranche_due_day is '持有档次的预期到期日';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.items_seniority is '项目档次优先级：1 优先档，0 非优先档';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.issue_amt_total is '产品当期总余额';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.amt_cur is '产品当期总余额';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_stc_flag is '资产证券化简单透明可比标志：1 STC，0 非STC';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.anew_asset_sec_flag is '再资产证券化标志：1 是，0 否';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_start_date is '证券起息日';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_end_date is '证券到期日';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_pool_a is '档次起始点A';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_pool_d is '档次分离点D';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_pool_t is '厚度T';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_pool_mr is '剩余有效期限';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rating_floor_rw is '外部评级1年期权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rating_ceil_rw is '外部评级5年期权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_orig_rw is '资产证券化原始权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_pool_rw is '资产池平均权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rw is '资产证券化调整后权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.sec_rw_adj is '资产证券化底线调整后的权重';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ccy_name is '币种名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.subject_name is '本金科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_subject_cd is '应计利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_subject_name is '应计利息科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.receivable_subject_cd is '应收利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.receivable_subject_name is '应收利息科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_receiv_subject_cd is '应收未收利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_receiv_subject_name is '应收未收利息名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.intadj_subject_cd is '利息调整科目';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.intadj_subject_name is '利息调整科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.fairchange_subject_cd is '公允价值变动科目';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.fairchange_subject_name is '公允价值变动科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.provision_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.provision_subject_name is '准备金科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.balance is '本金余额（原币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.balance_hcurr is '本金余额（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_receiv_int is '应收未收利息（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.asset_balance is '资产余额(本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ead_orig is '原始风险暴露(本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ccf is '表外信用风险转换系数';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ead_afterccf is '转换后的风险暴露(本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.ead_afterpro is '扣减准备金后的风险暴露（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.rwa is '风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.after_miti_rwa is '缓释后的风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.after_adj_rwa is '考虑监管上限调整后的风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.report_no is '报表编号';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.report_line_no is '报表栏位号';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.load_date is '加载日期';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.book_type_id is '账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rpt_asset_securitization.etl_timestamp is 'ETL处理时间戳';
