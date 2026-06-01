/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareleadunderwriter
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
create table ${iol_schema}.wind_ashareleadunderwriter_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_ashareleadunderwriter
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareleadunderwriter_op purge;
drop table ${iol_schema}.wind_ashareleadunderwriter_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareleadunderwriter_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareleadunderwriter where 0=1;

create table ${iol_schema}.wind_ashareleadunderwriter_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareleadunderwriter where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareleadunderwriter_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_lu_annissuedate -- 发行公告日
            ,s_lu_issuedate -- 发行日期
            ,s_lu_issuetype -- 发行类型
            ,s_lu_totalissuecollection -- 募集资金合计(万元)
            ,s_lu_totalissueexpenses -- 发行费用合计(万元)
            ,s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
            ,s_lu_number -- 参与主承销商个数
            ,s_lu_name -- 参与主承销商名称
            ,s_lu_institype -- 主承销商类型
            ,s_lu_aux_type -- 辅助类型
            ,s_info_compcode -- 主承销商id
            ,all_lu -- 全部参与主承销商名称
            ,meeting_dt -- 发审委会议日期
            ,pass_dt -- 发审委通过公告日
            ,s_info_listdate -- 上市日期
            ,type -- 发行类型
            ,netcollection -- 募资净额合计(万元)
            ,avg_totalcoll -- 募集总额算术平均 (万元)
            ,avg_netcoll -- 募资净额算术平均 (万元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareleadunderwriter_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_lu_annissuedate -- 发行公告日
            ,s_lu_issuedate -- 发行日期
            ,s_lu_issuetype -- 发行类型
            ,s_lu_totalissuecollection -- 募集资金合计(万元)
            ,s_lu_totalissueexpenses -- 发行费用合计(万元)
            ,s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
            ,s_lu_number -- 参与主承销商个数
            ,s_lu_name -- 参与主承销商名称
            ,s_lu_institype -- 主承销商类型
            ,s_lu_aux_type -- 辅助类型
            ,s_info_compcode -- 主承销商id
            ,all_lu -- 全部参与主承销商名称
            ,meeting_dt -- 发审委会议日期
            ,pass_dt -- 发审委通过公告日
            ,s_info_listdate -- 上市日期
            ,type -- 发行类型
            ,netcollection -- 募资净额合计(万元)
            ,avg_totalcoll -- 募集总额算术平均 (万元)
            ,avg_netcoll -- 募资净额算术平均 (万元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象id
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- wind代码
    ,nvl(n.s_lu_annissuedate, o.s_lu_annissuedate) as s_lu_annissuedate -- 发行公告日
    ,nvl(n.s_lu_issuedate, o.s_lu_issuedate) as s_lu_issuedate -- 发行日期
    ,nvl(n.s_lu_issuetype, o.s_lu_issuetype) as s_lu_issuetype -- 发行类型
    ,nvl(n.s_lu_totalissuecollection, o.s_lu_totalissuecollection) as s_lu_totalissuecollection -- 募集资金合计(万元)
    ,nvl(n.s_lu_totalissueexpenses, o.s_lu_totalissueexpenses) as s_lu_totalissueexpenses -- 发行费用合计(万元)
    ,nvl(n.s_lu_totaluderandsponefee, o.s_lu_totaluderandsponefee) as s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
    ,nvl(n.s_lu_number, o.s_lu_number) as s_lu_number -- 参与主承销商个数
    ,nvl(n.s_lu_name, o.s_lu_name) as s_lu_name -- 参与主承销商名称
    ,nvl(n.s_lu_institype, o.s_lu_institype) as s_lu_institype -- 主承销商类型
    ,nvl(n.s_lu_aux_type, o.s_lu_aux_type) as s_lu_aux_type -- 辅助类型
    ,nvl(n.s_info_compcode, o.s_info_compcode) as s_info_compcode -- 主承销商id
    ,nvl(n.all_lu, o.all_lu) as all_lu -- 全部参与主承销商名称
    ,nvl(n.meeting_dt, o.meeting_dt) as meeting_dt -- 发审委会议日期
    ,nvl(n.pass_dt, o.pass_dt) as pass_dt -- 发审委通过公告日
    ,nvl(n.s_info_listdate, o.s_info_listdate) as s_info_listdate -- 上市日期
    ,nvl(n.type, o.type) as type -- 发行类型
    ,nvl(n.netcollection, o.netcollection) as netcollection -- 募资净额合计(万元)
    ,nvl(n.avg_totalcoll, o.avg_totalcoll) as avg_totalcoll -- 募集总额算术平均 (万元)
    ,nvl(n.avg_netcoll, o.avg_netcoll) as avg_netcoll -- 募资净额算术平均 (万元)
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_ashareleadunderwriter_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_ashareleadunderwriter where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.s_lu_annissuedate <> n.s_lu_annissuedate
        or o.s_lu_issuedate <> n.s_lu_issuedate
        or o.s_lu_issuetype <> n.s_lu_issuetype
        or o.s_lu_totalissuecollection <> n.s_lu_totalissuecollection
        or o.s_lu_totalissueexpenses <> n.s_lu_totalissueexpenses
        or o.s_lu_totaluderandsponefee <> n.s_lu_totaluderandsponefee
        or o.s_lu_number <> n.s_lu_number
        or o.s_lu_name <> n.s_lu_name
        or o.s_lu_institype <> n.s_lu_institype
        or o.s_lu_aux_type <> n.s_lu_aux_type
        or o.s_info_compcode <> n.s_info_compcode
        or o.all_lu <> n.all_lu
        or o.meeting_dt <> n.meeting_dt
        or o.pass_dt <> n.pass_dt
        or o.s_info_listdate <> n.s_info_listdate
        or o.type <> n.type
        or o.netcollection <> n.netcollection
        or o.avg_totalcoll <> n.avg_totalcoll
        or o.avg_netcoll <> n.avg_netcoll
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareleadunderwriter_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_lu_annissuedate -- 发行公告日
            ,s_lu_issuedate -- 发行日期
            ,s_lu_issuetype -- 发行类型
            ,s_lu_totalissuecollection -- 募集资金合计(万元)
            ,s_lu_totalissueexpenses -- 发行费用合计(万元)
            ,s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
            ,s_lu_number -- 参与主承销商个数
            ,s_lu_name -- 参与主承销商名称
            ,s_lu_institype -- 主承销商类型
            ,s_lu_aux_type -- 辅助类型
            ,s_info_compcode -- 主承销商id
            ,all_lu -- 全部参与主承销商名称
            ,meeting_dt -- 发审委会议日期
            ,pass_dt -- 发审委通过公告日
            ,s_info_listdate -- 上市日期
            ,type -- 发行类型
            ,netcollection -- 募资净额合计(万元)
            ,avg_totalcoll -- 募集总额算术平均 (万元)
            ,avg_netcoll -- 募资净额算术平均 (万元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareleadunderwriter_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,s_lu_annissuedate -- 发行公告日
            ,s_lu_issuedate -- 发行日期
            ,s_lu_issuetype -- 发行类型
            ,s_lu_totalissuecollection -- 募集资金合计(万元)
            ,s_lu_totalissueexpenses -- 发行费用合计(万元)
            ,s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
            ,s_lu_number -- 参与主承销商个数
            ,s_lu_name -- 参与主承销商名称
            ,s_lu_institype -- 主承销商类型
            ,s_lu_aux_type -- 辅助类型
            ,s_info_compcode -- 主承销商id
            ,all_lu -- 全部参与主承销商名称
            ,meeting_dt -- 发审委会议日期
            ,pass_dt -- 发审委通过公告日
            ,s_info_listdate -- 上市日期
            ,type -- 发行类型
            ,netcollection -- 募资净额合计(万元)
            ,avg_totalcoll -- 募集总额算术平均 (万元)
            ,avg_netcoll -- 募资净额算术平均 (万元)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象id
    ,o.s_info_windcode -- wind代码
    ,o.s_lu_annissuedate -- 发行公告日
    ,o.s_lu_issuedate -- 发行日期
    ,o.s_lu_issuetype -- 发行类型
    ,o.s_lu_totalissuecollection -- 募集资金合计(万元)
    ,o.s_lu_totalissueexpenses -- 发行费用合计(万元)
    ,o.s_lu_totaluderandsponefee -- 承销与保荐费用(万元)
    ,o.s_lu_number -- 参与主承销商个数
    ,o.s_lu_name -- 参与主承销商名称
    ,o.s_lu_institype -- 主承销商类型
    ,o.s_lu_aux_type -- 辅助类型
    ,o.s_info_compcode -- 主承销商id
    ,o.all_lu -- 全部参与主承销商名称
    ,o.meeting_dt -- 发审委会议日期
    ,o.pass_dt -- 发审委通过公告日
    ,o.s_info_listdate -- 上市日期
    ,o.type -- 发行类型
    ,o.netcollection -- 募资净额合计(万元)
    ,o.avg_totalcoll -- 募集总额算术平均 (万元)
    ,o.avg_netcoll -- 募资净额算术平均 (万元)
    ,o.opdate -- 
    ,o.opmode -- 
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
from ${iol_schema}.wind_ashareleadunderwriter_bk o
    left join ${iol_schema}.wind_ashareleadunderwriter_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_ashareleadunderwriter_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_ashareleadunderwriter;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_ashareleadunderwriter') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_ashareleadunderwriter drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_ashareleadunderwriter add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_ashareleadunderwriter exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareleadunderwriter_cl;
alter table ${iol_schema}.wind_ashareleadunderwriter exchange partition p_20991231 with table ${iol_schema}.wind_ashareleadunderwriter_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareleadunderwriter to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareleadunderwriter_op purge;
drop table ${iol_schema}.wind_ashareleadunderwriter_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_ashareleadunderwriter_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareleadunderwriter',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
