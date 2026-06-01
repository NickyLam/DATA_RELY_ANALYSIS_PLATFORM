/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_credit_online
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
create table ${iol_schema}.icms_credit_online_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_credit_online
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_credit_online_op purge;
drop table ${iol_schema}.icms_credit_online_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_online_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_credit_online where 0=1;

create table ${iol_schema}.icms_credit_online_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_credit_online where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_credit_online_cl(
            applyserialno -- 授信申请流水号
            ,gylsubtype -- 供应链子类型，码值GYLSubType
            ,migtflag -- 
            ,channel -- 渠道
            ,inputuser -- 登记人
            ,artificialno -- 文本合同编号
            ,businesssum -- 申请金额
            ,maturity -- 额度结束日期
            ,mfcustomerid -- 核心客户号
            ,israise -- 是否提额，码值IsRaise
            ,businesstype -- 业务品种
            ,modelresult -- 零售内评风控策略JSON结果
            ,status -- 状态
            ,inputorg -- 登记机构
            ,isnotice -- 是否回调通知（1是2否）
            ,isverify -- 是否核验通过，码值YesNo
            ,phaseno -- 审批阶段（0100失败1000成功）
            ,applyseqnum -- 授信申请接口流水号
            ,interfacecode -- 回调交易码
            ,contractserialno -- 合同流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,isbreakheadauth -- 是否突破总部权限，码值YesNo
            ,putoutdate -- 额度开始日期
            ,approveserialno -- 批复流水号
            ,inputtime -- 登记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_credit_online_op(
            applyserialno -- 授信申请流水号
            ,gylsubtype -- 供应链子类型，码值GYLSubType
            ,migtflag -- 
            ,channel -- 渠道
            ,inputuser -- 登记人
            ,artificialno -- 文本合同编号
            ,businesssum -- 申请金额
            ,maturity -- 额度结束日期
            ,mfcustomerid -- 核心客户号
            ,israise -- 是否提额，码值IsRaise
            ,businesstype -- 业务品种
            ,modelresult -- 零售内评风控策略JSON结果
            ,status -- 状态
            ,inputorg -- 登记机构
            ,isnotice -- 是否回调通知（1是2否）
            ,isverify -- 是否核验通过，码值YesNo
            ,phaseno -- 审批阶段（0100失败1000成功）
            ,applyseqnum -- 授信申请接口流水号
            ,interfacecode -- 回调交易码
            ,contractserialno -- 合同流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,isbreakheadauth -- 是否突破总部权限，码值YesNo
            ,putoutdate -- 额度开始日期
            ,approveserialno -- 批复流水号
            ,inputtime -- 登记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.applyserialno, o.applyserialno) as applyserialno -- 授信申请流水号
    ,nvl(n.gylsubtype, o.gylsubtype) as gylsubtype -- 供应链子类型，码值GYLSubType
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同编号
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 申请金额
    ,nvl(n.maturity, o.maturity) as maturity -- 额度结束日期
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.israise, o.israise) as israise -- 是否提额，码值IsRaise
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.modelresult, o.modelresult) as modelresult -- 零售内评风控策略JSON结果
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.isnotice, o.isnotice) as isnotice -- 是否回调通知（1是2否）
    ,nvl(n.isverify, o.isverify) as isverify -- 是否核验通过，码值YesNo
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 审批阶段（0100失败1000成功）
    ,nvl(n.applyseqnum, o.applyseqnum) as applyseqnum -- 授信申请接口流水号
    ,nvl(n.interfacecode, o.interfacecode) as interfacecode -- 回调交易码
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.isbreakheadauth, o.isbreakheadauth) as isbreakheadauth -- 是否突破总部权限，码值YesNo
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 额度开始日期
    ,nvl(n.approveserialno, o.approveserialno) as approveserialno -- 批复流水号
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,case when
            n.applyserialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.applyserialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.applyserialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_credit_online_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_credit_online where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.applyserialno = n.applyserialno
