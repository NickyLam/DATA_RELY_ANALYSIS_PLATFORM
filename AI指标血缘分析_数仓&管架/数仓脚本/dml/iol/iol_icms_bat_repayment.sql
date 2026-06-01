/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bat_repayment
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
create table ${iol_schema}.icms_bat_repayment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bat_repayment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bat_repayment_op purge;
drop table ${iol_schema}.icms_bat_repayment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bat_repayment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bat_repayment where 0=1;

create table ${iol_schema}.icms_bat_repayment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bat_repayment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bat_repayment_cl(
            serialno -- 流水号
            ,duebillno -- 借据号
            ,transdate -- 交易日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,currency -- 币种
            ,schedulepayment -- 应还金额
            ,actualpayment -- 实际还款金额
            ,payaccountno -- 扣款帐号
            ,payserialno -- 还款交易流水号
            ,paymenttype -- 支付方式
            ,status -- 状态
            ,relaobjecttype -- 关联对象类型
            ,relaobjectno -- 关联对象编号
            ,batserialno -- 批次流水号
            ,transserialno -- 交易流水号(核算)
            ,grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,completeflag -- 完整性标示
            ,priamt -- 实还本金
            ,intamt -- 实还利息
            ,odpamt -- 实还罚息
            ,odiamt -- 实还复利
            ,remamt -- 剩余本金
            ,stageno -- 还款期数
            ,reasoncode -- 代偿标志
            ,receipttype -- 还款类型
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,reversal -- 冲正标识
            ,receiptno -- 回收单号
            ,channel -- 渠道号
            ,srcinitsysid -- 发起系统
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bat_repayment_op(
            serialno -- 流水号
            ,duebillno -- 借据号
            ,transdate -- 交易日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,currency -- 币种
            ,schedulepayment -- 应还金额
            ,actualpayment -- 实际还款金额
            ,payaccountno -- 扣款帐号
            ,payserialno -- 还款交易流水号
            ,paymenttype -- 支付方式
            ,status -- 状态
            ,relaobjecttype -- 关联对象类型
            ,relaobjectno -- 关联对象编号
            ,batserialno -- 批次流水号
            ,transserialno -- 交易流水号(核算)
            ,grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,completeflag -- 完整性标示
            ,priamt -- 实还本金
            ,intamt -- 实还利息
            ,odpamt -- 实还罚息
            ,odiamt -- 实还复利
            ,remamt -- 剩余本金
            ,stageno -- 还款期数
            ,reasoncode -- 代偿标志
            ,receipttype -- 还款类型
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,reversal -- 冲正标识
            ,receiptno -- 回收单号
            ,channel -- 渠道号
            ,srcinitsysid -- 发起系统
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据号
    ,nvl(n.transdate, o.transdate) as transdate -- 交易日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件编号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.schedulepayment, o.schedulepayment) as schedulepayment -- 应还金额
    ,nvl(n.actualpayment, o.actualpayment) as actualpayment -- 实际还款金额
    ,nvl(n.payaccountno, o.payaccountno) as payaccountno -- 扣款帐号
    ,nvl(n.payserialno, o.payserialno) as payserialno -- 还款交易流水号
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.relaobjecttype, o.relaobjecttype) as relaobjecttype -- 关联对象类型
    ,nvl(n.relaobjectno, o.relaobjectno) as relaobjectno -- 关联对象编号
    ,nvl(n.batserialno, o.batserialno) as batserialno -- 批次流水号
    ,nvl(n.transserialno, o.transserialno) as transserialno -- 交易流水号(核算)
    ,nvl(n.grouptype, o.grouptype) as grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完整性标示
    ,nvl(n.priamt, o.priamt) as priamt -- 实还本金
    ,nvl(n.intamt, o.intamt) as intamt -- 实还利息
    ,nvl(n.odpamt, o.odpamt) as odpamt -- 实还罚息
    ,nvl(n.odiamt, o.odiamt) as odiamt -- 实还复利
    ,nvl(n.remamt, o.remamt) as remamt -- 剩余本金
    ,nvl(n.stageno, o.stageno) as stageno -- 还款期数
    ,nvl(n.reasoncode, o.reasoncode) as reasoncode -- 代偿标志
    ,nvl(n.receipttype, o.receipttype) as receipttype -- 还款类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.reversal, o.reversal) as reversal -- 冲正标识
    ,nvl(n.receiptno, o.receiptno) as receiptno -- 回收单号
    ,nvl(n.channel, o.channel) as channel -- 渠道号
    ,nvl(n.srcinitsysid, o.srcinitsysid) as srcinitsysid -- 发起系统
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_bat_repayment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bat_repayment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.duebillno <> n.duebillno
        or o.transdate <> n.transdate
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.currency <> n.currency
        or o.schedulepayment <> n.schedulepayment
        or o.actualpayment <> n.actualpayment
        or o.payaccountno <> n.payaccountno
        or o.payserialno <> n.payserialno
        or o.paymenttype <> n.paymenttype
        or o.status <> n.status
        or o.relaobjecttype <> n.relaobjecttype
        or o.relaobjectno <> n.relaobjectno
        or o.batserialno <> n.batserialno
        or o.transserialno <> n.transserialno
        or o.grouptype <> n.grouptype
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.completeflag <> n.completeflag
        or o.priamt <> n.priamt
        or o.intamt <> n.intamt
        or o.odpamt <> n.odpamt
        or o.odiamt <> n.odiamt
        or o.remamt <> n.remamt
        or o.stageno <> n.stageno
        or o.reasoncode <> n.reasoncode
        or o.receipttype <> n.receipttype
        or o.migtflag <> n.migtflag
        or o.reversal <> n.reversal
        or o.receiptno <> n.receiptno
        or o.channel <> n.channel
        or o.srcinitsysid <> n.srcinitsysid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bat_repayment_cl(
            serialno -- 流水号
            ,duebillno -- 借据号
            ,transdate -- 交易日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,currency -- 币种
            ,schedulepayment -- 应还金额
            ,actualpayment -- 实际还款金额
            ,payaccountno -- 扣款帐号
            ,payserialno -- 还款交易流水号
            ,paymenttype -- 支付方式
            ,status -- 状态
            ,relaobjecttype -- 关联对象类型
            ,relaobjectno -- 关联对象编号
            ,batserialno -- 批次流水号
            ,transserialno -- 交易流水号(核算)
            ,grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,completeflag -- 完整性标示
            ,priamt -- 实还本金
            ,intamt -- 实还利息
            ,odpamt -- 实还罚息
            ,odiamt -- 实还复利
            ,remamt -- 剩余本金
            ,stageno -- 还款期数
            ,reasoncode -- 代偿标志
            ,receipttype -- 还款类型
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,reversal -- 冲正标识
            ,receiptno -- 回收单号
            ,channel -- 渠道号
            ,srcinitsysid -- 发起系统
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bat_repayment_op(
            serialno -- 流水号
            ,duebillno -- 借据号
            ,transdate -- 交易日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,currency -- 币种
            ,schedulepayment -- 应还金额
            ,actualpayment -- 实际还款金额
            ,payaccountno -- 扣款帐号
            ,payserialno -- 还款交易流水号
            ,paymenttype -- 支付方式
            ,status -- 状态
            ,relaobjecttype -- 关联对象类型
            ,relaobjectno -- 关联对象编号
            ,batserialno -- 批次流水号
            ,transserialno -- 交易流水号(核算)
            ,grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,completeflag -- 完整性标示
            ,priamt -- 实还本金
            ,intamt -- 实还利息
            ,odpamt -- 实还罚息
            ,odiamt -- 实还复利
            ,remamt -- 剩余本金
            ,stageno -- 还款期数
            ,reasoncode -- 代偿标志
            ,receipttype -- 还款类型
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,reversal -- 冲正标识
            ,receiptno -- 回收单号
            ,channel -- 渠道号
            ,srcinitsysid -- 发起系统
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.duebillno -- 借据号
    ,o.transdate -- 交易日期
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.certtype -- 证件类型
    ,o.certid -- 证件编号
    ,o.currency -- 币种
    ,o.schedulepayment -- 应还金额
    ,o.actualpayment -- 实际还款金额
    ,o.payaccountno -- 扣款帐号
    ,o.payserialno -- 还款交易流水号
    ,o.paymenttype -- 支付方式
    ,o.status -- 状态
    ,o.relaobjecttype -- 关联对象类型
    ,o.relaobjectno -- 关联对象编号
    ,o.batserialno -- 批次流水号
    ,o.transserialno -- 交易流水号(核算)
    ,o.grouptype -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.completeflag -- 完整性标示
    ,o.priamt -- 实还本金
    ,o.intamt -- 实还利息
    ,o.odpamt -- 实还罚息
    ,o.odiamt -- 实还复利
    ,o.remamt -- 剩余本金
    ,o.stageno -- 还款期数
    ,o.reasoncode -- 代偿标志
    ,o.receipttype -- 还款类型
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.reversal -- 冲正标识
    ,o.receiptno -- 回收单号
    ,o.channel -- 渠道号
    ,o.srcinitsysid -- 发起系统
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
from ${iol_schema}.icms_bat_repayment_bk o
    left join ${iol_schema}.icms_bat_repayment_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bat_repayment_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_bat_repayment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bat_repayment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bat_repayment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bat_repayment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bat_repayment exchange partition p_${batch_date} with table ${iol_schema}.icms_bat_repayment_cl;
alter table ${iol_schema}.icms_bat_repayment exchange partition p_20991231 with table ${iol_schema}.icms_bat_repayment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bat_repayment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bat_repayment_op purge;
drop table ${iol_schema}.icms_bat_repayment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bat_repayment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bat_repayment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
