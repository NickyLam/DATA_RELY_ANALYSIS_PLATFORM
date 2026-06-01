/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_teller_post_rela_info_nibsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_teller_post_rela_info_nibsi1_tm purge;
alter table ${iml_schema}.pty_teller_post_rela_info add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_teller_post_rela_info modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_teller_post_rela_info_nibsi1_tm
compress ${option_switch} for query high
as
select
    post_id -- 岗位编号
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_teller_post_rela_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nibs_ib_upm_post_rlt-
insert into ${iml_schema}.pty_teller_post_rela_info_nibsi1_tm(
    post_id -- 岗位编号
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.POSTNUM -- 岗位编号
    ,P1.USERNUM -- 柜员编号
    ,P1.BRANCHNUM -- 机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ib_upm_post_rlt' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_upm_post_rlt p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.pty_teller_post_rela_info truncate subpartition p_nibsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.pty_teller_post_rela_info exchange subpartition p_nibsi1_${batch_date} with table ${iml_schema}.pty_teller_post_rela_info_nibsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_teller_post_rela_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_teller_post_rela_info_nibsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_teller_post_rela_info', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);