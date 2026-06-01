/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ctms_tbs_v_wtrade_lend
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
alter table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend drop partition p_${last_date};
alter table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ctms_tbs_v_wtrade_lend partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,deal_id  -- 引用表ID
    ,deal_tablename  -- 引用表名
    ,aspclient_id  -- 部门编号
    ,portfolio_id  -- 交易组别
    ,portfolio_name  -- 交易组别名称
    ,serial_number  -- 交易序号
    ,user_number  -- 操作员
    ,branch_number  -- 分支机构号
    ,currency  -- 币别
    ,buyorsell  -- 交易方向
    ,amount  -- 面额
    ,trade_rate  -- 借贷费率
    ,market_rate  -- 市值
    ,value_date  -- 首期结算日
    ,maturity_date  -- 到期结算日
    ,trade_date  -- 交易录入日
    ,trade_time  -- 交易时间
    ,ref_number  -- 成交编号
    ,link_serial_number  -- 删除或修改的原始交易
    ,status  -- 状态
    ,dealer  -- 交易员ID
    ,account  -- 
    ,maturity_amount  -- 到期结算金额
    ,lend_id  -- 交易品种
    ,bondscode  -- 质押券代码
    ,lendbondscode  -- 标的券代码
    ,fee  -- 首期费用
    ,tax_amt  -- 首期税金
    ,broker_amt  -- 首期佣金
    ,interest  -- 应计利息
    ,note  -- 备注
    ,day_count  -- 日计息基准
    ,process_status  -- 处理状态
    ,realized_pl  -- 已实现损益
    ,unrealized_pl  -- 未实现损益
    ,total_pl  -- 总损益
    ,daily_pl  -- 每日损益
    ,interest_pl  -- 利息损益
    ,realized_days  -- 实际天数
    ,ori_trade_date  -- 原始交易日
    ,security_face_amount  -- 抵押品每张券面总额
    ,collateral_type  -- 抵押品种类
    ,lend_rate  -- 抵押比例
    ,settle_type  -- 首次结算方式
    ,settle_type2  -- 到期结算方式
    ,deal_time  -- 交易时间
    ,modify_user  -- 修改人
    ,keepfolder_id  -- 账户ID
    ,keepfolder_shortname  -- 账户名称
    ,cptys_short_name  -- 交易对手名
    ,cptys_id  -- 交易对手序号
    ,ref_deal_sn  -- 参考编号
    ,valid_source_sn  -- 连结的审批序号
    ,cancel_reason  -- 审批单被撤销理由
    ,source  -- 交易来源
    ,input_from  -- 输入来源
    ,cstp_serial  -- 原始交易序号
    ,cfets_from  -- 是否是CFETS交易
    ,lend_days  -- 借贷期限
    ,inv_type  -- 库存方式
    ,inv_short  -- 库存是否短仓
    ,auto_import  -- 是否自动导入
    ,price_flag  -- 金额标识
    ,match_flag  -- 是否匹配
    ,is_trans_quote  -- 审批单是否转成报价
    ,wtrade_lend_id_grand  -- 原始交易ID
    ,datasymbol_id  -- 数据源ID
    ,orig_serial_number  -- 原始交易序号
    ,impstatus  -- 导入状态
    ,prostatus  -- 处理状态
    ,spotfwd  -- 远期/即期
    ,lastmodified  -- 最后修改时间
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.deal_id  -- 引用表ID
    ,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'')  -- 引用表名
    ,t1.aspclient_id  -- 部门编号
    ,t1.portfolio_id  -- 交易组别
    ,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'')  -- 交易组别名称
    ,replace(replace(t1.serial_number,chr(13),''),chr(10),'')  -- 交易序号
    ,t1.user_number  -- 操作员
    ,t1.branch_number  -- 分支机构号
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 币别
    ,replace(replace(t1.buyorsell,chr(13),''),chr(10),'')  -- 交易方向
    ,t1.amount  -- 面额
    ,t1.trade_rate  -- 借贷费率
    ,t1.market_rate  -- 市值
    ,replace(replace(t1.value_date,chr(13),''),chr(10),'')  -- 首期结算日
    ,replace(replace(t1.maturity_date,chr(13),''),chr(10),'')  -- 到期结算日
    ,replace(replace(t1.trade_date,chr(13),''),chr(10),'')  -- 交易录入日
    ,t1.trade_time  -- 交易时间
    ,replace(replace(t1.ref_number,chr(13),''),chr(10),'')  -- 成交编号
    ,replace(replace(t1.link_serial_number,chr(13),''),chr(10),'')  -- 删除或修改的原始交易
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 状态
    ,t1.dealer  -- 交易员ID
    ,replace(replace(t1.account,chr(13),''),chr(10),'')  -- 
    ,t1.maturity_amount  -- 到期结算金额
    ,replace(replace(t1.lend_id,chr(13),''),chr(10),'')  -- 交易品种
    ,replace(replace(t1.bondscode,chr(13),''),chr(10),'')  -- 质押券代码
    ,replace(replace(t1.lendbondscode,chr(13),''),chr(10),'')  -- 标的券代码
    ,t1.fee  -- 首期费用
    ,t1.tax_amt  -- 首期税金
    ,t1.broker_amt  -- 首期佣金
    ,t1.interest  -- 应计利息
    ,replace(replace(t1.note,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.day_count,chr(13),''),chr(10),'')  -- 日计息基准
    ,replace(replace(t1.process_status,chr(13),''),chr(10),'')  -- 处理状态
    ,t1.realized_pl  -- 已实现损益
    ,t1.unrealized_pl  -- 未实现损益
    ,t1.total_pl  -- 总损益
    ,t1.daily_pl  -- 每日损益
    ,t1.interest_pl  -- 利息损益
    ,t1.realized_days  -- 实际天数
    ,replace(replace(t1.ori_trade_date,chr(13),''),chr(10),'')  -- 原始交易日
    ,replace(replace(t1.security_face_amount,chr(13),''),chr(10),'')  -- 抵押品每张券面总额
    ,replace(replace(t1.collateral_type,chr(13),''),chr(10),'')  -- 抵押品种类
    ,replace(replace(t1.lend_rate,chr(13),''),chr(10),'')  -- 抵押比例
    ,replace(replace(t1.settle_type,chr(13),''),chr(10),'')  -- 首次结算方式
    ,replace(replace(t1.settle_type2,chr(13),''),chr(10),'')  -- 到期结算方式
    ,t1.deal_time  -- 交易时间
    ,t1.modify_user  -- 修改人
    ,t1.keepfolder_id  -- 账户ID
    ,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cptys_short_name,chr(13),''),chr(10),'')  -- 交易对手名
    ,t1.cptys_id  -- 交易对手序号
    ,replace(replace(t1.ref_deal_sn,chr(13),''),chr(10),'')  -- 参考编号
    ,replace(replace(t1.valid_source_sn,chr(13),''),chr(10),'')  -- 连结的审批序号
    ,replace(replace(t1.cancel_reason,chr(13),''),chr(10),'')  -- 审批单被撤销理由
    ,replace(replace(t1.source,chr(13),''),chr(10),'')  -- 交易来源
    ,replace(replace(t1.input_from,chr(13),''),chr(10),'')  -- 输入来源
    ,replace(replace(t1.cstp_serial,chr(13),''),chr(10),'')  -- 原始交易序号
    ,replace(replace(t1.cfets_from,chr(13),''),chr(10),'')  -- 是否是CFETS交易
    ,t1.lend_days  -- 借贷期限
    ,replace(replace(t1.inv_type,chr(13),''),chr(10),'')  -- 库存方式
    ,replace(replace(t1.inv_short,chr(13),''),chr(10),'')  -- 库存是否短仓
    ,replace(replace(t1.auto_import,chr(13),''),chr(10),'')  -- 是否自动导入
    ,replace(replace(t1.price_flag,chr(13),''),chr(10),'')  -- 金额标识
    ,replace(replace(t1.match_flag,chr(13),''),chr(10),'')  -- 是否匹配
    ,replace(replace(t1.is_trans_quote,chr(13),''),chr(10),'')  -- 审批单是否转成报价
    ,t1.wtrade_lend_id_grand  -- 原始交易ID
    ,t1.datasymbol_id  -- 数据源ID
    ,replace(replace(t1.orig_serial_number,chr(13),''),chr(10),'')  -- 原始交易序号
    ,replace(replace(t1.impstatus,chr(13),''),chr(10),'')  -- 导入状态
    ,replace(replace(t1.prostatus,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.spotfwd,chr(13),''),chr(10),'')  -- 远期/即期
    ,t1.lastmodified  -- 最后修改时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iol_schema}.ctms_tbs_v_wtrade_lend t1    --债券借贷交易
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ctms_tbs_v_wtrade_lend',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);