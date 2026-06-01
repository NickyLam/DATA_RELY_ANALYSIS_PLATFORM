/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_curr_fin_instm_int_rat_ibmsf1
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
drop table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm purge;
drop table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_curr_fin_instm_int_rat add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_curr_fin_instm_int_rat modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_curr_fin_instm_int_rat partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm
compress ${option_switch} for query high
as
select
    int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat_def_id -- 利率定义编号
    ,int_rat -- 利率
    ,vp_start_dt -- 有效期起始日期
    ,vp_end_dt -- 有效期结束日期
    ,cfm_id -- 确认单编号
    ,txy_matn_flg -- 同兴赢维护标志
    ,sign_lmt -- 签约额度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_curr_fin_instm_int_rat
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_curr_fin_instm_int_rat partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_ded_rate-
insert into ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm(
    int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat_def_id -- 利率定义编号
    ,int_rat -- 利率
    ,vp_start_dt -- 有效期起始日期
    ,vp_end_dt -- 有效期结束日期
    ,cfm_id -- 确认单编号
    ,txy_matn_flg -- 同兴赢维护标志
    ,sign_lmt -- 签约额度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 利率编号
    ,'9999' -- 法人编号
    ,P1.DEF_ID -- 利率定义编号
    ,P1.RATE -- 利率
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 有效期起始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 有效期结束日期
    ,P1.CONFIRM_ID -- 确认单编号
    ,NVL(TRIM(P1.CREATE4TXY),'-') -- 同兴赢维护标志
    ,P1.SIGNING_AMOUNT -- 签约额度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_ded_rate' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_ded_rate p1
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm 
  	                                group by 
  	                                        int_rat_id
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
insert /*+ append */ into ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_ex(
    int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat_def_id -- 利率定义编号
    ,int_rat -- 利率
    ,vp_start_dt -- 有效期起始日期
    ,vp_end_dt -- 有效期结束日期
    ,cfm_id -- 确认单编号
    ,txy_matn_flg -- 同兴赢维护标志
    ,sign_lmt -- 签约额度
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.int_rat_id, o.int_rat_id) as int_rat_id -- 利率编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.int_rat_def_id, o.int_rat_def_id) as int_rat_def_id -- 利率定义编号
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.vp_start_dt, o.vp_start_dt) as vp_start_dt -- 有效期起始日期
    ,nvl(n.vp_end_dt, o.vp_end_dt) as vp_end_dt -- 有效期结束日期
    ,nvl(n.cfm_id, o.cfm_id) as cfm_id -- 确认单编号
    ,nvl(n.txy_matn_flg, o.txy_matn_flg) as txy_matn_flg -- 同兴赢维护标志
    ,nvl(n.sign_lmt, o.sign_lmt) as sign_lmt -- 签约额度
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.int_rat_id is null
                and o.lp_id is null
            ) or (
                o.int_rat_def_id <> n.int_rat_def_id
                or o.int_rat <> n.int_rat
                or o.vp_start_dt <> n.vp_start_dt
                or o.vp_end_dt <> n.vp_end_dt
                or o.cfm_id <> n.cfm_id
                or o.txy_matn_flg <> n.txy_matn_flg
                or o.sign_lmt <> n.sign_lmt
            ) or (
                 case when (
                           n.int_rat_id is null
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
                n.int_rat_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm n
    full join ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_bk o
        on
            o.int_rat_id = n.int_rat_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_curr_fin_instm_int_rat truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_curr_fin_instm_int_rat exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_curr_fin_instm_int_rat drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_curr_fin_instm_int_rat to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_tm purge;
drop table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_ex purge;
drop table ${iml_schema}.ref_curr_fin_instm_int_rat_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_curr_fin_instm_int_rat', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);