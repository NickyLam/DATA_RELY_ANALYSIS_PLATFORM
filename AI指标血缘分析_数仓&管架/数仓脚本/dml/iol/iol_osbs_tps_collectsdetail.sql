/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_collectsdetail
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
create table ${iol_schema}.osbs_tps_collectsdetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_collectsdetail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_collectsdetail_op purge;
drop table ${iol_schema}.osbs_tps_collectsdetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_collectsdetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_collectsdetail where 0=1;

create table ${iol_schema}.osbs_tps_collectsdetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_collectsdetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_collectsdetail_cl(
            tcd_collectdelno -- 计划编号
            ,tcd_transcode -- 交易编码
            ,tcd_protocolidqry -- 跨行查询协议
            ,tcd_protocolidpay -- 跨行支付协议
            ,tcd_payeracno -- 转出账号
            ,tcd_payeracname -- 转出账户名称
            ,tcd_payerbankname -- 转出银行名称
            ,tcd_payerbankactype -- 转出账号账户类别
            ,tcd_payerbankid -- 转出账户开户行
            ,tcd_payercurrency -- 转出币种
            ,tcd_payeeacno -- 转入账号
            ,tcd_modelflag -- 归集模式
            ,tcd_amount -- 转出金额
            ,tcd_remark -- 附言
            ,tcd_fee -- 费用
            ,tcd_validatemsg -- 验证信息
            ,tcd_notecode -- 付款用途
            ,tcd_submittime -- 提交时间
            ,tcd_singleamtlimit -- 单笔限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_collectsdetail_op(
            tcd_collectdelno -- 计划编号
            ,tcd_transcode -- 交易编码
            ,tcd_protocolidqry -- 跨行查询协议
            ,tcd_protocolidpay -- 跨行支付协议
            ,tcd_payeracno -- 转出账号
            ,tcd_payeracname -- 转出账户名称
            ,tcd_payerbankname -- 转出银行名称
            ,tcd_payerbankactype -- 转出账号账户类别
            ,tcd_payerbankid -- 转出账户开户行
            ,tcd_payercurrency -- 转出币种
            ,tcd_payeeacno -- 转入账号
            ,tcd_modelflag -- 归集模式
            ,tcd_amount -- 转出金额
            ,tcd_remark -- 附言
            ,tcd_fee -- 费用
            ,tcd_validatemsg -- 验证信息
            ,tcd_notecode -- 付款用途
            ,tcd_submittime -- 提交时间
            ,tcd_singleamtlimit -- 单笔限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tcd_collectdelno, o.tcd_collectdelno) as tcd_collectdelno -- 计划编号
    ,nvl(n.tcd_transcode, o.tcd_transcode) as tcd_transcode -- 交易编码
    ,nvl(n.tcd_protocolidqry, o.tcd_protocolidqry) as tcd_protocolidqry -- 跨行查询协议
    ,nvl(n.tcd_protocolidpay, o.tcd_protocolidpay) as tcd_protocolidpay -- 跨行支付协议
    ,nvl(n.tcd_payeracno, o.tcd_payeracno) as tcd_payeracno -- 转出账号
    ,nvl(n.tcd_payeracname, o.tcd_payeracname) as tcd_payeracname -- 转出账户名称
    ,nvl(n.tcd_payerbankname, o.tcd_payerbankname) as tcd_payerbankname -- 转出银行名称
    ,nvl(n.tcd_payerbankactype, o.tcd_payerbankactype) as tcd_payerbankactype -- 转出账号账户类别
    ,nvl(n.tcd_payerbankid, o.tcd_payerbankid) as tcd_payerbankid -- 转出账户开户行
    ,nvl(n.tcd_payercurrency, o.tcd_payercurrency) as tcd_payercurrency -- 转出币种
    ,nvl(n.tcd_payeeacno, o.tcd_payeeacno) as tcd_payeeacno -- 转入账号
    ,nvl(n.tcd_modelflag, o.tcd_modelflag) as tcd_modelflag -- 归集模式
    ,nvl(n.tcd_amount, o.tcd_amount) as tcd_amount -- 转出金额
    ,nvl(n.tcd_remark, o.tcd_remark) as tcd_remark -- 附言
    ,nvl(n.tcd_fee, o.tcd_fee) as tcd_fee -- 费用
    ,nvl(n.tcd_validatemsg, o.tcd_validatemsg) as tcd_validatemsg -- 验证信息
    ,nvl(n.tcd_notecode, o.tcd_notecode) as tcd_notecode -- 付款用途
    ,nvl(n.tcd_submittime, o.tcd_submittime) as tcd_submittime -- 提交时间
    ,nvl(n.tcd_singleamtlimit, o.tcd_singleamtlimit) as tcd_singleamtlimit -- 单笔限额
    ,case when
            n.tcd_collectdelno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tcd_collectdelno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tcd_collectdelno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_collectsdetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_collectsdetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tcd_collectdelno = n.tcd_collectdelno
where (
        o.tcd_collectdelno is null
    )
    or (
        n.tcd_collectdelno is null
    )
    or (
        o.tcd_transcode <> n.tcd_transcode
        or o.tcd_protocolidqry <> n.tcd_protocolidqry
        or o.tcd_protocolidpay <> n.tcd_protocolidpay
        or o.tcd_payeracno <> n.tcd_payeracno
        or o.tcd_payeracname <> n.tcd_payeracname
        or o.tcd_payerbankname <> n.tcd_payerbankname
        or o.tcd_payerbankactype <> n.tcd_payerbankactype
        or o.tcd_payerbankid <> n.tcd_payerbankid
        or o.tcd_payercurrency <> n.tcd_payercurrency
        or o.tcd_payeeacno <> n.tcd_payeeacno
        or o.tcd_modelflag <> n.tcd_modelflag
        or o.tcd_amount <> n.tcd_amount
        or o.tcd_remark <> n.tcd_remark
        or o.tcd_fee <> n.tcd_fee
        or o.tcd_validatemsg <> n.tcd_validatemsg
        or o.tcd_notecode <> n.tcd_notecode
        or o.tcd_submittime <> n.tcd_submittime
        or o.tcd_singleamtlimit <> n.tcd_singleamtlimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_collectsdetail_cl(
            tcd_collectdelno -- 计划编号
            ,tcd_transcode -- 交易编码
            ,tcd_protocolidqry -- 跨行查询协议
            ,tcd_protocolidpay -- 跨行支付协议
            ,tcd_payeracno -- 转出账号
            ,tcd_payeracname -- 转出账户名称
            ,tcd_payerbankname -- 转出银行名称
            ,tcd_payerbankactype -- 转出账号账户类别
            ,tcd_payerbankid -- 转出账户开户行
            ,tcd_payercurrency -- 转出币种
            ,tcd_payeeacno -- 转入账号
            ,tcd_modelflag -- 归集模式
            ,tcd_amount -- 转出金额
            ,tcd_remark -- 附言
            ,tcd_fee -- 费用
            ,tcd_validatemsg -- 验证信息
            ,tcd_notecode -- 付款用途
            ,tcd_submittime -- 提交时间
            ,tcd_singleamtlimit -- 单笔限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_collectsdetail_op(
            tcd_collectdelno -- 计划编号
            ,tcd_transcode -- 交易编码
            ,tcd_protocolidqry -- 跨行查询协议
            ,tcd_protocolidpay -- 跨行支付协议
            ,tcd_payeracno -- 转出账号
            ,tcd_payeracname -- 转出账户名称
            ,tcd_payerbankname -- 转出银行名称
            ,tcd_payerbankactype -- 转出账号账户类别
            ,tcd_payerbankid -- 转出账户开户行
            ,tcd_payercurrency -- 转出币种
            ,tcd_payeeacno -- 转入账号
            ,tcd_modelflag -- 归集模式
            ,tcd_amount -- 转出金额
            ,tcd_remark -- 附言
            ,tcd_fee -- 费用
            ,tcd_validatemsg -- 验证信息
            ,tcd_notecode -- 付款用途
            ,tcd_submittime -- 提交时间
            ,tcd_singleamtlimit -- 单笔限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tcd_collectdelno -- 计划编号
    ,o.tcd_transcode -- 交易编码
    ,o.tcd_protocolidqry -- 跨行查询协议
    ,o.tcd_protocolidpay -- 跨行支付协议
    ,o.tcd_payeracno -- 转出账号
    ,o.tcd_payeracname -- 转出账户名称
    ,o.tcd_payerbankname -- 转出银行名称
    ,o.tcd_payerbankactype -- 转出账号账户类别
    ,o.tcd_payerbankid -- 转出账户开户行
    ,o.tcd_payercurrency -- 转出币种
    ,o.tcd_payeeacno -- 转入账号
    ,o.tcd_modelflag -- 归集模式
    ,o.tcd_amount -- 转出金额
    ,o.tcd_remark -- 附言
    ,o.tcd_fee -- 费用
    ,o.tcd_validatemsg -- 验证信息
    ,o.tcd_notecode -- 付款用途
    ,o.tcd_submittime -- 提交时间
    ,o.tcd_singleamtlimit -- 单笔限额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_collectsdetail_bk o
    left join ${iol_schema}.osbs_tps_collectsdetail_op n
        on
            o.tcd_collectdelno = n.tcd_collectdelno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_collectsdetail_cl d
        on
            o.tcd_collectdelno = d.tcd_collectdelno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_collectsdetail;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_collectsdetail exchange partition p_19000101 with table ${iol_schema}.osbs_tps_collectsdetail_cl;
alter table ${iol_schema}.osbs_tps_collectsdetail exchange partition p_20991231 with table ${iol_schema}.osbs_tps_collectsdetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_collectsdetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_collectsdetail_op purge;
drop table ${iol_schema}.osbs_tps_collectsdetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_collectsdetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_collectsdetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
