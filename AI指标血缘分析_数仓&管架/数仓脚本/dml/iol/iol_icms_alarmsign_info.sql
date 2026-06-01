/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_alarmsign_info
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
create table ${iol_schema}.icms_alarmsign_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_alarmsign_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alarmsign_info_op purge;
drop table ${iol_schema}.icms_alarmsign_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alarmsign_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alarmsign_info where 0=1;

create table ${iol_schema}.icms_alarmsign_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alarmsign_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alarmsign_info_cl(
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alarmsign_info_op(
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.signid, o.signid) as signid -- 预警号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.signtitle, o.signtitle) as signtitle -- 预警主题
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新用户
    ,nvl(n.signdescribe, o.signdescribe) as signdescribe -- 预警描述
    ,nvl(n.optionvalue, o.optionvalue) as optionvalue -- 指标项值
    ,nvl(n.signclass, o.signclass) as signclass -- 预警CLASS
    ,nvl(n.signname, o.signname) as signname -- 预警名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.signtype, o.signtype) as signtype -- 预警信号类型(定量指标，定性指标)
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 预警层级(预警信号等级)
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.isratechangecondition, o.isratechangecondition) as isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
    ,nvl(n.signoptiontype, o.signoptiontype) as signoptiontype -- 预警指标类型
    ,nvl(n.thresholdvalue, o.thresholdvalue) as thresholdvalue -- 阈值
    ,nvl(n.signobjecttype, o.signobjecttype) as signobjecttype -- 预警对象类型
    ,nvl(n.judgment, o.judgment) as judgment -- 判断关系
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.signcusytomertype, o.signcusytomertype) as signcusytomertype -- 客户类型
    ,nvl(n.triggertimes, o.triggertimes) as triggertimes -- 触发频率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.alertinfosource, o.alertinfosource) as alertinfosource -- 
    ,case when
            n.signid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.signid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.signid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_alarmsign_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_alarmsign_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.signid = n.signid
where (
        o.signid is null
    )
    or (
        n.signid is null
    )
    or (
        o.inputdate <> n.inputdate
        or o.signtitle <> n.signtitle
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.signdescribe <> n.signdescribe
        or o.optionvalue <> n.optionvalue
        or o.signclass <> n.signclass
        or o.signname <> n.signname
        or o.inputuserid <> n.inputuserid
        or o.signtype <> n.signtype
        or o.signlevel <> n.signlevel
        or o.updateorgid <> n.updateorgid
        or o.isratechangecondition <> n.isratechangecondition
        or o.signoptiontype <> n.signoptiontype
        or o.thresholdvalue <> n.thresholdvalue
        or o.signobjecttype <> n.signobjecttype
        or o.judgment <> n.judgment
        or o.updatedate <> n.updatedate
        or o.signcusytomertype <> n.signcusytomertype
        or o.triggertimes <> n.triggertimes
        or o.remark <> n.remark
        or o.alertinfosource <> n.alertinfosource
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alarmsign_info_cl(
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alarmsign_info_op(
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.signid -- 预警号
    ,o.inputdate -- 登记日期
    ,o.signtitle -- 预警主题
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新用户
    ,o.signdescribe -- 预警描述
    ,o.optionvalue -- 指标项值
    ,o.signclass -- 预警CLASS
    ,o.signname -- 预警名称
    ,o.inputuserid -- 登记人
    ,o.signtype -- 预警信号类型(定量指标，定性指标)
    ,o.signlevel -- 预警层级(预警信号等级)
    ,o.updateorgid -- 更新机构
    ,o.isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
    ,o.signoptiontype -- 预警指标类型
    ,o.thresholdvalue -- 阈值
    ,o.signobjecttype -- 预警对象类型
    ,o.judgment -- 判断关系
    ,o.updatedate -- 更新日期
    ,o.signcusytomertype -- 客户类型
    ,o.triggertimes -- 触发频率
    ,o.remark -- 备注
    ,o.alertinfosource -- 
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
from ${iol_schema}.icms_alarmsign_info_bk o
    left join ${iol_schema}.icms_alarmsign_info_op n
        on
            o.signid = n.signid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_alarmsign_info_cl d
        on
            o.signid = d.signid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_alarmsign_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_alarmsign_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_alarmsign_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_alarmsign_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_alarmsign_info exchange partition p_${batch_date} with table ${iol_schema}.icms_alarmsign_info_cl;
alter table ${iol_schema}.icms_alarmsign_info exchange partition p_20991231 with table ${iol_schema}.icms_alarmsign_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_alarmsign_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alarmsign_info_op purge;
drop table ${iol_schema}.icms_alarmsign_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_alarmsign_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_alarmsign_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
