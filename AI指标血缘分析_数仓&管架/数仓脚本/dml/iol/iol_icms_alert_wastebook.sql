/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_alert_wastebook
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
create table ${iol_schema}.icms_alert_wastebook_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_alert_wastebook
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alert_wastebook_op purge;
drop table ${iol_schema}.icms_alert_wastebook_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alert_wastebook_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alert_wastebook where 0=1;

create table ${iol_schema}.icms_alert_wastebook_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alert_wastebook where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alert_wastebook_cl(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alert_wastebook_op(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.delstatus, o.delstatus) as delstatus -- 状态
    ,nvl(n.cutdate, o.cutdate) as cutdate -- 任务截止日期
    ,nvl(n.isoutfinish, o.isoutfinish) as isoutfinish -- 是否过期未完成
    ,nvl(n.confirmstatus, o.confirmstatus) as confirmstatus -- 确认状态
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 生效标志
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.certid, o.certid) as certid -- 证件编号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.accountmonth, o.accountmonth) as accountmonth -- 会计月份
    ,nvl(n.orgid, o.orgid) as orgid -- 机构号
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.buildtype, o.buildtype) as buildtype -- 预警发起方式
    ,nvl(n.isoverdue, o.isoverdue) as isoverdue -- 是否过期
    ,nvl(n.alerttype, o.alerttype) as alerttype -- 警示类型
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 完成日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.customername, o.customername) as customername -- 客户名
    ,nvl(n.endstatus, o.endstatus) as endstatus -- 结束状态
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.alertcontent, o.alertcontent) as alertcontent -- 预警内容
    ,nvl(n.alertinfosource, o.alertinfosource) as alertinfosource -- 预警信息来源
    ,nvl(n.remark1, o.remark1) as remark1 -- 客户经理失效原因
    ,nvl(n.remark2, o.remark2) as remark2 -- 风险经理失效原因
    ,nvl(n.remark3, o.remark3) as remark3 -- 总经理室失效原因
    ,nvl(n.remark4, o.remark4) as remark4 -- 客户经理生效原因
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 
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
from (select * from ${iol_schema}.icms_alert_wastebook_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_alert_wastebook where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.updatedate <> n.updatedate
        or o.delstatus <> n.delstatus
        or o.cutdate <> n.cutdate
        or o.isoutfinish <> n.isoutfinish
        or o.confirmstatus <> n.confirmstatus
        or o.effectflag <> n.effectflag
        or o.updateorgid <> n.updateorgid
        or o.relativeserialno <> n.relativeserialno
        or o.certid <> n.certid
        or o.customertype <> n.customertype
        or o.accountmonth <> n.accountmonth
        or o.orgid <> n.orgid
        or o.certtype <> n.certtype
        or o.buildtype <> n.buildtype
        or o.isoverdue <> n.isoverdue
        or o.alerttype <> n.alerttype
        or o.finishdate <> n.finishdate
        or o.approvestatus <> n.approvestatus
        or o.migtflag <> n.migtflag
        or o.customername <> n.customername
        or o.endstatus <> n.endstatus
        or o.balance <> n.balance
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.customerid <> n.customerid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.alertcontent <> n.alertcontent
        or o.alertinfosource <> n.alertinfosource
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
        or o.belongdept <> n.belongdept
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alert_wastebook_cl(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alert_wastebook_op(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.updatedate -- 更新日期
    ,o.delstatus -- 状态
    ,o.cutdate -- 任务截止日期
    ,o.isoutfinish -- 是否过期未完成
    ,o.confirmstatus -- 确认状态
    ,o.effectflag -- 生效标志
    ,o.updateorgid -- 更新机构
    ,o.relativeserialno -- 关联流水号
    ,o.certid -- 证件编号
    ,o.customertype -- 客户类型
    ,o.accountmonth -- 会计月份
    ,o.orgid -- 机构号
    ,o.certtype -- 证件类型
    ,o.buildtype -- 预警发起方式
    ,o.isoverdue -- 是否过期
    ,o.alerttype -- 警示类型
    ,o.finishdate -- 完成日期
    ,o.approvestatus -- 流程状态
    ,o.migtflag -- 
    ,o.customername -- 客户名
    ,o.endstatus -- 结束状态
    ,o.balance -- 余额
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.customerid -- 客户号
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.alertcontent -- 预警内容
    ,o.alertinfosource -- 预警信息来源
    ,o.remark1 -- 客户经理失效原因
    ,o.remark2 -- 风险经理失效原因
    ,o.remark3 -- 总经理室失效原因
    ,o.remark4 -- 客户经理生效原因
    ,o.belongdept -- 
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
from ${iol_schema}.icms_alert_wastebook_bk o
    left join ${iol_schema}.icms_alert_wastebook_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_alert_wastebook_cl d
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
--truncate table ${iol_schema}.icms_alert_wastebook;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_alert_wastebook') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_alert_wastebook drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_alert_wastebook add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_alert_wastebook exchange partition p_${batch_date} with table ${iol_schema}.icms_alert_wastebook_cl;
alter table ${iol_schema}.icms_alert_wastebook exchange partition p_20991231 with table ${iol_schema}.icms_alert_wastebook_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_alert_wastebook to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alert_wastebook_op purge;
drop table ${iol_schema}.icms_alert_wastebook_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_alert_wastebook_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_alert_wastebook',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
