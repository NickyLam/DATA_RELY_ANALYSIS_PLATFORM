/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_business_putout
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
create table ${iol_schema}.icms_lx_business_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_business_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_putout_op purge;
drop table ${iol_schema}.icms_lx_business_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_putout where 0=1;

create table ${iol_schema}.icms_lx_business_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_putout_cl(
            serialno -- 出账号
            ,contractserialno -- 关联合同号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,applyid -- 用信审批申请编号
            ,partnercode -- 合作方代码
            ,productid -- 产品编号
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,businesssum -- 借款金额
            ,currency -- 币种
            ,startdate -- 贷款发放日
            ,maturity -- 贷款到期日
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,annualrate -- 年化利率
            ,loanuse -- 申请贷款用途
            ,mobileno -- 手机号
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,repaytype -- 乐信还款方式
            ,unionguaranteeflag -- 是否联合融担
            ,approvestatus -- 审批状态
            ,hxfkstatus -- 核心放款状态
            ,hxfkmessage -- 核心放款失败信息
            ,hwzzstatus -- 行外转账状态
            ,hwzzmessage -- 行外转账失败信息
            ,hxczstatus -- 核心冲正状态
            ,hxczmessage -- 核心冲正失败信息
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updatedate -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,paymenttime -- 放款时间
            ,capitalloanno -- 借据号
            ,hxfkseqnum -- 核心交易流水号（用于冲正）
            ,gxzseqnum -- 挂销账编号
            ,stzfseqnum -- 受托支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_putout_op(
            serialno -- 出账号
            ,contractserialno -- 关联合同号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,applyid -- 用信审批申请编号
            ,partnercode -- 合作方代码
            ,productid -- 产品编号
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,businesssum -- 借款金额
            ,currency -- 币种
            ,startdate -- 贷款发放日
            ,maturity -- 贷款到期日
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,annualrate -- 年化利率
            ,loanuse -- 申请贷款用途
            ,mobileno -- 手机号
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,repaytype -- 乐信还款方式
            ,unionguaranteeflag -- 是否联合融担
            ,approvestatus -- 审批状态
            ,hxfkstatus -- 核心放款状态
            ,hxfkmessage -- 核心放款失败信息
            ,hwzzstatus -- 行外转账状态
            ,hwzzmessage -- 行外转账失败信息
            ,hxczstatus -- 核心冲正状态
            ,hxczmessage -- 核心冲正失败信息
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updatedate -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,paymenttime -- 放款时间
            ,capitalloanno -- 借据号
            ,hxfkseqnum -- 核心交易流水号（用于冲正）
            ,gxzseqnum -- 挂销账编号
            ,stzfseqnum -- 受托支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 关联合同号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.applyid, o.applyid) as applyid -- 用信审批申请编号
    ,nvl(n.partnercode, o.partnercode) as partnercode -- 合作方代码
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.creditno, o.creditno) as creditno -- 资方授信编号
    ,nvl(n.ordertype, o.ordertype) as ordertype -- 资产类型
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 借款金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.startdate, o.startdate) as startdate -- 贷款发放日
    ,nvl(n.maturity, o.maturity) as maturity -- 贷款到期日
    ,nvl(n.fixedbillday, o.fixedbillday) as fixedbillday -- 固定出账日
    ,nvl(n.fixedrepayday, o.fixedrepayday) as fixedrepayday -- 固定还款日
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 借款期数
    ,nvl(n.annualrate, o.annualrate) as annualrate -- 年化利率
    ,nvl(n.loanuse, o.loanuse) as loanuse -- 申请贷款用途
    ,nvl(n.mobileno, o.mobileno) as mobileno -- 手机号
    ,nvl(n.debitaccountname, o.debitaccountname) as debitaccountname -- 借款人收款户名
    ,nvl(n.debitopenaccountbank, o.debitopenaccountbank) as debitopenaccountbank -- 收款人银行卡开户行
    ,nvl(n.debitaccountno, o.debitaccountno) as debitaccountno -- 收款人银行卡卡号
    ,nvl(n.debitcnaps, o.debitcnaps) as debitcnaps -- 收款卡联行号
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 乐信还款方式
    ,nvl(n.unionguaranteeflag, o.unionguaranteeflag) as unionguaranteeflag -- 是否联合融担
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.hxfkstatus, o.hxfkstatus) as hxfkstatus -- 核心放款状态
    ,nvl(n.hxfkmessage, o.hxfkmessage) as hxfkmessage -- 核心放款失败信息
    ,nvl(n.hwzzstatus, o.hwzzstatus) as hwzzstatus -- 行外转账状态
    ,nvl(n.hwzzmessage, o.hwzzmessage) as hwzzmessage -- 行外转账失败信息
    ,nvl(n.hxczstatus, o.hxczstatus) as hxczstatus -- 核心冲正状态
    ,nvl(n.hxczmessage, o.hxczmessage) as hxczmessage -- 核心冲正失败信息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.paymenttime, o.paymenttime) as paymenttime -- 放款时间
    ,nvl(n.capitalloanno, o.capitalloanno) as capitalloanno -- 借据号
    ,nvl(n.hxfkseqnum, o.hxfkseqnum) as hxfkseqnum -- 核心交易流水号（用于冲正）
    ,nvl(n.gxzseqnum, o.gxzseqnum) as gxzseqnum -- 挂销账编号
    ,nvl(n.stzfseqnum, o.stzfseqnum) as stzfseqnum -- 受托支付全局流水号
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
from (select * from ${iol_schema}.icms_lx_business_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_business_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.contractserialno <> n.contractserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.applyid <> n.applyid
        or o.partnercode <> n.partnercode
        or o.productid <> n.productid
        or o.creditno <> n.creditno
        or o.ordertype <> n.ordertype
        or o.businesssum <> n.businesssum
        or o.currency <> n.currency
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.fixedbillday <> n.fixedbillday
        or o.fixedrepayday <> n.fixedrepayday
        or o.loanterm <> n.loanterm
        or o.annualrate <> n.annualrate
        or o.loanuse <> n.loanuse
        or o.mobileno <> n.mobileno
        or o.debitaccountname <> n.debitaccountname
        or o.debitopenaccountbank <> n.debitopenaccountbank
        or o.debitaccountno <> n.debitaccountno
        or o.debitcnaps <> n.debitcnaps
        or o.repaytype <> n.repaytype
        or o.unionguaranteeflag <> n.unionguaranteeflag
        or o.approvestatus <> n.approvestatus
        or o.hxfkstatus <> n.hxfkstatus
        or o.hxfkmessage <> n.hxfkmessage
        or o.hwzzstatus <> n.hwzzstatus
        or o.hwzzmessage <> n.hwzzmessage
        or o.hxczstatus <> n.hxczstatus
        or o.hxczmessage <> n.hxczmessage
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.paymenttime <> n.paymenttime
        or o.capitalloanno <> n.capitalloanno
        or o.hxfkseqnum <> n.hxfkseqnum
        or o.gxzseqnum <> n.gxzseqnum
        or o.stzfseqnum <> n.stzfseqnum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_putout_cl(
            serialno -- 出账号
            ,contractserialno -- 关联合同号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,applyid -- 用信审批申请编号
            ,partnercode -- 合作方代码
            ,productid -- 产品编号
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,businesssum -- 借款金额
            ,currency -- 币种
            ,startdate -- 贷款发放日
            ,maturity -- 贷款到期日
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,annualrate -- 年化利率
            ,loanuse -- 申请贷款用途
            ,mobileno -- 手机号
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,repaytype -- 乐信还款方式
            ,unionguaranteeflag -- 是否联合融担
            ,approvestatus -- 审批状态
            ,hxfkstatus -- 核心放款状态
            ,hxfkmessage -- 核心放款失败信息
            ,hwzzstatus -- 行外转账状态
            ,hwzzmessage -- 行外转账失败信息
            ,hxczstatus -- 核心冲正状态
            ,hxczmessage -- 核心冲正失败信息
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updatedate -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,paymenttime -- 放款时间
            ,capitalloanno -- 借据号
            ,hxfkseqnum -- 核心交易流水号（用于冲正）
            ,gxzseqnum -- 挂销账编号
            ,stzfseqnum -- 受托支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_putout_op(
            serialno -- 出账号
            ,contractserialno -- 关联合同号
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,applyid -- 用信审批申请编号
            ,partnercode -- 合作方代码
            ,productid -- 产品编号
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,businesssum -- 借款金额
            ,currency -- 币种
            ,startdate -- 贷款发放日
            ,maturity -- 贷款到期日
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,annualrate -- 年化利率
            ,loanuse -- 申请贷款用途
            ,mobileno -- 手机号
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,repaytype -- 乐信还款方式
            ,unionguaranteeflag -- 是否联合融担
            ,approvestatus -- 审批状态
            ,hxfkstatus -- 核心放款状态
            ,hxfkmessage -- 核心放款失败信息
            ,hwzzstatus -- 行外转账状态
            ,hwzzmessage -- 行外转账失败信息
            ,hxczstatus -- 核心冲正状态
            ,hxczmessage -- 核心冲正失败信息
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updatedate -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,paymenttime -- 放款时间
            ,capitalloanno -- 借据号
            ,hxfkseqnum -- 核心交易流水号（用于冲正）
            ,gxzseqnum -- 挂销账编号
            ,stzfseqnum -- 受托支付全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账号
    ,o.contractserialno -- 关联合同号
    ,o.customerid -- 客户号
    ,o.customername -- 客户名称
    ,o.applyid -- 用信审批申请编号
    ,o.partnercode -- 合作方代码
    ,o.productid -- 产品编号
    ,o.creditno -- 资方授信编号
    ,o.ordertype -- 资产类型
    ,o.businesssum -- 借款金额
    ,o.currency -- 币种
    ,o.startdate -- 贷款发放日
    ,o.maturity -- 贷款到期日
    ,o.fixedbillday -- 固定出账日
    ,o.fixedrepayday -- 固定还款日
    ,o.loanterm -- 借款期数
    ,o.annualrate -- 年化利率
    ,o.loanuse -- 申请贷款用途
    ,o.mobileno -- 手机号
    ,o.debitaccountname -- 借款人收款户名
    ,o.debitopenaccountbank -- 收款人银行卡开户行
    ,o.debitaccountno -- 收款人银行卡卡号
    ,o.debitcnaps -- 收款卡联行号
    ,o.repaytype -- 乐信还款方式
    ,o.unionguaranteeflag -- 是否联合融担
    ,o.approvestatus -- 审批状态
    ,o.hxfkstatus -- 核心放款状态
    ,o.hxfkmessage -- 核心放款失败信息
    ,o.hwzzstatus -- 行外转账状态
    ,o.hwzzmessage -- 行外转账失败信息
    ,o.hxczstatus -- 核心冲正状态
    ,o.hxczmessage -- 核心冲正失败信息
    ,o.inputdate -- 登记时间
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.paymenttime -- 放款时间
    ,o.capitalloanno -- 借据号
    ,o.hxfkseqnum -- 核心交易流水号（用于冲正）
    ,o.gxzseqnum -- 挂销账编号
    ,o.stzfseqnum -- 受托支付全局流水号
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
from ${iol_schema}.icms_lx_business_putout_bk o
    left join ${iol_schema}.icms_lx_business_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_business_putout_cl d
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
--truncate table ${iol_schema}.icms_lx_business_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_business_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_business_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_business_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_business_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_business_putout_cl;
alter table ${iol_schema}.icms_lx_business_putout exchange partition p_20991231 with table ${iol_schema}.icms_lx_business_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_business_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_putout_op purge;
drop table ${iol_schema}.icms_lx_business_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_business_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_business_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
