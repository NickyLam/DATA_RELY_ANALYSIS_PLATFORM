/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_abs_product_info
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
create table ${iol_schema}.abss_abs_product_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_abs_product_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_product_info_op purge;
drop table ${iol_schema}.abss_abs_product_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_product_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_product_info where 0=1;

create table ${iol_schema}.abss_abs_product_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_product_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_product_info_cl(
            productid -- 产品编号
            ,productname -- 产品名称
            ,producttype -- 产品类型
            ,productstatus -- 产品状态
            ,businessstatus -- 产品业务状态
            ,productmodel -- 产品模式
            ,preamt -- 预发行总额
            ,assetamt -- 资产总额
            ,confirmamt -- 确认发行总额
            ,currency -- 币种
            ,repurchaseflag -- 是否支持清仓回购
            ,itemno -- 项目编号
            ,assetpoolno -- 资产池编号
            ,initialdate -- 初始起算日/封包日
            ,trustdate -- 信托生效日/信托设立日
            ,maturity -- 信托法定到期日
            ,creditmeasure -- 增信措施
            ,bookbuildingdate -- 簿记建档日/发行日
            ,deliverydate -- 信托财产交付日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,paygracedays -- 转付偏移天数
            ,tempsaveflag -- 暂存标识(0-保存,1-暂存)
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,paydaterule -- 
            ,lossrate -- 违约率
            ,prepayrate -- 早偿率
            ,overduerate -- 逾期率
            ,pretenlossrate -- 前十大资产违约率
            ,cashflowflag -- 现金流测算标识
            ,creditremark -- 征信措施备注
            ,assettransferamt -- 资产转让对价
            ,assettransferamttype -- 资产转让对价计算方式
            ,zrhth -- 转让合同号
            ,zrsxf -- 转让手续费
            ,hgll -- 回购利率
            ,zrhtqsrq -- 转让合同起始日期
            ,zrhtdqrq -- 转让合同到期日期
            ,isdiycycle -- 是否为自定义归集周期
            ,platform -- 
            ,transactionorgtype -- 
            ,updatefeeplan -- 是否更新费用计划
            ,transferdate -- 交易对手转账日期
            ,paidamt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_product_info_op(
            productid -- 产品编号
            ,productname -- 产品名称
            ,producttype -- 产品类型
            ,productstatus -- 产品状态
            ,businessstatus -- 产品业务状态
            ,productmodel -- 产品模式
            ,preamt -- 预发行总额
            ,assetamt -- 资产总额
            ,confirmamt -- 确认发行总额
            ,currency -- 币种
            ,repurchaseflag -- 是否支持清仓回购
            ,itemno -- 项目编号
            ,assetpoolno -- 资产池编号
            ,initialdate -- 初始起算日/封包日
            ,trustdate -- 信托生效日/信托设立日
            ,maturity -- 信托法定到期日
            ,creditmeasure -- 增信措施
            ,bookbuildingdate -- 簿记建档日/发行日
            ,deliverydate -- 信托财产交付日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,paygracedays -- 转付偏移天数
            ,tempsaveflag -- 暂存标识(0-保存,1-暂存)
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,paydaterule -- 
            ,lossrate -- 违约率
            ,prepayrate -- 早偿率
            ,overduerate -- 逾期率
            ,pretenlossrate -- 前十大资产违约率
            ,cashflowflag -- 现金流测算标识
            ,creditremark -- 征信措施备注
            ,assettransferamt -- 资产转让对价
            ,assettransferamttype -- 资产转让对价计算方式
            ,zrhth -- 转让合同号
            ,zrsxf -- 转让手续费
            ,hgll -- 回购利率
            ,zrhtqsrq -- 转让合同起始日期
            ,zrhtdqrq -- 转让合同到期日期
            ,isdiycycle -- 是否为自定义归集周期
            ,platform -- 
            ,transactionorgtype -- 
            ,updatefeeplan -- 是否更新费用计划
            ,transferdate -- 交易对手转账日期
            ,paidamt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.productname, o.productname) as productname -- 产品名称
    ,nvl(n.producttype, o.producttype) as producttype -- 产品类型
    ,nvl(n.productstatus, o.productstatus) as productstatus -- 产品状态
    ,nvl(n.businessstatus, o.businessstatus) as businessstatus -- 产品业务状态
    ,nvl(n.productmodel, o.productmodel) as productmodel -- 产品模式
    ,nvl(n.preamt, o.preamt) as preamt -- 预发行总额
    ,nvl(n.assetamt, o.assetamt) as assetamt -- 资产总额
    ,nvl(n.confirmamt, o.confirmamt) as confirmamt -- 确认发行总额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.repurchaseflag, o.repurchaseflag) as repurchaseflag -- 是否支持清仓回购
    ,nvl(n.itemno, o.itemno) as itemno -- 项目编号
    ,nvl(n.assetpoolno, o.assetpoolno) as assetpoolno -- 资产池编号
    ,nvl(n.initialdate, o.initialdate) as initialdate -- 初始起算日/封包日
    ,nvl(n.trustdate, o.trustdate) as trustdate -- 信托生效日/信托设立日
    ,nvl(n.maturity, o.maturity) as maturity -- 信托法定到期日
    ,nvl(n.creditmeasure, o.creditmeasure) as creditmeasure -- 增信措施
    ,nvl(n.bookbuildingdate, o.bookbuildingdate) as bookbuildingdate -- 簿记建档日/发行日
    ,nvl(n.deliverydate, o.deliverydate) as deliverydate -- 信托财产交付日
    ,nvl(n.finishtype, o.finishtype) as finishtype -- 终结类型
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.paygracedays, o.paygracedays) as paygracedays -- 转付偏移天数
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标识(0-保存,1-暂存)
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人ID
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构ID
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.paydaterule, o.paydaterule) as paydaterule -- 
    ,nvl(n.lossrate, o.lossrate) as lossrate -- 违约率
    ,nvl(n.prepayrate, o.prepayrate) as prepayrate -- 早偿率
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期率
    ,nvl(n.pretenlossrate, o.pretenlossrate) as pretenlossrate -- 前十大资产违约率
    ,nvl(n.cashflowflag, o.cashflowflag) as cashflowflag -- 现金流测算标识
    ,nvl(n.creditremark, o.creditremark) as creditremark -- 征信措施备注
    ,nvl(n.assettransferamt, o.assettransferamt) as assettransferamt -- 资产转让对价
    ,nvl(n.assettransferamttype, o.assettransferamttype) as assettransferamttype -- 资产转让对价计算方式
    ,nvl(n.zrhth, o.zrhth) as zrhth -- 转让合同号
    ,nvl(n.zrsxf, o.zrsxf) as zrsxf -- 转让手续费
    ,nvl(n.hgll, o.hgll) as hgll -- 回购利率
    ,nvl(n.zrhtqsrq, o.zrhtqsrq) as zrhtqsrq -- 转让合同起始日期
    ,nvl(n.zrhtdqrq, o.zrhtdqrq) as zrhtdqrq -- 转让合同到期日期
    ,nvl(n.isdiycycle, o.isdiycycle) as isdiycycle -- 是否为自定义归集周期
    ,nvl(n.platform, o.platform) as platform -- 
    ,nvl(n.transactionorgtype, o.transactionorgtype) as transactionorgtype -- 
    ,nvl(n.updatefeeplan, o.updatefeeplan) as updatefeeplan -- 是否更新费用计划
    ,nvl(n.transferdate, o.transferdate) as transferdate -- 交易对手转账日期
    ,nvl(n.paidamt, o.paidamt) as paidamt -- 交易对手已支付金额
    ,case when
            n.productid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.productid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.productid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_abs_product_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_abs_product_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.productid = n.productid
