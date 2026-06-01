/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ibank_accti_subj_para_ibmsf1
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
drop table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_ibank_accti_subj_para add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_ibank_accti_subj_para modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ibank_accti_subj_para partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm
compress ${option_switch} for query high
as
select
    seq_num -- 序号
    ,level1_subj_name -- 一级科目名称
    ,level2_subj_name -- 二级科目名称
    ,level3_subj_name -- 三级科目名称
    ,accti_code -- 核算码
    ,subj_attr_cd -- 科目属性代码
    ,subj_dir_cd -- 科目方向代码
    ,level1_subj_id -- 一级科目编号
    ,level2_subj_id -- 二级科目编号
    ,level3_subj_id -- 三级科目编号
    ,entry_type_cd -- 分录类型代码
    ,entry_type_cd_1 -- 分录类型代码1
    ,entry_type_cd_2 -- 分录类型代码2
    ,entry_type_cd_3 -- 分录类型代码3
    ,entry_type_cd_4 -- 分录类型代码4
    ,entry_type_cd_5 -- 分录类型代码5
    ,charge_type_cd -- 记账类型代码
    ,level4_subj_name -- 四级科目名称
    ,level5_subj_name -- 五级科目名称
    ,level4_subj_id -- 四级科目编号
    ,level5_subj_id -- 五级科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_accti_subj_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_ibank_accti_subj_para partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_accounting_entry_def-1
