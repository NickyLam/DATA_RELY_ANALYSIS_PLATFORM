/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_irs_rate_history
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
create table ${iol_schema}.icms_irs_rate_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_irs_rate_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_irs_rate_history_op purge;
drop table ${iol_schema}.icms_irs_rate_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_irs_rate_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_irs_rate_history where 0=1;

create table ${iol_schema}.icms_irs_rate_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_irs_rate_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_irs_rate_history_cl(
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_irs_rate_history_op(
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.adjustlevel, o.adjustlevel) as adjustlevel -- 调整等级
    ,nvl(n.applyid, o.applyid) as applyid -- 评级申请Id
    ,nvl(n.balance, o.balance) as balance -- 当时余额
    ,nvl(n.customerid, o.customerid) as customerid -- 客户ID
    ,nvl(n.datasource, o.datasource) as datasource -- 数据来源 1.申请2.跑批3.老评级
    ,nvl(n.finallevel, o.finallevel) as finallevel -- 确认级别
    ,nvl(n.ifvalid, o.ifvalid) as ifvalid -- 评级是否失效(0是失效1是有效)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 发起人机构id
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 发起人id
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 模型编码
    ,nvl(n.modelname, o.modelname) as modelname -- 模型名称
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型 IRS_OCCUR_TYPE
    ,nvl(n.originlevel, o.originlevel) as originlevel -- 初始等级
    ,nvl(n.overthrowlevel, o.overthrowlevel) as overthrowlevel -- 推翻等级
    ,nvl(n.pusherrorinfo, o.pusherrorinfo) as pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
    ,nvl(n.ratedate, o.ratedate) as ratedate -- 评级生效日期
    ,nvl(n.ratedelayreason, o.ratedelayreason) as ratedelayreason -- 评级延期原因
    ,nvl(n.rateenddate, o.rateenddate) as rateenddate -- 评级失效日期
    ,nvl(n.ratereport, o.ratereport) as ratereport -- 评级报告
    ,nvl(n.realenddate, o.realenddate) as realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
    ,nvl(n.reportdelete, o.reportdelete) as reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
    ,nvl(n.reportno, o.reportno) as reportno -- 使用报表号
    ,nvl(n.reporttime, o.reporttime) as reporttime -- 使用报表期次
    ,nvl(n.reserve, o.reserve) as reserve -- 备用字段
    ,nvl(n.serialno, o.serialno) as serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
    ,nvl(n.wyreason, o.wyreason) as wyreason -- 查询code_library对应的WYREASON对应的违约原因
    ,case when
            n.applyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.applyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.applyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_irs_rate_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_irs_rate_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.applyid = n.applyid
where (
        o.applyid is null
    )
    or (
        n.applyid is null
    )
    or (
        o.adjustlevel <> n.adjustlevel
        or o.balance <> n.balance
        or o.customerid <> n.customerid
        or o.datasource <> n.datasource
        or o.finallevel <> n.finallevel
        or o.ifvalid <> n.ifvalid
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.modelcode <> n.modelcode
        or o.modelname <> n.modelname
        or o.occurtype <> n.occurtype
        or o.originlevel <> n.originlevel
        or o.overthrowlevel <> n.overthrowlevel
        or o.pusherrorinfo <> n.pusherrorinfo
        or o.ratedate <> n.ratedate
        or o.ratedelayreason <> n.ratedelayreason
        or o.rateenddate <> n.rateenddate
        or o.ratereport <> n.ratereport
        or o.realenddate <> n.realenddate
        or o.reportdelete <> n.reportdelete
        or o.reportno <> n.reportno
        or o.reporttime <> n.reporttime
        or o.reserve <> n.reserve
        or o.serialno <> n.serialno
        or o.wyreason <> n.wyreason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_irs_rate_history_cl(
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_irs_rate_history_op(
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.adjustlevel -- 调整等级
    ,o.applyid -- 评级申请Id
    ,o.balance -- 当时余额
    ,o.customerid -- 客户ID
    ,o.datasource -- 数据来源 1.申请2.跑批3.老评级
    ,o.finallevel -- 确认级别
    ,o.ifvalid -- 评级是否失效(0是失效1是有效)
    ,o.inputdate -- 新增时间
    ,o.inputorgid -- 发起人机构id
    ,o.inputuserid -- 发起人id
    ,o.modelcode -- 模型编码
    ,o.modelname -- 模型名称
    ,o.occurtype -- 发生类型 IRS_OCCUR_TYPE
    ,o.originlevel -- 初始等级
    ,o.overthrowlevel -- 推翻等级
    ,o.pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
    ,o.ratedate -- 评级生效日期
    ,o.ratedelayreason -- 评级延期原因
    ,o.rateenddate -- 评级失效日期
    ,o.ratereport -- 评级报告
    ,o.realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
    ,o.reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
    ,o.reportno -- 使用报表号
    ,o.reporttime -- 使用报表期次
    ,o.reserve -- 备用字段
    ,o.serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
    ,o.wyreason -- 查询code_library对应的WYREASON对应的违约原因
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
from ${iol_schema}.icms_irs_rate_history_bk o
    left join ${iol_schema}.icms_irs_rate_history_op n
        on
            o.applyid = n.applyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_irs_rate_history_cl d
        on
            o.applyid = d.applyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_irs_rate_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_irs_rate_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_irs_rate_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_irs_rate_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_irs_rate_history exchange partition p_${batch_date} with table ${iol_schema}.icms_irs_rate_history_cl;
alter table ${iol_schema}.icms_irs_rate_history exchange partition p_20991231 with table ${iol_schema}.icms_irs_rate_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_irs_rate_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_irs_rate_history_op purge;
drop table ${iol_schema}.icms_irs_rate_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_irs_rate_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_irs_rate_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
