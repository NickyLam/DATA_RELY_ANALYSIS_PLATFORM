/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_secd_pay_node_info_para_mpcsf1
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
alter table ${iml_schema}.ref_secd_pay_node_info_para add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_secd_pay_node_info_para partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op purge;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_secd_pay_node_info_para partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_secd_pay_node_info_para partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_secd_pay_node_info_para partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a08tccpcinfo-
insert into ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_tm(
    node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CCPCCD -- 节点代码
    ,P1.CCPCRUNSTS -- 节点运行状态代码
    ,P1.CCPCNM -- 节点名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CCPCTP END -- 节点类型代码
    ,P1.CCPCCITYCD -- 所在城市代码
    ,P1.CHNGNB -- 变更期数
    ,P1.SYSCD -- 系统编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tccpcinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tccpcinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CCPCTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A08TCCPCINFO'
        AND R1.SRC_FIELD_EN_NAME= 'CCPCTP'
        AND R1.TARGET_TAB_EN_NAME= 'REF_SECD_PAY_NODE_INFO_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'NODE_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl(
            node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op(
            node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.node_cd, o.node_cd) as node_cd -- 节点代码
    ,nvl(n.node_move_status_cd, o.node_move_status_cd) as node_move_status_cd -- 节点运行状态代码
    ,nvl(n.node_name, o.node_name) as node_name -- 节点名称
    ,nvl(n.node_type_cd, o.node_type_cd) as node_type_cd -- 节点类型代码
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 所在城市代码
    ,nvl(n.modif_perds, o.modif_perds) as modif_perds -- 变更期数
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,case when
            n.node_cd is null
            and n.sys_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.node_cd is null
            and n.sys_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.node_cd is null
            and n.sys_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_tm n
    full join (select * from ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.node_cd = n.node_cd
            and o.sys_id = n.sys_id
where (
        o.node_cd is null
        and o.sys_id is null
    )
    or (
        n.node_cd is null
        and n.sys_id is null
    )
    or (
        o.node_move_status_cd <> n.node_move_status_cd
        or o.node_name <> n.node_name
        or o.node_type_cd <> n.node_type_cd
        or o.city_cd <> n.city_cd
        or o.modif_perds <> n.modif_perds
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl(
            node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op(
            node_cd -- 节点代码
    ,node_move_status_cd -- 节点运行状态代码
    ,node_name -- 节点名称
    ,node_type_cd -- 节点类型代码
    ,city_cd -- 所在城市代码
    ,modif_perds -- 变更期数
    ,sys_id -- 系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.node_cd -- 节点代码
    ,o.node_move_status_cd -- 节点运行状态代码
    ,o.node_name -- 节点名称
    ,o.node_type_cd -- 节点类型代码
    ,o.city_cd -- 所在城市代码
    ,o.modif_perds -- 变更期数
    ,o.sys_id -- 系统编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_bk o
    left join ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op n
        on
            o.node_cd = n.node_cd
            and o.sys_id = n.sys_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl d
        on
            o.node_cd = d.node_cd
            and o.sys_id = d.sys_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_secd_pay_node_info_para;
alter table ${iml_schema}.ref_secd_pay_node_info_para truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_secd_pay_node_info_para exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl;
alter table ${iml_schema}.ref_secd_pay_node_info_para exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_secd_pay_node_info_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_op purge;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_secd_pay_node_info_para_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_secd_pay_node_info_para', partname => 'p_mpcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
