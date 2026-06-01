/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ctms_tbs_v_iamdeals
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
alter table ${idl_schema}.icrm_ctms_tbs_v_iamdeals drop partition p_${last_date};
alter table ${idl_schema}.icrm_ctms_tbs_v_iamdeals drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ctms_tbs_v_iamdeals add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ctms_tbs_v_iamdeals partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,deal_id  -- 引用表ID
    ,deal_tablename  -- 引用表名
    ,aspclient_id  -- 部门编号
    ,serial_number  -- 交易号(标识数据表中记录的唯一组合)
    ,trade_date  -- 首期交易日
    ,value_date  -- 首期交割日
    ,maturity_date  -- 到期交割日
    ,buyorsell  -- 交易方向
    ,repo_rate  -- 拆借利率
    ,amount  -- 首期结算金额
    ,maturity_amount  -- 到期结算金额
    ,fee  -- 首期费用
    ,tax_amt  -- 首期税金
    ,broker_amt  -- 首期佣金
    ,interest  -- 应计利息
    ,portfolio_id  -- 交易组别
    ,portfolio_name  -- 交易组别名称
    ,keepfolder_id  -- 账户ID
    ,keepfolder_shortname  -- 账户名称
    ,cptys_short_name  -- 交易对手名
    ,cptys_id  -- 交易对手ID
    ,dealer_id  -- 交易员ID
    ,dealer_name  -- 交易员姓名
    ,ref_number  -- 成交编号
    ,cfets_from  -- 是否是CFETS交易
    ,lastmodified  -- 最后修改时间
    ,datasymbol_id  -- 数据源ID
    ,repo_days  -- 拆借天数
    ,iamdeals_id_grand  -- 原始交易ID
    ,note  -- 备注
    ,counterparty_type  -- 交易类别
    ,repo_id  -- 交易品种
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.deal_id  -- 引用表ID
    ,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'')  -- 引用表名
    ,t1.aspclient_id  -- 部门编号
    ,replace(replace(t1.serial_number,chr(13),''),chr(10),'')  -- 交易号(标识数据表中记录的唯一组合)
    ,t1.trade_date  -- 首期交易日
    ,t1.value_date  -- 首期交割日
    ,t1.maturity_date  -- 到期交割日
    ,replace(replace(t1.buyorsell,chr(13),''),chr(10),'')  -- 交易方向
    ,t1.repo_rate  -- 拆借利率
    ,t1.amount  -- 首期结算金额
    ,t1.maturity_amount  -- 到期结算金额
    ,t1.fee  -- 首期费用
    ,t1.tax_amt  -- 首期税金
    ,t1.broker_amt  -- 首期佣金
    ,t1.interest  -- 应计利息
    ,t1.portfolio_id  -- 交易组别
    ,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'')  -- 交易组别名称
    ,t1.keepfolder_id  -- 账户ID
    ,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cptys_short_name,chr(13),''),chr(10),'')  -- 交易对手名
    ,t1.cptys_id  -- 交易对手ID
    ,t1.dealer_id  -- 交易员ID
    ,replace(replace(t1.dealer_name,chr(13),''),chr(10),'')  -- 交易员姓名
    ,replace(replace(t1.ref_number,chr(13),''),chr(10),'')  -- 成交编号
    ,replace(replace(t1.cfets_from,chr(13),''),chr(10),'')  -- 是否是CFETS交易
    ,t1.lastmodified  -- 最后修改时间
    ,t1.datasymbol_id  -- 数据源ID
    ,t1.repo_days  -- 拆借天数
    ,t1.iamdeals_id_grand  -- 原始交易ID
    ,replace(replace(t1.note,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.counterparty_type,chr(13),''),chr(10),'')  -- 交易类别
    ,replace(replace(t1.repo_id,chr(13),''),chr(10),'')  -- 交易品种
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iol_schema}.ctms_tbs_v_iamdeals t1    --拆借交易
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ctms_tbs_v_iamdeals',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);