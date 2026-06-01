/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_abroad
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
create table ${iol_schema}.nhrs_hi_psndoc_abroad_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_abroad
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_abroad_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_abroad where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_abroad_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_abroad where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_abroad_cl(
            abroadarea -- 所去国家(地区)
            ,abroaddate -- 出国(出境)时间
            ,abroadex -- 异常情况
            ,abroadgroup -- 团组名称
            ,abroadnumber -- 审批文号
            ,abroadout -- 派出单位
            ,abroadoutlay -- 经费来源
            ,abroadpro -- 审批单位
            ,abroadprodate -- 审批时间
            ,abroadreturn -- 回国时间
            ,abroadunit -- 所去单位
            ,abroadway -- 出国(出境)目的
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,glbdef1 -- 合计天数
            ,glbdef2 -- 出国（境）事由
            ,glbdef3 -- 是否出具在职证明
            ,glbdef4 -- 联系电话
            ,glbdef5 -- 户籍地
            ,glbdef6 -- 申请出国（境）时间（开始）
            ,glbdef7 -- 申请出国（境）时间（结束）
            ,glbdef8 -- 申请出国（境）时间（总）（作废）
            ,glbdef9 -- 备注
            ,glbdef10 -- 申请出国（境）时间（总）
            ,glbdef11 -- 登记类型
            ,glbdef12 -- 证件类型
            ,glbdef13 -- 证件号码
            ,glbdef14 -- 证件领用日期
            ,glbdef15 -- 证件预计归还日期
            ,glbdef16 -- 证件实际归还日期
            ,glbdef17 -- 最近证件入库日期
            ,glbdef18 -- 证件是否在有效期内
            ,glbdef19 -- 在库状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_abroad_op(
            abroadarea -- 所去国家(地区)
            ,abroaddate -- 出国(出境)时间
            ,abroadex -- 异常情况
            ,abroadgroup -- 团组名称
            ,abroadnumber -- 审批文号
            ,abroadout -- 派出单位
            ,abroadoutlay -- 经费来源
            ,abroadpro -- 审批单位
            ,abroadprodate -- 审批时间
            ,abroadreturn -- 回国时间
            ,abroadunit -- 所去单位
            ,abroadway -- 出国(出境)目的
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,glbdef1 -- 合计天数
            ,glbdef2 -- 出国（境）事由
            ,glbdef3 -- 是否出具在职证明
            ,glbdef4 -- 联系电话
            ,glbdef5 -- 户籍地
            ,glbdef6 -- 申请出国（境）时间（开始）
            ,glbdef7 -- 申请出国（境）时间（结束）
            ,glbdef8 -- 申请出国（境）时间（总）（作废）
            ,glbdef9 -- 备注
            ,glbdef10 -- 申请出国（境）时间（总）
            ,glbdef11 -- 登记类型
            ,glbdef12 -- 证件类型
            ,glbdef13 -- 证件号码
            ,glbdef14 -- 证件领用日期
            ,glbdef15 -- 证件预计归还日期
            ,glbdef16 -- 证件实际归还日期
            ,glbdef17 -- 最近证件入库日期
            ,glbdef18 -- 证件是否在有效期内
            ,glbdef19 -- 在库状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.abroadarea, o.abroadarea) as abroadarea -- 所去国家(地区)
    ,nvl(n.abroaddate, o.abroaddate) as abroaddate -- 出国(出境)时间
    ,nvl(n.abroadex, o.abroadex) as abroadex -- 异常情况
    ,nvl(n.abroadgroup, o.abroadgroup) as abroadgroup -- 团组名称
    ,nvl(n.abroadnumber, o.abroadnumber) as abroadnumber -- 审批文号
    ,nvl(n.abroadout, o.abroadout) as abroadout -- 派出单位
    ,nvl(n.abroadoutlay, o.abroadoutlay) as abroadoutlay -- 经费来源
    ,nvl(n.abroadpro, o.abroadpro) as abroadpro -- 审批单位
    ,nvl(n.abroadprodate, o.abroadprodate) as abroadprodate -- 审批时间
    ,nvl(n.abroadreturn, o.abroadreturn) as abroadreturn -- 回国时间
    ,nvl(n.abroadunit, o.abroadunit) as abroadunit -- 所去单位
    ,nvl(n.abroadway, o.abroadway) as abroadway -- 出国(出境)目的
    ,nvl(n.begindate, o.begindate) as begindate -- 起始日期
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.enddate, o.enddate) as enddate -- 终止日期
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最近记录标志
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员主键
    ,nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 人员子表主键
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 合计天数
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 出国（境）事由
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 是否出具在职证明
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 联系电话
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 户籍地
    ,nvl(n.glbdef6, o.glbdef6) as glbdef6 -- 申请出国（境）时间（开始）
    ,nvl(n.glbdef7, o.glbdef7) as glbdef7 -- 申请出国（境）时间（结束）
    ,nvl(n.glbdef8, o.glbdef8) as glbdef8 -- 申请出国（境）时间（总）（作废）
    ,nvl(n.glbdef9, o.glbdef9) as glbdef9 -- 备注
    ,nvl(n.glbdef10, o.glbdef10) as glbdef10 -- 申请出国（境）时间（总）
    ,nvl(n.glbdef11, o.glbdef11) as glbdef11 -- 登记类型
    ,nvl(n.glbdef12, o.glbdef12) as glbdef12 -- 证件类型
    ,nvl(n.glbdef13, o.glbdef13) as glbdef13 -- 证件号码
    ,nvl(n.glbdef14, o.glbdef14) as glbdef14 -- 证件领用日期
    ,nvl(n.glbdef15, o.glbdef15) as glbdef15 -- 证件预计归还日期
    ,nvl(n.glbdef16, o.glbdef16) as glbdef16 -- 证件实际归还日期
    ,nvl(n.glbdef17, o.glbdef17) as glbdef17 -- 最近证件入库日期
    ,nvl(n.glbdef18, o.glbdef18) as glbdef18 -- 证件是否在有效期内
    ,nvl(n.glbdef19, o.glbdef19) as glbdef19 -- 在库状态
    ,case when
            n.pk_psndoc_sub is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psndoc_sub is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psndoc_sub is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psndoc_abroad_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_abroad where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.abroadarea <> n.abroadarea
        or o.abroaddate <> n.abroaddate
        or o.abroadex <> n.abroadex
        or o.abroadgroup <> n.abroadgroup
        or o.abroadnumber <> n.abroadnumber
        or o.abroadout <> n.abroadout
        or o.abroadoutlay <> n.abroadoutlay
        or o.abroadpro <> n.abroadpro
        or o.abroadprodate <> n.abroadprodate
        or o.abroadreturn <> n.abroadreturn
        or o.abroadunit <> n.abroadunit
        or o.abroadway <> n.abroadway
        or o.begindate <> n.begindate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.enddate <> n.enddate
        or o.lastflag <> n.lastflag
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.recordnum <> n.recordnum
        or o.ts <> n.ts
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef5 <> n.glbdef5
        or o.glbdef6 <> n.glbdef6
        or o.glbdef7 <> n.glbdef7
        or o.glbdef8 <> n.glbdef8
        or o.glbdef9 <> n.glbdef9
        or o.glbdef10 <> n.glbdef10
        or o.glbdef11 <> n.glbdef11
        or o.glbdef12 <> n.glbdef12
        or o.glbdef13 <> n.glbdef13
        or o.glbdef14 <> n.glbdef14
        or o.glbdef15 <> n.glbdef15
        or o.glbdef16 <> n.glbdef16
        or o.glbdef17 <> n.glbdef17
        or o.glbdef18 <> n.glbdef18
        or o.glbdef19 <> n.glbdef19
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_abroad_cl(
            abroadarea -- 所去国家(地区)
            ,abroaddate -- 出国(出境)时间
            ,abroadex -- 异常情况
            ,abroadgroup -- 团组名称
            ,abroadnumber -- 审批文号
            ,abroadout -- 派出单位
            ,abroadoutlay -- 经费来源
            ,abroadpro -- 审批单位
            ,abroadprodate -- 审批时间
            ,abroadreturn -- 回国时间
            ,abroadunit -- 所去单位
            ,abroadway -- 出国(出境)目的
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,glbdef1 -- 合计天数
            ,glbdef2 -- 出国（境）事由
            ,glbdef3 -- 是否出具在职证明
            ,glbdef4 -- 联系电话
            ,glbdef5 -- 户籍地
            ,glbdef6 -- 申请出国（境）时间（开始）
            ,glbdef7 -- 申请出国（境）时间（结束）
            ,glbdef8 -- 申请出国（境）时间（总）（作废）
            ,glbdef9 -- 备注
            ,glbdef10 -- 申请出国（境）时间（总）
            ,glbdef11 -- 登记类型
            ,glbdef12 -- 证件类型
            ,glbdef13 -- 证件号码
            ,glbdef14 -- 证件领用日期
            ,glbdef15 -- 证件预计归还日期
            ,glbdef16 -- 证件实际归还日期
            ,glbdef17 -- 最近证件入库日期
            ,glbdef18 -- 证件是否在有效期内
            ,glbdef19 -- 在库状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_abroad_op(
            abroadarea -- 所去国家(地区)
            ,abroaddate -- 出国(出境)时间
            ,abroadex -- 异常情况
            ,abroadgroup -- 团组名称
            ,abroadnumber -- 审批文号
            ,abroadout -- 派出单位
            ,abroadoutlay -- 经费来源
            ,abroadpro -- 审批单位
            ,abroadprodate -- 审批时间
            ,abroadreturn -- 回国时间
            ,abroadunit -- 所去单位
            ,abroadway -- 出国(出境)目的
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,glbdef1 -- 合计天数
            ,glbdef2 -- 出国（境）事由
            ,glbdef3 -- 是否出具在职证明
            ,glbdef4 -- 联系电话
            ,glbdef5 -- 户籍地
            ,glbdef6 -- 申请出国（境）时间（开始）
            ,glbdef7 -- 申请出国（境）时间（结束）
            ,glbdef8 -- 申请出国（境）时间（总）（作废）
            ,glbdef9 -- 备注
            ,glbdef10 -- 申请出国（境）时间（总）
            ,glbdef11 -- 登记类型
            ,glbdef12 -- 证件类型
            ,glbdef13 -- 证件号码
            ,glbdef14 -- 证件领用日期
            ,glbdef15 -- 证件预计归还日期
            ,glbdef16 -- 证件实际归还日期
            ,glbdef17 -- 最近证件入库日期
            ,glbdef18 -- 证件是否在有效期内
            ,glbdef19 -- 在库状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.abroadarea -- 所去国家(地区)
    ,o.abroaddate -- 出国(出境)时间
    ,o.abroadex -- 异常情况
    ,o.abroadgroup -- 团组名称
    ,o.abroadnumber -- 审批文号
    ,o.abroadout -- 派出单位
    ,o.abroadoutlay -- 经费来源
    ,o.abroadpro -- 审批单位
    ,o.abroadprodate -- 审批时间
    ,o.abroadreturn -- 回国时间
    ,o.abroadunit -- 所去单位
    ,o.abroadway -- 出国(出境)目的
    ,o.begindate -- 起始日期
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.enddate -- 终止日期
    ,o.lastflag -- 最近记录标志
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_psndoc -- 人员主键
    ,o.pk_psndoc_sub -- 人员子表主键
    ,o.recordnum -- 记录序号
    ,o.ts -- 时间戳
    ,o.glbdef1 -- 合计天数
    ,o.glbdef2 -- 出国（境）事由
    ,o.glbdef3 -- 是否出具在职证明
    ,o.glbdef4 -- 联系电话
    ,o.glbdef5 -- 户籍地
    ,o.glbdef6 -- 申请出国（境）时间（开始）
    ,o.glbdef7 -- 申请出国（境）时间（结束）
    ,o.glbdef8 -- 申请出国（境）时间（总）（作废）
    ,o.glbdef9 -- 备注
    ,o.glbdef10 -- 申请出国（境）时间（总）
    ,o.glbdef11 -- 登记类型
    ,o.glbdef12 -- 证件类型
    ,o.glbdef13 -- 证件号码
    ,o.glbdef14 -- 证件领用日期
    ,o.glbdef15 -- 证件预计归还日期
    ,o.glbdef16 -- 证件实际归还日期
    ,o.glbdef17 -- 最近证件入库日期
    ,o.glbdef18 -- 证件是否在有效期内
    ,o.glbdef19 -- 在库状态
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
from ${iol_schema}.nhrs_hi_psndoc_abroad_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_abroad_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_abroad_cl d
        on
            o.pk_psndoc_sub = d.pk_psndoc_sub
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psndoc_abroad;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_abroad') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_abroad drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_abroad add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_abroad exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_abroad_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_abroad exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_abroad_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_abroad to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_abroad',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
