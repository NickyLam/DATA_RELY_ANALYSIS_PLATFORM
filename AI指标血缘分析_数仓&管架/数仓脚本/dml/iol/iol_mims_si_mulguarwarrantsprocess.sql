/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_mulguarwarrantsprocess
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
create table ${iol_schema}.mims_si_mulguarwarrantsprocess_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_mulguarwarrantsprocess;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess_op purge;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_mulguarwarrantsprocess_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_mulguarwarrantsprocess where 0=1;

create table ${iol_schema}.mims_si_mulguarwarrantsprocess_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_mulguarwarrantsprocess where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_mulguarwarrantsprocess_cl(
            businessinsid -- 业务实例ID
            ,types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
            ,principal -- 权证临时借用人名称
            ,bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,bowreason -- 权证临时出库/续期具体原因
            ,accbackdate -- 权证预计归还日期
            ,opertor -- 经办人
            ,deptcode -- 所属机构
            ,operdate -- 经办日期
            ,ischange -- 权证信息是否发生变化权证临时出库归还1是0否
            ,changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
            ,changeinfo -- 权证信息变化情况描述权证临时出库归还
            ,newwarrantsno -- 新权利凭证号权证临时出库归还
            ,outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
            ,outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,reamark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_mulguarwarrantsprocess_op(
            businessinsid -- 业务实例ID
            ,types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
            ,principal -- 权证临时借用人名称
            ,bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,bowreason -- 权证临时出库/续期具体原因
            ,accbackdate -- 权证预计归还日期
            ,opertor -- 经办人
            ,deptcode -- 所属机构
            ,operdate -- 经办日期
            ,ischange -- 权证信息是否发生变化权证临时出库归还1是0否
            ,changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
            ,changeinfo -- 权证信息变化情况描述权证临时出库归还
            ,newwarrantsno -- 新权利凭证号权证临时出库归还
            ,outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
            ,outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,reamark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.businessinsid, o.businessinsid) as businessinsid -- 业务实例ID
    ,nvl(n.types, o.types) as types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
    ,nvl(n.principal, o.principal) as principal -- 权证临时借用人名称
    ,nvl(n.bowreasontype, o.bowreasontype) as bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,nvl(n.bowreason, o.bowreason) as bowreason -- 权证临时出库/续期具体原因
    ,nvl(n.accbackdate, o.accbackdate) as accbackdate -- 权证预计归还日期
    ,nvl(n.opertor, o.opertor) as opertor -- 经办人
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属机构
    ,nvl(n.operdate, o.operdate) as operdate -- 经办日期
    ,nvl(n.ischange, o.ischange) as ischange -- 权证信息是否发生变化权证临时出库归还1是0否
    ,nvl(n.changetype, o.changetype) as changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
    ,nvl(n.changeinfo, o.changeinfo) as changeinfo -- 权证信息变化情况描述权证临时出库归还
    ,nvl(n.newwarrantsno, o.newwarrantsno) as newwarrantsno -- 新权利凭证号权证临时出库归还
    ,nvl(n.outgoingtype, o.outgoingtype) as outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
    ,nvl(n.outgoingreason, o.outgoingreason) as outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,nvl(n.reamark, o.reamark) as reamark -- 备注
    ,case when
            n.businessinsid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.businessinsid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.businessinsid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_mulguarwarrantsprocess_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_mulguarwarrantsprocess where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.businessinsid = n.businessinsid
where (
        o.businessinsid is null
    )
    or (
        n.businessinsid is null
    )
    or (
        o.types <> n.types
        or o.principal <> n.principal
        or o.bowreasontype <> n.bowreasontype
        or o.bowreason <> n.bowreason
        or o.accbackdate <> n.accbackdate
        or o.opertor <> n.opertor
        or o.deptcode <> n.deptcode
        or o.operdate <> n.operdate
        or o.ischange <> n.ischange
        or o.changetype <> n.changetype
        or o.changeinfo <> n.changeinfo
        or o.newwarrantsno <> n.newwarrantsno
        or o.outgoingtype <> n.outgoingtype
        or o.outgoingreason <> n.outgoingreason
        or o.reamark <> n.reamark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_mulguarwarrantsprocess_cl(
            businessinsid -- 业务实例ID
            ,types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
            ,principal -- 权证临时借用人名称
            ,bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,bowreason -- 权证临时出库/续期具体原因
            ,accbackdate -- 权证预计归还日期
            ,opertor -- 经办人
            ,deptcode -- 所属机构
            ,operdate -- 经办日期
            ,ischange -- 权证信息是否发生变化权证临时出库归还1是0否
            ,changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
            ,changeinfo -- 权证信息变化情况描述权证临时出库归还
            ,newwarrantsno -- 新权利凭证号权证临时出库归还
            ,outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
            ,outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,reamark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_mulguarwarrantsprocess_op(
            businessinsid -- 业务实例ID
            ,types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
            ,principal -- 权证临时借用人名称
            ,bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,bowreason -- 权证临时出库/续期具体原因
            ,accbackdate -- 权证预计归还日期
            ,opertor -- 经办人
            ,deptcode -- 所属机构
            ,operdate -- 经办日期
            ,ischange -- 权证信息是否发生变化权证临时出库归还1是0否
            ,changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
            ,changeinfo -- 权证信息变化情况描述权证临时出库归还
            ,newwarrantsno -- 新权利凭证号权证临时出库归还
            ,outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
            ,outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
            ,reamark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.businessinsid -- 业务实例ID
    ,o.types -- 类型1-临时出库 2-续借 3-归还 4-正常出库
    ,o.principal -- 权证临时借用人名称
    ,o.bowreasontype -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,o.bowreason -- 权证临时出库/续期具体原因
    ,o.accbackdate -- 权证预计归还日期
    ,o.opertor -- 经办人
    ,o.deptcode -- 所属机构
    ,o.operdate -- 经办日期
    ,o.ischange -- 权证信息是否发生变化权证临时出库归还1是0否
    ,o.changetype -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
    ,o.changeinfo -- 权证信息变化情况描述权证临时出库归还
    ,o.newwarrantsno -- 新权利凭证号权证临时出库归还
    ,o.outgoingtype -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
    ,o.outgoingreason -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,o.reamark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_mulguarwarrantsprocess_bk o
    left join ${iol_schema}.mims_si_mulguarwarrantsprocess_op n
        on
            o.businessinsid = n.businessinsid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_mulguarwarrantsprocess_cl d
        on
            o.businessinsid = d.businessinsid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_mulguarwarrantsprocess;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_mulguarwarrantsprocess exchange partition p_19000101 with table ${iol_schema}.mims_si_mulguarwarrantsprocess_cl;
alter table ${iol_schema}.mims_si_mulguarwarrantsprocess exchange partition p_20991231 with table ${iol_schema}.mims_si_mulguarwarrantsprocess_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_mulguarwarrantsprocess to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess_op purge;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_mulguarwarrantsprocess',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
