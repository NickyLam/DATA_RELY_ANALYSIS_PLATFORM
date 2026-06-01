/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_upl_loan
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
create table ${iol_schema}.icms_bc_upl_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bc_upl_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_upl_loan_op purge;
drop table ${iol_schema}.icms_bc_upl_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_upl_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_upl_loan where 0=1;

create table ${iol_schema}.icms_bc_upl_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_upl_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_upl_loan_cl(
            serialno -- 合同编号
            ,subbusinesstype -- 助贷业务品种
            ,loantradesum -- 贷款用途交易金额
            ,feeratio -- 手续费率
            ,loankind -- 期限类型
            ,feesum -- 手续费金额/受托止付金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,batchpaymentflag -- 是否参与批扣
            ,uplaccountno -- 微贷结算账号
            ,warrantorid -- 主要担保人代码
            ,payaccountname2 -- 第二还款账户名
            ,warrantor -- 主要担保人
            ,paysource -- 还款说明
            ,holdcorpus -- 保留本金
            ,paymenttype -- 支付方式
            ,businessprop -- 贷款成数
            ,paybankaddcode -- 收款人开户行地点
            ,incomeorgid -- 入账机构编号
            ,payaccountno2 -- 第二还款账户
            ,feepayment -- 手续费支付方式
            ,bankinoutflag -- 行内外标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_upl_loan_op(
            serialno -- 合同编号
            ,subbusinesstype -- 助贷业务品种
            ,loantradesum -- 贷款用途交易金额
            ,feeratio -- 手续费率
            ,loankind -- 期限类型
            ,feesum -- 手续费金额/受托止付金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,batchpaymentflag -- 是否参与批扣
            ,uplaccountno -- 微贷结算账号
            ,warrantorid -- 主要担保人代码
            ,payaccountname2 -- 第二还款账户名
            ,warrantor -- 主要担保人
            ,paysource -- 还款说明
            ,holdcorpus -- 保留本金
            ,paymenttype -- 支付方式
            ,businessprop -- 贷款成数
            ,paybankaddcode -- 收款人开户行地点
            ,incomeorgid -- 入账机构编号
            ,payaccountno2 -- 第二还款账户
            ,feepayment -- 手续费支付方式
            ,bankinoutflag -- 行内外标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.subbusinesstype, o.subbusinesstype) as subbusinesstype -- 助贷业务品种
    ,nvl(n.loantradesum, o.loantradesum) as loantradesum -- 贷款用途交易金额
    ,nvl(n.feeratio, o.feeratio) as feeratio -- 手续费率
    ,nvl(n.loankind, o.loankind) as loankind -- 期限类型
    ,nvl(n.feesum, o.feesum) as feesum -- 手续费金额/受托止付金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.batchpaymentflag, o.batchpaymentflag) as batchpaymentflag -- 是否参与批扣
    ,nvl(n.uplaccountno, o.uplaccountno) as uplaccountno -- 微贷结算账号
    ,nvl(n.warrantorid, o.warrantorid) as warrantorid -- 主要担保人代码
    ,nvl(n.payaccountname2, o.payaccountname2) as payaccountname2 -- 第二还款账户名
    ,nvl(n.warrantor, o.warrantor) as warrantor -- 主要担保人
    ,nvl(n.paysource, o.paysource) as paysource -- 还款说明
    ,nvl(n.holdcorpus, o.holdcorpus) as holdcorpus -- 保留本金
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.businessprop, o.businessprop) as businessprop -- 贷款成数
    ,nvl(n.paybankaddcode, o.paybankaddcode) as paybankaddcode -- 收款人开户行地点
    ,nvl(n.incomeorgid, o.incomeorgid) as incomeorgid -- 入账机构编号
    ,nvl(n.payaccountno2, o.payaccountno2) as payaccountno2 -- 第二还款账户
    ,nvl(n.feepayment, o.feepayment) as feepayment -- 手续费支付方式
    ,nvl(n.bankinoutflag, o.bankinoutflag) as bankinoutflag -- 行内外标志
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
from (select * from ${iol_schema}.icms_bc_upl_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bc_upl_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.subbusinesstype <> n.subbusinesstype
        or o.loantradesum <> n.loantradesum
        or o.feeratio <> n.feeratio
        or o.loankind <> n.loankind
        or o.feesum <> n.feesum
        or o.migtflag <> n.migtflag
        or o.batchpaymentflag <> n.batchpaymentflag
        or o.uplaccountno <> n.uplaccountno
        or o.warrantorid <> n.warrantorid
        or o.payaccountname2 <> n.payaccountname2
        or o.warrantor <> n.warrantor
        or o.paysource <> n.paysource
        or o.holdcorpus <> n.holdcorpus
        or o.paymenttype <> n.paymenttype
        or o.businessprop <> n.businessprop
        or o.paybankaddcode <> n.paybankaddcode
        or o.incomeorgid <> n.incomeorgid
        or o.payaccountno2 <> n.payaccountno2
        or o.feepayment <> n.feepayment
        or o.bankinoutflag <> n.bankinoutflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_upl_loan_cl(
            serialno -- 合同编号
            ,subbusinesstype -- 助贷业务品种
            ,loantradesum -- 贷款用途交易金额
            ,feeratio -- 手续费率
            ,loankind -- 期限类型
            ,feesum -- 手续费金额/受托止付金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,batchpaymentflag -- 是否参与批扣
            ,uplaccountno -- 微贷结算账号
            ,warrantorid -- 主要担保人代码
            ,payaccountname2 -- 第二还款账户名
            ,warrantor -- 主要担保人
            ,paysource -- 还款说明
            ,holdcorpus -- 保留本金
            ,paymenttype -- 支付方式
            ,businessprop -- 贷款成数
            ,paybankaddcode -- 收款人开户行地点
            ,incomeorgid -- 入账机构编号
            ,payaccountno2 -- 第二还款账户
            ,feepayment -- 手续费支付方式
            ,bankinoutflag -- 行内外标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_upl_loan_op(
            serialno -- 合同编号
            ,subbusinesstype -- 助贷业务品种
            ,loantradesum -- 贷款用途交易金额
            ,feeratio -- 手续费率
            ,loankind -- 期限类型
            ,feesum -- 手续费金额/受托止付金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,batchpaymentflag -- 是否参与批扣
            ,uplaccountno -- 微贷结算账号
            ,warrantorid -- 主要担保人代码
            ,payaccountname2 -- 第二还款账户名
            ,warrantor -- 主要担保人
            ,paysource -- 还款说明
            ,holdcorpus -- 保留本金
            ,paymenttype -- 支付方式
            ,businessprop -- 贷款成数
            ,paybankaddcode -- 收款人开户行地点
            ,incomeorgid -- 入账机构编号
            ,payaccountno2 -- 第二还款账户
            ,feepayment -- 手续费支付方式
            ,bankinoutflag -- 行内外标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.subbusinesstype -- 助贷业务品种
    ,o.loantradesum -- 贷款用途交易金额
    ,o.feeratio -- 手续费率
    ,o.loankind -- 期限类型
    ,o.feesum -- 手续费金额/受托止付金额
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.batchpaymentflag -- 是否参与批扣
    ,o.uplaccountno -- 微贷结算账号
    ,o.warrantorid -- 主要担保人代码
    ,o.payaccountname2 -- 第二还款账户名
    ,o.warrantor -- 主要担保人
    ,o.paysource -- 还款说明
    ,o.holdcorpus -- 保留本金
    ,o.paymenttype -- 支付方式
    ,o.businessprop -- 贷款成数
    ,o.paybankaddcode -- 收款人开户行地点
    ,o.incomeorgid -- 入账机构编号
    ,o.payaccountno2 -- 第二还款账户
    ,o.feepayment -- 手续费支付方式
    ,o.bankinoutflag -- 行内外标志
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
from ${iol_schema}.icms_bc_upl_loan_bk o
    left join ${iol_schema}.icms_bc_upl_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bc_upl_loan_cl d
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
--truncate table ${iol_schema}.icms_bc_upl_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bc_upl_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bc_upl_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bc_upl_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bc_upl_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bc_upl_loan_cl;
alter table ${iol_schema}.icms_bc_upl_loan exchange partition p_20991231 with table ${iol_schema}.icms_bc_upl_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bc_upl_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_upl_loan_op purge;
drop table ${iol_schema}.icms_bc_upl_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bc_upl_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bc_upl_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
