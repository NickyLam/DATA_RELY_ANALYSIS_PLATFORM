/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_rating_h_rnetf1
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
alter table ${iml_schema}.agt_rating_h add partition p_rnetf1 values ('rnetf1')(
        subpartition p_rnetf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_rnetf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_rating_h_rnetf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_rating_h partition for ('rnetf1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_rating_h_rnetf1_tm purge;
drop table ${iml_schema}.agt_rating_h_rnetf1_op purge;
drop table ${iml_schema}.agt_rating_h_rnetf1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_rating_h_rnetf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_rating_h partition for ('rnetf1')
where 0=1
;

create table ${iml_schema}.agt_rating_h_rnetf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_rating_h partition for ('rnetf1') where 0=1;

create table ${iml_schema}.agt_rating_h_rnetf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_rating_h partition for ('rnetf1') where 0=1;

-- 3.1 get new data into table
-- rcrs_net_acc_loan-1
insert into ${iml_schema}.agt_rating_h_rnetf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222510'||P1.BILL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,'3' -- 评级类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TEN_CLA END -- 评级结果代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TEN_CLA_DATE) -- 评级日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_acc_loan' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_acc_loan p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TEN_CLA = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'RCRS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R3.SRC_FIELD_EN_NAME= 'TEN_CLA'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_RATING_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RATING_RESULT_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- rcrs_net_acc_loan-2
insert into ${iml_schema}.agt_rating_h_rnetf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222510'||P1.BILL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,'1' -- 评级类型代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.LOAN_FORM4 END -- 评级结果代码
    ,'' -- 评级日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_acc_loan' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_acc_loan p1
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.LOAN_FORM4 = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'RCRS'
        AND R6.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R6.SRC_FIELD_EN_NAME= 'LOAN_FORM4'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_RATING_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'RATING_RESULT_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- rcrs_net_acc_loan-3
insert into ${iml_schema}.agt_rating_h_rnetf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222510'||P1.BILL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,'2' -- 评级类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CLA END -- 评级结果代码
    ,'' -- 评级日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_acc_loan' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_acc_loan p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CLA = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'RCRS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R4.SRC_FIELD_EN_NAME= 'CLA'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_RATING_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RATING_RESULT_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_rating_h_rnetf1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.rating_type_cd -- 评级类型代码
    ,n.rating_result_cd -- 评级结果代码
    ,n.rating_dt -- 评级日期
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'rnetf1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_rating_h_rnetf1_tm n
    left join (select * from ${iml_schema}.agt_rating_h_rnetf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.rating_type_cd = n.rating_type_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.rating_type_cd is null
    )
    or (
        o.rating_result_cd <> n.rating_result_cd
        or o.rating_dt <> n.rating_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_rating_h_rnetf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_rating_h_rnetf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_result_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.rating_type_cd -- 评级类型代码
    ,o.rating_result_cd -- 评级结果代码
    ,o.rating_dt -- 评级日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_rating_h_rnetf1_bk o
    left join ${iml_schema}.agt_rating_h_rnetf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.rating_type_cd = n.rating_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_rating_h;
alter table ${iml_schema}.agt_rating_h truncate partition for ('rnetf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_rating_h exchange subpartition p_rnetf1_19000101 with table ${iml_schema}.agt_rating_h_rnetf1_cl;
alter table ${iml_schema}.agt_rating_h exchange subpartition p_rnetf1_20991231 with table ${iml_schema}.agt_rating_h_rnetf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_rating_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_rating_h_rnetf1_tm purge;
drop table ${iml_schema}.agt_rating_h_rnetf1_op purge;
drop table ${iml_schema}.agt_rating_h_rnetf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_rating_h_rnetf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_rating_h', partname => 'p_rnetf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
