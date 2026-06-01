/*
Purpose:    指标模型层-职业人员结构分析月报表，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_person_stru_analy
CreateDate: 20210913
修改记录：
    郑沛隆 2021-09-13 新建脚本 
    依赖于源表：
    ITL_EDW_ORWS_T_EMP_INFO
    ITL_EDW_ORWS_TORG_ORGAN
    
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_person_stru_analy_${batch_date}_tm purge ;
alter table ${idl_schema}.base_d_person_stru_analy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_person_stru_analy_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_person_stru_analy
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table

INSERT INTO ${idl_schema}.base_d_person_stru_analy_${batch_date}_tm
    (orgno -- 机构编号
    ,id -- 人员ID
    ,NAME -- 人员姓名
    ,sex -- 性别
    ,born_date -- 出生日期
    ,job_date -- 工作日期
    ,position -- 岗位ID
    ,isservice -- 是否营运人员
    ,status -- 人员状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
     )

    SELECT t2.organnum AS org_no
          ,t1.id AS id
          ,t1.name AS NAME
          ,t1.sex AS sex
          ,t1.born_date AS born_date
          ,t1.job_date AS job_date
          ,t1.position AS position
          ,t1.isservice AS isservice
          ,t1.status AS status
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   itl_edw_orws_t_emp_info t1 -- tab职业生涯个人信息表
    LEFT   JOIN itl_edw_orws_torg_organ t2 --tab机构代码表
    ON     t1.to_organ = t2.organid
    WHERE  t1.etl_dt = last_day(to_date('${batch_date}'
                              ,'yyyymmdd'));
COMMIT;




-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_person_stru_analy truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_person_stru_analy exchange partition p_${batch_date} with table ${idl_schema}.base_d_person_stru_analy_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_person_stru_analy to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_person_stru_analy_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_person_stru_analy', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);