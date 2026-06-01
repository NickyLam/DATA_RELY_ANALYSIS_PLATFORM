/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl rwas_rpt_tran_securities
CreateDate: 20241128
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.rwas_rpt_tran_securities purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.rwas_rpt_tran_securities(
etl_dt date --etl处理日期
,data_date date --数据日期
,loan_ref_no varchar2(150) --借据号
,sec_no varchar2(90) --债券编号
,sec_name varchar2(150) --债券名称
,product_no varchar2(45) --标准产品编号
,product_name varchar2(45) --标准产品名称
,loan_ref_desc varchar2(600) --债项描述
,tradetypeid varchar2(30) --多空头标志
,asset_thd_cls_cd varchar2(30) --金融资产分类
,s_grade varchar2(15) --主体评级
,grade varchar2(15) --债券评级
,int_rat_adj_way_cd varchar2(45) --利率类别
,coupon varchar2(15) --债券利率
,start_date date --起息日
,due_date date --到期日期
,next_reval_date date --下一重定价日期
,rema__reval_date number(18,6) --剩余重定价期限(月)
,remainingmaturity number(18,6) --剩余期限(月)
,org_cd varchar2(90) --入账机构编号
,org_name varchar2(150) --入账机构名称
,cust_no varchar2(90) --发行人客户号
,cust_name varchar2(300) --发行人名称
,ccp_type_cd varchar2(90) --交易对手类型
,ccp_type_name varchar2(90) --交易对手类型名称
,sec_type_cd varchar2(90) --债券类型
,subject_cd varchar2(24) --本金科目代码
,subject_name varchar2(300) --本金科目名称
,accrued_subject_cd varchar2(24) --应计利息科目
,accrued_subject_name varchar2(300) --应计利息科目名称
,receivable_subject_cd varchar2(24) --应收利息科目
,receivable_subject_name varchar2(300) --应收利息科目名称
,accrued_receiv_subject_cd varchar2(24) --应收未收利息科目
,accrued_receiv_subject_name varchar2(300) --应收未收利息名称
,intadj_subject_cd varchar2(24) --利息调整科目
,intadj_subject_name varchar2(300) --利息调整科目名称
,fairchange_subject_cd varchar2(24) --公允价值变动科目
,fairchange_subject_name varchar2(300) --公允价值变动科目名称
,provision_subject_cd varchar2(24) --准备金科目代码
,provision_subject_name varchar2(300) --准备金科目名称
,ccy_cd varchar2(15) --币种代码
,ccy_name varchar2(90) --币种名称
,balance number(18,2) --本金余额(原币)
,balance_hcurr number(18,2) --本金余额(本币)
,receivable_int number(18,2) --应收利息(本币)
,accrued_receiv_int number(18,2) --应收未收利息（本币）
,accrued_int number(18,2) --应计利息(本币)
,int_adj number(18,2) --利息调整(本币)
,fair_value_change number(18,2) --公允价值变动(本币)
,provision number(18,2) --计提准备金(本币)
,asset_balance number(18,2) --资产余额(本币）
,ead_orig number(18,2) --原始风险暴露（本币）
,rate_sec_type_cd varchar2(60) --特定利率风险债券类型
,specific_risk_ratio varchar2(15) --利率特定风险资本计提比率
,spec_risk_capital_amount number(18,2) --利率特定风险资本
,coupon_flag varchar2(15) --年息票率大于等于3%标志
,mat_bucketid varchar2(90) --时段
,specific_risk_charge varchar2(15) --风险权重
,exposureamount number(18,2) --一般市场风险的资本要求总额
,general_risk_capital_amount number(18,2) --一般利率风险资本
,due_date_risk number(18,2) --到期日风险资本
,rwaamount number(18,2) --rwa
,scra_rating varchar2(15) --scra评级
,orig_maturity number(18,2) --原始期限
,load_date varchar2(30) --加载日期

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.rwas_rpt_tran_securities to ${iel_schema};

-- comment
comment on table ${idl_schema}.rwas_rpt_tran_securities is '内部管理报表_交易债券';
comment on column ${idl_schema}.rwas_rpt_tran_securities.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.rwas_rpt_tran_securities.data_date is '数据日期';
comment on column ${idl_schema}.rwas_rpt_tran_securities.loan_ref_no is '借据号';
comment on column ${idl_schema}.rwas_rpt_tran_securities.sec_no is '债券编号';
comment on column ${idl_schema}.rwas_rpt_tran_securities.sec_name is '债券名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.product_no is '标准产品编号';
comment on column ${idl_schema}.rwas_rpt_tran_securities.product_name is '标准产品名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.loan_ref_desc is '债项描述';
comment on column ${idl_schema}.rwas_rpt_tran_securities.tradetypeid is '多空头标志';
comment on column ${idl_schema}.rwas_rpt_tran_securities.asset_thd_cls_cd is '金融资产分类';
comment on column ${idl_schema}.rwas_rpt_tran_securities.s_grade is '主体评级';
comment on column ${idl_schema}.rwas_rpt_tran_securities.grade is '债券评级';
comment on column ${idl_schema}.rwas_rpt_tran_securities.int_rat_adj_way_cd is '利率类别';
comment on column ${idl_schema}.rwas_rpt_tran_securities.coupon is '债券利率';
comment on column ${idl_schema}.rwas_rpt_tran_securities.start_date is '起息日';
comment on column ${idl_schema}.rwas_rpt_tran_securities.due_date is '到期日期';
comment on column ${idl_schema}.rwas_rpt_tran_securities.next_reval_date is '下一重定价日期';
comment on column ${idl_schema}.rwas_rpt_tran_securities.rema__reval_date is '剩余重定价期限(月)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.remainingmaturity is '剩余期限(月)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.org_cd is '入账机构编号';
comment on column ${idl_schema}.rwas_rpt_tran_securities.org_name is '入账机构名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.cust_no is '发行人客户号';
comment on column ${idl_schema}.rwas_rpt_tran_securities.cust_name is '发行人名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.ccp_type_cd is '交易对手类型';
comment on column ${idl_schema}.rwas_rpt_tran_securities.ccp_type_name is '交易对手类型名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.sec_type_cd is '债券类型';
comment on column ${idl_schema}.rwas_rpt_tran_securities.subject_cd is '本金科目代码';
comment on column ${idl_schema}.rwas_rpt_tran_securities.subject_name is '本金科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_subject_cd is '应计利息科目';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_subject_name is '应计利息科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.receivable_subject_cd is '应收利息科目';
comment on column ${idl_schema}.rwas_rpt_tran_securities.receivable_subject_name is '应收利息科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_receiv_subject_cd is '应收未收利息科目';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_receiv_subject_name is '应收未收利息名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.intadj_subject_cd is '利息调整科目';
comment on column ${idl_schema}.rwas_rpt_tran_securities.intadj_subject_name is '利息调整科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.fairchange_subject_cd is '公允价值变动科目';
comment on column ${idl_schema}.rwas_rpt_tran_securities.fairchange_subject_name is '公允价值变动科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.provision_subject_cd is '准备金科目代码';
comment on column ${idl_schema}.rwas_rpt_tran_securities.provision_subject_name is '准备金科目名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.ccy_cd is '币种代码';
comment on column ${idl_schema}.rwas_rpt_tran_securities.ccy_name is '币种名称';
comment on column ${idl_schema}.rwas_rpt_tran_securities.balance is '本金余额(原币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.balance_hcurr is '本金余额(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.receivable_int is '应收利息(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_receiv_int is '应收未收利息（本币）';
comment on column ${idl_schema}.rwas_rpt_tran_securities.accrued_int is '应计利息(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.int_adj is '利息调整(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.fair_value_change is '公允价值变动(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.provision is '计提准备金(本币)';
comment on column ${idl_schema}.rwas_rpt_tran_securities.asset_balance is '资产余额(本币）';
comment on column ${idl_schema}.rwas_rpt_tran_securities.ead_orig is '原始风险暴露（本币）';
comment on column ${idl_schema}.rwas_rpt_tran_securities.rate_sec_type_cd is '特定利率风险债券类型';
comment on column ${idl_schema}.rwas_rpt_tran_securities.specific_risk_ratio is '利率特定风险资本计提比率';
comment on column ${idl_schema}.rwas_rpt_tran_securities.spec_risk_capital_amount is '利率特定风险资本';
comment on column ${idl_schema}.rwas_rpt_tran_securities.coupon_flag is '年息票率大于等于3%标志';
comment on column ${idl_schema}.rwas_rpt_tran_securities.mat_bucketid is '时段';
comment on column ${idl_schema}.rwas_rpt_tran_securities.specific_risk_charge is '风险权重';
comment on column ${idl_schema}.rwas_rpt_tran_securities.exposureamount is '一般市场风险的资本要求总额';
comment on column ${idl_schema}.rwas_rpt_tran_securities.general_risk_capital_amount is '一般利率风险资本';
comment on column ${idl_schema}.rwas_rpt_tran_securities.due_date_risk is '到期日风险资本';
comment on column ${idl_schema}.rwas_rpt_tran_securities.rwaamount is 'rwa';
comment on column ${idl_schema}.rwas_rpt_tran_securities.scra_rating is 'scra评级';
comment on column ${idl_schema}.rwas_rpt_tran_securities.orig_maturity is '原始期限';
comment on column ${idl_schema}.rwas_rpt_tran_securities.load_date is '加载日期';

