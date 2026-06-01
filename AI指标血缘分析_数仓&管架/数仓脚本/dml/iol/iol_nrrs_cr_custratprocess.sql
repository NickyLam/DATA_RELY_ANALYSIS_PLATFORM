/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_cr_custratprocess
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
create table ${iol_schema}.nrrs_cr_custratprocess_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_cr_custratprocess;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_cr_custratprocess_op purge;
drop table ${iol_schema}.nrrs_cr_custratprocess_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_cr_custratprocess_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_cr_custratprocess where 0=1;

create table ${iol_schema}.nrrs_cr_custratprocess_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_cr_custratprocess where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_cr_custratprocess_cl(
            faud -- 序号
            ,lsh -- 评级流水号
            ,rattype -- 评级类型
            ,custid -- 客户编号
            ,operatorid -- 操作员
            ,deptcode -- 所属机构
            ,role_id -- 岗位角色
            ,ratdate -- 处理日期
            ,gettype -- 结果产生方式
            ,risklevel -- 评级级别
            ,compname -- 外部评级公司名称
            ,outratedta -- 外部评级日期
            ,outrateenddta -- 外部评级截止日期
            ,overthing -- 推翻事由
            ,reason -- 暂无评级原因
            ,audittype -- 意见类型
            ,opinion -- 意见说明
            ,auditdate -- 审核日期
            ,auditdateend -- 审核截止日期
            ,uselsh -- 最新使用评级流水号
            ,newestflag -- 最新标志
            ,year -- 评级报表年月
            ,reportid -- 报告编号
            ,lastestdhrisklevel -- 最新贷后评级级别
            ,lastestzsrisklevel -- 最新正式评级级别
            ,isreferconreport -- 是否参考合并报表结果
            ,conreportlsh -- 合并报表结果对应流水号
            ,conreportstate -- 合并报表评级状态
            ,ratlook -- 评级展望
            ,outrisklevel -- 外部级别
            ,overturn -- 是否推翻
            ,lastfaud -- 上一岗位序号
            ,exbron -- 业务标示
            ,ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
            ,maincustomerid -- 借款人客户号
            ,applyserialno -- 所属授信号
            ,busicode -- 业务品种
            ,fslx -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_cr_custratprocess_op(
            faud -- 序号
            ,lsh -- 评级流水号
            ,rattype -- 评级类型
            ,custid -- 客户编号
            ,operatorid -- 操作员
            ,deptcode -- 所属机构
            ,role_id -- 岗位角色
            ,ratdate -- 处理日期
            ,gettype -- 结果产生方式
            ,risklevel -- 评级级别
            ,compname -- 外部评级公司名称
            ,outratedta -- 外部评级日期
            ,outrateenddta -- 外部评级截止日期
            ,overthing -- 推翻事由
            ,reason -- 暂无评级原因
            ,audittype -- 意见类型
            ,opinion -- 意见说明
            ,auditdate -- 审核日期
            ,auditdateend -- 审核截止日期
            ,uselsh -- 最新使用评级流水号
            ,newestflag -- 最新标志
            ,year -- 评级报表年月
            ,reportid -- 报告编号
            ,lastestdhrisklevel -- 最新贷后评级级别
            ,lastestzsrisklevel -- 最新正式评级级别
            ,isreferconreport -- 是否参考合并报表结果
            ,conreportlsh -- 合并报表结果对应流水号
            ,conreportstate -- 合并报表评级状态
            ,ratlook -- 评级展望
            ,outrisklevel -- 外部级别
            ,overturn -- 是否推翻
            ,lastfaud -- 上一岗位序号
            ,exbron -- 业务标示
            ,ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
            ,maincustomerid -- 借款人客户号
            ,applyserialno -- 所属授信号
            ,busicode -- 业务品种
            ,fslx -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.faud, o.faud) as faud -- 序号
    ,nvl(n.lsh, o.lsh) as lsh -- 评级流水号
    ,nvl(n.rattype, o.rattype) as rattype -- 评级类型
    ,nvl(n.custid, o.custid) as custid -- 客户编号
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 操作员
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属机构
    ,nvl(n.role_id, o.role_id) as role_id -- 岗位角色
    ,nvl(n.ratdate, o.ratdate) as ratdate -- 处理日期
    ,nvl(n.gettype, o.gettype) as gettype -- 结果产生方式
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 评级级别
    ,nvl(n.compname, o.compname) as compname -- 外部评级公司名称
    ,nvl(n.outratedta, o.outratedta) as outratedta -- 外部评级日期
    ,nvl(n.outrateenddta, o.outrateenddta) as outrateenddta -- 外部评级截止日期
    ,nvl(n.overthing, o.overthing) as overthing -- 推翻事由
    ,nvl(n.reason, o.reason) as reason -- 暂无评级原因
    ,nvl(n.audittype, o.audittype) as audittype -- 意见类型
    ,nvl(n.opinion, o.opinion) as opinion -- 意见说明
    ,nvl(n.auditdate, o.auditdate) as auditdate -- 审核日期
    ,nvl(n.auditdateend, o.auditdateend) as auditdateend -- 审核截止日期
    ,nvl(n.uselsh, o.uselsh) as uselsh -- 最新使用评级流水号
    ,nvl(n.newestflag, o.newestflag) as newestflag -- 最新标志
    ,nvl(n.year, o.year) as year -- 评级报表年月
    ,nvl(n.reportid, o.reportid) as reportid -- 报告编号
    ,nvl(n.lastestdhrisklevel, o.lastestdhrisklevel) as lastestdhrisklevel -- 最新贷后评级级别
    ,nvl(n.lastestzsrisklevel, o.lastestzsrisklevel) as lastestzsrisklevel -- 最新正式评级级别
    ,nvl(n.isreferconreport, o.isreferconreport) as isreferconreport -- 是否参考合并报表结果
    ,nvl(n.conreportlsh, o.conreportlsh) as conreportlsh -- 合并报表结果对应流水号
    ,nvl(n.conreportstate, o.conreportstate) as conreportstate -- 合并报表评级状态
    ,nvl(n.ratlook, o.ratlook) as ratlook -- 评级展望
    ,nvl(n.outrisklevel, o.outrisklevel) as outrisklevel -- 外部级别
    ,nvl(n.overturn, o.overturn) as overturn -- 是否推翻
    ,nvl(n.lastfaud, o.lastfaud) as lastfaud -- 上一岗位序号
    ,nvl(n.exbron, o.exbron) as exbron -- 业务标示
    ,nvl(n.ratertype, o.ratertype) as ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 借款人客户号
    ,nvl(n.applyserialno, o.applyserialno) as applyserialno -- 所属授信号
    ,nvl(n.busicode, o.busicode) as busicode -- 业务品种
    ,nvl(n.fslx, o.fslx) as fslx -- 发生类型
    ,case when
            n.faud is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.faud is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.faud is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_cr_custratprocess_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_cr_custratprocess where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.faud = n.faud
where (
        o.faud is null
    )
    or (
        n.faud is null
    )
    or (
        o.lsh <> n.lsh
        or o.rattype <> n.rattype
        or o.custid <> n.custid
        or o.operatorid <> n.operatorid
        or o.deptcode <> n.deptcode
        or o.role_id <> n.role_id
        or o.ratdate <> n.ratdate
        or o.gettype <> n.gettype
        or o.risklevel <> n.risklevel
        or o.compname <> n.compname
        or o.outratedta <> n.outratedta
        or o.outrateenddta <> n.outrateenddta
        or o.overthing <> n.overthing
        or o.reason <> n.reason
        or o.audittype <> n.audittype
        or o.opinion <> n.opinion
        or o.auditdate <> n.auditdate
        or o.auditdateend <> n.auditdateend
        or o.uselsh <> n.uselsh
        or o.newestflag <> n.newestflag
        or o.year <> n.year
        or o.reportid <> n.reportid
        or o.lastestdhrisklevel <> n.lastestdhrisklevel
        or o.lastestzsrisklevel <> n.lastestzsrisklevel
        or o.isreferconreport <> n.isreferconreport
        or o.conreportlsh <> n.conreportlsh
        or o.conreportstate <> n.conreportstate
        or o.ratlook <> n.ratlook
        or o.outrisklevel <> n.outrisklevel
        or o.overturn <> n.overturn
        or o.lastfaud <> n.lastfaud
        or o.exbron <> n.exbron
        or o.ratertype <> n.ratertype
        or o.maincustomerid <> n.maincustomerid
        or o.applyserialno <> n.applyserialno
        or o.busicode <> n.busicode
        or o.fslx <> n.fslx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_cr_custratprocess_cl(
            faud -- 序号
            ,lsh -- 评级流水号
            ,rattype -- 评级类型
            ,custid -- 客户编号
            ,operatorid -- 操作员
            ,deptcode -- 所属机构
            ,role_id -- 岗位角色
            ,ratdate -- 处理日期
            ,gettype -- 结果产生方式
            ,risklevel -- 评级级别
            ,compname -- 外部评级公司名称
            ,outratedta -- 外部评级日期
            ,outrateenddta -- 外部评级截止日期
            ,overthing -- 推翻事由
            ,reason -- 暂无评级原因
            ,audittype -- 意见类型
            ,opinion -- 意见说明
            ,auditdate -- 审核日期
            ,auditdateend -- 审核截止日期
            ,uselsh -- 最新使用评级流水号
            ,newestflag -- 最新标志
            ,year -- 评级报表年月
            ,reportid -- 报告编号
            ,lastestdhrisklevel -- 最新贷后评级级别
            ,lastestzsrisklevel -- 最新正式评级级别
            ,isreferconreport -- 是否参考合并报表结果
            ,conreportlsh -- 合并报表结果对应流水号
            ,conreportstate -- 合并报表评级状态
            ,ratlook -- 评级展望
            ,outrisklevel -- 外部级别
            ,overturn -- 是否推翻
            ,lastfaud -- 上一岗位序号
            ,exbron -- 业务标示
            ,ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
            ,maincustomerid -- 借款人客户号
            ,applyserialno -- 所属授信号
            ,busicode -- 业务品种
            ,fslx -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_cr_custratprocess_op(
            faud -- 序号
            ,lsh -- 评级流水号
            ,rattype -- 评级类型
            ,custid -- 客户编号
            ,operatorid -- 操作员
            ,deptcode -- 所属机构
            ,role_id -- 岗位角色
            ,ratdate -- 处理日期
            ,gettype -- 结果产生方式
            ,risklevel -- 评级级别
            ,compname -- 外部评级公司名称
            ,outratedta -- 外部评级日期
            ,outrateenddta -- 外部评级截止日期
            ,overthing -- 推翻事由
            ,reason -- 暂无评级原因
            ,audittype -- 意见类型
            ,opinion -- 意见说明
            ,auditdate -- 审核日期
            ,auditdateend -- 审核截止日期
            ,uselsh -- 最新使用评级流水号
            ,newestflag -- 最新标志
            ,year -- 评级报表年月
            ,reportid -- 报告编号
            ,lastestdhrisklevel -- 最新贷后评级级别
            ,lastestzsrisklevel -- 最新正式评级级别
            ,isreferconreport -- 是否参考合并报表结果
            ,conreportlsh -- 合并报表结果对应流水号
            ,conreportstate -- 合并报表评级状态
            ,ratlook -- 评级展望
            ,outrisklevel -- 外部级别
            ,overturn -- 是否推翻
            ,lastfaud -- 上一岗位序号
            ,exbron -- 业务标示
            ,ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
            ,maincustomerid -- 借款人客户号
            ,applyserialno -- 所属授信号
            ,busicode -- 业务品种
            ,fslx -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.faud -- 序号
    ,o.lsh -- 评级流水号
    ,o.rattype -- 评级类型
    ,o.custid -- 客户编号
    ,o.operatorid -- 操作员
    ,o.deptcode -- 所属机构
    ,o.role_id -- 岗位角色
    ,o.ratdate -- 处理日期
    ,o.gettype -- 结果产生方式
    ,o.risklevel -- 评级级别
    ,o.compname -- 外部评级公司名称
    ,o.outratedta -- 外部评级日期
    ,o.outrateenddta -- 外部评级截止日期
    ,o.overthing -- 推翻事由
    ,o.reason -- 暂无评级原因
    ,o.audittype -- 意见类型
    ,o.opinion -- 意见说明
    ,o.auditdate -- 审核日期
    ,o.auditdateend -- 审核截止日期
    ,o.uselsh -- 最新使用评级流水号
    ,o.newestflag -- 最新标志
    ,o.year -- 评级报表年月
    ,o.reportid -- 报告编号
    ,o.lastestdhrisklevel -- 最新贷后评级级别
    ,o.lastestzsrisklevel -- 最新正式评级级别
    ,o.isreferconreport -- 是否参考合并报表结果
    ,o.conreportlsh -- 合并报表结果对应流水号
    ,o.conreportstate -- 合并报表评级状态
    ,o.ratlook -- 评级展望
    ,o.outrisklevel -- 外部级别
    ,o.overturn -- 是否推翻
    ,o.lastfaud -- 上一岗位序号
    ,o.exbron -- 业务标示
    ,o.ratertype -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
    ,o.maincustomerid -- 借款人客户号
    ,o.applyserialno -- 所属授信号
    ,o.busicode -- 业务品种
    ,o.fslx -- 发生类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_cr_custratprocess_bk o
    left join ${iol_schema}.nrrs_cr_custratprocess_op n
        on
            o.faud = n.faud
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_cr_custratprocess_cl d
        on
            o.faud = d.faud
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_cr_custratprocess;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_cr_custratprocess exchange partition p_19000101 with table ${iol_schema}.nrrs_cr_custratprocess_cl;
alter table ${iol_schema}.nrrs_cr_custratprocess exchange partition p_20991231 with table ${iol_schema}.nrrs_cr_custratprocess_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_cr_custratprocess to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_cr_custratprocess_op purge;
drop table ${iol_schema}.nrrs_cr_custratprocess_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_cr_custratprocess_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_cr_custratprocess',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
