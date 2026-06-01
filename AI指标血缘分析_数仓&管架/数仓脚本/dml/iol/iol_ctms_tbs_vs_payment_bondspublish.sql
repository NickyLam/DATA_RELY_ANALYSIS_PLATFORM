/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_bondspublish
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
create table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_bondspublish;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_bondspublish where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_bondspublish where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手ID
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是CFETS交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,assettype_id -- 资产类型ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手ID
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是CFETS交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,assettype_id -- 资产类型ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 债券代码
    ,nvl(n.bondsname, o.bondsname) as bondsname -- 债券名称
    ,nvl(n.bondstype, o.bondstype) as bondstype -- 债券类型
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易号
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 交易日
    ,nvl(n.settledate, o.settledate) as settledate -- 交割日
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 买卖方向
    ,nvl(n.cleanprice, o.cleanprice) as cleanprice -- 交易净价
    ,nvl(n.dirtyprice, o.dirtyprice) as dirtyprice -- 交易全价
    ,nvl(n.yieldtomaturity, o.yieldtomaturity) as yieldtomaturity -- 到期收益率
    ,nvl(n.settleamount, o.settleamount) as settleamount -- 结算金额
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.folderatts, o.folderatts) as folderatts -- 账户属性
    ,nvl(n.classfyname, o.classfyname) as classfyname -- 四分类名称
    ,nvl(n.cptys_shortname, o.cptys_shortname) as cptys_shortname -- 交易对手名称
    ,nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手ID
    ,nvl(n.settletype, o.settletype) as settletype -- 结算方式
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.feeamount, o.feeamount) as feeamount -- 手续费
    ,nvl(n.taxamount, o.taxamount) as taxamount -- 税金
    ,nvl(n.brokeramount, o.brokeramount) as brokeramount -- 佣金
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.nominal, o.nominal) as nominal -- 券面总额
    ,nvl(n.accruedamount, o.accruedamount) as accruedamount -- 应计利息总额
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是CFETS交易
    ,nvl(n.source, o.source) as source -- 交易来源
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.assettype_id, o.assettype_id) as assettype_id -- 资产类型ID
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
    ,nvl(n.status, o.status) as status -- 状态
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_payment_bondspublish_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_bondspublish where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
where (
        o.deal_id is null
        and o.deal_tablename is null
    )
    or (
        n.deal_id is null
        and n.deal_tablename is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.bondscode <> n.bondscode
        or o.bondsname <> n.bondsname
        or o.bondstype <> n.bondstype
        or o.serial_number <> n.serial_number
        or o.tradedate <> n.tradedate
        or o.settledate <> n.settledate
        or o.buyorsell <> n.buyorsell
        or o.cleanprice <> n.cleanprice
        or o.dirtyprice <> n.dirtyprice
        or o.yieldtomaturity <> n.yieldtomaturity
        or o.settleamount <> n.settleamount
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.folderatts <> n.folderatts
        or o.classfyname <> n.classfyname
        or o.cptys_shortname <> n.cptys_shortname
        or o.cptys_id <> n.cptys_id
        or o.settletype <> n.settletype
        or o.dealer_id <> n.dealer_id
        or o.dealer_name <> n.dealer_name
        or o.ref_number <> n.ref_number
        or o.feeamount <> n.feeamount
        or o.taxamount <> n.taxamount
        or o.brokeramount <> n.brokeramount
        or o.note <> n.note
        or o.nominal <> n.nominal
        or o.accruedamount <> n.accruedamount
        or o.cfets_from <> n.cfets_from
        or o.source <> n.source
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.assettype_id <> n.assettype_id
        or o.lastmodified_pay <> n.lastmodified_pay
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手ID
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是CFETS交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,assettype_id -- 资产类型ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手ID
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是CFETS交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,assettype_id -- 资产类型ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.bondscode -- 债券代码
    ,o.bondsname -- 债券名称
    ,o.bondstype -- 债券类型
    ,o.serial_number -- 交易号
    ,o.tradedate -- 交易日
    ,o.settledate -- 交割日
    ,o.buyorsell -- 买卖方向
    ,o.cleanprice -- 交易净价
    ,o.dirtyprice -- 交易全价
    ,o.yieldtomaturity -- 到期收益率
    ,o.settleamount -- 结算金额
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.folderatts -- 账户属性
    ,o.classfyname -- 四分类名称
    ,o.cptys_shortname -- 交易对手名称
    ,o.cptys_id -- 交易对手ID
    ,o.settletype -- 结算方式
    ,o.dealer_id -- 交易员
    ,o.dealer_name -- 交易员名称
    ,o.ref_number -- 成交编号
    ,o.feeamount -- 手续费
    ,o.taxamount -- 税金
    ,o.brokeramount -- 佣金
    ,o.note -- 备注
    ,o.nominal -- 券面总额
    ,o.accruedamount -- 应计利息总额
    ,o.cfets_from -- 是否是CFETS交易
    ,o.source -- 交易来源
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbol_id -- 数据源ID
    ,o.assettype_id -- 资产类型ID
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.status -- 状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_bondspublish_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_tablename = d.deal_tablename
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_bondspublish;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_bondspublish exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_bondspublish exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_bondspublish to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondspublish_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_bondspublish',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
