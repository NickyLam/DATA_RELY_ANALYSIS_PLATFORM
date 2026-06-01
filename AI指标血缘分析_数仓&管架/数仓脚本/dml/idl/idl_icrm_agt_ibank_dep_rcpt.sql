/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_ibank_dep_rcpt
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
alter table ${idl_schema}.icrm_agt_ibank_dep_rcpt drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_ibank_dep_rcpt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_ibank_dep_rcpt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_ibank_dep_rcpt partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,vouch_id  -- 凭证编号
    ,lp_id  -- 法人编号
    ,dep_rcpt_cd  -- 存单代码
    ,asset_type_cd  -- 资产类型代码
    ,market_type_cd  -- 市场类型代码
    ,curr_cd  -- 币种代码
    ,quot_way_cd  -- 报价方式代码
    ,dep_rcpt_name  -- 存单名称
    ,prod_type_cd  -- 产品类型代码
    ,prod_type_name  -- 产品类型名称
    ,int_rat_pct_spd_bp  -- 利率%、利差BP
    ,issue_qtty  -- 发行量(亿元)
    ,issue_price  -- 发行价格
    ,lowt_issue_price  -- 最低发行价格
    ,higt_issue_price  -- 最高发行价格
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,tenor_val  -- 期限值(天)
    ,fir_int_rat_cfm_dt  -- 首次利率确定日期
    ,pay_int_freq_cd  -- 付息频率代码
    ,issue_way_cd  -- 发行方式代码
    ,coupon_type_cd  -- 息票类型代码
    ,base_rat_id  -- 基准利率编号
    ,base_asset_type_id  -- 基准资产类型编号
    ,base_market_type_id  -- 基准市场类型编号
    ,stl_status_cd  -- 结算状态代码
    ,pay_dt  -- 缴款日期
    ,cash_dt  -- 兑付日期
    ,issue_dt  -- 发行日期
    ,annual_int_rat  -- 年化利率
    ,int_accr_base_cd  -- 计息基准代码
    ,fir_pay_int_dt  -- 首次付息日期
    ,invt_bid_way_cd  -- 招标方式代码
    ,lowt_yld_rat  -- 最低收益率
    ,higt_yld_rat  -- 最高收益率
    ,actl_issue_qtty  -- 实际发行量(亿元)
    ,issuer_name  -- 发行人名称
    ,range  -- 范围
    ,rating_org  -- 评级机构
    ,rating  -- 评级
    ,fac_val  -- 票面
    ,start_issue_dt  -- 开始发行日期
    ,end_issue_dt  -- 结束发行日期
    ,max_subscr_qtty  -- 最大认购量
    ,min_subscr_qtty  -- 最小认购量
    ,sig_max_subscr_qtty  -- 单笔最大认购量
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.vouch_id,chr(13),''),chr(10),'')  -- 凭证编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.dep_rcpt_cd,chr(13),''),chr(10),'')  -- 存单代码
    ,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'')  -- 资产类型代码
    ,replace(replace(t1.market_type_cd,chr(13),''),chr(10),'')  -- 市场类型代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.quot_way_cd,chr(13),''),chr(10),'')  -- 报价方式代码
    ,replace(replace(t1.dep_rcpt_name,chr(13),''),chr(10),'')  -- 存单名称
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'')  -- 产品类型名称
    ,t1.int_rat_pct_spd_bp  -- 利率%、利差BP
    ,t1.issue_qtty  -- 发行量(亿元)
    ,t1.issue_price  -- 发行价格
    ,t1.lowt_issue_price  -- 最低发行价格
    ,t1.higt_issue_price  -- 最高发行价格
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.tenor_val  -- 期限值(天)
    ,t1.fir_int_rat_cfm_dt  -- 首次利率确定日期
    ,replace(replace(t1.pay_int_freq_cd,chr(13),''),chr(10),'')  -- 付息频率代码
    ,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'')  -- 发行方式代码
    ,replace(replace(t1.coupon_type_cd,chr(13),''),chr(10),'')  -- 息票类型代码
    ,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'')  -- 基准利率编号
    ,replace(replace(t1.base_asset_type_id,chr(13),''),chr(10),'')  -- 基准资产类型编号
    ,replace(replace(t1.base_market_type_id,chr(13),''),chr(10),'')  -- 基准市场类型编号
    ,replace(replace(t2.vouch_status_cd,chr(13),''),chr(10),'') as stl_status_cd  -- 结算状态代码
    ,t1.pay_dt  -- 缴款日期
    ,t1.cash_dt  -- 兑付日期
    ,t1.issue_dt  -- 发行日期
    ,t1.annual_int_rat  -- 年化利率
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,t1.fir_pay_int_dt  -- 首次付息日期
    ,replace(replace(t1.invt_bid_way_cd,chr(13),''),chr(10),'')  -- 招标方式代码
    ,t1.lowt_yld_rat  -- 最低收益率
    ,t1.higt_yld_rat  -- 最高收益率
    ,t1.actl_issue_qtty  -- 实际发行量(亿元)
    ,replace(replace(t1.issuer_name,chr(13),''),chr(10),'')  -- 发行人名称
    ,replace(replace(t1.range,chr(13),''),chr(10),'')  -- 范围
    ,replace(replace(t1.rating_org,chr(13),''),chr(10),'')  -- 评级机构
    ,replace(replace(t1.rating,chr(13),''),chr(10),'')  -- 评级
    ,t1.fac_val  -- 票面
    ,t1.start_issue_dt  -- 开始发行日期
    ,t1.end_issue_dt  -- 结束发行日期
    ,t1.max_subscr_qtty  -- 最大认购量
    ,t1.min_subscr_qtty  -- 最小认购量
    ,t1.sig_max_subscr_qtty  -- 单笔最大认购量
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_ibank_dep_rcpt t1    --同业存单表
left join iml.agt_vouch_status_h t2  --凭证状态历史
    on t1.vouch_id=t2.vouch_id
    and t1.lp_id = t2.lp_id
    and t2.vouch_status_type_cd ='CD1778'
    and t2.job_cd ='ibmsf1'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_ibank_dep_rcpt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);