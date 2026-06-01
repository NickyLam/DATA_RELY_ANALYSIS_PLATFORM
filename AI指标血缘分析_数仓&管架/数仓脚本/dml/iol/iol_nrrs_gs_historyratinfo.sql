/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_gs_historyratinfo
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
create table ${iol_schema}.nrrs_gs_historyratinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_gs_historyratinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_gs_historyratinfo_op purge;
drop table ${iol_schema}.nrrs_gs_historyratinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_gs_historyratinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_gs_historyratinfo where 0=1;

create table ${iol_schema}.nrrs_gs_historyratinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_gs_historyratinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_gs_historyratinfo_cl(
            modelcode -- 体系类型代号
            ,index1 -- 对象代码1
            ,index2 -- 对象代码2
            ,index3 -- 对象代码3
            ,index4 -- 对象代码4
            ,index5 -- 对象代码5
            ,snumberrat -- 评级流水号
            ,year -- 评级报表年月
            ,risklevel -- 确认等级
            ,wavelevel -- 波动级别
            ,warnstate -- 预警状态
            ,policy -- 政策取向
            ,ratdate -- 评级生效日期
            ,ratdateend -- 评级到期时间
            ,pd -- 违约概率
            ,loansugg -- 授信限额
            ,operatorid -- 评级操作员
            ,reporttimes -- 基准报表
            ,faud -- 审核序号
            ,gettype -- 结果产生方式
            ,finalresultlsh -- 结果对应评级流水号
            ,overthing -- 推翻原因
            ,finalcompname -- 最终外部评级公司名称
            ,anewoutratedta -- 外部评级日期
            ,anewoutrateenddta -- 外部评级截止日期
            ,reviewflag -- 是否审核
            ,custtype -- 客户类型
            ,rattype -- 评级类型
            ,overturn -- 是否推翻
            ,modellevel -- 模型等级
            ,modelscore -- 模型得分
            ,audittype -- 意见类型
            ,modellsh -- 模型编号(暂未维护)
            ,loanlevel -- 债项等级(暂未维护)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_gs_historyratinfo_op(
            modelcode -- 体系类型代号
            ,index1 -- 对象代码1
            ,index2 -- 对象代码2
            ,index3 -- 对象代码3
            ,index4 -- 对象代码4
            ,index5 -- 对象代码5
            ,snumberrat -- 评级流水号
            ,year -- 评级报表年月
            ,risklevel -- 确认等级
            ,wavelevel -- 波动级别
            ,warnstate -- 预警状态
            ,policy -- 政策取向
            ,ratdate -- 评级生效日期
            ,ratdateend -- 评级到期时间
            ,pd -- 违约概率
            ,loansugg -- 授信限额
            ,operatorid -- 评级操作员
            ,reporttimes -- 基准报表
            ,faud -- 审核序号
            ,gettype -- 结果产生方式
            ,finalresultlsh -- 结果对应评级流水号
            ,overthing -- 推翻原因
            ,finalcompname -- 最终外部评级公司名称
            ,anewoutratedta -- 外部评级日期
            ,anewoutrateenddta -- 外部评级截止日期
            ,reviewflag -- 是否审核
            ,custtype -- 客户类型
            ,rattype -- 评级类型
            ,overturn -- 是否推翻
            ,modellevel -- 模型等级
            ,modelscore -- 模型得分
            ,audittype -- 意见类型
            ,modellsh -- 模型编号(暂未维护)
            ,loanlevel -- 债项等级(暂未维护)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.modelcode, o.modelcode) as modelcode -- 体系类型代号
    ,nvl(n.index1, o.index1) as index1 -- 对象代码1
    ,nvl(n.index2, o.index2) as index2 -- 对象代码2
    ,nvl(n.index3, o.index3) as index3 -- 对象代码3
    ,nvl(n.index4, o.index4) as index4 -- 对象代码4
    ,nvl(n.index5, o.index5) as index5 -- 对象代码5
    ,nvl(n.snumberrat, o.snumberrat) as snumberrat -- 评级流水号
    ,nvl(n.year, o.year) as year -- 评级报表年月
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 确认等级
    ,nvl(n.wavelevel, o.wavelevel) as wavelevel -- 波动级别
    ,nvl(n.warnstate, o.warnstate) as warnstate -- 预警状态
    ,nvl(n.policy, o.policy) as policy -- 政策取向
    ,nvl(n.ratdate, o.ratdate) as ratdate -- 评级生效日期
    ,nvl(n.ratdateend, o.ratdateend) as ratdateend -- 评级到期时间
    ,nvl(n.pd, o.pd) as pd -- 违约概率
    ,nvl(n.loansugg, o.loansugg) as loansugg -- 授信限额
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 评级操作员
    ,nvl(n.reporttimes, o.reporttimes) as reporttimes -- 基准报表
    ,nvl(n.faud, o.faud) as faud -- 审核序号
    ,nvl(n.gettype, o.gettype) as gettype -- 结果产生方式
    ,nvl(n.finalresultlsh, o.finalresultlsh) as finalresultlsh -- 结果对应评级流水号
    ,nvl(n.overthing, o.overthing) as overthing -- 推翻原因
    ,nvl(n.finalcompname, o.finalcompname) as finalcompname -- 最终外部评级公司名称
    ,nvl(n.anewoutratedta, o.anewoutratedta) as anewoutratedta -- 外部评级日期
    ,nvl(n.anewoutrateenddta, o.anewoutrateenddta) as anewoutrateenddta -- 外部评级截止日期
    ,nvl(n.reviewflag, o.reviewflag) as reviewflag -- 是否审核
    ,nvl(n.custtype, o.custtype) as custtype -- 客户类型
    ,nvl(n.rattype, o.rattype) as rattype -- 评级类型
    ,nvl(n.overturn, o.overturn) as overturn -- 是否推翻
    ,nvl(n.modellevel, o.modellevel) as modellevel -- 模型等级
    ,nvl(n.modelscore, o.modelscore) as modelscore -- 模型得分
    ,nvl(n.audittype, o.audittype) as audittype -- 意见类型
    ,nvl(n.modellsh, o.modellsh) as modellsh -- 模型编号(暂未维护)
    ,nvl(n.loanlevel, o.loanlevel) as loanlevel -- 债项等级(暂未维护)
    ,case when
            n.modelcode is null
            and n.index1 is null
            and n.index2 is null
            and n.index3 is null
            and n.index4 is null
            and n.index5 is null
            and n.snumberrat is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.modelcode is null
            and n.index1 is null
            and n.index2 is null
            and n.index3 is null
            and n.index4 is null
            and n.index5 is null
            and n.snumberrat is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.modelcode is null
            and n.index1 is null
            and n.index2 is null
            and n.index3 is null
            and n.index4 is null
            and n.index5 is null
            and n.snumberrat is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_gs_historyratinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_gs_historyratinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.modelcode = n.modelcode
            and o.index1 = n.index1
            and o.index2 = n.index2
            and o.index3 = n.index3
            and o.index4 = n.index4
            and o.index5 = n.index5
            and o.snumberrat = n.snumberrat
where (
        o.modelcode is null
        and o.index1 is null
        and o.index2 is null
        and o.index3 is null
        and o.index4 is null
        and o.index5 is null
        and o.snumberrat is null
    )
    or (
        n.modelcode is null
        and n.index1 is null
        and n.index2 is null
        and n.index3 is null
        and n.index4 is null
        and n.index5 is null
        and n.snumberrat is null
    )
    or (
        o.year <> n.year
        or o.risklevel <> n.risklevel
        or o.wavelevel <> n.wavelevel
        or o.warnstate <> n.warnstate
        or o.policy <> n.policy
        or o.ratdate <> n.ratdate
        or o.ratdateend <> n.ratdateend
        or o.pd <> n.pd
        or o.loansugg <> n.loansugg
        or o.operatorid <> n.operatorid
        or o.reporttimes <> n.reporttimes
        or o.faud <> n.faud
        or o.gettype <> n.gettype
        or o.finalresultlsh <> n.finalresultlsh
        or o.overthing <> n.overthing
        or o.finalcompname <> n.finalcompname
        or o.anewoutratedta <> n.anewoutratedta
        or o.anewoutrateenddta <> n.anewoutrateenddta
        or o.reviewflag <> n.reviewflag
        or o.custtype <> n.custtype
        or o.rattype <> n.rattype
        or o.overturn <> n.overturn
        or o.modellevel <> n.modellevel
        or o.modelscore <> n.modelscore
        or o.audittype <> n.audittype
        or o.modellsh <> n.modellsh
        or o.loanlevel <> n.loanlevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_gs_historyratinfo_cl(
            modelcode -- 体系类型代号
            ,index1 -- 对象代码1
            ,index2 -- 对象代码2
            ,index3 -- 对象代码3
            ,index4 -- 对象代码4
            ,index5 -- 对象代码5
            ,snumberrat -- 评级流水号
            ,year -- 评级报表年月
            ,risklevel -- 确认等级
            ,wavelevel -- 波动级别
            ,warnstate -- 预警状态
            ,policy -- 政策取向
            ,ratdate -- 评级生效日期
            ,ratdateend -- 评级到期时间
            ,pd -- 违约概率
            ,loansugg -- 授信限额
            ,operatorid -- 评级操作员
            ,reporttimes -- 基准报表
            ,faud -- 审核序号
            ,gettype -- 结果产生方式
            ,finalresultlsh -- 结果对应评级流水号
            ,overthing -- 推翻原因
            ,finalcompname -- 最终外部评级公司名称
            ,anewoutratedta -- 外部评级日期
            ,anewoutrateenddta -- 外部评级截止日期
            ,reviewflag -- 是否审核
            ,custtype -- 客户类型
            ,rattype -- 评级类型
            ,overturn -- 是否推翻
            ,modellevel -- 模型等级
            ,modelscore -- 模型得分
            ,audittype -- 意见类型
            ,modellsh -- 模型编号(暂未维护)
            ,loanlevel -- 债项等级(暂未维护)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_gs_historyratinfo_op(
            modelcode -- 体系类型代号
            ,index1 -- 对象代码1
            ,index2 -- 对象代码2
            ,index3 -- 对象代码3
            ,index4 -- 对象代码4
            ,index5 -- 对象代码5
            ,snumberrat -- 评级流水号
            ,year -- 评级报表年月
            ,risklevel -- 确认等级
            ,wavelevel -- 波动级别
            ,warnstate -- 预警状态
            ,policy -- 政策取向
            ,ratdate -- 评级生效日期
            ,ratdateend -- 评级到期时间
            ,pd -- 违约概率
            ,loansugg -- 授信限额
            ,operatorid -- 评级操作员
            ,reporttimes -- 基准报表
            ,faud -- 审核序号
            ,gettype -- 结果产生方式
            ,finalresultlsh -- 结果对应评级流水号
            ,overthing -- 推翻原因
            ,finalcompname -- 最终外部评级公司名称
            ,anewoutratedta -- 外部评级日期
            ,anewoutrateenddta -- 外部评级截止日期
            ,reviewflag -- 是否审核
            ,custtype -- 客户类型
            ,rattype -- 评级类型
            ,overturn -- 是否推翻
            ,modellevel -- 模型等级
            ,modelscore -- 模型得分
            ,audittype -- 意见类型
            ,modellsh -- 模型编号(暂未维护)
            ,loanlevel -- 债项等级(暂未维护)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.modelcode -- 体系类型代号
    ,o.index1 -- 对象代码1
    ,o.index2 -- 对象代码2
    ,o.index3 -- 对象代码3
    ,o.index4 -- 对象代码4
    ,o.index5 -- 对象代码5
    ,o.snumberrat -- 评级流水号
    ,o.year -- 评级报表年月
    ,o.risklevel -- 确认等级
    ,o.wavelevel -- 波动级别
    ,o.warnstate -- 预警状态
    ,o.policy -- 政策取向
    ,o.ratdate -- 评级生效日期
    ,o.ratdateend -- 评级到期时间
    ,o.pd -- 违约概率
    ,o.loansugg -- 授信限额
    ,o.operatorid -- 评级操作员
    ,o.reporttimes -- 基准报表
    ,o.faud -- 审核序号
    ,o.gettype -- 结果产生方式
    ,o.finalresultlsh -- 结果对应评级流水号
    ,o.overthing -- 推翻原因
    ,o.finalcompname -- 最终外部评级公司名称
    ,o.anewoutratedta -- 外部评级日期
    ,o.anewoutrateenddta -- 外部评级截止日期
    ,o.reviewflag -- 是否审核
    ,o.custtype -- 客户类型
    ,o.rattype -- 评级类型
    ,o.overturn -- 是否推翻
    ,o.modellevel -- 模型等级
    ,o.modelscore -- 模型得分
    ,o.audittype -- 意见类型
    ,o.modellsh -- 模型编号(暂未维护)
    ,o.loanlevel -- 债项等级(暂未维护)
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
from ${iol_schema}.nrrs_gs_historyratinfo_bk o
    left join ${iol_schema}.nrrs_gs_historyratinfo_op n
        on
            o.modelcode = n.modelcode
            and o.index1 = n.index1
            and o.index2 = n.index2
            and o.index3 = n.index3
            and o.index4 = n.index4
            and o.index5 = n.index5
            and o.snumberrat = n.snumberrat
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_gs_historyratinfo_cl d
        on
            o.modelcode = d.modelcode
            and o.index1 = d.index1
            and o.index2 = d.index2
            and o.index3 = d.index3
            and o.index4 = d.index4
            and o.index5 = d.index5
            and o.snumberrat = d.snumberrat
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nrrs_gs_historyratinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nrrs_gs_historyratinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nrrs_gs_historyratinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nrrs_gs_historyratinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nrrs_gs_historyratinfo exchange partition p_${batch_date} with table ${iol_schema}.nrrs_gs_historyratinfo_cl;
alter table ${iol_schema}.nrrs_gs_historyratinfo exchange partition p_20991231 with table ${iol_schema}.nrrs_gs_historyratinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_gs_historyratinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_gs_historyratinfo_op purge;
drop table ${iol_schema}.nrrs_gs_historyratinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_gs_historyratinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_gs_historyratinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
