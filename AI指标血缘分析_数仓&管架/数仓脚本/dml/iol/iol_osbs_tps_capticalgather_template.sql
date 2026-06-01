/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_capticalgather_template
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
create table ${iol_schema}.osbs_tps_capticalgather_template_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_capticalgather_template;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_capticalgather_template_op purge;
drop table ${iol_schema}.osbs_tps_capticalgather_template_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_capticalgather_template_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_capticalgather_template where 0=1;

create table ${iol_schema}.osbs_tps_capticalgather_template_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_capticalgather_template where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_capticalgather_template_cl(
            tgt_capticalgather_no -- 资金归集编号
            ,tgt_ecifno -- 统一客户号
            ,tgt_userno -- 用户顺序号
            ,tgt_transcode -- 交易编码
            ,tgt_payaccno -- 转出账号
            ,tgt_payaccname -- 转出账户名称
            ,tgt_paybankname -- 付款银行名称
            ,tgt_payacctype -- 转出账号账户类别
            ,tgt_paybankid -- 转出账户开户行
            ,tgt_paycurrency -- 转出币种
            ,tgt_rcvaccno -- 转入账号
            ,tgt_amount -- 金额
            ,tgt_remark -- 附言
            ,tgt_fee -- 费用
            ,tgt_use -- 付款用途
            ,tgt_submittime -- 提交时间
            ,tgt_singleamtlimit -- 单笔限额
            ,tgt_protocolno -- 收钱协议号
            ,tgt_rcvbankid -- 转入行号
            ,tgt_summary -- 核心摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_capticalgather_template_op(
            tgt_capticalgather_no -- 资金归集编号
            ,tgt_ecifno -- 统一客户号
            ,tgt_userno -- 用户顺序号
            ,tgt_transcode -- 交易编码
            ,tgt_payaccno -- 转出账号
            ,tgt_payaccname -- 转出账户名称
            ,tgt_paybankname -- 付款银行名称
            ,tgt_payacctype -- 转出账号账户类别
            ,tgt_paybankid -- 转出账户开户行
            ,tgt_paycurrency -- 转出币种
            ,tgt_rcvaccno -- 转入账号
            ,tgt_amount -- 金额
            ,tgt_remark -- 附言
            ,tgt_fee -- 费用
            ,tgt_use -- 付款用途
            ,tgt_submittime -- 提交时间
            ,tgt_singleamtlimit -- 单笔限额
            ,tgt_protocolno -- 收钱协议号
            ,tgt_rcvbankid -- 转入行号
            ,tgt_summary -- 核心摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tgt_capticalgather_no, o.tgt_capticalgather_no) as tgt_capticalgather_no -- 资金归集编号
    ,nvl(n.tgt_ecifno, o.tgt_ecifno) as tgt_ecifno -- 统一客户号
    ,nvl(n.tgt_userno, o.tgt_userno) as tgt_userno -- 用户顺序号
    ,nvl(n.tgt_transcode, o.tgt_transcode) as tgt_transcode -- 交易编码
    ,nvl(n.tgt_payaccno, o.tgt_payaccno) as tgt_payaccno -- 转出账号
    ,nvl(n.tgt_payaccname, o.tgt_payaccname) as tgt_payaccname -- 转出账户名称
    ,nvl(n.tgt_paybankname, o.tgt_paybankname) as tgt_paybankname -- 付款银行名称
    ,nvl(n.tgt_payacctype, o.tgt_payacctype) as tgt_payacctype -- 转出账号账户类别
    ,nvl(n.tgt_paybankid, o.tgt_paybankid) as tgt_paybankid -- 转出账户开户行
    ,nvl(n.tgt_paycurrency, o.tgt_paycurrency) as tgt_paycurrency -- 转出币种
    ,nvl(n.tgt_rcvaccno, o.tgt_rcvaccno) as tgt_rcvaccno -- 转入账号
    ,nvl(n.tgt_amount, o.tgt_amount) as tgt_amount -- 金额
    ,nvl(n.tgt_remark, o.tgt_remark) as tgt_remark -- 附言
    ,nvl(n.tgt_fee, o.tgt_fee) as tgt_fee -- 费用
    ,nvl(n.tgt_use, o.tgt_use) as tgt_use -- 付款用途
    ,nvl(n.tgt_submittime, o.tgt_submittime) as tgt_submittime -- 提交时间
    ,nvl(n.tgt_singleamtlimit, o.tgt_singleamtlimit) as tgt_singleamtlimit -- 单笔限额
    ,nvl(n.tgt_protocolno, o.tgt_protocolno) as tgt_protocolno -- 收钱协议号
    ,nvl(n.tgt_rcvbankid, o.tgt_rcvbankid) as tgt_rcvbankid -- 转入行号
    ,nvl(n.tgt_summary, o.tgt_summary) as tgt_summary -- 核心摘要码
    ,case when
            n.tgt_capticalgather_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tgt_capticalgather_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tgt_capticalgather_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_capticalgather_template_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_capticalgather_template where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tgt_capticalgather_no = n.tgt_capticalgather_no
where (
        o.tgt_capticalgather_no is null
    )
    or (
        n.tgt_capticalgather_no is null
    )
    or (
        o.tgt_ecifno <> n.tgt_ecifno
        or o.tgt_userno <> n.tgt_userno
        or o.tgt_transcode <> n.tgt_transcode
        or o.tgt_payaccno <> n.tgt_payaccno
        or o.tgt_payaccname <> n.tgt_payaccname
        or o.tgt_paybankname <> n.tgt_paybankname
        or o.tgt_payacctype <> n.tgt_payacctype
        or o.tgt_paybankid <> n.tgt_paybankid
        or o.tgt_paycurrency <> n.tgt_paycurrency
        or o.tgt_rcvaccno <> n.tgt_rcvaccno
        or o.tgt_amount <> n.tgt_amount
        or o.tgt_remark <> n.tgt_remark
        or o.tgt_fee <> n.tgt_fee
        or o.tgt_use <> n.tgt_use
        or o.tgt_submittime <> n.tgt_submittime
        or o.tgt_singleamtlimit <> n.tgt_singleamtlimit
        or o.tgt_protocolno <> n.tgt_protocolno
        or o.tgt_rcvbankid <> n.tgt_rcvbankid
        or o.tgt_summary <> n.tgt_summary
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_capticalgather_template_cl(
            tgt_capticalgather_no -- 资金归集编号
            ,tgt_ecifno -- 统一客户号
            ,tgt_userno -- 用户顺序号
            ,tgt_transcode -- 交易编码
            ,tgt_payaccno -- 转出账号
            ,tgt_payaccname -- 转出账户名称
            ,tgt_paybankname -- 付款银行名称
            ,tgt_payacctype -- 转出账号账户类别
            ,tgt_paybankid -- 转出账户开户行
            ,tgt_paycurrency -- 转出币种
            ,tgt_rcvaccno -- 转入账号
            ,tgt_amount -- 金额
            ,tgt_remark -- 附言
            ,tgt_fee -- 费用
            ,tgt_use -- 付款用途
            ,tgt_submittime -- 提交时间
            ,tgt_singleamtlimit -- 单笔限额
            ,tgt_protocolno -- 收钱协议号
            ,tgt_rcvbankid -- 转入行号
            ,tgt_summary -- 核心摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_capticalgather_template_op(
            tgt_capticalgather_no -- 资金归集编号
            ,tgt_ecifno -- 统一客户号
            ,tgt_userno -- 用户顺序号
            ,tgt_transcode -- 交易编码
            ,tgt_payaccno -- 转出账号
            ,tgt_payaccname -- 转出账户名称
            ,tgt_paybankname -- 付款银行名称
            ,tgt_payacctype -- 转出账号账户类别
            ,tgt_paybankid -- 转出账户开户行
            ,tgt_paycurrency -- 转出币种
            ,tgt_rcvaccno -- 转入账号
            ,tgt_amount -- 金额
            ,tgt_remark -- 附言
            ,tgt_fee -- 费用
            ,tgt_use -- 付款用途
            ,tgt_submittime -- 提交时间
            ,tgt_singleamtlimit -- 单笔限额
            ,tgt_protocolno -- 收钱协议号
            ,tgt_rcvbankid -- 转入行号
            ,tgt_summary -- 核心摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tgt_capticalgather_no -- 资金归集编号
    ,o.tgt_ecifno -- 统一客户号
    ,o.tgt_userno -- 用户顺序号
    ,o.tgt_transcode -- 交易编码
    ,o.tgt_payaccno -- 转出账号
    ,o.tgt_payaccname -- 转出账户名称
    ,o.tgt_paybankname -- 付款银行名称
    ,o.tgt_payacctype -- 转出账号账户类别
    ,o.tgt_paybankid -- 转出账户开户行
    ,o.tgt_paycurrency -- 转出币种
    ,o.tgt_rcvaccno -- 转入账号
    ,o.tgt_amount -- 金额
    ,o.tgt_remark -- 附言
    ,o.tgt_fee -- 费用
    ,o.tgt_use -- 付款用途
    ,o.tgt_submittime -- 提交时间
    ,o.tgt_singleamtlimit -- 单笔限额
    ,o.tgt_protocolno -- 收钱协议号
    ,o.tgt_rcvbankid -- 转入行号
    ,o.tgt_summary -- 核心摘要码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_capticalgather_template_bk o
    left join ${iol_schema}.osbs_tps_capticalgather_template_op n
        on
            o.tgt_capticalgather_no = n.tgt_capticalgather_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_capticalgather_template_cl d
        on
            o.tgt_capticalgather_no = d.tgt_capticalgather_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_capticalgather_template;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_capticalgather_template exchange partition p_19000101 with table ${iol_schema}.osbs_tps_capticalgather_template_cl;
alter table ${iol_schema}.osbs_tps_capticalgather_template exchange partition p_20991231 with table ${iol_schema}.osbs_tps_capticalgather_template_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_capticalgather_template to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_capticalgather_template_op purge;
drop table ${iol_schema}.osbs_tps_capticalgather_template_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_capticalgather_template_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_capticalgather_template',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
