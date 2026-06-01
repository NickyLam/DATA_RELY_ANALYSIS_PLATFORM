/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ctms_tbs_v_openrepodeals
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
alter table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals drop partition p_${last_date};
alter table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ctms_tbs_v_openrepodeals partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,deal_id  -- 引用表ID
    ,deal_tablename  -- 引用表名
    ,aspclient_id  -- 部门编号
    ,serial_number  -- 交易序号
    ,portfolio_id  -- 投组编号
    ,portfolio_name  -- 投组名称
    ,keepfolder_id  -- 账户ID
    ,keepfolder_shortname  -- 账号名称
    ,currency  -- 币种
    ,buyorsell  -- 交易方向
    ,amount  -- 首期金额
    ,trade_rate  -- 回购利率
    ,ref_number  -- 成交编号
    ,trade_date  -- 交易日期
    ,value_date  -- 首期交割日
    ,maturity_date  -- 到期交割日
    ,bondscode  -- 债券代码
    ,bondsname  -- 债券名称
    ,face_amount  -- 券面总额
    ,first_price  -- 首期净价
    ,maturity_price  -- 到期净价
    ,maturity_amount  -- 到期金额
    ,interest  -- 应计利息
    ,cpty_id  -- 交易对手ID
    ,cpty_name  -- 交易对手名称
    ,dealer_id  -- 交易员ID
    ,dealer_name  -- 交易员名称
    ,fee1  -- 首期费用
    ,tax_amt1  -- 首期税金
    ,broker_amt1  -- 首期佣金
    ,fee2  -- 到期费用
    ,tax_amt2  -- 到期税金
    ,broker_amt2  -- 到期佣金
    ,tradingfee  -- 交易费
    ,settle_type  -- 首期交割方式
    ,settle_type2  -- 到期交割方式
    ,source  -- 交易来源
    ,cfets_from  -- 是否是CFETS交易
    ,spot_v  -- 近端连结面额
    ,fwd_v  -- 远端连结面额
    ,cstp_req  -- 是否需要连结原始交易
    ,keep_type  -- 核算方法
    ,note  -- 备注
    ,datasymbol_id  -- 数据源ID
    ,lastmodified  -- 最后修改时间
    ,openrepodeals_id_grand  -- 原始交易ID
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.deal_id  -- 引用表ID
    ,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'')  -- 引用表名
    ,t1.aspclient_id  -- 部门编号
    ,replace(replace(t1.serial_number,chr(13),''),chr(10),'')  -- 交易序号
    ,t1.portfolio_id  -- 投组编号
    ,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'')  -- 投组名称
    ,t1.keepfolder_id  -- 账户ID
    ,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'')  -- 账号名称
    ,replace(replace(t1.currency,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.buyorsell,chr(13),''),chr(10),'')  -- 交易方向
    ,t1.amount  -- 首期金额
    ,t1.trade_rate  -- 回购利率
    ,replace(replace(t1.ref_number,chr(13),''),chr(10),'')  -- 成交编号
    ,t1.trade_date  -- 交易日期
    ,t1.value_date  -- 首期交割日
    ,t1.maturity_date  -- 到期交割日
    ,replace(replace(t1.bondscode,chr(13),''),chr(10),'')  -- 债券代码
    ,replace(replace(t1.bondsname,chr(13),''),chr(10),'')  -- 债券名称
    ,t1.face_amount  -- 券面总额
    ,t1.first_price  -- 首期净价
    ,t1.maturity_price  -- 到期净价
    ,t1.maturity_amount  -- 到期金额
    ,t1.interest  -- 应计利息
    ,t1.cpty_id  -- 交易对手ID
    ,replace(replace(t1.cpty_name,chr(13),''),chr(10),'')  -- 交易对手名称
    ,t1.dealer_id  -- 交易员ID
    ,replace(replace(t1.dealer_name,chr(13),''),chr(10),'')  -- 交易员名称
    ,t1.fee1  -- 首期费用
    ,t1.tax_amt1  -- 首期税金
    ,t1.broker_amt1  -- 首期佣金
    ,t1.fee2  -- 到期费用
    ,t1.tax_amt2  -- 到期税金
    ,t1.broker_amt2  -- 到期佣金
    ,t1.tradingfee  -- 交易费
    ,replace(replace(t1.settle_type,chr(13),''),chr(10),'')  -- 首期交割方式
    ,replace(replace(t1.settle_type2,chr(13),''),chr(10),'')  -- 到期交割方式
    ,replace(replace(t1.source,chr(13),''),chr(10),'')  -- 交易来源
    ,replace(replace(t1.cfets_from,chr(13),''),chr(10),'')  -- 是否是CFETS交易
    ,t1.spot_v  -- 近端连结面额
    ,t1.fwd_v  -- 远端连结面额
    ,replace(replace(t1.cstp_req,chr(13),''),chr(10),'')  -- 是否需要连结原始交易
    ,replace(replace(t1.keep_type,chr(13),''),chr(10),'')  -- 核算方法
    ,replace(replace(t1.note,chr(13),''),chr(10),'')  -- 备注
    ,t1.datasymbol_id  -- 数据源ID
    ,t1.lastmodified  -- 最后修改时间
    ,t1.openrepodeals_id_grand  -- 原始交易ID
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iol_schema}.ctms_tbs_v_openrepodeals t1    --开放式回购交易
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ctms_tbs_v_openrepodeals',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);