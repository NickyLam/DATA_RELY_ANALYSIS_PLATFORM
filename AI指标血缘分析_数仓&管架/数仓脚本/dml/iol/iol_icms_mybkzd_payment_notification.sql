/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_payment_notification
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
create table ${iol_schema}.icms_mybkzd_payment_notification_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_payment_notification
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_payment_notification_op purge;
drop table ${iol_schema}.icms_mybkzd_payment_notification_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_payment_notification_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_payment_notification where 0=1;

create table ${iol_schema}.icms_mybkzd_payment_notification_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_payment_notification where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_payment_notification_cl(
            serialno -- 信贷流水号
            ,requestid -- 请求幂等ID
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,businessmodel -- 与合作机构合作的业务模式
            ,loanarno -- 贷款合约号
            ,amount -- 支用金额
            ,intrate -- 初始年利率
            ,realintrate -- 实际折后年利率
            ,putoutdate -- 放款日期
            ,startdate -- 贷款起始日期
            ,enddate -- 贷款到期日期
            ,repaytype -- 还款方式
            ,certtype -- 证件类型
            ,certno -- 客户证件号
            ,certname -- 客户姓名
            ,platformamt -- 授信额度
            ,isdirect -- 是否受托支付
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,entrustedpay -- 受托支付账户
            ,entrustedpaymentname -- 受托支付账户名
            ,lendapproverequestid -- 支用审批时的requestid
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_payment_notification_op(
            serialno -- 信贷流水号
            ,requestid -- 请求幂等ID
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,businessmodel -- 与合作机构合作的业务模式
            ,loanarno -- 贷款合约号
            ,amount -- 支用金额
            ,intrate -- 初始年利率
            ,realintrate -- 实际折后年利率
            ,putoutdate -- 放款日期
            ,startdate -- 贷款起始日期
            ,enddate -- 贷款到期日期
            ,repaytype -- 还款方式
            ,certtype -- 证件类型
            ,certno -- 客户证件号
            ,certname -- 客户姓名
            ,platformamt -- 授信额度
            ,isdirect -- 是否受托支付
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,entrustedpay -- 受托支付账户
            ,entrustedpaymentname -- 受托支付账户名
            ,lendapproverequestid -- 支用审批时的requestid
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 信贷流水号
    ,nvl(n.requestid, o.requestid) as requestid -- 请求幂等ID
    ,nvl(n.custipid, o.custipid) as custipid -- 借款人在网商的会员ID
    ,nvl(n.custiproleid, o.custiproleid) as custiproleid -- 借款人在网商的会员角色ID
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 与合作机构合作的业务模式
    ,nvl(n.loanarno, o.loanarno) as loanarno -- 贷款合约号
    ,nvl(n.amount, o.amount) as amount -- 支用金额
    ,nvl(n.intrate, o.intrate) as intrate -- 初始年利率
    ,nvl(n.realintrate, o.realintrate) as realintrate -- 实际折后年利率
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.startdate, o.startdate) as startdate -- 贷款起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 贷款到期日期
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certno, o.certno) as certno -- 客户证件号
    ,nvl(n.certname, o.certname) as certname -- 客户姓名
    ,nvl(n.platformamt, o.platformamt) as platformamt -- 授信额度
    ,nvl(n.isdirect, o.isdirect) as isdirect -- 是否受托支付
    ,nvl(n.encashacctno, o.encashacctno) as encashacctno -- 收款账户
    ,nvl(n.encashacctname, o.encashacctname) as encashacctname -- 收款账户名
    ,nvl(n.entrustedpay, o.entrustedpay) as entrustedpay -- 受托支付账户
    ,nvl(n.entrustedpaymentname, o.entrustedpaymentname) as entrustedpaymentname -- 受托支付账户名
    ,nvl(n.lendapproverequestid, o.lendapproverequestid) as lendapproverequestid -- 支用审批时的requestid
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
from (select * from ${iol_schema}.icms_mybkzd_payment_notification_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_payment_notification where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.requestid <> n.requestid
        or o.custipid <> n.custipid
        or o.custiproleid <> n.custiproleid
        or o.businessmodel <> n.businessmodel
        or o.loanarno <> n.loanarno
        or o.amount <> n.amount
        or o.intrate <> n.intrate
        or o.realintrate <> n.realintrate
        or o.putoutdate <> n.putoutdate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.repaytype <> n.repaytype
        or o.certtype <> n.certtype
        or o.certno <> n.certno
        or o.certname <> n.certname
        or o.platformamt <> n.platformamt
        or o.isdirect <> n.isdirect
        or o.encashacctno <> n.encashacctno
        or o.encashacctname <> n.encashacctname
        or o.entrustedpay <> n.entrustedpay
        or o.entrustedpaymentname <> n.entrustedpaymentname
        or o.lendapproverequestid <> n.lendapproverequestid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_payment_notification_cl(
            serialno -- 信贷流水号
            ,requestid -- 请求幂等ID
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,businessmodel -- 与合作机构合作的业务模式
            ,loanarno -- 贷款合约号
            ,amount -- 支用金额
            ,intrate -- 初始年利率
            ,realintrate -- 实际折后年利率
            ,putoutdate -- 放款日期
            ,startdate -- 贷款起始日期
            ,enddate -- 贷款到期日期
            ,repaytype -- 还款方式
            ,certtype -- 证件类型
            ,certno -- 客户证件号
            ,certname -- 客户姓名
            ,platformamt -- 授信额度
            ,isdirect -- 是否受托支付
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,entrustedpay -- 受托支付账户
            ,entrustedpaymentname -- 受托支付账户名
            ,lendapproverequestid -- 支用审批时的requestid
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_payment_notification_op(
            serialno -- 信贷流水号
            ,requestid -- 请求幂等ID
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,businessmodel -- 与合作机构合作的业务模式
            ,loanarno -- 贷款合约号
            ,amount -- 支用金额
            ,intrate -- 初始年利率
            ,realintrate -- 实际折后年利率
            ,putoutdate -- 放款日期
            ,startdate -- 贷款起始日期
            ,enddate -- 贷款到期日期
            ,repaytype -- 还款方式
            ,certtype -- 证件类型
            ,certno -- 客户证件号
            ,certname -- 客户姓名
            ,platformamt -- 授信额度
            ,isdirect -- 是否受托支付
            ,encashacctno -- 收款账户
            ,encashacctname -- 收款账户名
            ,entrustedpay -- 受托支付账户
            ,entrustedpaymentname -- 受托支付账户名
            ,lendapproverequestid -- 支用审批时的requestid
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 信贷流水号
    ,o.requestid -- 请求幂等ID
    ,o.custipid -- 借款人在网商的会员ID
    ,o.custiproleid -- 借款人在网商的会员角色ID
    ,o.businessmodel -- 与合作机构合作的业务模式
    ,o.loanarno -- 贷款合约号
    ,o.amount -- 支用金额
    ,o.intrate -- 初始年利率
    ,o.realintrate -- 实际折后年利率
    ,o.putoutdate -- 放款日期
    ,o.startdate -- 贷款起始日期
    ,o.enddate -- 贷款到期日期
    ,o.repaytype -- 还款方式
    ,o.certtype -- 证件类型
    ,o.certno -- 客户证件号
    ,o.certname -- 客户姓名
    ,o.platformamt -- 授信额度
    ,o.isdirect -- 是否受托支付
    ,o.encashacctno -- 收款账户
    ,o.encashacctname -- 收款账户名
    ,o.entrustedpay -- 受托支付账户
    ,o.entrustedpaymentname -- 受托支付账户名
    ,o.lendapproverequestid -- 支用审批时的requestid
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
from ${iol_schema}.icms_mybkzd_payment_notification_bk o
    left join ${iol_schema}.icms_mybkzd_payment_notification_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_payment_notification_cl d
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
--truncate table ${iol_schema}.icms_mybkzd_payment_notification;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_payment_notification') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_payment_notification drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_payment_notification add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_payment_notification exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_payment_notification_cl;
alter table ${iol_schema}.icms_mybkzd_payment_notification exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_payment_notification_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_payment_notification to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_payment_notification_op purge;
drop table ${iol_schema}.icms_mybkzd_payment_notification_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_payment_notification_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_payment_notification',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
