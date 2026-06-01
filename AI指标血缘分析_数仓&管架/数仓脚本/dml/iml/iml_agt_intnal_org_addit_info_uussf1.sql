/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intnal_org_addit_info_uussf1
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
drop table ${iml_schema}.agt_intnal_org_addit_info_uussf1_tm purge;
drop table ${iml_schema}.agt_intnal_org_addit_info_uussf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_intnal_org_addit_info add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_intnal_org_addit_info modify partition p_uussf1
    add subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intnal_org_addit_info_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intnal_org_addit_info partition for ('uussf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intnal_org_addit_info_uussf1_tm
compress ${option_switch} for query high
as
select
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,bus_lics_num -- 营业执照号码
    ,work_start_tm -- 工作开始时间
    ,work_end_tm -- 工作结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intnal_org_addit_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_intnal_org_addit_info_uussf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_intnal_org_addit_info partition for ('uussf1') where 0=1;

-- 2.1 insert data to tm table
-- uuss_uus_organ-
insert into ${iml_schema}.agt_intnal_org_addit_info_uussf1_tm(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,bus_lics_num -- 营业执照号码
    ,work_start_tm -- 工作开始时间
    ,work_end_tm -- 工作结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ORGANCODE -- 机构编号
    ,'9999' -- 法人编号
    ,P1.BUSINESSLICENSE -- 营业执照号码
    ,P1.WORKSTARTTM -- 工作开始时间
    ,P1.WORKENDTM -- 工作结束时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_organ' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_organ p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_intnal_org_addit_info_uussf1_ex(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,bus_lics_num -- 营业执照号码
    ,work_start_tm -- 工作开始时间
    ,work_end_tm -- 工作结束时间
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_lics_num, o.bus_lics_num) as bus_lics_num -- 营业执照号码
    ,nvl(n.work_start_tm, o.work_start_tm) as work_start_tm -- 工作开始时间
    ,nvl(n.work_end_tm, o.work_end_tm) as work_end_tm -- 工作结束时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.org_id is null
                and o.lp_id is null
            ) or (
                o.bus_lics_num <> n.bus_lics_num
                or o.work_start_tm <> n.work_start_tm
                or o.work_end_tm <> n.work_end_tm
            )
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.org_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intnal_org_addit_info_uussf1_tm n
    full join ${iml_schema}.agt_intnal_org_addit_info_uussf1_bk o
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_intnal_org_addit_info truncate partition for ('uussf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_intnal_org_addit_info exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.agt_intnal_org_addit_info_uussf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intnal_org_addit_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_intnal_org_addit_info_uussf1_tm purge;
drop table ${iml_schema}.agt_intnal_org_addit_info_uussf1_ex purge;
drop table ${iml_schema}.agt_intnal_org_addit_info_uussf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intnal_org_addit_info', partname => 'p_uussf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);