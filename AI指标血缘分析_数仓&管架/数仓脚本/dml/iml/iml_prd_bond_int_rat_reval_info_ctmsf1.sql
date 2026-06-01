/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_int_rat_reval_info_ctmsf1
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
drop table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_bond_int_rat_reval_info add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_bond_int_rat_reval_info modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_int_rat_reval_info partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm
compress ${option_switch} for query high
as
select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,reval_dt -- 重定价日期
    ,reval_int_rat -- 重定价利率
    ,adj_spread -- 调整点差
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_int_rat_reval_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_bond_int_rat_reval_info partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_v_security_fix_schd-
insert into ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,reval_dt -- 重定价日期
    ,reval_int_rat -- 重定价利率
    ,adj_spread -- 调整点差
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,P1.SEQ -- 序号
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 失效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.FIXING_DATE) -- 重定价日期
    ,P1.FIXING_RATE -- 重定价利率
    ,P1.SPREAD -- 调整点差
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_security_fix_schd' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_security_fix_schd p1
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm 
  	                                group by 
  	                                        bond_id
  	                                        ,lp_id
  	                                        ,seq_num
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
insert /*+ append */ into ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_ex(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,reval_dt -- 重定价日期
    ,reval_int_rat -- 重定价利率
    ,adj_spread -- 调整点差
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.reval_dt, o.reval_dt) as reval_dt -- 重定价日期
    ,nvl(n.reval_int_rat, o.reval_int_rat) as reval_int_rat -- 重定价利率
    ,nvl(n.adj_spread, o.adj_spread) as adj_spread -- 调整点差
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bond_id is null
                and o.lp_id is null
                and o.seq_num is null
            ) or (
                o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.reval_dt <> n.reval_dt
                or o.reval_int_rat <> n.reval_int_rat
                or o.adj_spread <> n.adj_spread
            ) or (
                 case when (
                           n.bond_id is null
                           and n.lp_id is null
                           and n.seq_num is null
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
                n.bond_id is null
                and n.lp_id is null
                and n.seq_num is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm n
    full join ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_bk o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_bond_int_rat_reval_info truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_bond_int_rat_reval_info exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_int_rat_reval_info drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_int_rat_reval_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_ex purge;
drop table ${iml_schema}.prd_bond_int_rat_reval_info_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_int_rat_reval_info', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);