/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_merge_splt_h_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_party_merge_splt_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_merge_splt_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_merge_splt_h partition for ('eifsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_merge_splt_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_merge_splt_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_merge_splt_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_merge_splt_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_merge_splt_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_pub_merger_split_reg-1
insert into ${iml_schema}.pty_party_merge_splt_h_eifsf1_tm(
    seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.EXCHANGE_ID -- 序号
    ,'9999' -- 法人编号
    ,P1.LEFT_CUST_NO -- 当事人编号
    ,P1.MERGED_CUST_NO -- 被归并方当事人编号
    ,NVL(TRIM(P1.MERGED_STATE),'-') -- 归并状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.MERGED_DATE) -- 归并日期
    ,P1.MERGED_ORG -- 归并机构编号
    ,P1.MERGED_TE -- 归并柜员编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.SPLIT_DATE) -- 拆分日期
    ,P1.SPLIT_ORG -- 拆分机构编号
    ,P1.SPLIT_TE -- 拆分柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_pub_merger_split_reg' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_pub_merger_split_reg p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl(
            seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_merge_splt_h_eifsf1_op(
            seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.merged_party_id, o.merged_party_id) as merged_party_id -- 被归并方当事人编号
    ,nvl(n.merge_status_cd, o.merge_status_cd) as merge_status_cd -- 归并状态代码
    ,nvl(n.merge_dt, o.merge_dt) as merge_dt -- 归并日期
    ,nvl(n.merge_org_id, o.merge_org_id) as merge_org_id -- 归并机构编号
    ,nvl(n.merge_teller_id, o.merge_teller_id) as merge_teller_id -- 归并柜员编号
    ,nvl(n.splt_dt, o.splt_dt) as splt_dt -- 拆分日期
    ,nvl(n.splt_org_id, o.splt_org_id) as splt_org_id -- 拆分机构编号
    ,nvl(n.splt_teller_id, o.splt_teller_id) as splt_teller_id -- 拆分柜员编号
    ,case when
            n.seq_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_merge_splt_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_merge_splt_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
where (
        o.seq_num is null
        and o.lp_id is null
    )
    or (
        n.seq_num is null
        and n.lp_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.merged_party_id <> n.merged_party_id
        or o.merge_status_cd <> n.merge_status_cd
        or o.merge_dt <> n.merge_dt
        or o.merge_org_id <> n.merge_org_id
        or o.merge_teller_id <> n.merge_teller_id
        or o.splt_dt <> n.splt_dt
        or o.splt_org_id <> n.splt_org_id
        or o.splt_teller_id <> n.splt_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl(
            seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_merge_splt_h_eifsf1_op(
            seq_num -- 序号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,merged_party_id -- 被归并方当事人编号
    ,merge_status_cd -- 归并状态代码
    ,merge_dt -- 归并日期
    ,merge_org_id -- 归并机构编号
    ,merge_teller_id -- 归并柜员编号
    ,splt_dt -- 拆分日期
    ,splt_org_id -- 拆分机构编号
    ,splt_teller_id -- 拆分柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_num -- 序号
    ,o.lp_id -- 法人编号
    ,o.party_id -- 当事人编号
    ,o.merged_party_id -- 被归并方当事人编号
    ,o.merge_status_cd -- 归并状态代码
    ,o.merge_dt -- 归并日期
    ,o.merge_org_id -- 归并机构编号
    ,o.merge_teller_id -- 归并柜员编号
    ,o.splt_dt -- 拆分日期
    ,o.splt_org_id -- 拆分机构编号
    ,o.splt_teller_id -- 拆分柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_merge_splt_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_merge_splt_h_eifsf1_op n
        on
            o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl d
        on
            o.seq_num = d.seq_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_merge_splt_h;
alter table ${iml_schema}.pty_party_merge_splt_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_party_merge_splt_h exchange subpartition p_eifsf1_19000101 with table ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_merge_splt_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_merge_splt_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_merge_splt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_merge_splt_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_merge_splt_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
