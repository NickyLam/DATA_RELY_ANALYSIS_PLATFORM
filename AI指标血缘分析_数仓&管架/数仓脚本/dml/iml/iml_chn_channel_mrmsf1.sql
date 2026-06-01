/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_channel_mrmsf1
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
drop table ${iml_schema}.chn_channel_mrmsf1_tm purge;
drop table ${iml_schema}.chn_channel_mrmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.chn_channel add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.chn_channel modify partition p_mrmsf1
    add subpartition p_mrmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_channel_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_channel partition for ('mrmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_channel_mrmsf1_tm
compress ${option_switch} for query high
as
select
    chn_id -- 渠道编号
    ,lp_id -- 法人编号
    ,chn_type_cd -- 渠道类型代码
    ,chn_name -- 渠道名称
    ,chn_status_cd -- 渠道状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_channel
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.chn_channel_mrmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.chn_channel partition for ('mrmsf1') where 0=1;

-- 2.1 insert data to tm table
-- mrms_tbl_direct_term_inf-
insert into ${iml_schema}.chn_channel_mrmsf1_tm(
    chn_id -- 渠道编号
    ,lp_id -- 法人编号
    ,chn_type_cd -- 渠道类型代码
    ,chn_name -- 渠道名称
    ,chn_status_cd -- 渠道状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103002'||p1.id -- 渠道编号
    ,'9999' -- 法人编号
    ,'103002' -- 渠道类型代码
    ,' ' -- 渠道名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.term_sta end -- 渠道状态代码
    ,TO_DATE('00010101','YYYYMMDD') -- 生效日期
    ,TO_DATE('20991231','YYYYMMDD') -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_direct_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_direct_term_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_sta = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_DIRECT_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_sta'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_CHANNEL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- mrms_tbl_term_inf-
insert into ${iml_schema}.chn_channel_mrmsf1_tm(
    chn_id -- 渠道编号
    ,lp_id -- 法人编号
    ,chn_type_cd -- 渠道类型代码
    ,chn_name -- 渠道名称
    ,chn_status_cd -- 渠道状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103001'||p1.mcht_cd||p1.term_id -- 渠道编号
    ,'9999' -- 法人编号
    ,'103001' -- 渠道类型代码
    ,' ' -- 渠道名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.term_sta END -- 渠道状态代码
    ,TO_DATE('00010101','YYYYMMDD') -- 生效日期
    ,TO_DATE('20991231','YYYYMMDD') -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_term_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_sta = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_sta'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_CHANNEL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_channel_mrmsf1_tm 
  	                                group by 
  	                                        chn_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.chn_channel_mrmsf1_ex(
    chn_id -- 渠道编号
    ,lp_id -- 法人编号
    ,chn_type_cd -- 渠道类型代码
    ,chn_name -- 渠道名称
    ,chn_status_cd -- 渠道状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.chn_type_cd, o.chn_type_cd) as chn_type_cd -- 渠道类型代码
    ,nvl(n.chn_name, o.chn_name) as chn_name -- 渠道名称
    ,nvl(n.chn_status_cd, o.chn_status_cd) as chn_status_cd -- 渠道状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.chn_id is null
                and o.lp_id is null
            ) or (
                o.chn_type_cd <> n.chn_type_cd
                or o.chn_name <> n.chn_name
                or o.chn_status_cd <> n.chn_status_cd
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
            ) or (
                 case when (
                           n.chn_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.chn_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_channel_mrmsf1_tm n
    full join ${iml_schema}.chn_channel_mrmsf1_bk o
        on
            o.chn_id = n.chn_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_channel truncate partition for ('mrmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.chn_channel exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.chn_channel_mrmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.chn_channel drop subpartition p_mrmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_channel to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.chn_channel_mrmsf1_tm purge;
drop table ${iml_schema}.chn_channel_mrmsf1_ex purge;
drop table ${iml_schema}.chn_channel_mrmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_channel', partname => 'p_mrmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);