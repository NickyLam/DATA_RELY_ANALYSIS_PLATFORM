/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_upl_loan
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
create table ${iol_schema}.icms_bp_upl_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bp_upl_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_upl_loan_op purge;
drop table ${iol_schema}.icms_bp_upl_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_upl_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_upl_loan where 0=1;

create table ${iol_schema}.icms_bp_upl_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_upl_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_upl_loan_cl(
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_upl_loan_op(
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.paybankno, o.paybankno) as paybankno -- 收款人行号
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.oldtradedate, o.oldtradedate) as oldtradedate -- 原交易日期
    ,nvl(n.oldtradeserialno, o.oldtradeserialno) as oldtradeserialno -- 原交易流水号
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 贷款期限
    ,nvl(n.vouchmode, o.vouchmode) as vouchmode -- 担保方式
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 付款方式
    ,nvl(n.begintime, o.begintime) as begintime -- 开始时间
    ,nvl(n.loankind, o.loankind) as loankind -- 期限类型
    ,nvl(n.trustpayaccountno, o.trustpayaccountno) as trustpayaccountno -- 受托支付账号
    ,nvl(n.paysource, o.paysource) as paysource -- 还款说明
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.businessserialno, o.businessserialno) as businessserialno -- 交易流水号
    ,nvl(n.warrantorid, o.warrantorid) as warrantorid -- 主要担保人编码
    ,nvl(n.warrantor, o.warrantor) as warrantor -- 主要担保人
    ,nvl(n.uplaccountno, o.uplaccountno) as uplaccountno -- 微贷结算账号
    ,nvl(n.stayentrustnumber, o.stayentrustnumber) as stayentrustnumber -- 待受托划款的笔数
    ,nvl(n.paybankaddcode, o.paybankaddcode) as paybankaddcode -- 收款人开户行地点
    ,nvl(n.holdcorpus, o.holdcorpus) as holdcorpus -- 保留本金
    ,nvl(n.crstranseqno, o.crstranseqno) as crstranseqno -- 正向交易流水号
    ,nvl(n.uplpayaccountno2, o.uplpayaccountno2) as uplpayaccountno2 -- 微贷还款账户2
    ,nvl(n.paybankname, o.paybankname) as paybankname -- 收款人行名
    ,nvl(n.subbusinesstype, o.subbusinesstype) as subbusinesstype -- 助贷业务品种
    ,nvl(n.uplpayaccountno1, o.uplpayaccountno1) as uplpayaccountno1 -- 微贷还款账户1
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 交易日期
    ,nvl(n.putoutstatus, o.putoutstatus) as putoutstatus -- 出账状态
    ,nvl(n.bankinoutflag, o.bankinoutflag) as bankinoutflag -- 行内外标识
    ,nvl(n.errorinfo, o.errorinfo) as errorinfo -- 错误信息
    ,nvl(n.paybankkindcode, o.paybankkindcode) as paybankkindcode -- 收款人开户行类别
    ,nvl(n.trustpayaccountname, o.trustpayaccountname) as trustpayaccountname -- 受托支付户名
    ,nvl(n.batchpaymentflag, o.batchpaymentflag) as batchpaymentflag -- 是否参与批扣
    ,nvl(n.userid, o.userid) as userid -- 用户编号
    ,nvl(n.payaccountno2, o.payaccountno2) as payaccountno2 -- 第二还款账户
    ,nvl(n.actualbegintime, o.actualbegintime) as actualbegintime -- 实际开始时间
    ,nvl(n.exchangetype, o.exchangetype) as exchangetype -- 交易类型
    ,nvl(n.payprinintvl, o.payprinintvl) as payprinintvl -- 贷款还息间隔
    ,nvl(n.incomeorgid, o.incomeorgid) as incomeorgid -- 入账机构
    ,nvl(n.payaccountname2, o.payaccountname2) as payaccountname2 -- 第二还款账户名
    ,nvl(n.crstrandate, o.crstrandate) as crstrandate -- 正向交易日期
    ,nvl(n.paymentmode, o.paymentmode) as paymentmode -- 
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
from (select * from ${iol_schema}.icms_bp_upl_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bp_upl_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.paybankno <> n.paybankno
        or o.mfcustomerid <> n.mfcustomerid
        or o.migtflag <> n.migtflag
        or o.oldtradedate <> n.oldtradedate
        or o.oldtradeserialno <> n.oldtradeserialno
        or o.loanterm <> n.loanterm
        or o.vouchmode <> n.vouchmode
        or o.repaymode <> n.repaymode
        or o.begintime <> n.begintime
        or o.loankind <> n.loankind
        or o.trustpayaccountno <> n.trustpayaccountno
        or o.paysource <> n.paysource
        or o.loantype <> n.loantype
        or o.businessserialno <> n.businessserialno
        or o.warrantorid <> n.warrantorid
        or o.warrantor <> n.warrantor
        or o.uplaccountno <> n.uplaccountno
        or o.stayentrustnumber <> n.stayentrustnumber
        or o.paybankaddcode <> n.paybankaddcode
        or o.holdcorpus <> n.holdcorpus
        or o.crstranseqno <> n.crstranseqno
        or o.uplpayaccountno2 <> n.uplpayaccountno2
        or o.paybankname <> n.paybankname
        or o.subbusinesstype <> n.subbusinesstype
        or o.uplpayaccountno1 <> n.uplpayaccountno1
        or o.tradedate <> n.tradedate
        or o.putoutstatus <> n.putoutstatus
        or o.bankinoutflag <> n.bankinoutflag
        or o.errorinfo <> n.errorinfo
        or o.paybankkindcode <> n.paybankkindcode
        or o.trustpayaccountname <> n.trustpayaccountname
        or o.batchpaymentflag <> n.batchpaymentflag
        or o.userid <> n.userid
        or o.payaccountno2 <> n.payaccountno2
        or o.actualbegintime <> n.actualbegintime
        or o.exchangetype <> n.exchangetype
        or o.payprinintvl <> n.payprinintvl
        or o.incomeorgid <> n.incomeorgid
        or o.payaccountname2 <> n.payaccountname2
        or o.crstrandate <> n.crstrandate
        or o.paymentmode <> n.paymentmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_upl_loan_cl(
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_upl_loan_op(
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.paybankno -- 收款人行号
    ,o.mfcustomerid -- 核心客户编号
    ,o.migtflag -- 
    ,o.oldtradedate -- 原交易日期
    ,o.oldtradeserialno -- 原交易流水号
    ,o.loanterm -- 贷款期限
    ,o.vouchmode -- 担保方式
    ,o.repaymode -- 付款方式
    ,o.begintime -- 开始时间
    ,o.loankind -- 期限类型
    ,o.trustpayaccountno -- 受托支付账号
    ,o.paysource -- 还款说明
    ,o.loantype -- 贷款类型
    ,o.businessserialno -- 交易流水号
    ,o.warrantorid -- 主要担保人编码
    ,o.warrantor -- 主要担保人
    ,o.uplaccountno -- 微贷结算账号
    ,o.stayentrustnumber -- 待受托划款的笔数
    ,o.paybankaddcode -- 收款人开户行地点
    ,o.holdcorpus -- 保留本金
    ,o.crstranseqno -- 正向交易流水号
    ,o.uplpayaccountno2 -- 微贷还款账户2
    ,o.paybankname -- 收款人行名
    ,o.subbusinesstype -- 助贷业务品种
    ,o.uplpayaccountno1 -- 微贷还款账户1
    ,o.tradedate -- 交易日期
    ,o.putoutstatus -- 出账状态
    ,o.bankinoutflag -- 行内外标识
    ,o.errorinfo -- 错误信息
    ,o.paybankkindcode -- 收款人开户行类别
    ,o.trustpayaccountname -- 受托支付户名
    ,o.batchpaymentflag -- 是否参与批扣
    ,o.userid -- 用户编号
    ,o.payaccountno2 -- 第二还款账户
    ,o.actualbegintime -- 实际开始时间
    ,o.exchangetype -- 交易类型
    ,o.payprinintvl -- 贷款还息间隔
    ,o.incomeorgid -- 入账机构
    ,o.payaccountname2 -- 第二还款账户名
    ,o.crstrandate -- 正向交易日期
    ,o.paymentmode -- 
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
from ${iol_schema}.icms_bp_upl_loan_bk o
    left join ${iol_schema}.icms_bp_upl_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bp_upl_loan_cl d
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
--truncate table ${iol_schema}.icms_bp_upl_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bp_upl_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bp_upl_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bp_upl_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bp_upl_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bp_upl_loan_cl;
alter table ${iol_schema}.icms_bp_upl_loan exchange partition p_20991231 with table ${iol_schema}.icms_bp_upl_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bp_upl_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_upl_loan_op purge;
drop table ${iol_schema}.icms_bp_upl_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bp_upl_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bp_upl_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
