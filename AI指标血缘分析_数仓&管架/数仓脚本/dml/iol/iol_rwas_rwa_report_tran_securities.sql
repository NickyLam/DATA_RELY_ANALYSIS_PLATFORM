/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rwa_report_tran_securities
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rwas_rwa_report_tran_securities_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rwas_rwa_report_tran_securities
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_rwa_report_tran_securities_op purge;
drop table ${iol_schema}.rwas_rwa_report_tran_securities_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_tran_securities_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rwa_report_tran_securities where 0=1;

create table ${iol_schema}.rwas_rwa_report_tran_securities_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rwa_report_tran_securities where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_rwa_report_tran_securities_cl(
            data_date -- 数据日期
            ,loan_ref_id -- 债项ID
            ,loan_ref_no -- 借据号
            ,sec_no -- 证券编号
            ,tradetypeid -- 多空头标志
            ,asset_thd_cls_cd -- 金融资产分类
            ,s_grade -- 主体评级
            ,grade -- 债券评级
            ,int_rat_adj_way_cd -- 利率类别
            ,coupon -- 债券利率
            ,start_date -- 开始日期
            ,due_date -- 到期日期
            ,next_reval_date -- 下一重定价日期
            ,rema__reval_date -- 剩余重定价期限(月)
            ,remainingmaturity -- 剩余期限(月)
            ,org_cd -- 入账机构
            ,cust_name -- 发行人名称
            ,ccp_type_cd -- 客户类型(引擎)
            ,sec_type_cd -- 证券类型
            ,assettype_id -- 资产类型(引擎)
            ,subject_cd -- 本金科目代码
            ,interest_receive_subject_cd -- 应收利息科目代码
            ,accrual_class_subject_cd -- 应计科目代码
            ,interest_adjust_subject_cd -- 利息调整科目代码
            ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
            ,provision_single_subject_cd -- 准备金科目代码
            ,asset_balance -- 资产余额(原币)
            ,ccy_cd -- 币种代码
            ,asset_balance_hcurr -- 资产余额(本币)
            ,receivable_int -- 应收利息(本币)
            ,accrued_int -- 应计利息(本币)
            ,int_adj -- 利息调整(本币)
            ,fair_value_change -- 公允价值变动(本币)
            ,provision -- 计提准备金(本币)
            ,amt -- 证券头寸金额(本币)
            ,rate_sec_type_cd -- 特定利率风险债券类型
            ,specific_risk_ratio -- 利率特定风险资本计提比率
            ,spec_risk_capital_amount -- 利率特定风险资本
            ,coupon_flag -- 年息票率大于等于3%标志
            ,mat_bucketid -- 时段
            ,specific_risk_charge -- 风险权重
            ,exposureamount -- 一般市场风险的资本要求总额
            ,rwaamount -- RWA
            ,sec_name -- 证券名称
            ,product_name -- 交易品种
            ,general_risk_capital_amount -- 一般利率风险资本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_rwa_report_tran_securities_op(
            data_date -- 数据日期
            ,loan_ref_id -- 债项ID
            ,loan_ref_no -- 借据号
            ,sec_no -- 证券编号
            ,tradetypeid -- 多空头标志
            ,asset_thd_cls_cd -- 金融资产分类
            ,s_grade -- 主体评级
            ,grade -- 债券评级
            ,int_rat_adj_way_cd -- 利率类别
            ,coupon -- 债券利率
            ,start_date -- 开始日期
            ,due_date -- 到期日期
            ,next_reval_date -- 下一重定价日期
            ,rema__reval_date -- 剩余重定价期限(月)
            ,remainingmaturity -- 剩余期限(月)
            ,org_cd -- 入账机构
            ,cust_name -- 发行人名称
            ,ccp_type_cd -- 客户类型(引擎)
            ,sec_type_cd -- 证券类型
            ,assettype_id -- 资产类型(引擎)
            ,subject_cd -- 本金科目代码
            ,interest_receive_subject_cd -- 应收利息科目代码
            ,accrual_class_subject_cd -- 应计科目代码
            ,interest_adjust_subject_cd -- 利息调整科目代码
            ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
            ,provision_single_subject_cd -- 准备金科目代码
            ,asset_balance -- 资产余额(原币)
            ,ccy_cd -- 币种代码
            ,asset_balance_hcurr -- 资产余额(本币)
            ,receivable_int -- 应收利息(本币)
            ,accrued_int -- 应计利息(本币)
            ,int_adj -- 利息调整(本币)
            ,fair_value_change -- 公允价值变动(本币)
            ,provision -- 计提准备金(本币)
            ,amt -- 证券头寸金额(本币)
            ,rate_sec_type_cd -- 特定利率风险债券类型
            ,specific_risk_ratio -- 利率特定风险资本计提比率
            ,spec_risk_capital_amount -- 利率特定风险资本
            ,coupon_flag -- 年息票率大于等于3%标志
            ,mat_bucketid -- 时段
            ,specific_risk_charge -- 风险权重
            ,exposureamount -- 一般市场风险的资本要求总额
            ,rwaamount -- RWA
            ,sec_name -- 证券名称
            ,product_name -- 交易品种
            ,general_risk_capital_amount -- 一般利率风险资本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.data_date, o.data_date) as data_date -- 数据日期
    ,nvl(n.loan_ref_id, o.loan_ref_id) as loan_ref_id -- 债项ID
    ,nvl(n.loan_ref_no, o.loan_ref_no) as loan_ref_no -- 借据号
    ,nvl(n.sec_no, o.sec_no) as sec_no -- 证券编号
    ,nvl(n.tradetypeid, o.tradetypeid) as tradetypeid -- 多空头标志
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 金融资产分类
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 主体评级
    ,nvl(n.grade, o.grade) as grade -- 债券评级
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率类别
    ,nvl(n.coupon, o.coupon) as coupon -- 债券利率
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.due_date, o.due_date) as due_date -- 到期日期
    ,nvl(n.next_reval_date, o.next_reval_date) as next_reval_date -- 下一重定价日期
    ,nvl(n.rema__reval_date, o.rema__reval_date) as rema__reval_date -- 剩余重定价期限(月)
    ,nvl(n.remainingmaturity, o.remainingmaturity) as remainingmaturity -- 剩余期限(月)
    ,nvl(n.org_cd, o.org_cd) as org_cd -- 入账机构
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 发行人名称
    ,nvl(n.ccp_type_cd, o.ccp_type_cd) as ccp_type_cd -- 客户类型(引擎)
    ,nvl(n.sec_type_cd, o.sec_type_cd) as sec_type_cd -- 证券类型
    ,nvl(n.assettype_id, o.assettype_id) as assettype_id -- 资产类型(引擎)
    ,nvl(n.subject_cd, o.subject_cd) as subject_cd -- 本金科目代码
    ,nvl(n.interest_receive_subject_cd, o.interest_receive_subject_cd) as interest_receive_subject_cd -- 应收利息科目代码
    ,nvl(n.accrual_class_subject_cd, o.accrual_class_subject_cd) as accrual_class_subject_cd -- 应计科目代码
    ,nvl(n.interest_adjust_subject_cd, o.interest_adjust_subject_cd) as interest_adjust_subject_cd -- 利息调整科目代码
    ,nvl(n.fairvalue_changes_subject_cd, o.fairvalue_changes_subject_cd) as fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,nvl(n.provision_single_subject_cd, o.provision_single_subject_cd) as provision_single_subject_cd -- 准备金科目代码
    ,nvl(n.asset_balance, o.asset_balance) as asset_balance -- 资产余额(原币)
    ,nvl(n.ccy_cd, o.ccy_cd) as ccy_cd -- 币种代码
    ,nvl(n.asset_balance_hcurr, o.asset_balance_hcurr) as asset_balance_hcurr -- 资产余额(本币)
    ,nvl(n.receivable_int, o.receivable_int) as receivable_int -- 应收利息(本币)
    ,nvl(n.accrued_int, o.accrued_int) as accrued_int -- 应计利息(本币)
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调整(本币)
    ,nvl(n.fair_value_change, o.fair_value_change) as fair_value_change -- 公允价值变动(本币)
    ,nvl(n.provision, o.provision) as provision -- 计提准备金(本币)
    ,nvl(n.amt, o.amt) as amt -- 证券头寸金额(本币)
    ,nvl(n.rate_sec_type_cd, o.rate_sec_type_cd) as rate_sec_type_cd -- 特定利率风险债券类型
    ,nvl(n.specific_risk_ratio, o.specific_risk_ratio) as specific_risk_ratio -- 利率特定风险资本计提比率
    ,nvl(n.spec_risk_capital_amount, o.spec_risk_capital_amount) as spec_risk_capital_amount -- 利率特定风险资本
    ,nvl(n.coupon_flag, o.coupon_flag) as coupon_flag -- 年息票率大于等于3%标志
    ,nvl(n.mat_bucketid, o.mat_bucketid) as mat_bucketid -- 时段
    ,nvl(n.specific_risk_charge, o.specific_risk_charge) as specific_risk_charge -- 风险权重
    ,nvl(n.exposureamount, o.exposureamount) as exposureamount -- 一般市场风险的资本要求总额
    ,nvl(n.rwaamount, o.rwaamount) as rwaamount -- RWA
    ,nvl(n.sec_name, o.sec_name) as sec_name -- 证券名称
    ,nvl(n.product_name, o.product_name) as product_name -- 交易品种
    ,nvl(n.general_risk_capital_amount, o.general_risk_capital_amount) as general_risk_capital_amount -- 一般利率风险资本
    ,case when
            n.data_date is null
            and n.loan_ref_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.data_date is null
            and n.loan_ref_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.data_date is null
            and n.loan_ref_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rwas_rwa_report_tran_securities_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rwas_rwa_report_tran_securities where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.data_date = n.data_date
            and o.loan_ref_id = n.loan_ref_id
