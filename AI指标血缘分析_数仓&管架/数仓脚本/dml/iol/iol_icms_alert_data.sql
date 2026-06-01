/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_alert_data
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
create table ${iol_schema}.icms_alert_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_alert_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alert_data_op purge;
drop table ${iol_schema}.icms_alert_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alert_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alert_data where 0=1;

create table ${iol_schema}.icms_alert_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alert_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alert_data_cl(
            customerid -- 客户号
            ,objecttype -- 对象类型
            ,objectno -- 对象号
            ,signid -- 警示号
            ,signdescribe -- 警示描述
            ,confirmstatus -- 确认状态
            ,confirmconment -- 预警信号认定说明
            ,relieverexplain -- 解除说明
            ,remark -- 备注
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,isreliever -- 是否解除
            ,updateorgid -- 更新机构
            ,status -- 状态
            ,endstatus -- 结束状态
            ,serialno -- 流水号
            ,inputuserid -- 录入人
            ,updateuserid -- 更新用户
            ,alerttype -- 警示类型
            ,contrtolmeasure -- 风险控制措施
            ,itemvalue -- 对象值
            ,signlevel -- 警示层级
            ,urgentalarm -- 紧急预警
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alert_data_op(
            customerid -- 客户号
            ,objecttype -- 对象类型
            ,objectno -- 对象号
            ,signid -- 警示号
            ,signdescribe -- 警示描述
            ,confirmstatus -- 确认状态
            ,confirmconment -- 预警信号认定说明
            ,relieverexplain -- 解除说明
            ,remark -- 备注
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,isreliever -- 是否解除
            ,updateorgid -- 更新机构
            ,status -- 状态
            ,endstatus -- 结束状态
            ,serialno -- 流水号
            ,inputuserid -- 录入人
            ,updateuserid -- 更新用户
            ,alerttype -- 警示类型
            ,contrtolmeasure -- 风险控制措施
            ,itemvalue -- 对象值
            ,signlevel -- 警示层级
            ,urgentalarm -- 紧急预警
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象号
    ,nvl(n.signid, o.signid) as signid -- 警示号
    ,nvl(n.signdescribe, o.signdescribe) as signdescribe -- 警示描述
    ,nvl(n.confirmstatus, o.confirmstatus) as confirmstatus -- 确认状态
    ,nvl(n.confirmconment, o.confirmconment) as confirmconment -- 预警信号认定说明
    ,nvl(n.relieverexplain, o.relieverexplain) as relieverexplain -- 解除说明
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.isreliever, o.isreliever) as isreliever -- 是否解除
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.endstatus, o.endstatus) as endstatus -- 结束状态
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新用户
    ,nvl(n.alerttype, o.alerttype) as alerttype -- 警示类型
    ,nvl(n.contrtolmeasure, o.contrtolmeasure) as contrtolmeasure -- 风险控制措施
    ,nvl(n.itemvalue, o.itemvalue) as itemvalue -- 对象值
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 警示层级
    ,nvl(n.urgentalarm, o.urgentalarm) as urgentalarm -- 紧急预警
    ,case when
            n.customerid is null
            and n.objecttype is null
            and n.objectno is null
            and n.signid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
            and n.objecttype is null
            and n.objectno is null
            and n.signid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
            and n.objecttype is null
            and n.objectno is null
            and n.signid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_alert_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_alert_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.signid = n.signid
where (
        o.customerid is null
        and o.objecttype is null
        and o.objectno is null
        and o.signid is null
    )
    or (
        n.customerid is null
        and n.objecttype is null
        and n.objectno is null
        and n.signid is null
    )
    or (
        o.signdescribe <> n.signdescribe
        or o.confirmstatus <> n.confirmstatus
        or o.confirmconment <> n.confirmconment
        or o.relieverexplain <> n.relieverexplain
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.migtflag <> n.migtflag
        or o.updatedate <> n.updatedate
        or o.isreliever <> n.isreliever
        or o.updateorgid <> n.updateorgid
        or o.status <> n.status
        or o.endstatus <> n.endstatus
        or o.serialno <> n.serialno
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.alerttype <> n.alerttype
        or o.contrtolmeasure <> n.contrtolmeasure
        or o.itemvalue <> n.itemvalue
        or o.signlevel <> n.signlevel
        or o.urgentalarm <> n.urgentalarm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alert_data_cl(
            customerid -- 客户号
            ,objecttype -- 对象类型
            ,objectno -- 对象号
            ,signid -- 警示号
            ,signdescribe -- 警示描述
            ,confirmstatus -- 确认状态
            ,confirmconment -- 预警信号认定说明
            ,relieverexplain -- 解除说明
            ,remark -- 备注
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,isreliever -- 是否解除
            ,updateorgid -- 更新机构
            ,status -- 状态
            ,endstatus -- 结束状态
            ,serialno -- 流水号
            ,inputuserid -- 录入人
            ,updateuserid -- 更新用户
            ,alerttype -- 警示类型
            ,contrtolmeasure -- 风险控制措施
            ,itemvalue -- 对象值
            ,signlevel -- 警示层级
            ,urgentalarm -- 紧急预警
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alert_data_op(
            customerid -- 客户号
            ,objecttype -- 对象类型
            ,objectno -- 对象号
            ,signid -- 警示号
            ,signdescribe -- 警示描述
            ,confirmstatus -- 确认状态
            ,confirmconment -- 预警信号认定说明
            ,relieverexplain -- 解除说明
            ,remark -- 备注
            ,inputorgid -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,isreliever -- 是否解除
            ,updateorgid -- 更新机构
            ,status -- 状态
            ,endstatus -- 结束状态
            ,serialno -- 流水号
            ,inputuserid -- 录入人
            ,updateuserid -- 更新用户
            ,alerttype -- 警示类型
            ,contrtolmeasure -- 风险控制措施
            ,itemvalue -- 对象值
            ,signlevel -- 警示层级
            ,urgentalarm -- 紧急预警
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象号
    ,o.signid -- 警示号
    ,o.signdescribe -- 警示描述
    ,o.confirmstatus -- 确认状态
    ,o.confirmconment -- 预警信号认定说明
    ,o.relieverexplain -- 解除说明
    ,o.remark -- 备注
    ,o.inputorgid -- 录入机构
    ,o.inputdate -- 录入日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.updatedate -- 更新日期
    ,o.isreliever -- 是否解除
    ,o.updateorgid -- 更新机构
    ,o.status -- 状态
    ,o.endstatus -- 结束状态
    ,o.serialno -- 流水号
    ,o.inputuserid -- 录入人
    ,o.updateuserid -- 更新用户
    ,o.alerttype -- 警示类型
    ,o.contrtolmeasure -- 风险控制措施
    ,o.itemvalue -- 对象值
    ,o.signlevel -- 警示层级
    ,o.urgentalarm -- 紧急预警
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
from ${iol_schema}.icms_alert_data_bk o
    left join ${iol_schema}.icms_alert_data_op n
        on
            o.customerid = n.customerid
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.signid = n.signid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_alert_data_cl d
        on
            o.customerid = d.customerid
            and o.objecttype = d.objecttype
            and o.objectno = d.objectno
            and o.signid = d.signid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_alert_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_alert_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_alert_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_alert_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_alert_data exchange partition p_${batch_date} with table ${iol_schema}.icms_alert_data_cl;
alter table ${iol_schema}.icms_alert_data exchange partition p_20991231 with table ${iol_schema}.icms_alert_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_alert_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alert_data_op purge;
drop table ${iol_schema}.icms_alert_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_alert_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_alert_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
