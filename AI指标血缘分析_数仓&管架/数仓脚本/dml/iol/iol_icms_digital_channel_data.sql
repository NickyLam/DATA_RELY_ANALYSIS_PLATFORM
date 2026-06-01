/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_digital_channel_data
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
create table ${iol_schema}.icms_digital_channel_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_digital_channel_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_digital_channel_data_op purge;
drop table ${iol_schema}.icms_digital_channel_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_digital_channel_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_digital_channel_data where 0=1;

create table ${iol_schema}.icms_digital_channel_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_digital_channel_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_digital_channel_data_cl(
            serialno -- 流水号
            ,contractno -- 额度合同流水号
            ,phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
            ,putoutno -- 出账流水号
            ,inputdate -- 登记时间
            ,orderno -- 订单号
            ,ywblipstatus -- 业务影像状态
            ,blipinfo -- 影像路径
            ,updatedate -- 更新时间
            ,customername -- 客户姓名
            ,respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
            ,ordersumamt -- 订单金额
            ,applysum -- 额度初审金额
            ,remark -- 备注
            ,edblipinfo -- 额度影像路径
            ,customerid -- 客户号
            ,applyserialno -- 授信申请流水号
            ,ywblipinfo -- 业务影像路径
            ,mfcustomerid -- 核心客户号
            ,duebillno -- 借据流水号
            ,channel -- 渠道
            ,billamt -- 服务费
            ,applystatus -- 额度初审结果(成功失败）
            ,approvesum -- 额度终审金额
            ,updateorgid -- 更新机构
            ,contractno1 -- 业务合同流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
            ,edblipstatus -- 额度影像状态
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approvestatus -- 额度终审结果(成功失败）
            ,inputorgid -- 登记机构
            ,otherinfo -- 线上渠道业务数据
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_digital_channel_data_op(
            serialno -- 流水号
            ,contractno -- 额度合同流水号
            ,phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
            ,putoutno -- 出账流水号
            ,inputdate -- 登记时间
            ,orderno -- 订单号
            ,ywblipstatus -- 业务影像状态
            ,blipinfo -- 影像路径
            ,updatedate -- 更新时间
            ,customername -- 客户姓名
            ,respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
            ,ordersumamt -- 订单金额
            ,applysum -- 额度初审金额
            ,remark -- 备注
            ,edblipinfo -- 额度影像路径
            ,customerid -- 客户号
            ,applyserialno -- 授信申请流水号
            ,ywblipinfo -- 业务影像路径
            ,mfcustomerid -- 核心客户号
            ,duebillno -- 借据流水号
            ,channel -- 渠道
            ,billamt -- 服务费
            ,applystatus -- 额度初审结果(成功失败）
            ,approvesum -- 额度终审金额
            ,updateorgid -- 更新机构
            ,contractno1 -- 业务合同流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
            ,edblipstatus -- 额度影像状态
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approvestatus -- 额度终审结果(成功失败）
            ,inputorgid -- 登记机构
            ,otherinfo -- 线上渠道业务数据
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.contractno, o.contractno) as contractno -- 额度合同流水号
    ,nvl(n.phasetype, o.phasetype) as phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账流水号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.orderno, o.orderno) as orderno -- 订单号
    ,nvl(n.ywblipstatus, o.ywblipstatus) as ywblipstatus -- 业务影像状态
    ,nvl(n.blipinfo, o.blipinfo) as blipinfo -- 影像路径
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.customername, o.customername) as customername -- 客户姓名
    ,nvl(n.respstatus, o.respstatus) as respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
    ,nvl(n.ordersumamt, o.ordersumamt) as ordersumamt -- 订单金额
    ,nvl(n.applysum, o.applysum) as applysum -- 额度初审金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.edblipinfo, o.edblipinfo) as edblipinfo -- 额度影像路径
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.applyserialno, o.applyserialno) as applyserialno -- 授信申请流水号
    ,nvl(n.ywblipinfo, o.ywblipinfo) as ywblipinfo -- 业务影像路径
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据流水号
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.billamt, o.billamt) as billamt -- 服务费
    ,nvl(n.applystatus, o.applystatus) as applystatus -- 额度初审结果(成功失败）
    ,nvl(n.approvesum, o.approvesum) as approvesum -- 额度终审金额
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.contractno1, o.contractno1) as contractno1 -- 业务合同流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.respinfo, o.respinfo) as respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
    ,nvl(n.edblipstatus, o.edblipstatus) as edblipstatus -- 额度影像状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 额度终审结果(成功失败）
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.otherinfo, o.otherinfo) as otherinfo -- 线上渠道业务数据
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
from (select * from ${iol_schema}.icms_digital_channel_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_digital_channel_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.contractno <> n.contractno
        or o.phasetype <> n.phasetype
        or o.putoutno <> n.putoutno
        or o.inputdate <> n.inputdate
        or o.orderno <> n.orderno
        or o.ywblipstatus <> n.ywblipstatus
        or o.blipinfo <> n.blipinfo
        or o.updatedate <> n.updatedate
        or o.customername <> n.customername
        or o.respstatus <> n.respstatus
        or o.ordersumamt <> n.ordersumamt
        or o.applysum <> n.applysum
        or o.remark <> n.remark
        or o.edblipinfo <> n.edblipinfo
        or o.customerid <> n.customerid
        or o.applyserialno <> n.applyserialno
        or o.ywblipinfo <> n.ywblipinfo
        or o.mfcustomerid <> n.mfcustomerid
        or o.duebillno <> n.duebillno
        or o.channel <> n.channel
        or o.billamt <> n.billamt
        or o.applystatus <> n.applystatus
        or o.approvesum <> n.approvesum
        or o.updateorgid <> n.updateorgid
        or o.contractno1 <> n.contractno1
        or o.migtflag <> n.migtflag
        or o.respinfo <> n.respinfo
        or o.edblipstatus <> n.edblipstatus
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.approvestatus <> n.approvestatus
        or o.inputorgid <> n.inputorgid
        or o.otherinfo <> n.otherinfo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_digital_channel_data_cl(
            serialno -- 流水号
            ,contractno -- 额度合同流水号
            ,phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
            ,putoutno -- 出账流水号
            ,inputdate -- 登记时间
            ,orderno -- 订单号
            ,ywblipstatus -- 业务影像状态
            ,blipinfo -- 影像路径
            ,updatedate -- 更新时间
            ,customername -- 客户姓名
            ,respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
            ,ordersumamt -- 订单金额
            ,applysum -- 额度初审金额
            ,remark -- 备注
            ,edblipinfo -- 额度影像路径
            ,customerid -- 客户号
            ,applyserialno -- 授信申请流水号
            ,ywblipinfo -- 业务影像路径
            ,mfcustomerid -- 核心客户号
            ,duebillno -- 借据流水号
            ,channel -- 渠道
            ,billamt -- 服务费
            ,applystatus -- 额度初审结果(成功失败）
            ,approvesum -- 额度终审金额
            ,updateorgid -- 更新机构
            ,contractno1 -- 业务合同流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
            ,edblipstatus -- 额度影像状态
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approvestatus -- 额度终审结果(成功失败）
            ,inputorgid -- 登记机构
            ,otherinfo -- 线上渠道业务数据
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_digital_channel_data_op(
            serialno -- 流水号
            ,contractno -- 额度合同流水号
            ,phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
            ,putoutno -- 出账流水号
            ,inputdate -- 登记时间
            ,orderno -- 订单号
            ,ywblipstatus -- 业务影像状态
            ,blipinfo -- 影像路径
            ,updatedate -- 更新时间
            ,customername -- 客户姓名
            ,respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
            ,ordersumamt -- 订单金额
            ,applysum -- 额度初审金额
            ,remark -- 备注
            ,edblipinfo -- 额度影像路径
            ,customerid -- 客户号
            ,applyserialno -- 授信申请流水号
            ,ywblipinfo -- 业务影像路径
            ,mfcustomerid -- 核心客户号
            ,duebillno -- 借据流水号
            ,channel -- 渠道
            ,billamt -- 服务费
            ,applystatus -- 额度初审结果(成功失败）
            ,approvesum -- 额度终审金额
            ,updateorgid -- 更新机构
            ,contractno1 -- 业务合同流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
            ,edblipstatus -- 额度影像状态
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,approvestatus -- 额度终审结果(成功失败）
            ,inputorgid -- 登记机构
            ,otherinfo -- 线上渠道业务数据
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.contractno -- 额度合同流水号
    ,o.phasetype -- 额度业务阶段(0.额度终审失败1.额度终审成功2.已生成额度合同，3.额度合同已出账4.额度合同已签行章5.额度合同已签客户章)
    ,o.putoutno -- 出账流水号
    ,o.inputdate -- 登记时间
    ,o.orderno -- 订单号
    ,o.ywblipstatus -- 业务影像状态
    ,o.blipinfo -- 影像路径
    ,o.updatedate -- 更新时间
    ,o.customername -- 客户姓名
    ,o.respstatus -- 额度审批结果（S：申请已受理E:申请未受理)
    ,o.ordersumamt -- 订单金额
    ,o.applysum -- 额度初审金额
    ,o.remark -- 备注
    ,o.edblipinfo -- 额度影像路径
    ,o.customerid -- 客户号
    ,o.applyserialno -- 授信申请流水号
    ,o.ywblipinfo -- 业务影像路径
    ,o.mfcustomerid -- 核心客户号
    ,o.duebillno -- 借据流水号
    ,o.channel -- 渠道
    ,o.billamt -- 服务费
    ,o.applystatus -- 额度初审结果(成功失败）
    ,o.approvesum -- 额度终审金额
    ,o.updateorgid -- 更新机构
    ,o.contractno1 -- 业务合同流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.respinfo -- 额度审批失败原因（成功：申请已受理失败：具体未受理的原因）
    ,o.edblipstatus -- 额度影像状态
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 更新人
    ,o.approvestatus -- 额度终审结果(成功失败）
    ,o.inputorgid -- 登记机构
    ,o.otherinfo -- 线上渠道业务数据
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
from ${iol_schema}.icms_digital_channel_data_bk o
    left join ${iol_schema}.icms_digital_channel_data_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_digital_channel_data_cl d
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
--truncate table ${iol_schema}.icms_digital_channel_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_digital_channel_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_digital_channel_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_digital_channel_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_digital_channel_data exchange partition p_${batch_date} with table ${iol_schema}.icms_digital_channel_data_cl;
alter table ${iol_schema}.icms_digital_channel_data exchange partition p_20991231 with table ${iol_schema}.icms_digital_channel_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_digital_channel_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_digital_channel_data_op purge;
drop table ${iol_schema}.icms_digital_channel_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_digital_channel_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_digital_channel_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
