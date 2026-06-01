/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fina_report
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
create table ${iol_schema}.icms_fina_report_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fina_report
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_report_op purge;
drop table ${iol_schema}.icms_fina_report_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_report_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_report where 0=1;

create table ${iol_schema}.icms_fina_report_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_report where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_report_cl(
            reportno -- 财报号
            ,reportflag -- 报表检查标志
            ,currency -- 币种
            ,inputorgid -- 登记机构
            ,accountingmonth -- 会计月
            ,hxtyzlsource -- 资料来源
            ,auditingagency -- 审计机构
            ,remark -- 注释
            ,inputuserid -- 登记人
            ,accordingflag -- 依据标志
            ,reportstatus -- 状态
            ,auditopinion -- 审计意见
            ,warningresult -- 预警结果
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,islock -- 是否内评系统锁定：0-锁定1-正常
            ,auditflag -- 审计标志
            ,updatedate -- 更新日期
            ,reporttypeno -- 财报类型编号
            ,reportscope -- 报表口径
            ,monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
            ,corporgid -- 法人机构编号
            ,reportperiod -- 报表周期
            ,auditdate -- 审计时间
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期登记日期时间
            ,customerid -- 客户编号
            ,deleteflag -- 删除标志
            ,reportopinion -- 报表注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_report_op(
            reportno -- 财报号
            ,reportflag -- 报表检查标志
            ,currency -- 币种
            ,inputorgid -- 登记机构
            ,accountingmonth -- 会计月
            ,hxtyzlsource -- 资料来源
            ,auditingagency -- 审计机构
            ,remark -- 注释
            ,inputuserid -- 登记人
            ,accordingflag -- 依据标志
            ,reportstatus -- 状态
            ,auditopinion -- 审计意见
            ,warningresult -- 预警结果
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,islock -- 是否内评系统锁定：0-锁定1-正常
            ,auditflag -- 审计标志
            ,updatedate -- 更新日期
            ,reporttypeno -- 财报类型编号
            ,reportscope -- 报表口径
            ,monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
            ,corporgid -- 法人机构编号
            ,reportperiod -- 报表周期
            ,auditdate -- 审计时间
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期登记日期时间
            ,customerid -- 客户编号
            ,deleteflag -- 删除标志
            ,reportopinion -- 报表注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reportno, o.reportno) as reportno -- 财报号
    ,nvl(n.reportflag, o.reportflag) as reportflag -- 报表检查标志
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.accountingmonth, o.accountingmonth) as accountingmonth -- 会计月
    ,nvl(n.hxtyzlsource, o.hxtyzlsource) as hxtyzlsource -- 资料来源
    ,nvl(n.auditingagency, o.auditingagency) as auditingagency -- 审计机构
    ,nvl(n.remark, o.remark) as remark -- 注释
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.accordingflag, o.accordingflag) as accordingflag -- 依据标志
    ,nvl(n.reportstatus, o.reportstatus) as reportstatus -- 状态
    ,nvl(n.auditopinion, o.auditopinion) as auditopinion -- 审计意见
    ,nvl(n.warningresult, o.warningresult) as warningresult -- 预警结果
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.islock, o.islock) as islock -- 是否内评系统锁定：0-锁定1-正常
    ,nvl(n.auditflag, o.auditflag) as auditflag -- 审计标志
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.reporttypeno, o.reporttypeno) as reporttypeno -- 财报类型编号
    ,nvl(n.reportscope, o.reportscope) as reportscope -- 报表口径
    ,nvl(n.monetaryunit, o.monetaryunit) as monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 报表周期
    ,nvl(n.auditdate, o.auditdate) as auditdate -- 审计时间
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期登记日期时间
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.reportopinion, o.reportopinion) as reportopinion -- 报表注释
    ,case when
            n.reportno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reportno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reportno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fina_report_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fina_report where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reportno = n.reportno
