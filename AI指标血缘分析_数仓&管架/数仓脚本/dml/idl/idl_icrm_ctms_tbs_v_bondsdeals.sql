/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ctms_tbs_v_bondsdeals
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
alter table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals drop partition p_${last_date};
alter table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ctms_tbs_v_bondsdeals partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,deal_id  -- 引用表ID
    ,deal_tablename  -- 引用表名
    ,aspclient_id  -- 部门编号
    ,bondscode  -- 债券代码
    ,bondsname  -- 债券名称
    ,bondstype  -- 债券类型
    ,serial_number  -- 交易号
    ,tradedate  -- 交易日
    ,settledate  -- 交割日
    ,buyorsell  -- 买卖方向
    ,cleanprice  -- 交易净价
    ,dirtyprice  -- 交易全价
    ,yieldtomaturity  -- 到期收益率
    ,settleamount  -- 结算金额
    ,portfolio_id  -- 交易组别
    ,portfolio_name  -- 交易组别名称
    ,keepfolder_id  -- 账户ID
    ,keepfolder_shortname  -- 账户名称
    ,folderatts  -- 账户属性
    ,classfyname  -- 四分类名称
    ,cptys_shortname  -- 交易对手名称
    ,cptys_id  -- 交易对手ID
    ,settletype  -- 结算方式
    ,dealer_id  -- 交易员
    ,dealer_name  -- 交易员名称
    ,ref_number  -- 成交编号
    ,feeamount  -- 手续费
    ,taxamount  -- 税金
    ,brokeramount  -- 佣金
    ,note  -- 备注
    ,nominal  -- 券面总额
    ,accruedamount  -- 应计利息总额
    ,cfets_from  -- 是否是CFETS交易
    ,source  -- 交易来源
    ,lastmodified  -- 最后修改时间
    ,datasymbol_id  -- 数据源ID
    ,assettype_id  -- 资产类型ID
    ,bondsdeals_id_grand  -- 原始交易ID
    ,stock_id  -- 股票代码
    ,convert_price  -- 转股价格
    ,stock_price  -- 正股价格
    ,convert_quantity  -- 转股数量
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.deal_id  -- 引用表ID
    ,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'')  -- 引用表名
    ,t1.aspclient_id  -- 部门编号
    ,replace(replace(t1.bondscode,chr(13),''),chr(10),'')  -- 债券代码
    ,replace(replace(t1.bondsname,chr(13),''),chr(10),'')  -- 债券名称
    ,replace(replace(t1.bondstype,chr(13),''),chr(10),'')  -- 债券类型
    ,replace(replace(t1.serial_number,chr(13),''),chr(10),'')  -- 交易号
    ,t1.tradedate  -- 交易日
    ,t1.settledate  -- 交割日
    ,replace(replace(t1.buyorsell,chr(13),''),chr(10),'')  -- 买卖方向
    ,t1.cleanprice  -- 交易净价
    ,t1.dirtyprice  -- 交易全价
    ,t1.yieldtomaturity  -- 到期收益率
    ,t1.settleamount  -- 结算金额
    ,t1.portfolio_id  -- 交易组别
    ,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'')  -- 交易组别名称
    ,t1.keepfolder_id  -- 账户ID
    ,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.folderatts,chr(13),''),chr(10),'')  -- 账户属性
    ,replace(replace(t1.classfyname,chr(13),''),chr(10),'')  -- 四分类名称
    ,replace(replace(t1.cptys_shortname,chr(13),''),chr(10),'')  -- 交易对手名称
    ,t1.cptys_id  -- 交易对手ID
    ,replace(replace(t1.settletype,chr(13),''),chr(10),'')  -- 结算方式
    ,t1.dealer_id  -- 交易员
    ,replace(replace(t1.dealer_name,chr(13),''),chr(10),'')  -- 交易员名称
    ,replace(replace(t1.ref_number,chr(13),''),chr(10),'')  -- 成交编号
    ,t1.feeamount  -- 手续费
    ,t1.taxamount  -- 税金
    ,t1.brokeramount  -- 佣金
    ,replace(replace(t1.note,chr(13),''),chr(10),'')  -- 备注
    ,t1.nominal  -- 券面总额
    ,t1.accruedamount  -- 应计利息总额
    ,replace(replace(t1.cfets_from,chr(13),''),chr(10),'')  -- 是否是CFETS交易
    ,replace(replace(t1.source,chr(13),''),chr(10),'')  -- 交易来源
    ,t1.lastmodified  -- 最后修改时间
    ,t1.datasymbol_id  -- 数据源ID
    ,t1.assettype_id  -- 资产类型ID
    ,t1.bondsdeals_id_grand  -- 原始交易ID
    ,replace(replace(t1.stock_id,chr(13),''),chr(10),'')  -- 股票代码
    ,t1.convert_price  -- 转股价格
    ,t1.stock_price  -- 正股价格
    ,t1.convert_quantity  -- 转股数量
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iol_schema}.ctms_tbs_v_bondsdeals t1    --现券交易
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ctms_tbs_v_bondsdeals',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);