where (
        o.applyserialno is null
    )
    or (
        n.applyserialno is null
    )
    or (
        o.gylsubtype <> n.gylsubtype
        or o.migtflag <> n.migtflag
        or o.channel <> n.channel
        or o.inputuser <> n.inputuser
        or o.artificialno <> n.artificialno
        or o.businesssum <> n.businesssum
        or o.maturity <> n.maturity
        or o.mfcustomerid <> n.mfcustomerid
        or o.israise <> n.israise
        or o.businesstype <> n.businesstype
        or o.modelresult <> n.modelresult
        or o.status <> n.status
        or o.inputorg <> n.inputorg
        or o.isnotice <> n.isnotice
        or o.isverify <> n.isverify
        or o.phaseno <> n.phaseno
        or o.applyseqnum <> n.applyseqnum
        or o.interfacecode <> n.interfacecode
        or o.contractserialno <> n.contractserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.isbreakheadauth <> n.isbreakheadauth
        or o.putoutdate <> n.putoutdate
        or o.approveserialno <> n.approveserialno
        or o.inputtime <> n.inputtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_credit_online_cl(
            applyserialno -- 授信申请流水号
            ,gylsubtype -- 供应链子类型，码值GYLSubType
            ,migtflag -- 
            ,channel -- 渠道
            ,inputuser -- 登记人
            ,artificialno -- 文本合同编号
            ,businesssum -- 申请金额
            ,maturity -- 额度结束日期
            ,mfcustomerid -- 核心客户号
            ,israise -- 是否提额，码值IsRaise
            ,businesstype -- 业务品种
            ,modelresult -- 零售内评风控策略JSON结果
            ,status -- 状态
            ,inputorg -- 登记机构
            ,isnotice -- 是否回调通知（1是2否）
            ,isverify -- 是否核验通过，码值YesNo
            ,phaseno -- 审批阶段（0100失败1000成功）
            ,applyseqnum -- 授信申请接口流水号
            ,interfacecode -- 回调交易码
            ,contractserialno -- 合同流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,isbreakheadauth -- 是否突破总部权限，码值YesNo
            ,putoutdate -- 额度开始日期
            ,approveserialno -- 批复流水号
            ,inputtime -- 登记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_credit_online_op(
            applyserialno -- 授信申请流水号
            ,gylsubtype -- 供应链子类型，码值GYLSubType
            ,migtflag -- 
            ,channel -- 渠道
            ,inputuser -- 登记人
            ,artificialno -- 文本合同编号
            ,businesssum -- 申请金额
            ,maturity -- 额度结束日期
            ,mfcustomerid -- 核心客户号
            ,israise -- 是否提额，码值IsRaise
            ,businesstype -- 业务品种
            ,modelresult -- 零售内评风控策略JSON结果
            ,status -- 状态
            ,inputorg -- 登记机构
            ,isnotice -- 是否回调通知（1是2否）
            ,isverify -- 是否核验通过，码值YesNo
            ,phaseno -- 审批阶段（0100失败1000成功）
            ,applyseqnum -- 授信申请接口流水号
            ,interfacecode -- 回调交易码
            ,contractserialno -- 合同流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,isbreakheadauth -- 是否突破总部权限，码值YesNo
            ,putoutdate -- 额度开始日期
            ,approveserialno -- 批复流水号
            ,inputtime -- 登记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.applyserialno -- 授信申请流水号
    ,o.gylsubtype -- 供应链子类型，码值GYLSubType
    ,o.migtflag -- 
    ,o.channel -- 渠道
    ,o.inputuser -- 登记人
    ,o.artificialno -- 文本合同编号
    ,o.businesssum -- 申请金额
    ,o.maturity -- 额度结束日期
    ,o.mfcustomerid -- 核心客户号
    ,o.israise -- 是否提额，码值IsRaise
    ,o.businesstype -- 业务品种
    ,o.modelresult -- 零售内评风控策略JSON结果
    ,o.status -- 状态
    ,o.inputorg -- 登记机构
    ,o.isnotice -- 是否回调通知（1是2否）
    ,o.isverify -- 是否核验通过，码值YesNo
    ,o.phaseno -- 审批阶段（0100失败1000成功）
    ,o.applyseqnum -- 授信申请接口流水号
    ,o.interfacecode -- 回调交易码
    ,o.contractserialno -- 合同流水号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.isbreakheadauth -- 是否突破总部权限，码值YesNo
    ,o.putoutdate -- 额度开始日期
    ,o.approveserialno -- 批复流水号
    ,o.inputtime -- 登记时间
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
from ${iol_schema}.icms_credit_online_bk o
    left join ${iol_schema}.icms_credit_online_op n
        on
            o.applyserialno = n.applyserialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_credit_online_cl d
        on
            o.applyserialno = d.applyserialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_credit_online;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_credit_online') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_credit_online drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_credit_online add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_credit_online exchange partition p_${batch_date} with table ${iol_schema}.icms_credit_online_cl;
alter table ${iol_schema}.icms_credit_online exchange partition p_20991231 with table ${iol_schema}.icms_credit_online_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_credit_online to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_credit_online_op purge;
drop table ${iol_schema}.icms_credit_online_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_credit_online_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_credit_online',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