where (
        o.data_date is null
        and o.loan_ref_id is null
    )
    or (
        n.data_date is null
        and n.loan_ref_id is null
    )
    or (
        o.loan_ref_no <> n.loan_ref_no
        or o.sec_no <> n.sec_no
        or o.tradetypeid <> n.tradetypeid
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.s_grade <> n.s_grade
        or o.grade <> n.grade
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.coupon <> n.coupon
        or o.start_date <> n.start_date
        or o.due_date <> n.due_date
        or o.next_reval_date <> n.next_reval_date
        or o.rema__reval_date <> n.rema__reval_date
        or o.remainingmaturity <> n.remainingmaturity
        or o.org_cd <> n.org_cd
        or o.cust_name <> n.cust_name
        or o.ccp_type_cd <> n.ccp_type_cd
        or o.sec_type_cd <> n.sec_type_cd
        or o.assettype_id <> n.assettype_id
        or o.subject_cd <> n.subject_cd
        or o.interest_receive_subject_cd <> n.interest_receive_subject_cd
        or o.accrual_class_subject_cd <> n.accrual_class_subject_cd
        or o.interest_adjust_subject_cd <> n.interest_adjust_subject_cd
        or o.fairvalue_changes_subject_cd <> n.fairvalue_changes_subject_cd
        or o.provision_single_subject_cd <> n.provision_single_subject_cd
        or o.asset_balance <> n.asset_balance
        or o.ccy_cd <> n.ccy_cd
        or o.asset_balance_hcurr <> n.asset_balance_hcurr
        or o.receivable_int <> n.receivable_int
        or o.accrued_int <> n.accrued_int
        or o.int_adj <> n.int_adj
        or o.fair_value_change <> n.fair_value_change
        or o.provision <> n.provision
        or o.amt <> n.amt
        or o.rate_sec_type_cd <> n.rate_sec_type_cd
        or o.specific_risk_ratio <> n.specific_risk_ratio
        or o.spec_risk_capital_amount <> n.spec_risk_capital_amount
        or o.coupon_flag <> n.coupon_flag
        or o.mat_bucketid <> n.mat_bucketid
        or o.specific_risk_charge <> n.specific_risk_charge
        or o.exposureamount <> n.exposureamount
        or o.rwaamount <> n.rwaamount
        or o.sec_name <> n.sec_name
        or o.product_name <> n.product_name
        or o.general_risk_capital_amount <> n.general_risk_capital_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_rwa_report_tran_securities_cl(
            data_date -- 数据日期
            ,loan_ref_id -- 债项ID
            ,loan_ref_no -- 借据号
            ,sec_no -- 证券编号
            ,tradetypeid -- 多空头标志
            ,asset_thd_cls_cd -- 金融资产分类
            ,s_grade -- 主体评级
            ,grade -- 债券评级
            ,int_rat_adj_way_cd -- 利率类别
            ,coupon -- 债券利率
            ,start_date -- 开始日期
            ,due_date -- 到期日期
            ,next_reval_date -- 下一重定价日期
            ,rema__reval_date -- 剩余重定价期限(月)
            ,remainingmaturity -- 剩余期限(月)
            ,org_cd -- 入账机构
            ,cust_name -- 发行人名称
            ,ccp_type_cd -- 客户类型(引擎)
            ,sec_type_cd -- 证券类型
            ,assettype_id -- 资产类型(引擎)
            ,subject_cd -- 本金科目代码
            ,interest_receive_subject_cd -- 应收利息科目代码
            ,accrual_class_subject_cd -- 应计科目代码
            ,interest_adjust_subject_cd -- 利息调整科目代码
            ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
            ,provision_single_subject_cd -- 准备金科目代码
            ,asset_balance -- 资产余额(原币)
            ,ccy_cd -- 币种代码
            ,asset_balance_hcurr -- 资产余额(本币)
            ,receivable_int -- 应收利息(本币)
            ,accrued_int -- 应计利息(本币)
            ,int_adj -- 利息调整(本币)
            ,fair_value_change -- 公允价值变动(本币)
            ,provision -- 计提准备金(本币)
            ,amt -- 证券头寸金额(本币)
            ,rate_sec_type_cd -- 特定利率风险债券类型
            ,specific_risk_ratio -- 利率特定风险资本计提比率
            ,spec_risk_capital_amount -- 利率特定风险资本
            ,coupon_flag -- 年息票率大于等于3%标志
            ,mat_bucketid -- 时段
            ,specific_risk_charge -- 风险权重
            ,exposureamount -- 一般市场风险的资本要求总额
            ,rwaamount -- RWA
            ,sec_name -- 证券名称
            ,product_name -- 交易品种
            ,general_risk_capital_amount -- 一般利率风险资本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_rwa_report_tran_securities_op(
            data_date -- 数据日期
            ,loan_ref_id -- 债项ID
            ,loan_ref_no -- 借据号
            ,sec_no -- 证券编号
            ,tradetypeid -- 多空头标志
            ,asset_thd_cls_cd -- 金融资产分类
            ,s_grade -- 主体评级
            ,grade -- 债券评级
            ,int_rat_adj_way_cd -- 利率类别
            ,coupon -- 债券利率
            ,start_date -- 开始日期
            ,due_date -- 到期日期
            ,next_reval_date -- 下一重定价日期
            ,rema__reval_date -- 剩余重定价期限(月)
            ,remainingmaturity -- 剩余期限(月)
            ,org_cd -- 入账机构
            ,cust_name -- 发行人名称
            ,ccp_type_cd -- 客户类型(引擎)
            ,sec_type_cd -- 证券类型
            ,assettype_id -- 资产类型(引擎)
            ,subject_cd -- 本金科目代码
            ,interest_receive_subject_cd -- 应收利息科目代码
            ,accrual_class_subject_cd -- 应计科目代码
            ,interest_adjust_subject_cd -- 利息调整科目代码
            ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
            ,provision_single_subject_cd -- 准备金科目代码
            ,asset_balance -- 资产余额(原币)
            ,ccy_cd -- 币种代码
            ,asset_balance_hcurr -- 资产余额(本币)
            ,receivable_int -- 应收利息(本币)
            ,accrued_int -- 应计利息(本币)
            ,int_adj -- 利息调整(本币)
            ,fair_value_change -- 公允价值变动(本币)
            ,provision -- 计提准备金(本币)
            ,amt -- 证券头寸金额(本币)
            ,rate_sec_type_cd -- 特定利率风险债券类型
            ,specific_risk_ratio -- 利率特定风险资本计提比率
            ,spec_risk_capital_amount -- 利率特定风险资本
            ,coupon_flag -- 年息票率大于等于3%标志
            ,mat_bucketid -- 时段
            ,specific_risk_charge -- 风险权重
            ,exposureamount -- 一般市场风险的资本要求总额
            ,rwaamount -- RWA
            ,sec_name -- 证券名称
            ,product_name -- 交易品种
            ,general_risk_capital_amount -- 一般利率风险资本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.data_date -- 数据日期
    ,o.loan_ref_id -- 债项ID
    ,o.loan_ref_no -- 借据号
    ,o.sec_no -- 证券编号
    ,o.tradetypeid -- 多空头标志
    ,o.asset_thd_cls_cd -- 金融资产分类
    ,o.s_grade -- 主体评级
    ,o.grade -- 债券评级
    ,o.int_rat_adj_way_cd -- 利率类别
    ,o.coupon -- 债券利率
    ,o.start_date -- 开始日期
    ,o.due_date -- 到期日期
    ,o.next_reval_date -- 下一重定价日期
    ,o.rema__reval_date -- 剩余重定价期限(月)
    ,o.remainingmaturity -- 剩余期限(月)
    ,o.org_cd -- 入账机构
    ,o.cust_name -- 发行人名称
    ,o.ccp_type_cd -- 客户类型(引擎)
    ,o.sec_type_cd -- 证券类型
    ,o.assettype_id -- 资产类型(引擎)
    ,o.subject_cd -- 本金科目代码
    ,o.interest_receive_subject_cd -- 应收利息科目代码
    ,o.accrual_class_subject_cd -- 应计科目代码
    ,o.interest_adjust_subject_cd -- 利息调整科目代码
    ,o.fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,o.provision_single_subject_cd -- 准备金科目代码
    ,o.asset_balance -- 资产余额(原币)
    ,o.ccy_cd -- 币种代码
    ,o.asset_balance_hcurr -- 资产余额(本币)
    ,o.receivable_int -- 应收利息(本币)
    ,o.accrued_int -- 应计利息(本币)
    ,o.int_adj -- 利息调整(本币)
    ,o.fair_value_change -- 公允价值变动(本币)
    ,o.provision -- 计提准备金(本币)
    ,o.amt -- 证券头寸金额(本币)
    ,o.rate_sec_type_cd -- 特定利率风险债券类型
    ,o.specific_risk_ratio -- 利率特定风险资本计提比率
    ,o.spec_risk_capital_amount -- 利率特定风险资本
    ,o.coupon_flag -- 年息票率大于等于3%标志
    ,o.mat_bucketid -- 时段
    ,o.specific_risk_charge -- 风险权重
    ,o.exposureamount -- 一般市场风险的资本要求总额
    ,o.rwaamount -- RWA
    ,o.sec_name -- 证券名称
    ,o.product_name -- 交易品种
    ,o.general_risk_capital_amount -- 一般利率风险资本
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.rwas_rwa_report_tran_securities_bk o
    left join ${iol_schema}.rwas_rwa_report_tran_securities_op n
        on
            o.data_date = n.data_date
            and o.loan_ref_id = n.loan_ref_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rwas_rwa_report_tran_securities_cl d
        on
            o.data_date = d.data_date
            and o.loan_ref_id = d.loan_ref_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rwas_rwa_report_tran_securities;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rwas_rwa_report_tran_securities') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rwas_rwa_report_tran_securities drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rwas_rwa_report_tran_securities add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rwas_rwa_report_tran_securities exchange partition p_${batch_date} with table ${iol_schema}.rwas_rwa_report_tran_securities_cl;
alter table ${iol_schema}.rwas_rwa_report_tran_securities exchange partition p_20991231 with table ${iol_schema}.rwas_rwa_report_tran_securities_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rwa_report_tran_securities to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_rwa_report_tran_securities_op purge;
drop table ${iol_schema}.rwas_rwa_report_tran_securities_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rwas_rwa_report_tran_securities_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rwa_report_tran_securities',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
