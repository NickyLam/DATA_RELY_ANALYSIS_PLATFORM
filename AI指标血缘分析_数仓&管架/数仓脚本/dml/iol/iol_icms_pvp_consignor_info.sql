/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_pvp_consignor_info
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
create table ${iol_schema}.icms_pvp_consignor_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_pvp_consignor_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pvp_consignor_info_op purge;
drop table ${iol_schema}.icms_pvp_consignor_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pvp_consignor_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pvp_consignor_info where 0=1;

create table ${iol_schema}.icms_pvp_consignor_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pvp_consignor_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pvp_consignor_info_cl(
            serialno -- 申请业务流水号
            ,consignorname -- 委托人名称
            ,capaccounttype -- 本金归还入账账户支付工具类型
            ,taxaccountname -- 印花税扣税账号名称
            ,nationaleconomysubclass -- 国民经济部门子类
            ,contno -- 借款合同号
            ,depaccountname -- 委托人存款账户名称
            ,fundsprovided -- 资金来源
            ,cusname -- 借款人名称
            ,capaccountname -- 本金归还入账账户名称
            ,taxaccounttype -- 印花税扣税账号支付工具类型
            ,consignorid -- 委托人客户号
            ,depaccounttype -- 委托人存款账户支付工具类型
            ,feeaccount -- 手续费收取账号
            ,feeaccountname -- 手续费收取账号名称
            ,entrustdepaccounttype -- 委托存款账户支付工具类型
            ,intaccount -- 利息归还入账账户
            ,intaccounttype -- 利息归还入账账户支付工具类型
            ,entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
            ,entrustdeptypesub -- 委托贷款细类
            ,migtflag -- 
            ,nationaleconomycategory -- 国民经济大类
            ,entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
            ,principalmarriage -- 委托人婚姻状况
            ,taxaccount -- 印花税扣税账号
            ,consignorcerttype -- 委托人证件类型
            ,intaccountname -- 利息归还入账账户名称
            ,billno -- 借据号
            ,entrustdepdustrytype -- 委托贷款投向
            ,cusid -- 借款人客户号
            ,consignorcertno -- 委托证人件号码
            ,consignortype -- 委托人类型
            ,depaccount -- 委托人存款账户
            ,feeaccounttype -- 手续费收取账号支付工具类型
            ,capaccount -- 本金归还入账账户
            ,entrustdepaccount -- 委托存款账户
            ,entrustdepaccountname -- 委托存款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pvp_consignor_info_op(
            serialno -- 申请业务流水号
            ,consignorname -- 委托人名称
            ,capaccounttype -- 本金归还入账账户支付工具类型
            ,taxaccountname -- 印花税扣税账号名称
            ,nationaleconomysubclass -- 国民经济部门子类
            ,contno -- 借款合同号
            ,depaccountname -- 委托人存款账户名称
            ,fundsprovided -- 资金来源
            ,cusname -- 借款人名称
            ,capaccountname -- 本金归还入账账户名称
            ,taxaccounttype -- 印花税扣税账号支付工具类型
            ,consignorid -- 委托人客户号
            ,depaccounttype -- 委托人存款账户支付工具类型
            ,feeaccount -- 手续费收取账号
            ,feeaccountname -- 手续费收取账号名称
            ,entrustdepaccounttype -- 委托存款账户支付工具类型
            ,intaccount -- 利息归还入账账户
            ,intaccounttype -- 利息归还入账账户支付工具类型
            ,entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
            ,entrustdeptypesub -- 委托贷款细类
            ,migtflag -- 
            ,nationaleconomycategory -- 国民经济大类
            ,entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
            ,principalmarriage -- 委托人婚姻状况
            ,taxaccount -- 印花税扣税账号
            ,consignorcerttype -- 委托人证件类型
            ,intaccountname -- 利息归还入账账户名称
            ,billno -- 借据号
            ,entrustdepdustrytype -- 委托贷款投向
            ,cusid -- 借款人客户号
            ,consignorcertno -- 委托证人件号码
            ,consignortype -- 委托人类型
            ,depaccount -- 委托人存款账户
            ,feeaccounttype -- 手续费收取账号支付工具类型
            ,capaccount -- 本金归还入账账户
            ,entrustdepaccount -- 委托存款账户
            ,entrustdepaccountname -- 委托存款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请业务流水号
    ,nvl(n.consignorname, o.consignorname) as consignorname -- 委托人名称
    ,nvl(n.capaccounttype, o.capaccounttype) as capaccounttype -- 本金归还入账账户支付工具类型
    ,nvl(n.taxaccountname, o.taxaccountname) as taxaccountname -- 印花税扣税账号名称
    ,nvl(n.nationaleconomysubclass, o.nationaleconomysubclass) as nationaleconomysubclass -- 国民经济部门子类
    ,nvl(n.contno, o.contno) as contno -- 借款合同号
    ,nvl(n.depaccountname, o.depaccountname) as depaccountname -- 委托人存款账户名称
    ,nvl(n.fundsprovided, o.fundsprovided) as fundsprovided -- 资金来源
    ,nvl(n.cusname, o.cusname) as cusname -- 借款人名称
    ,nvl(n.capaccountname, o.capaccountname) as capaccountname -- 本金归还入账账户名称
    ,nvl(n.taxaccounttype, o.taxaccounttype) as taxaccounttype -- 印花税扣税账号支付工具类型
    ,nvl(n.consignorid, o.consignorid) as consignorid -- 委托人客户号
    ,nvl(n.depaccounttype, o.depaccounttype) as depaccounttype -- 委托人存款账户支付工具类型
    ,nvl(n.feeaccount, o.feeaccount) as feeaccount -- 手续费收取账号
    ,nvl(n.feeaccountname, o.feeaccountname) as feeaccountname -- 手续费收取账号名称
    ,nvl(n.entrustdepaccounttype, o.entrustdepaccounttype) as entrustdepaccounttype -- 委托存款账户支付工具类型
    ,nvl(n.intaccount, o.intaccount) as intaccount -- 利息归还入账账户
    ,nvl(n.intaccounttype, o.intaccounttype) as intaccounttype -- 利息归还入账账户支付工具类型
    ,nvl(n.entrustdepaccountbankname, o.entrustdepaccountbankname) as entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
    ,nvl(n.entrustdeptypesub, o.entrustdeptypesub) as entrustdeptypesub -- 委托贷款细类
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.nationaleconomycategory, o.nationaleconomycategory) as nationaleconomycategory -- 国民经济大类
    ,nvl(n.entrustdepaccountbank, o.entrustdepaccountbank) as entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
    ,nvl(n.principalmarriage, o.principalmarriage) as principalmarriage -- 委托人婚姻状况
    ,nvl(n.taxaccount, o.taxaccount) as taxaccount -- 印花税扣税账号
    ,nvl(n.consignorcerttype, o.consignorcerttype) as consignorcerttype -- 委托人证件类型
    ,nvl(n.intaccountname, o.intaccountname) as intaccountname -- 利息归还入账账户名称
    ,nvl(n.billno, o.billno) as billno -- 借据号
    ,nvl(n.entrustdepdustrytype, o.entrustdepdustrytype) as entrustdepdustrytype -- 委托贷款投向
    ,nvl(n.cusid, o.cusid) as cusid -- 借款人客户号
    ,nvl(n.consignorcertno, o.consignorcertno) as consignorcertno -- 委托证人件号码
    ,nvl(n.consignortype, o.consignortype) as consignortype -- 委托人类型
    ,nvl(n.depaccount, o.depaccount) as depaccount -- 委托人存款账户
    ,nvl(n.feeaccounttype, o.feeaccounttype) as feeaccounttype -- 手续费收取账号支付工具类型
    ,nvl(n.capaccount, o.capaccount) as capaccount -- 本金归还入账账户
    ,nvl(n.entrustdepaccount, o.entrustdepaccount) as entrustdepaccount -- 委托存款账户
    ,nvl(n.entrustdepaccountname, o.entrustdepaccountname) as entrustdepaccountname -- 委托存款账户名称
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
from (select * from ${iol_schema}.icms_pvp_consignor_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_pvp_consignor_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.consignorname <> n.consignorname
        or o.capaccounttype <> n.capaccounttype
        or o.taxaccountname <> n.taxaccountname
        or o.nationaleconomysubclass <> n.nationaleconomysubclass
        or o.contno <> n.contno
        or o.depaccountname <> n.depaccountname
        or o.fundsprovided <> n.fundsprovided
        or o.cusname <> n.cusname
        or o.capaccountname <> n.capaccountname
        or o.taxaccounttype <> n.taxaccounttype
        or o.consignorid <> n.consignorid
        or o.depaccounttype <> n.depaccounttype
        or o.feeaccount <> n.feeaccount
        or o.feeaccountname <> n.feeaccountname
        or o.entrustdepaccounttype <> n.entrustdepaccounttype
        or o.intaccount <> n.intaccount
        or o.intaccounttype <> n.intaccounttype
        or o.entrustdepaccountbankname <> n.entrustdepaccountbankname
        or o.entrustdeptypesub <> n.entrustdeptypesub
        or o.migtflag <> n.migtflag
        or o.nationaleconomycategory <> n.nationaleconomycategory
        or o.entrustdepaccountbank <> n.entrustdepaccountbank
        or o.principalmarriage <> n.principalmarriage
        or o.taxaccount <> n.taxaccount
        or o.consignorcerttype <> n.consignorcerttype
        or o.intaccountname <> n.intaccountname
        or o.billno <> n.billno
        or o.entrustdepdustrytype <> n.entrustdepdustrytype
        or o.cusid <> n.cusid
        or o.consignorcertno <> n.consignorcertno
        or o.consignortype <> n.consignortype
        or o.depaccount <> n.depaccount
        or o.feeaccounttype <> n.feeaccounttype
        or o.capaccount <> n.capaccount
        or o.entrustdepaccount <> n.entrustdepaccount
        or o.entrustdepaccountname <> n.entrustdepaccountname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pvp_consignor_info_cl(
            serialno -- 申请业务流水号
            ,consignorname -- 委托人名称
            ,capaccounttype -- 本金归还入账账户支付工具类型
            ,taxaccountname -- 印花税扣税账号名称
            ,nationaleconomysubclass -- 国民经济部门子类
            ,contno -- 借款合同号
            ,depaccountname -- 委托人存款账户名称
            ,fundsprovided -- 资金来源
            ,cusname -- 借款人名称
            ,capaccountname -- 本金归还入账账户名称
            ,taxaccounttype -- 印花税扣税账号支付工具类型
            ,consignorid -- 委托人客户号
            ,depaccounttype -- 委托人存款账户支付工具类型
            ,feeaccount -- 手续费收取账号
            ,feeaccountname -- 手续费收取账号名称
            ,entrustdepaccounttype -- 委托存款账户支付工具类型
            ,intaccount -- 利息归还入账账户
            ,intaccounttype -- 利息归还入账账户支付工具类型
            ,entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
            ,entrustdeptypesub -- 委托贷款细类
            ,migtflag -- 
            ,nationaleconomycategory -- 国民经济大类
            ,entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
            ,principalmarriage -- 委托人婚姻状况
            ,taxaccount -- 印花税扣税账号
            ,consignorcerttype -- 委托人证件类型
            ,intaccountname -- 利息归还入账账户名称
            ,billno -- 借据号
            ,entrustdepdustrytype -- 委托贷款投向
            ,cusid -- 借款人客户号
            ,consignorcertno -- 委托证人件号码
            ,consignortype -- 委托人类型
            ,depaccount -- 委托人存款账户
            ,feeaccounttype -- 手续费收取账号支付工具类型
            ,capaccount -- 本金归还入账账户
            ,entrustdepaccount -- 委托存款账户
            ,entrustdepaccountname -- 委托存款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pvp_consignor_info_op(
            serialno -- 申请业务流水号
            ,consignorname -- 委托人名称
            ,capaccounttype -- 本金归还入账账户支付工具类型
            ,taxaccountname -- 印花税扣税账号名称
            ,nationaleconomysubclass -- 国民经济部门子类
            ,contno -- 借款合同号
            ,depaccountname -- 委托人存款账户名称
            ,fundsprovided -- 资金来源
            ,cusname -- 借款人名称
            ,capaccountname -- 本金归还入账账户名称
            ,taxaccounttype -- 印花税扣税账号支付工具类型
            ,consignorid -- 委托人客户号
            ,depaccounttype -- 委托人存款账户支付工具类型
            ,feeaccount -- 手续费收取账号
            ,feeaccountname -- 手续费收取账号名称
            ,entrustdepaccounttype -- 委托存款账户支付工具类型
            ,intaccount -- 利息归还入账账户
            ,intaccounttype -- 利息归还入账账户支付工具类型
            ,entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
            ,entrustdeptypesub -- 委托贷款细类
            ,migtflag -- 
            ,nationaleconomycategory -- 国民经济大类
            ,entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
            ,principalmarriage -- 委托人婚姻状况
            ,taxaccount -- 印花税扣税账号
            ,consignorcerttype -- 委托人证件类型
            ,intaccountname -- 利息归还入账账户名称
            ,billno -- 借据号
            ,entrustdepdustrytype -- 委托贷款投向
            ,cusid -- 借款人客户号
            ,consignorcertno -- 委托证人件号码
            ,consignortype -- 委托人类型
            ,depaccount -- 委托人存款账户
            ,feeaccounttype -- 手续费收取账号支付工具类型
            ,capaccount -- 本金归还入账账户
            ,entrustdepaccount -- 委托存款账户
            ,entrustdepaccountname -- 委托存款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请业务流水号
    ,o.consignorname -- 委托人名称
    ,o.capaccounttype -- 本金归还入账账户支付工具类型
    ,o.taxaccountname -- 印花税扣税账号名称
    ,o.nationaleconomysubclass -- 国民经济部门子类
    ,o.contno -- 借款合同号
    ,o.depaccountname -- 委托人存款账户名称
    ,o.fundsprovided -- 资金来源
    ,o.cusname -- 借款人名称
    ,o.capaccountname -- 本金归还入账账户名称
    ,o.taxaccounttype -- 印花税扣税账号支付工具类型
    ,o.consignorid -- 委托人客户号
    ,o.depaccounttype -- 委托人存款账户支付工具类型
    ,o.feeaccount -- 手续费收取账号
    ,o.feeaccountname -- 手续费收取账号名称
    ,o.entrustdepaccounttype -- 委托存款账户支付工具类型
    ,o.intaccount -- 利息归还入账账户
    ,o.intaccounttype -- 利息归还入账账户支付工具类型
    ,o.entrustdepaccountbankname -- 委托存款账户开户行行名称（行内的）
    ,o.entrustdeptypesub -- 委托贷款细类
    ,o.migtflag -- 
    ,o.nationaleconomycategory -- 国民经济大类
    ,o.entrustdepaccountbank -- 委托存款账户开户行行号（行内的）
    ,o.principalmarriage -- 委托人婚姻状况
    ,o.taxaccount -- 印花税扣税账号
    ,o.consignorcerttype -- 委托人证件类型
    ,o.intaccountname -- 利息归还入账账户名称
    ,o.billno -- 借据号
    ,o.entrustdepdustrytype -- 委托贷款投向
    ,o.cusid -- 借款人客户号
    ,o.consignorcertno -- 委托证人件号码
    ,o.consignortype -- 委托人类型
    ,o.depaccount -- 委托人存款账户
    ,o.feeaccounttype -- 手续费收取账号支付工具类型
    ,o.capaccount -- 本金归还入账账户
    ,o.entrustdepaccount -- 委托存款账户
    ,o.entrustdepaccountname -- 委托存款账户名称
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
from ${iol_schema}.icms_pvp_consignor_info_bk o
    left join ${iol_schema}.icms_pvp_consignor_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_pvp_consignor_info_cl d
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
--truncate table ${iol_schema}.icms_pvp_consignor_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_pvp_consignor_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_pvp_consignor_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_pvp_consignor_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_pvp_consignor_info exchange partition p_${batch_date} with table ${iol_schema}.icms_pvp_consignor_info_cl;
alter table ${iol_schema}.icms_pvp_consignor_info exchange partition p_20991231 with table ${iol_schema}.icms_pvp_consignor_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_pvp_consignor_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pvp_consignor_info_op purge;
drop table ${iol_schema}.icms_pvp_consignor_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_pvp_consignor_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_pvp_consignor_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
