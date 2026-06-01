/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_zs_extent_up_info
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
create table ${iol_schema}.icms_mybk_zs_extent_up_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_zs_extent_up_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info_op purge;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_zs_extent_up_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_zs_extent_up_info where 0=1;

create table ${iol_schema}.icms_mybk_zs_extent_up_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_zs_extent_up_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_zs_extent_up_info_cl(
            serialno -- 流水号
            ,bankcardnumber -- 银行卡号
            ,devstabilitygrade -- 最近六个月设备稳定等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,profession -- 职业信息
            ,totpayamt6mgrade -- 最近六个月支付金额等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 手机号稳定等级
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,riskscore -- 风险分数
            ,riskseg -- 风险分层
            ,consumegrade -- 消费档次
            ,depositbankname -- 开户行名称
            ,adrstabilitygrade -- 地址稳定等级
            ,havecarprobgrade -- 有车概率等级
            ,firstloanlengthgrade -- 信贷时长等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,repayamt6mgrade -- 最近六个月还款金额等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_zs_extent_up_info_op(
            serialno -- 流水号
            ,bankcardnumber -- 银行卡号
            ,devstabilitygrade -- 最近六个月设备稳定等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,profession -- 职业信息
            ,totpayamt6mgrade -- 最近六个月支付金额等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 手机号稳定等级
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,riskscore -- 风险分数
            ,riskseg -- 风险分层
            ,consumegrade -- 消费档次
            ,depositbankname -- 开户行名称
            ,adrstabilitygrade -- 地址稳定等级
            ,havecarprobgrade -- 有车概率等级
            ,firstloanlengthgrade -- 信贷时长等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,repayamt6mgrade -- 最近六个月还款金额等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.bankcardnumber, o.bankcardnumber) as bankcardnumber -- 银行卡号
    ,nvl(n.devstabilitygrade, o.devstabilitygrade) as devstabilitygrade -- 最近六个月设备稳定等级
    ,nvl(n.ovdorderamt6mgrade, o.ovdorderamt6mgrade) as ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,nvl(n.profession, o.profession) as profession -- 职业信息
    ,nvl(n.totpayamt6mgrade, o.totpayamt6mgrade) as totpayamt6mgrade -- 最近六个月支付金额等级
    ,nvl(n.ovdordercnt6mgrade, o.ovdordercnt6mgrade) as ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.repaymentseg, o.repaymentseg) as repaymentseg -- 偿债能力
    ,nvl(n.mobilefixedgrade, o.mobilefixedgrade) as mobilefixedgrade -- 手机号稳定等级
    ,nvl(n.last6mavgassettotalgrade, o.last6mavgassettotalgrade) as last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,nvl(n.positivebizcnt1ygrade, o.positivebizcnt1ygrade) as positivebizcnt1ygrade -- 最近一年履约等级
    ,nvl(n.riskscore, o.riskscore) as riskscore -- 风险分数
    ,nvl(n.riskseg, o.riskseg) as riskseg -- 风险分层
    ,nvl(n.consumegrade, o.consumegrade) as consumegrade -- 消费档次
    ,nvl(n.depositbankname, o.depositbankname) as depositbankname -- 开户行名称
    ,nvl(n.adrstabilitygrade, o.adrstabilitygrade) as adrstabilitygrade -- 地址稳定等级
    ,nvl(n.havecarprobgrade, o.havecarprobgrade) as havecarprobgrade -- 有车概率等级
    ,nvl(n.firstloanlengthgrade, o.firstloanlengthgrade) as firstloanlengthgrade -- 信贷时长等级
    ,nvl(n.havefangprobgrade, o.havefangprobgrade) as havefangprobgrade -- 有房概率等级
    ,nvl(n.ovdorderdays6mgrade, o.ovdorderdays6mgrade) as ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,nvl(n.repayamt6mgrade, o.repayamt6mgrade) as repayamt6mgrade -- 最近六个月还款金额等级
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
from (select * from ${iol_schema}.icms_mybk_zs_extent_up_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybk_zs_extent_up_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.bankcardnumber <> n.bankcardnumber
        or o.devstabilitygrade <> n.devstabilitygrade
        or o.ovdorderamt6mgrade <> n.ovdorderamt6mgrade
        or o.profession <> n.profession
        or o.totpayamt6mgrade <> n.totpayamt6mgrade
        or o.ovdordercnt6mgrade <> n.ovdordercnt6mgrade
        or o.migtflag <> n.migtflag
        or o.repaymentseg <> n.repaymentseg
        or o.mobilefixedgrade <> n.mobilefixedgrade
        or o.last6mavgassettotalgrade <> n.last6mavgassettotalgrade
        or o.positivebizcnt1ygrade <> n.positivebizcnt1ygrade
        or o.riskscore <> n.riskscore
        or o.riskseg <> n.riskseg
        or o.consumegrade <> n.consumegrade
        or o.depositbankname <> n.depositbankname
        or o.adrstabilitygrade <> n.adrstabilitygrade
        or o.havecarprobgrade <> n.havecarprobgrade
        or o.firstloanlengthgrade <> n.firstloanlengthgrade
        or o.havefangprobgrade <> n.havefangprobgrade
        or o.ovdorderdays6mgrade <> n.ovdorderdays6mgrade
        or o.repayamt6mgrade <> n.repayamt6mgrade
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_zs_extent_up_info_cl(
            serialno -- 流水号
            ,bankcardnumber -- 银行卡号
            ,devstabilitygrade -- 最近六个月设备稳定等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,profession -- 职业信息
            ,totpayamt6mgrade -- 最近六个月支付金额等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 手机号稳定等级
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,riskscore -- 风险分数
            ,riskseg -- 风险分层
            ,consumegrade -- 消费档次
            ,depositbankname -- 开户行名称
            ,adrstabilitygrade -- 地址稳定等级
            ,havecarprobgrade -- 有车概率等级
            ,firstloanlengthgrade -- 信贷时长等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,repayamt6mgrade -- 最近六个月还款金额等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_zs_extent_up_info_op(
            serialno -- 流水号
            ,bankcardnumber -- 银行卡号
            ,devstabilitygrade -- 最近六个月设备稳定等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,profession -- 职业信息
            ,totpayamt6mgrade -- 最近六个月支付金额等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 手机号稳定等级
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,riskscore -- 风险分数
            ,riskseg -- 风险分层
            ,consumegrade -- 消费档次
            ,depositbankname -- 开户行名称
            ,adrstabilitygrade -- 地址稳定等级
            ,havecarprobgrade -- 有车概率等级
            ,firstloanlengthgrade -- 信贷时长等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,repayamt6mgrade -- 最近六个月还款金额等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.bankcardnumber -- 银行卡号
    ,o.devstabilitygrade -- 最近六个月设备稳定等级
    ,o.ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,o.profession -- 职业信息
    ,o.totpayamt6mgrade -- 最近六个月支付金额等级
    ,o.ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.repaymentseg -- 偿债能力
    ,o.mobilefixedgrade -- 手机号稳定等级
    ,o.last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,o.positivebizcnt1ygrade -- 最近一年履约等级
    ,o.riskscore -- 风险分数
    ,o.riskseg -- 风险分层
    ,o.consumegrade -- 消费档次
    ,o.depositbankname -- 开户行名称
    ,o.adrstabilitygrade -- 地址稳定等级
    ,o.havecarprobgrade -- 有车概率等级
    ,o.firstloanlengthgrade -- 信贷时长等级
    ,o.havefangprobgrade -- 有房概率等级
    ,o.ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,o.repayamt6mgrade -- 最近六个月还款金额等级
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
from ${iol_schema}.icms_mybk_zs_extent_up_info_bk o
    left join ${iol_schema}.icms_mybk_zs_extent_up_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybk_zs_extent_up_info_cl d
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
--truncate table ${iol_schema}.icms_mybk_zs_extent_up_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_zs_extent_up_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_zs_extent_up_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_zs_extent_up_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_zs_extent_up_info exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_zs_extent_up_info_cl;
alter table ${iol_schema}.icms_mybk_zs_extent_up_info exchange partition p_20991231 with table ${iol_schema}.icms_mybk_zs_extent_up_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_zs_extent_up_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info_op purge;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_zs_extent_up_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
