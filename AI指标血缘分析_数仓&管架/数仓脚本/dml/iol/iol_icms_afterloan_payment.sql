/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_payment
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
create table ${iol_schema}.icms_afterloan_payment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_payment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_payment_op purge;
drop table ${iol_schema}.icms_afterloan_payment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_payment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_payment where 0=1;

create table ${iol_schema}.icms_afterloan_payment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_payment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_payment_cl(
            serialno -- 流水号
            ,updateuserid -- 更新人
            ,violateamt -- 违约金金额
            ,objecttype -- 关联对象类型
            ,actualpayinterestamt -- 实收利息
            ,payaccountno -- 存款账户账号
            ,transno -- 核心交易号
            ,updatedate -- 更新日期
            ,prepayamtflag -- 提前还款金额类型
            ,belongdept -- 所属条线
            ,customerid -- 客户编号
            ,actualpayinterestpenaltyamt -- 实收复息
            ,remark -- 备注
            ,prepayinterestamt -- 提前归还利息
            ,inputdate -- 登记日期
            ,corporgid -- 法人机构编号
            ,productid -- 产品编号
            ,prepayinterestdaysflag -- 提前还款计息模式
            ,transstatus -- 交易状态
            ,updateorgid -- 更新机构
            ,payaccountflag -- 账户标志
            ,actualpayprincipalpenaltyamt -- 实收罚息
            ,payaccountname -- 存款账户名称
            ,prepayprincipalamt -- 提前归还本金
            ,prepayfeeamt -- 提前归还费用
            ,excutedate -- 交易日期
            ,transdate -- 生效日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,prepayinterestbaseflag -- 提前还款计息基础
            ,prepayamt -- 提前还款金额
            ,payaccounttype -- 账户类型
            ,loanno -- 关联借据号
            ,transcode -- 交易类型
            ,actualpayfeeamt -- 实收费用
            ,completeflag -- 完成标志
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customername -- 客户名称
            ,payamt -- 还款总金额
            ,paymentcurrency -- 币种
            ,applystatus -- 申请状态
            ,actualpayprincipalamt -- 实收本金
            ,payruletype -- 扣款顺序
            ,relativeserialno -- 关联流水号
            ,prepaytype -- 提前还款方式
            ,autopayflag -- 是否在线支付
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_payment_op(
            serialno -- 流水号
            ,updateuserid -- 更新人
            ,violateamt -- 违约金金额
            ,objecttype -- 关联对象类型
            ,actualpayinterestamt -- 实收利息
            ,payaccountno -- 存款账户账号
            ,transno -- 核心交易号
            ,updatedate -- 更新日期
            ,prepayamtflag -- 提前还款金额类型
            ,belongdept -- 所属条线
            ,customerid -- 客户编号
            ,actualpayinterestpenaltyamt -- 实收复息
            ,remark -- 备注
            ,prepayinterestamt -- 提前归还利息
            ,inputdate -- 登记日期
            ,corporgid -- 法人机构编号
            ,productid -- 产品编号
            ,prepayinterestdaysflag -- 提前还款计息模式
            ,transstatus -- 交易状态
            ,updateorgid -- 更新机构
            ,payaccountflag -- 账户标志
            ,actualpayprincipalpenaltyamt -- 实收罚息
            ,payaccountname -- 存款账户名称
            ,prepayprincipalamt -- 提前归还本金
            ,prepayfeeamt -- 提前归还费用
            ,excutedate -- 交易日期
            ,transdate -- 生效日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,prepayinterestbaseflag -- 提前还款计息基础
            ,prepayamt -- 提前还款金额
            ,payaccounttype -- 账户类型
            ,loanno -- 关联借据号
            ,transcode -- 交易类型
            ,actualpayfeeamt -- 实收费用
            ,completeflag -- 完成标志
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customername -- 客户名称
            ,payamt -- 还款总金额
            ,paymentcurrency -- 币种
            ,applystatus -- 申请状态
            ,actualpayprincipalamt -- 实收本金
            ,payruletype -- 扣款顺序
            ,relativeserialno -- 关联流水号
            ,prepaytype -- 提前还款方式
            ,autopayflag -- 是否在线支付
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.violateamt, o.violateamt) as violateamt -- 违约金金额
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联对象类型
    ,nvl(n.actualpayinterestamt, o.actualpayinterestamt) as actualpayinterestamt -- 实收利息
    ,nvl(n.payaccountno, o.payaccountno) as payaccountno -- 存款账户账号
    ,nvl(n.transno, o.transno) as transno -- 核心交易号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.prepayamtflag, o.prepayamtflag) as prepayamtflag -- 提前还款金额类型
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.actualpayinterestpenaltyamt, o.actualpayinterestpenaltyamt) as actualpayinterestpenaltyamt -- 实收复息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.prepayinterestamt, o.prepayinterestamt) as prepayinterestamt -- 提前归还利息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.prepayinterestdaysflag, o.prepayinterestdaysflag) as prepayinterestdaysflag -- 提前还款计息模式
    ,nvl(n.transstatus, o.transstatus) as transstatus -- 交易状态
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.payaccountflag, o.payaccountflag) as payaccountflag -- 账户标志
    ,nvl(n.actualpayprincipalpenaltyamt, o.actualpayprincipalpenaltyamt) as actualpayprincipalpenaltyamt -- 实收罚息
    ,nvl(n.payaccountname, o.payaccountname) as payaccountname -- 存款账户名称
    ,nvl(n.prepayprincipalamt, o.prepayprincipalamt) as prepayprincipalamt -- 提前归还本金
    ,nvl(n.prepayfeeamt, o.prepayfeeamt) as prepayfeeamt -- 提前归还费用
    ,nvl(n.excutedate, o.excutedate) as excutedate -- 交易日期
    ,nvl(n.transdate, o.transdate) as transdate -- 生效日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.prepayinterestbaseflag, o.prepayinterestbaseflag) as prepayinterestbaseflag -- 提前还款计息基础
    ,nvl(n.prepayamt, o.prepayamt) as prepayamt -- 提前还款金额
    ,nvl(n.payaccounttype, o.payaccounttype) as payaccounttype -- 账户类型
    ,nvl(n.loanno, o.loanno) as loanno -- 关联借据号
    ,nvl(n.transcode, o.transcode) as transcode -- 交易类型
    ,nvl(n.actualpayfeeamt, o.actualpayfeeamt) as actualpayfeeamt -- 实收费用
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完成标志
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.payamt, o.payamt) as payamt -- 还款总金额
    ,nvl(n.paymentcurrency, o.paymentcurrency) as paymentcurrency -- 币种
    ,nvl(n.applystatus, o.applystatus) as applystatus -- 申请状态
    ,nvl(n.actualpayprincipalamt, o.actualpayprincipalamt) as actualpayprincipalamt -- 实收本金
    ,nvl(n.payruletype, o.payruletype) as payruletype -- 扣款顺序
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.prepaytype, o.prepaytype) as prepaytype -- 提前还款方式
    ,nvl(n.autopayflag, o.autopayflag) as autopayflag -- 是否在线支付
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
from (select * from ${iol_schema}.icms_afterloan_payment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_payment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.violateamt <> n.violateamt
        or o.objecttype <> n.objecttype
        or o.actualpayinterestamt <> n.actualpayinterestamt
        or o.payaccountno <> n.payaccountno
        or o.transno <> n.transno
        or o.updatedate <> n.updatedate
        or o.prepayamtflag <> n.prepayamtflag
        or o.belongdept <> n.belongdept
        or o.customerid <> n.customerid
        or o.actualpayinterestpenaltyamt <> n.actualpayinterestpenaltyamt
        or o.remark <> n.remark
        or o.prepayinterestamt <> n.prepayinterestamt
        or o.inputdate <> n.inputdate
        or o.corporgid <> n.corporgid
        or o.productid <> n.productid
        or o.prepayinterestdaysflag <> n.prepayinterestdaysflag
        or o.transstatus <> n.transstatus
        or o.updateorgid <> n.updateorgid
        or o.payaccountflag <> n.payaccountflag
        or o.actualpayprincipalpenaltyamt <> n.actualpayprincipalpenaltyamt
        or o.payaccountname <> n.payaccountname
        or o.prepayprincipalamt <> n.prepayprincipalamt
        or o.prepayfeeamt <> n.prepayfeeamt
        or o.excutedate <> n.excutedate
        or o.transdate <> n.transdate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.prepayinterestbaseflag <> n.prepayinterestbaseflag
        or o.prepayamt <> n.prepayamt
        or o.payaccounttype <> n.payaccounttype
        or o.loanno <> n.loanno
        or o.transcode <> n.transcode
        or o.actualpayfeeamt <> n.actualpayfeeamt
        or o.completeflag <> n.completeflag
        or o.migtflag <> n.migtflag
        or o.customername <> n.customername
        or o.payamt <> n.payamt
        or o.paymentcurrency <> n.paymentcurrency
        or o.applystatus <> n.applystatus
        or o.actualpayprincipalamt <> n.actualpayprincipalamt
        or o.payruletype <> n.payruletype
        or o.relativeserialno <> n.relativeserialno
        or o.prepaytype <> n.prepaytype
        or o.autopayflag <> n.autopayflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_payment_cl(
            serialno -- 流水号
            ,updateuserid -- 更新人
            ,violateamt -- 违约金金额
            ,objecttype -- 关联对象类型
            ,actualpayinterestamt -- 实收利息
            ,payaccountno -- 存款账户账号
            ,transno -- 核心交易号
            ,updatedate -- 更新日期
            ,prepayamtflag -- 提前还款金额类型
            ,belongdept -- 所属条线
            ,customerid -- 客户编号
            ,actualpayinterestpenaltyamt -- 实收复息
            ,remark -- 备注
            ,prepayinterestamt -- 提前归还利息
            ,inputdate -- 登记日期
            ,corporgid -- 法人机构编号
            ,productid -- 产品编号
            ,prepayinterestdaysflag -- 提前还款计息模式
            ,transstatus -- 交易状态
            ,updateorgid -- 更新机构
            ,payaccountflag -- 账户标志
            ,actualpayprincipalpenaltyamt -- 实收罚息
            ,payaccountname -- 存款账户名称
            ,prepayprincipalamt -- 提前归还本金
            ,prepayfeeamt -- 提前归还费用
            ,excutedate -- 交易日期
            ,transdate -- 生效日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,prepayinterestbaseflag -- 提前还款计息基础
            ,prepayamt -- 提前还款金额
            ,payaccounttype -- 账户类型
            ,loanno -- 关联借据号
            ,transcode -- 交易类型
            ,actualpayfeeamt -- 实收费用
            ,completeflag -- 完成标志
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customername -- 客户名称
            ,payamt -- 还款总金额
            ,paymentcurrency -- 币种
            ,applystatus -- 申请状态
            ,actualpayprincipalamt -- 实收本金
            ,payruletype -- 扣款顺序
            ,relativeserialno -- 关联流水号
            ,prepaytype -- 提前还款方式
            ,autopayflag -- 是否在线支付
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_payment_op(
            serialno -- 流水号
            ,updateuserid -- 更新人
            ,violateamt -- 违约金金额
            ,objecttype -- 关联对象类型
            ,actualpayinterestamt -- 实收利息
            ,payaccountno -- 存款账户账号
            ,transno -- 核心交易号
            ,updatedate -- 更新日期
            ,prepayamtflag -- 提前还款金额类型
            ,belongdept -- 所属条线
            ,customerid -- 客户编号
            ,actualpayinterestpenaltyamt -- 实收复息
            ,remark -- 备注
            ,prepayinterestamt -- 提前归还利息
            ,inputdate -- 登记日期
            ,corporgid -- 法人机构编号
            ,productid -- 产品编号
            ,prepayinterestdaysflag -- 提前还款计息模式
            ,transstatus -- 交易状态
            ,updateorgid -- 更新机构
            ,payaccountflag -- 账户标志
            ,actualpayprincipalpenaltyamt -- 实收罚息
            ,payaccountname -- 存款账户名称
            ,prepayprincipalamt -- 提前归还本金
            ,prepayfeeamt -- 提前归还费用
            ,excutedate -- 交易日期
            ,transdate -- 生效日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,prepayinterestbaseflag -- 提前还款计息基础
            ,prepayamt -- 提前还款金额
            ,payaccounttype -- 账户类型
            ,loanno -- 关联借据号
            ,transcode -- 交易类型
            ,actualpayfeeamt -- 实收费用
            ,completeflag -- 完成标志
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,customername -- 客户名称
            ,payamt -- 还款总金额
            ,paymentcurrency -- 币种
            ,applystatus -- 申请状态
            ,actualpayprincipalamt -- 实收本金
            ,payruletype -- 扣款顺序
            ,relativeserialno -- 关联流水号
            ,prepaytype -- 提前还款方式
            ,autopayflag -- 是否在线支付
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.updateuserid -- 更新人
    ,o.violateamt -- 违约金金额
    ,o.objecttype -- 关联对象类型
    ,o.actualpayinterestamt -- 实收利息
    ,o.payaccountno -- 存款账户账号
    ,o.transno -- 核心交易号
    ,o.updatedate -- 更新日期
    ,o.prepayamtflag -- 提前还款金额类型
    ,o.belongdept -- 所属条线
    ,o.customerid -- 客户编号
    ,o.actualpayinterestpenaltyamt -- 实收复息
    ,o.remark -- 备注
    ,o.prepayinterestamt -- 提前归还利息
    ,o.inputdate -- 登记日期
    ,o.corporgid -- 法人机构编号
    ,o.productid -- 产品编号
    ,o.prepayinterestdaysflag -- 提前还款计息模式
    ,o.transstatus -- 交易状态
    ,o.updateorgid -- 更新机构
    ,o.payaccountflag -- 账户标志
    ,o.actualpayprincipalpenaltyamt -- 实收罚息
    ,o.payaccountname -- 存款账户名称
    ,o.prepayprincipalamt -- 提前归还本金
    ,o.prepayfeeamt -- 提前归还费用
    ,o.excutedate -- 交易日期
    ,o.transdate -- 生效日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.prepayinterestbaseflag -- 提前还款计息基础
    ,o.prepayamt -- 提前还款金额
    ,o.payaccounttype -- 账户类型
    ,o.loanno -- 关联借据号
    ,o.transcode -- 交易类型
    ,o.actualpayfeeamt -- 实收费用
    ,o.completeflag -- 完成标志
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.customername -- 客户名称
    ,o.payamt -- 还款总金额
    ,o.paymentcurrency -- 币种
    ,o.applystatus -- 申请状态
    ,o.actualpayprincipalamt -- 实收本金
    ,o.payruletype -- 扣款顺序
    ,o.relativeserialno -- 关联流水号
    ,o.prepaytype -- 提前还款方式
    ,o.autopayflag -- 是否在线支付
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
from ${iol_schema}.icms_afterloan_payment_bk o
    left join ${iol_schema}.icms_afterloan_payment_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_payment_cl d
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
--truncate table ${iol_schema}.icms_afterloan_payment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_payment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_payment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_payment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_payment exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_payment_cl;
alter table ${iol_schema}.icms_afterloan_payment exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_payment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_payment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_payment_op purge;
drop table ${iol_schema}.icms_afterloan_payment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_payment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_payment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