insert into ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm(
    seq_num -- 序号
    ,level1_subj_name -- 一级科目名称
    ,level2_subj_name -- 二级科目名称
    ,level3_subj_name -- 三级科目名称
    ,accti_code -- 核算码
    ,subj_attr_cd -- 科目属性代码
    ,subj_dir_cd -- 科目方向代码
    ,level1_subj_id -- 一级科目编号
    ,level2_subj_id -- 二级科目编号
    ,level3_subj_id -- 三级科目编号
    ,entry_type_cd -- 分录类型代码
    ,entry_type_cd_1 -- 分录类型代码1
    ,entry_type_cd_2 -- 分录类型代码2
    ,entry_type_cd_3 -- 分录类型代码3
    ,entry_type_cd_4 -- 分录类型代码4
    ,entry_type_cd_5 -- 分录类型代码5
    ,charge_type_cd -- 记账类型代码
    ,level4_subj_name -- 四级科目名称
    ,level5_subj_name -- 五级科目名称
    ,level4_subj_id -- 四级科目编号
    ,level5_subj_id -- 五级科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.AS_ID -- 序号
    ,P1.ACTING_ENTRY_NAME_1 -- 一级科目名称
    ,P1.ACTING_ENTRY_NAME_2 -- 二级科目名称
    ,P1.ACTING_ENTRY_NAME_3 -- 三级科目名称
    ,P1.ACTING_CODE -- 核算码
    ,P1.PROPERTY_M -- 科目属性代码
    ,P1.ENTRY_DIRECTION_M -- 科目方向代码
    ,P1.ACTING_ENTRY_CODE_1 -- 一级科目编号
    ,P1.ACTING_ENTRY_CODE_2 -- 二级科目编号
    ,P1.ACTING_ENTRY_CODE_3 -- 三级科目编号
    ,P1.ENTRY_TYPE -- 分录类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ENTRY_TYPE_1 END -- 分录类型代码1
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ENTRY_TYPE_2 END -- 分录类型代码2
    ,NVL(TRIM(P1.ENTRY_TYPE_3),'-') -- 分录类型代码3
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.ENTRY_TYPE_4 END -- 分录类型代码4
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.ENTRY_TYPE_5 END -- 分录类型代码5
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.GZB_TYPE END -- 记账类型代码
    ,P1.ACTING_ENTRY_NAME_4 -- 四级科目名称
    ,P1.ACTING_ENTRY_NAME_5 -- 五级科目名称
    ,P1.ACTING_ENTRY_CODE_4 -- 四级科目编号
    ,P1.ACTING_ENTRY_CODE_5 -- 五级科目编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_accounting_entry_def' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_accounting_entry_def p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ENTRY_TYPE_1= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCOUNTING_ENTRY_DEF'
        AND R3.SRC_FIELD_EN_NAME= 'ENTRY_TYPE_1'
        AND R3.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTI_SUBJ_PARA'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD_1'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ENTRY_TYPE_2= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IBMS'
        AND R4.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCOUNTING_ENTRY_DEF'
        AND R4.SRC_FIELD_EN_NAME= 'ENTRY_TYPE_2'
        AND R4.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTI_SUBJ_PARA'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD_2'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ENTRY_TYPE_4= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IBMS'
        AND R5.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCOUNTING_ENTRY_DEF'
        AND R5.SRC_FIELD_EN_NAME= 'ENTRY_TYPE_4'
        AND R5.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTI_SUBJ_PARA'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD_4'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.ENTRY_TYPE_5= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'IBMS'
        AND R6.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCOUNTING_ENTRY_DEF'
        AND R6.SRC_FIELD_EN_NAME= 'ENTRY_TYPE_5'
        AND R6.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTI_SUBJ_PARA'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD_5'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.GZB_TYPE= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'IBMS'
        AND R7.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCOUNTING_ENTRY_DEF'
        AND R7.SRC_FIELD_EN_NAME= 'GZB_TYPE'
        AND R7.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTI_SUBJ_PARA'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm 
  	                                group by 
  	                                        seq_num
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
insert /*+ append */ into ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_ex(
    seq_num -- 序号
    ,level1_subj_name -- 一级科目名称
    ,level2_subj_name -- 二级科目名称
    ,level3_subj_name -- 三级科目名称
    ,accti_code -- 核算码
    ,subj_attr_cd -- 科目属性代码
    ,subj_dir_cd -- 科目方向代码
    ,level1_subj_id -- 一级科目编号
    ,level2_subj_id -- 二级科目编号
    ,level3_subj_id -- 三级科目编号
    ,entry_type_cd -- 分录类型代码
    ,entry_type_cd_1 -- 分录类型代码1
    ,entry_type_cd_2 -- 分录类型代码2
    ,entry_type_cd_3 -- 分录类型代码3
    ,entry_type_cd_4 -- 分录类型代码4
    ,entry_type_cd_5 -- 分录类型代码5
    ,charge_type_cd -- 记账类型代码
    ,level4_subj_name -- 四级科目名称
    ,level5_subj_name -- 五级科目名称
    ,level4_subj_id -- 四级科目编号
    ,level5_subj_id -- 五级科目编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.level1_subj_name, o.level1_subj_name) as level1_subj_name -- 一级科目名称
    ,nvl(n.level2_subj_name, o.level2_subj_name) as level2_subj_name -- 二级科目名称
    ,nvl(n.level3_subj_name, o.level3_subj_name) as level3_subj_name -- 三级科目名称
    ,nvl(n.accti_code, o.accti_code) as accti_code -- 核算码
    ,nvl(n.subj_attr_cd, o.subj_attr_cd) as subj_attr_cd -- 科目属性代码
    ,nvl(n.subj_dir_cd, o.subj_dir_cd) as subj_dir_cd -- 科目方向代码
    ,nvl(n.level1_subj_id, o.level1_subj_id) as level1_subj_id -- 一级科目编号
    ,nvl(n.level2_subj_id, o.level2_subj_id) as level2_subj_id -- 二级科目编号
    ,nvl(n.level3_subj_id, o.level3_subj_id) as level3_subj_id -- 三级科目编号
    ,nvl(n.entry_type_cd, o.entry_type_cd) as entry_type_cd -- 分录类型代码
    ,nvl(n.entry_type_cd_1, o.entry_type_cd_1) as entry_type_cd_1 -- 分录类型代码1
    ,nvl(n.entry_type_cd_2, o.entry_type_cd_2) as entry_type_cd_2 -- 分录类型代码2
    ,nvl(n.entry_type_cd_3, o.entry_type_cd_3) as entry_type_cd_3 -- 分录类型代码3
    ,nvl(n.entry_type_cd_4, o.entry_type_cd_4) as entry_type_cd_4 -- 分录类型代码4
    ,nvl(n.entry_type_cd_5, o.entry_type_cd_5) as entry_type_cd_5 -- 分录类型代码5
    ,nvl(n.charge_type_cd, o.charge_type_cd) as charge_type_cd -- 记账类型代码
    ,nvl(n.level4_subj_name, o.level4_subj_name) as level4_subj_name -- 四级科目名称
    ,nvl(n.level5_subj_name, o.level5_subj_name) as level5_subj_name -- 五级科目名称
    ,nvl(n.level4_subj_id, o.level4_subj_id) as level4_subj_id -- 四级科目编号
    ,nvl(n.level5_subj_id, o.level5_subj_id) as level5_subj_id -- 五级科目编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.seq_num is null
            ) or (
                o.level1_subj_name <> n.level1_subj_name
                or o.level2_subj_name <> n.level2_subj_name
                or o.level3_subj_name <> n.level3_subj_name
                or o.accti_code <> n.accti_code
                or o.subj_attr_cd <> n.subj_attr_cd
                or o.subj_dir_cd <> n.subj_dir_cd
                or o.level1_subj_id <> n.level1_subj_id
                or o.level2_subj_id <> n.level2_subj_id
                or o.level3_subj_id <> n.level3_subj_id
                or o.entry_type_cd <> n.entry_type_cd
                or o.entry_type_cd_1 <> n.entry_type_cd_1
                or o.entry_type_cd_2 <> n.entry_type_cd_2
                or o.entry_type_cd_3 <> n.entry_type_cd_3
                or o.entry_type_cd_4 <> n.entry_type_cd_4
                or o.entry_type_cd_5 <> n.entry_type_cd_5
                or o.charge_type_cd <> n.charge_type_cd
                or o.level4_subj_name <> n.level4_subj_name
                or o.level5_subj_name <> n.level5_subj_name
                or o.level4_subj_id <> n.level4_subj_id
                or o.level5_subj_id <> n.level5_subj_id
            ) or (
                 case when (
                           n.seq_num is null
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
                n.seq_num is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm n
    full join ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_bk o
        on
            o.seq_num = n.seq_num
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_ibank_accti_subj_para truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_ibank_accti_subj_para exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_ibank_accti_subj_para drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ibank_accti_subj_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_ex purge;
drop table ${iml_schema}.ref_ibank_accti_subj_para_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ibank_accti_subj_para', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);