where (
        o.reportno is null
    )
    or (
        n.reportno is null
    )
    or (
        o.reportflag <> n.reportflag
        or o.currency <> n.currency
        or o.inputorgid <> n.inputorgid
        or o.accountingmonth <> n.accountingmonth
        or o.hxtyzlsource <> n.hxtyzlsource
        or o.auditingagency <> n.auditingagency
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.accordingflag <> n.accordingflag
        or o.reportstatus <> n.reportstatus
        or o.auditopinion <> n.auditopinion
        or o.warningresult <> n.warningresult
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.islock <> n.islock
        or o.auditflag <> n.auditflag
        or o.updatedate <> n.updatedate
        or o.reporttypeno <> n.reporttypeno
        or o.reportscope <> n.reportscope
        or o.monetaryunit <> n.monetaryunit
        or o.corporgid <> n.corporgid
        or o.reportperiod <> n.reportperiod
        or o.auditdate <> n.auditdate
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.customerid <> n.customerid
        or o.deleteflag <> n.deleteflag
        or o.reportopinion <> n.reportopinion
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_report_cl(
            reportno -- 财报号
            ,reportflag -- 报表检查标志
            ,currency -- 币种
            ,inputorgid -- 登记机构
            ,accountingmonth -- 会计月
            ,hxtyzlsource -- 资料来源
            ,auditingagency -- 审计机构
            ,remark -- 注释
            ,inputuserid -- 登记人
            ,accordingflag -- 依据标志
            ,reportstatus -- 状态
            ,auditopinion -- 审计意见
            ,warningresult -- 预警结果
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,islock -- 是否内评系统锁定：0-锁定1-正常
            ,auditflag -- 审计标志
            ,updatedate -- 更新日期
            ,reporttypeno -- 财报类型编号
            ,reportscope -- 报表口径
            ,monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
            ,corporgid -- 法人机构编号
            ,reportperiod -- 报表周期
            ,auditdate -- 审计时间
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期登记日期时间
            ,customerid -- 客户编号
            ,deleteflag -- 删除标志
            ,reportopinion -- 报表注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_report_op(
            reportno -- 财报号
            ,reportflag -- 报表检查标志
            ,currency -- 币种
            ,inputorgid -- 登记机构
            ,accountingmonth -- 会计月
            ,hxtyzlsource -- 资料来源
            ,auditingagency -- 审计机构
            ,remark -- 注释
            ,inputuserid -- 登记人
            ,accordingflag -- 依据标志
            ,reportstatus -- 状态
            ,auditopinion -- 审计意见
            ,warningresult -- 预警结果
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,islock -- 是否内评系统锁定：0-锁定1-正常
            ,auditflag -- 审计标志
            ,updatedate -- 更新日期
            ,reporttypeno -- 财报类型编号
            ,reportscope -- 报表口径
            ,monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
            ,corporgid -- 法人机构编号
            ,reportperiod -- 报表周期
            ,auditdate -- 审计时间
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期登记日期时间
            ,customerid -- 客户编号
            ,deleteflag -- 删除标志
            ,reportopinion -- 报表注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reportno -- 财报号
    ,o.reportflag -- 报表检查标志
    ,o.currency -- 币种
    ,o.inputorgid -- 登记机构
    ,o.accountingmonth -- 会计月
    ,o.hxtyzlsource -- 资料来源
    ,o.auditingagency -- 审计机构
    ,o.remark -- 注释
    ,o.inputuserid -- 登记人
    ,o.accordingflag -- 依据标志
    ,o.reportstatus -- 状态
    ,o.auditopinion -- 审计意见
    ,o.warningresult -- 预警结果
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.islock -- 是否内评系统锁定：0-锁定1-正常
    ,o.auditflag -- 审计标志
    ,o.updatedate -- 更新日期
    ,o.reporttypeno -- 财报类型编号
    ,o.reportscope -- 报表口径
    ,o.monetaryunit -- 货币单位在Code_library拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
    ,o.corporgid -- 法人机构编号
    ,o.reportperiod -- 报表周期
    ,o.auditdate -- 审计时间
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputdate -- 登记日期登记日期时间
    ,o.customerid -- 客户编号
    ,o.deleteflag -- 删除标志
    ,o.reportopinion -- 报表注释
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
from ${iol_schema}.icms_fina_report_bk o
    left join ${iol_schema}.icms_fina_report_op n
        on
            o.reportno = n.reportno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fina_report_cl d
        on
            o.reportno = d.reportno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fina_report;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fina_report') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fina_report drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fina_report add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fina_report exchange partition p_${batch_date} with table ${iol_schema}.icms_fina_report_cl;
alter table ${iol_schema}.icms_fina_report exchange partition p_20991231 with table ${iol_schema}.icms_fina_report_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fina_report to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_report_op purge;
drop table ${iol_schema}.icms_fina_report_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fina_report_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fina_report',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
