/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_zs_extent_info
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
create table ${iol_schema}.icms_mybk_zs_extent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_zs_extent_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_zs_extent_info_op purge;
drop table ${iol_schema}.icms_mybk_zs_extent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_zs_extent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_zs_extent_info where 0=1;

create table ${iol_schema}.icms_mybk_zs_extent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_zs_extent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_zs_extent_info_cl(
            serialno -- 流水号
            ,adrstabilitydays -- 地址稳定天数
            ,last6mavgassettotal -- 最近六个月流动资产均值
            ,iszmfraudflag -- 是否芝麻欺诈关注清单
            ,xfdcindex -- 消费档次
            ,zmscore -- 芝麻评分
            ,migtflag -- 
            ,repaymentseg -- 偿债能力
            ,authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
            ,ovdordercnt6m -- 最近六个月逾期总笔数
            ,authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
            ,totpayamt6m -- 最近六个支付总金额
            ,positivebizcnt1y -- 最近一年履约场景数
            ,mobilefixeddays -- 手机号稳定天数
            ,alilast6mtradetotal -- 付宝交易笔数
            ,havecarflag -- 是否有车
            ,profession -- 职业信息
            ,iszmattentionflag -- 是否芝麻行业关注名单
            ,authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
            ,ovdorderamt6m -- 最近六个月逾期总金额
            ,bankcardnumber -- 银行卡号
            ,havefangflag -- 是否有房
            ,depositbankname -- 开户行名称
            ,riskseg -- 风险分层
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_zs_extent_info_op(
            serialno -- 流水号
            ,adrstabilitydays -- 地址稳定天数
            ,last6mavgassettotal -- 最近六个月流动资产均值
            ,iszmfraudflag -- 是否芝麻欺诈关注清单
            ,xfdcindex -- 消费档次
            ,zmscore -- 芝麻评分
            ,migtflag -- 
            ,repaymentseg -- 偿债能力
            ,authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
            ,ovdordercnt6m -- 最近六个月逾期总笔数
            ,authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
            ,totpayamt6m -- 最近六个支付总金额
            ,positivebizcnt1y -- 最近一年履约场景数
            ,mobilefixeddays -- 手机号稳定天数
            ,alilast6mtradetotal -- 付宝交易笔数
            ,havecarflag -- 是否有车
            ,profession -- 职业信息
            ,iszmattentionflag -- 是否芝麻行业关注名单
            ,authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
            ,ovdorderamt6m -- 最近六个月逾期总金额
            ,bankcardnumber -- 银行卡号
            ,havefangflag -- 是否有房
            ,depositbankname -- 开户行名称
            ,riskseg -- 风险分层
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.adrstabilitydays, o.adrstabilitydays) as adrstabilitydays -- 地址稳定天数
    ,nvl(n.last6mavgassettotal, o.last6mavgassettotal) as last6mavgassettotal -- 最近六个月流动资产均值
    ,nvl(n.iszmfraudflag, o.iszmfraudflag) as iszmfraudflag -- 是否芝麻欺诈关注清单
    ,nvl(n.xfdcindex, o.xfdcindex) as xfdcindex -- 消费档次
    ,nvl(n.zmscore, o.zmscore) as zmscore -- 芝麻评分
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.repaymentseg, o.repaymentseg) as repaymentseg -- 偿债能力
    ,nvl(n.authfinlast6mcnt, o.authfinlast6mcnt) as authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
    ,nvl(n.ovdordercnt6m, o.ovdordercnt6m) as ovdordercnt6m -- 最近六个月逾期总笔数
    ,nvl(n.authfinlast1mcnt, o.authfinlast1mcnt) as authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
    ,nvl(n.totpayamt6m, o.totpayamt6m) as totpayamt6m -- 最近六个支付总金额
    ,nvl(n.positivebizcnt1y, o.positivebizcnt1y) as positivebizcnt1y -- 最近一年履约场景数
    ,nvl(n.mobilefixeddays, o.mobilefixeddays) as mobilefixeddays -- 手机号稳定天数
    ,nvl(n.alilast6mtradetotal, o.alilast6mtradetotal) as alilast6mtradetotal -- 付宝交易笔数
    ,nvl(n.havecarflag, o.havecarflag) as havecarflag -- 是否有车
    ,nvl(n.profession, o.profession) as profession -- 职业信息
    ,nvl(n.iszmattentionflag, o.iszmattentionflag) as iszmattentionflag -- 是否芝麻行业关注名单
    ,nvl(n.authfinlast3mcnt, o.authfinlast3mcnt) as authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
    ,nvl(n.ovdorderamt6m, o.ovdorderamt6m) as ovdorderamt6m -- 最近六个月逾期总金额
    ,nvl(n.bankcardnumber, o.bankcardnumber) as bankcardnumber -- 银行卡号
    ,nvl(n.havefangflag, o.havefangflag) as havefangflag -- 是否有房
    ,nvl(n.depositbankname, o.depositbankname) as depositbankname -- 开户行名称
    ,nvl(n.riskseg, o.riskseg) as riskseg -- 风险分层
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
from (select * from ${iol_schema}.icms_mybk_zs_extent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybk_zs_extent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.adrstabilitydays <> n.adrstabilitydays
        or o.last6mavgassettotal <> n.last6mavgassettotal
        or o.iszmfraudflag <> n.iszmfraudflag
        or o.xfdcindex <> n.xfdcindex
        or o.zmscore <> n.zmscore
        or o.migtflag <> n.migtflag
        or o.repaymentseg <> n.repaymentseg
        or o.authfinlast6mcnt <> n.authfinlast6mcnt
        or o.ovdordercnt6m <> n.ovdordercnt6m
        or o.authfinlast1mcnt <> n.authfinlast1mcnt
        or o.totpayamt6m <> n.totpayamt6m
        or o.positivebizcnt1y <> n.positivebizcnt1y
        or o.mobilefixeddays <> n.mobilefixeddays
        or o.alilast6mtradetotal <> n.alilast6mtradetotal
        or o.havecarflag <> n.havecarflag
        or o.profession <> n.profession
        or o.iszmattentionflag <> n.iszmattentionflag
        or o.authfinlast3mcnt <> n.authfinlast3mcnt
        or o.ovdorderamt6m <> n.ovdorderamt6m
        or o.bankcardnumber <> n.bankcardnumber
        or o.havefangflag <> n.havefangflag
        or o.depositbankname <> n.depositbankname
        or o.riskseg <> n.riskseg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_zs_extent_info_cl(
            serialno -- 流水号
            ,adrstabilitydays -- 地址稳定天数
            ,last6mavgassettotal -- 最近六个月流动资产均值
            ,iszmfraudflag -- 是否芝麻欺诈关注清单
            ,xfdcindex -- 消费档次
            ,zmscore -- 芝麻评分
            ,migtflag -- 
            ,repaymentseg -- 偿债能力
            ,authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
            ,ovdordercnt6m -- 最近六个月逾期总笔数
            ,authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
            ,totpayamt6m -- 最近六个支付总金额
            ,positivebizcnt1y -- 最近一年履约场景数
            ,mobilefixeddays -- 手机号稳定天数
            ,alilast6mtradetotal -- 付宝交易笔数
            ,havecarflag -- 是否有车
            ,profession -- 职业信息
            ,iszmattentionflag -- 是否芝麻行业关注名单
            ,authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
            ,ovdorderamt6m -- 最近六个月逾期总金额
            ,bankcardnumber -- 银行卡号
            ,havefangflag -- 是否有房
            ,depositbankname -- 开户行名称
            ,riskseg -- 风险分层
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_zs_extent_info_op(
            serialno -- 流水号
            ,adrstabilitydays -- 地址稳定天数
            ,last6mavgassettotal -- 最近六个月流动资产均值
            ,iszmfraudflag -- 是否芝麻欺诈关注清单
            ,xfdcindex -- 消费档次
            ,zmscore -- 芝麻评分
            ,migtflag -- 
            ,repaymentseg -- 偿债能力
            ,authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
            ,ovdordercnt6m -- 最近六个月逾期总笔数
            ,authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
            ,totpayamt6m -- 最近六个支付总金额
            ,positivebizcnt1y -- 最近一年履约场景数
            ,mobilefixeddays -- 手机号稳定天数
            ,alilast6mtradetotal -- 付宝交易笔数
            ,havecarflag -- 是否有车
            ,profession -- 职业信息
            ,iszmattentionflag -- 是否芝麻行业关注名单
            ,authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
            ,ovdorderamt6m -- 最近六个月逾期总金额
            ,bankcardnumber -- 银行卡号
            ,havefangflag -- 是否有房
            ,depositbankname -- 开户行名称
            ,riskseg -- 风险分层
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.adrstabilitydays -- 地址稳定天数
    ,o.last6mavgassettotal -- 最近六个月流动资产均值
    ,o.iszmfraudflag -- 是否芝麻欺诈关注清单
    ,o.xfdcindex -- 消费档次
    ,o.zmscore -- 芝麻评分
    ,o.migtflag -- 
    ,o.repaymentseg -- 偿债能力
    ,o.authfinlast6mcnt -- 最近六个主动查询(芝麻信用)金融机构数
    ,o.ovdordercnt6m -- 最近六个月逾期总笔数
    ,o.authfinlast1mcnt -- 最近一个月主动查询(芝麻信用)金融机构数
    ,o.totpayamt6m -- 最近六个支付总金额
    ,o.positivebizcnt1y -- 最近一年履约场景数
    ,o.mobilefixeddays -- 手机号稳定天数
    ,o.alilast6mtradetotal -- 付宝交易笔数
    ,o.havecarflag -- 是否有车
    ,o.profession -- 职业信息
    ,o.iszmattentionflag -- 是否芝麻行业关注名单
    ,o.authfinlast3mcnt -- 最近三个主动查询(芝麻信用)金融机构数
    ,o.ovdorderamt6m -- 最近六个月逾期总金额
    ,o.bankcardnumber -- 银行卡号
    ,o.havefangflag -- 是否有房
    ,o.depositbankname -- 开户行名称
    ,o.riskseg -- 风险分层
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
from ${iol_schema}.icms_mybk_zs_extent_info_bk o
    left join ${iol_schema}.icms_mybk_zs_extent_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybk_zs_extent_info_cl d
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
--truncate table ${iol_schema}.icms_mybk_zs_extent_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_zs_extent_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_zs_extent_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_zs_extent_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_zs_extent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_zs_extent_info_cl;
alter table ${iol_schema}.icms_mybk_zs_extent_info exchange partition p_20991231 with table ${iol_schema}.icms_mybk_zs_extent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_zs_extent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_zs_extent_info_op purge;
drop table ${iol_schema}.icms_mybk_zs_extent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_zs_extent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_zs_extent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
