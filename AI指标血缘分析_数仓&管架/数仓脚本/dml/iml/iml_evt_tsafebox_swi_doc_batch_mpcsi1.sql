/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tsafebox_swi_doc_batch_mpcsi1
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
drop table ${iml_schema}.evt_tsafebox_swi_doc_batch_mpcsi1_tm purge;
alter table ${iml_schema}.evt_tsafebox_swi_doc_batch add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tsafebox_swi_doc_batch modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_swi_doc_batch_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dt -- 登记日期
    ,doc_name -- 文件名称
    ,tot -- 总笔数
    ,sucs_cnt -- 成功笔数
    ,fail_cnt -- 失败笔数
    ,proc_status_cd -- 处理状态代码
    ,rest_descb -- 处理结果描述
    ,proc_start_tm -- 处理开始时间
    ,proc_end_tm -- 处理结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tsafebox_swi_doc_batch
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a20tsafeboxfileinf-1
insert into ${iml_schema}.evt_tsafebox_swi_doc_batch_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dt -- 登记日期
    ,doc_name -- 文件名称
    ,tot -- 总笔数
    ,sucs_cnt -- 成功笔数
    ,fail_cnt -- 失败笔数
    ,proc_status_cd -- 处理状态代码
    ,rest_descb -- 处理结果描述
    ,proc_start_tm -- 处理开始时间
    ,proc_end_tm -- 处理结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401034'||P1.FILENAME||P1.INSERTDT -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(P1.INSERTDT||P1.INSERTTM) -- 登记日期
    ,P1.FILENAME -- 文件名称
    ,P1.TOTALNUM -- 总笔数
    ,P1.SUCNUM -- 成功笔数
    ,P1.FAILNUM -- 失败笔数
    ,nvl(trim(P1.STATUS),'-') -- 处理状态代码
    ,P1.FILL -- 处理结果描述
    ,${iml_schema}.dateformat_min(P1.BGINTM) -- 处理开始时间
    ,${iml_schema}.dateformat_max2(P1.EDNTM) -- 处理结束时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a20tsafeboxfileinf' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a20tsafeboxfileinf p1
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_tsafebox_swi_doc_batch truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tsafebox_swi_doc_batch exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_tsafebox_swi_doc_batch_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tsafebox_swi_doc_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tsafebox_swi_doc_batch_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tsafebox_swi_doc_batch', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);