where (
        o.productid is null
    )
    or (
        n.productid is null
    )
    or (
        o.productname <> n.productname
        or o.producttype <> n.producttype
        or o.productstatus <> n.productstatus
        or o.businessstatus <> n.businessstatus
        or o.productmodel <> n.productmodel
        or o.preamt <> n.preamt
        or o.assetamt <> n.assetamt
        or o.confirmamt <> n.confirmamt
        or o.currency <> n.currency
        or o.repurchaseflag <> n.repurchaseflag
        or o.itemno <> n.itemno
        or o.assetpoolno <> n.assetpoolno
        or o.initialdate <> n.initialdate
        or o.trustdate <> n.trustdate
        or o.maturity <> n.maturity
        or o.creditmeasure <> n.creditmeasure
        or o.bookbuildingdate <> n.bookbuildingdate
        or o.deliverydate <> n.deliverydate
        or o.finishtype <> n.finishtype
        or o.finishdate <> n.finishdate
        or o.paygracedays <> n.paygracedays
        or o.tempsaveflag <> n.tempsaveflag
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputtime <> n.inputtime
        or o.updatetime <> n.updatetime
        or o.paydaterule <> n.paydaterule
        or o.lossrate <> n.lossrate
        or o.prepayrate <> n.prepayrate
        or o.overduerate <> n.overduerate
        or o.pretenlossrate <> n.pretenlossrate
        or o.cashflowflag <> n.cashflowflag
        or o.creditremark <> n.creditremark
        or o.assettransferamt <> n.assettransferamt
        or o.assettransferamttype <> n.assettransferamttype
        or o.zrhth <> n.zrhth
        or o.zrsxf <> n.zrsxf
        or o.hgll <> n.hgll
        or o.zrhtqsrq <> n.zrhtqsrq
        or o.zrhtdqrq <> n.zrhtdqrq
        or o.isdiycycle <> n.isdiycycle
        or o.platform <> n.platform
        or o.transactionorgtype <> n.transactionorgtype
        or o.updatefeeplan <> n.updatefeeplan
        or o.transferdate <> n.transferdate
        or o.paidamt <> n.paidamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_product_info_cl(
            productid -- 产品编号
            ,productname -- 产品名称
            ,producttype -- 产品类型
            ,productstatus -- 产品状态
            ,businessstatus -- 产品业务状态
            ,productmodel -- 产品模式
            ,preamt -- 预发行总额
            ,assetamt -- 资产总额
            ,confirmamt -- 确认发行总额
            ,currency -- 币种
            ,repurchaseflag -- 是否支持清仓回购
            ,itemno -- 项目编号
            ,assetpoolno -- 资产池编号
            ,initialdate -- 初始起算日/封包日
            ,trustdate -- 信托生效日/信托设立日
            ,maturity -- 信托法定到期日
            ,creditmeasure -- 增信措施
            ,bookbuildingdate -- 簿记建档日/发行日
            ,deliverydate -- 信托财产交付日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,paygracedays -- 转付偏移天数
            ,tempsaveflag -- 暂存标识(0-保存,1-暂存)
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,paydaterule -- 
            ,lossrate -- 违约率
            ,prepayrate -- 早偿率
            ,overduerate -- 逾期率
            ,pretenlossrate -- 前十大资产违约率
            ,cashflowflag -- 现金流测算标识
            ,creditremark -- 征信措施备注
            ,assettransferamt -- 资产转让对价
            ,assettransferamttype -- 资产转让对价计算方式
            ,zrhth -- 转让合同号
            ,zrsxf -- 转让手续费
            ,hgll -- 回购利率
            ,zrhtqsrq -- 转让合同起始日期
            ,zrhtdqrq -- 转让合同到期日期
            ,isdiycycle -- 是否为自定义归集周期
            ,platform -- 
            ,transactionorgtype -- 
            ,updatefeeplan -- 是否更新费用计划
            ,transferdate -- 交易对手转账日期
            ,paidamt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_product_info_op(
            productid -- 产品编号
            ,productname -- 产品名称
            ,producttype -- 产品类型
            ,productstatus -- 产品状态
            ,businessstatus -- 产品业务状态
            ,productmodel -- 产品模式
            ,preamt -- 预发行总额
            ,assetamt -- 资产总额
            ,confirmamt -- 确认发行总额
            ,currency -- 币种
            ,repurchaseflag -- 是否支持清仓回购
            ,itemno -- 项目编号
            ,assetpoolno -- 资产池编号
            ,initialdate -- 初始起算日/封包日
            ,trustdate -- 信托生效日/信托设立日
            ,maturity -- 信托法定到期日
            ,creditmeasure -- 增信措施
            ,bookbuildingdate -- 簿记建档日/发行日
            ,deliverydate -- 信托财产交付日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,paygracedays -- 转付偏移天数
            ,tempsaveflag -- 暂存标识(0-保存,1-暂存)
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,paydaterule -- 
            ,lossrate -- 违约率
            ,prepayrate -- 早偿率
            ,overduerate -- 逾期率
            ,pretenlossrate -- 前十大资产违约率
            ,cashflowflag -- 现金流测算标识
            ,creditremark -- 征信措施备注
            ,assettransferamt -- 资产转让对价
            ,assettransferamttype -- 资产转让对价计算方式
            ,zrhth -- 转让合同号
            ,zrsxf -- 转让手续费
            ,hgll -- 回购利率
            ,zrhtqsrq -- 转让合同起始日期
            ,zrhtdqrq -- 转让合同到期日期
            ,isdiycycle -- 是否为自定义归集周期
            ,platform -- 
            ,transactionorgtype -- 
            ,updatefeeplan -- 是否更新费用计划
            ,transferdate -- 交易对手转账日期
            ,paidamt -- 交易对手已支付金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.productid -- 产品编号
    ,o.productname -- 产品名称
    ,o.producttype -- 产品类型
    ,o.productstatus -- 产品状态
    ,o.businessstatus -- 产品业务状态
    ,o.productmodel -- 产品模式
    ,o.preamt -- 预发行总额
    ,o.assetamt -- 资产总额
    ,o.confirmamt -- 确认发行总额
    ,o.currency -- 币种
    ,o.repurchaseflag -- 是否支持清仓回购
    ,o.itemno -- 项目编号
    ,o.assetpoolno -- 资产池编号
    ,o.initialdate -- 初始起算日/封包日
    ,o.trustdate -- 信托生效日/信托设立日
    ,o.maturity -- 信托法定到期日
    ,o.creditmeasure -- 增信措施
    ,o.bookbuildingdate -- 簿记建档日/发行日
    ,o.deliverydate -- 信托财产交付日
    ,o.finishtype -- 终结类型
    ,o.finishdate -- 终结日期
    ,o.paygracedays -- 转付偏移天数
    ,o.tempsaveflag -- 暂存标识(0-保存,1-暂存)
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人ID
    ,o.inputorgid -- 登记机构ID
    ,o.inputtime -- 登记时间
    ,o.updatetime -- 更新时间
    ,o.paydaterule -- 
    ,o.lossrate -- 违约率
    ,o.prepayrate -- 早偿率
    ,o.overduerate -- 逾期率
    ,o.pretenlossrate -- 前十大资产违约率
    ,o.cashflowflag -- 现金流测算标识
    ,o.creditremark -- 征信措施备注
    ,o.assettransferamt -- 资产转让对价
    ,o.assettransferamttype -- 资产转让对价计算方式
    ,o.zrhth -- 转让合同号
    ,o.zrsxf -- 转让手续费
    ,o.hgll -- 回购利率
    ,o.zrhtqsrq -- 转让合同起始日期
    ,o.zrhtdqrq -- 转让合同到期日期
    ,o.isdiycycle -- 是否为自定义归集周期
    ,o.platform -- 
    ,o.transactionorgtype -- 
    ,o.updatefeeplan -- 是否更新费用计划
    ,o.transferdate -- 交易对手转账日期
    ,o.paidamt -- 交易对手已支付金额
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
from ${iol_schema}.abss_abs_product_info_bk o
    left join ${iol_schema}.abss_abs_product_info_op n
        on
            o.productid = n.productid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_abs_product_info_cl d
        on
            o.productid = d.productid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.abss_abs_product_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('abss_abs_product_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.abss_abs_product_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.abss_abs_product_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.abss_abs_product_info exchange partition p_${batch_date} with table ${iol_schema}.abss_abs_product_info_cl;
alter table ${iol_schema}.abss_abs_product_info exchange partition p_20991231 with table ${iol_schema}.abss_abs_product_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_abs_product_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_product_info_op purge;
drop table ${iol_schema}.abss_abs_product_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_abs_product_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_abs_product_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
