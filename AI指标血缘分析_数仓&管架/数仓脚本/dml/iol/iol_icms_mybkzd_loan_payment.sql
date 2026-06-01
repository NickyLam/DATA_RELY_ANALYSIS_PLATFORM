/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_loan_payment
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
create table ${iol_schema}.icms_mybkzd_loan_payment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_loan_payment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_loan_payment_op purge;
drop table ${iol_schema}.icms_mybkzd_loan_payment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_loan_payment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_loan_payment where 0=1;

create table ${iol_schema}.icms_mybkzd_loan_payment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_loan_payment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_loan_payment_cl(
            serialno -- 网商贷支用信贷流水号
            ,custiproleid -- 客户IPROLEID
            ,requestid -- 请求幂等ID
            ,creditno -- 贷前授信的编号
            ,certtype -- 借款人证件类型
            ,certname -- 借款人证件名称
            ,certno -- 借款人证件号码
            ,platformamt -- 授信额度
            ,availableamt -- 可用额度
            ,businessmodel -- 与合作机构合作的业务模式
            ,businessscene -- 与合作机构的业务场景
            ,businesstag -- 与合作机构的业务标识
            ,loanmode -- 出资模式
            ,loanuse -- 资金用途
            ,encashamt -- 申请放款金额(分)
            ,totalterms -- 贷款期数
            ,termtype -- 贷款期数单位
            ,repaymode -- 还款方式
            ,ratetype -- 利率类型
            ,rate -- 实际放款利率(年利率)
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,isdirect -- 是否受托支付
            ,entrustedpayment -- 受托账号
            ,entrustedpaymentname -- 受托账号户名
            ,custverifytype -- 核身方式
            ,contracts -- 合同版本信息
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customerid -- 客户ID
            ,approvestatus -- 审批状态
            ,extendfield1 -- 拓展字段1
            ,extendfield2 -- 拓展字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记单位
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新单位
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_loan_payment_op(
            serialno -- 网商贷支用信贷流水号
            ,custiproleid -- 客户IPROLEID
            ,requestid -- 请求幂等ID
            ,creditno -- 贷前授信的编号
            ,certtype -- 借款人证件类型
            ,certname -- 借款人证件名称
            ,certno -- 借款人证件号码
            ,platformamt -- 授信额度
            ,availableamt -- 可用额度
            ,businessmodel -- 与合作机构合作的业务模式
            ,businessscene -- 与合作机构的业务场景
            ,businesstag -- 与合作机构的业务标识
            ,loanmode -- 出资模式
            ,loanuse -- 资金用途
            ,encashamt -- 申请放款金额(分)
            ,totalterms -- 贷款期数
            ,termtype -- 贷款期数单位
            ,repaymode -- 还款方式
            ,ratetype -- 利率类型
            ,rate -- 实际放款利率(年利率)
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,isdirect -- 是否受托支付
            ,entrustedpayment -- 受托账号
            ,entrustedpaymentname -- 受托账号户名
            ,custverifytype -- 核身方式
            ,contracts -- 合同版本信息
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customerid -- 客户ID
            ,approvestatus -- 审批状态
            ,extendfield1 -- 拓展字段1
            ,extendfield2 -- 拓展字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记单位
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新单位
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 网商贷支用信贷流水号
    ,nvl(n.custiproleid, o.custiproleid) as custiproleid -- 客户IPROLEID
    ,nvl(n.requestid, o.requestid) as requestid -- 请求幂等ID
    ,nvl(n.creditno, o.creditno) as creditno -- 贷前授信的编号
    ,nvl(n.certtype, o.certtype) as certtype -- 借款人证件类型
    ,nvl(n.certname, o.certname) as certname -- 借款人证件名称
    ,nvl(n.certno, o.certno) as certno -- 借款人证件号码
    ,nvl(n.platformamt, o.platformamt) as platformamt -- 授信额度
    ,nvl(n.availableamt, o.availableamt) as availableamt -- 可用额度
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 与合作机构合作的业务模式
    ,nvl(n.businessscene, o.businessscene) as businessscene -- 与合作机构的业务场景
    ,nvl(n.businesstag, o.businesstag) as businesstag -- 与合作机构的业务标识
    ,nvl(n.loanmode, o.loanmode) as loanmode -- 出资模式
    ,nvl(n.loanuse, o.loanuse) as loanuse -- 资金用途
    ,nvl(n.encashamt, o.encashamt) as encashamt -- 申请放款金额(分)
    ,nvl(n.totalterms, o.totalterms) as totalterms -- 贷款期数
    ,nvl(n.termtype, o.termtype) as termtype -- 贷款期数单位
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 还款方式
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率类型
    ,nvl(n.rate, o.rate) as rate -- 实际放款利率(年利率)
    ,nvl(n.encashacctno, o.encashacctno) as encashacctno -- 收款账户
    ,nvl(n.encashacctname, o.encashacctname) as encashacctname -- 收款账户名
    ,nvl(n.isdirect, o.isdirect) as isdirect -- 是否受托支付
    ,nvl(n.entrustedpayment, o.entrustedpayment) as entrustedpayment -- 受托账号
    ,nvl(n.entrustedpaymentname, o.entrustedpaymentname) as entrustedpaymentname -- 受托账号户名
    ,nvl(n.custverifytype, o.custverifytype) as custverifytype -- 核身方式
    ,nvl(n.contracts, o.contracts) as contracts -- 合同版本信息
    ,nvl(n.custverifyresult, o.custverifyresult) as custverifyresult -- 核身结果
    ,nvl(n.custverifytime, o.custverifytime) as custverifytime -- 核身通过时间
    ,nvl(n.customerid, o.customerid) as customerid -- 客户ID
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.extendfield1, o.extendfield1) as extendfield1 -- 拓展字段1
    ,nvl(n.extendfield2, o.extendfield2) as extendfield2 -- 拓展字段2
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记单位
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新单位
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
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
from (select * from ${iol_schema}.icms_mybkzd_loan_payment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_loan_payment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.custiproleid <> n.custiproleid
        or o.requestid <> n.requestid
        or o.creditno <> n.creditno
        or o.certtype <> n.certtype
        or o.certname <> n.certname
        or o.certno <> n.certno
        or o.platformamt <> n.platformamt
        or o.availableamt <> n.availableamt
        or o.businessmodel <> n.businessmodel
        or o.businessscene <> n.businessscene
        or o.businesstag <> n.businesstag
        or o.loanmode <> n.loanmode
        or o.loanuse <> n.loanuse
        or o.encashamt <> n.encashamt
        or o.totalterms <> n.totalterms
        or o.termtype <> n.termtype
        or o.repaymode <> n.repaymode
        or o.ratetype <> n.ratetype
        or o.rate <> n.rate
        or o.encashacctno <> n.encashacctno
        or o.encashacctname <> n.encashacctname
        or o.isdirect <> n.isdirect
        or o.entrustedpayment <> n.entrustedpayment
        or o.entrustedpaymentname <> n.entrustedpaymentname
        or o.custverifytype <> n.custverifytype
        or o.contracts <> n.contracts
        or o.custverifyresult <> n.custverifyresult
        or o.custverifytime <> n.custverifytime
        or o.customerid <> n.customerid
        or o.approvestatus <> n.approvestatus
        or o.extendfield1 <> n.extendfield1
        or o.extendfield2 <> n.extendfield2
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_loan_payment_cl(
            serialno -- 网商贷支用信贷流水号
            ,custiproleid -- 客户IPROLEID
            ,requestid -- 请求幂等ID
            ,creditno -- 贷前授信的编号
            ,certtype -- 借款人证件类型
            ,certname -- 借款人证件名称
            ,certno -- 借款人证件号码
            ,platformamt -- 授信额度
            ,availableamt -- 可用额度
            ,businessmodel -- 与合作机构合作的业务模式
            ,businessscene -- 与合作机构的业务场景
            ,businesstag -- 与合作机构的业务标识
            ,loanmode -- 出资模式
            ,loanuse -- 资金用途
            ,encashamt -- 申请放款金额(分)
            ,totalterms -- 贷款期数
            ,termtype -- 贷款期数单位
            ,repaymode -- 还款方式
            ,ratetype -- 利率类型
            ,rate -- 实际放款利率(年利率)
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,isdirect -- 是否受托支付
            ,entrustedpayment -- 受托账号
            ,entrustedpaymentname -- 受托账号户名
            ,custverifytype -- 核身方式
            ,contracts -- 合同版本信息
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customerid -- 客户ID
            ,approvestatus -- 审批状态
            ,extendfield1 -- 拓展字段1
            ,extendfield2 -- 拓展字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记单位
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新单位
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_loan_payment_op(
            serialno -- 网商贷支用信贷流水号
            ,custiproleid -- 客户IPROLEID
            ,requestid -- 请求幂等ID
            ,creditno -- 贷前授信的编号
            ,certtype -- 借款人证件类型
            ,certname -- 借款人证件名称
            ,certno -- 借款人证件号码
            ,platformamt -- 授信额度
            ,availableamt -- 可用额度
            ,businessmodel -- 与合作机构合作的业务模式
            ,businessscene -- 与合作机构的业务场景
            ,businesstag -- 与合作机构的业务标识
            ,loanmode -- 出资模式
            ,loanuse -- 资金用途
            ,encashamt -- 申请放款金额(分)
            ,totalterms -- 贷款期数
            ,termtype -- 贷款期数单位
            ,repaymode -- 还款方式
            ,ratetype -- 利率类型
            ,rate -- 实际放款利率(年利率)
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,isdirect -- 是否受托支付
            ,entrustedpayment -- 受托账号
            ,entrustedpaymentname -- 受托账号户名
            ,custverifytype -- 核身方式
            ,contracts -- 合同版本信息
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customerid -- 客户ID
            ,approvestatus -- 审批状态
            ,extendfield1 -- 拓展字段1
            ,extendfield2 -- 拓展字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记单位
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新单位
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 网商贷支用信贷流水号
    ,o.custiproleid -- 客户IPROLEID
    ,o.requestid -- 请求幂等ID
    ,o.creditno -- 贷前授信的编号
    ,o.certtype -- 借款人证件类型
    ,o.certname -- 借款人证件名称
    ,o.certno -- 借款人证件号码
    ,o.platformamt -- 授信额度
    ,o.availableamt -- 可用额度
    ,o.businessmodel -- 与合作机构合作的业务模式
    ,o.businessscene -- 与合作机构的业务场景
    ,o.businesstag -- 与合作机构的业务标识
    ,o.loanmode -- 出资模式
    ,o.loanuse -- 资金用途
    ,o.encashamt -- 申请放款金额(分)
    ,o.totalterms -- 贷款期数
    ,o.termtype -- 贷款期数单位
    ,o.repaymode -- 还款方式
    ,o.ratetype -- 利率类型
    ,o.rate -- 实际放款利率(年利率)
    ,o.encashacctno -- 收款账户
    ,o.encashacctname -- 收款账户名
    ,o.isdirect -- 是否受托支付
    ,o.entrustedpayment -- 受托账号
    ,o.entrustedpaymentname -- 受托账号户名
    ,o.custverifytype -- 核身方式
    ,o.contracts -- 合同版本信息
    ,o.custverifyresult -- 核身结果
    ,o.custverifytime -- 核身通过时间
    ,o.customerid -- 客户ID
    ,o.approvestatus -- 审批状态
    ,o.extendfield1 -- 拓展字段1
    ,o.extendfield2 -- 拓展字段2
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记单位
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新单位
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_mybkzd_loan_payment_bk o
    left join ${iol_schema}.icms_mybkzd_loan_payment_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_loan_payment_cl d
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
--truncate table ${iol_schema}.icms_mybkzd_loan_payment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_loan_payment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_loan_payment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_loan_payment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_loan_payment exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_loan_payment_cl;
alter table ${iol_schema}.icms_mybkzd_loan_payment exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_loan_payment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_loan_payment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_loan_payment_op purge;
drop table ${iol_schema}.icms_mybkzd_loan_payment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_loan_payment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_loan_payment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
