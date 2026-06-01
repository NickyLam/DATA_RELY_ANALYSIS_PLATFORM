/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_acct_famsf1
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
drop table ${iml_schema}.prd_am_acct_famsf1_tm purge;
drop table ${iml_schema}.prd_am_acct_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_am_acct add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_acct modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_acct_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_acct partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_acct_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,acct_fname -- 账户全称
    ,acct_abbr -- 账户简称
    ,acct_type_cd -- 账户类型代码
    ,entry_type_cd -- 记账类型代码
    ,prft_mode_cd -- 收益模式代码
    ,valid_flg -- 有效标志
    ,exp_flg -- 到期标志
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_am_acct_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_am_acct partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_glb_account-
insert into ${iml_schema}.prd_am_acct_famsf1_tm(
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,acct_fname -- 账户全称
    ,acct_abbr -- 账户简称
    ,acct_type_cd -- 账户类型代码
    ,entry_type_cd -- 记账类型代码
    ,prft_mode_cd -- 收益模式代码
    ,valid_flg -- 有效标志
    ,exp_flg -- 到期标志
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GLACUUID -- 产品账户编号
    ,'9999' -- 法人编号
    ,P1.ACCTNAME -- 账户全称
    ,P1.ACCTABBR -- 账户简称
    ,P1.ACCTTYPE -- 账户类型代码
    ,P1.BOOKTYPE -- 记账类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFITMODE END -- 收益模式代码
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.ENDFLAG -- 到期标志
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_glb_account' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_glb_account p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFITMODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_GLB_ACCOUNT'
        AND R1.SRC_FIELD_EN_NAME= 'PROFITMODE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and EFFECTFLAG = 'E'
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_am_acct_famsf1_tm 
  	                                group by 
  	                                        prod_acct_id
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
insert /*+ append */ into ${iml_schema}.prd_am_acct_famsf1_ex(
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,acct_fname -- 账户全称
    ,acct_abbr -- 账户简称
    ,acct_type_cd -- 账户类型代码
    ,entry_type_cd -- 记账类型代码
    ,prft_mode_cd -- 收益模式代码
    ,valid_flg -- 有效标志
    ,exp_flg -- 到期标志
    ,remark -- 备注
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_acct_id, o.prod_acct_id) as prod_acct_id -- 产品账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_fname, o.acct_fname) as acct_fname -- 账户全称
    ,nvl(n.acct_abbr, o.acct_abbr) as acct_abbr -- 账户简称
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.entry_type_cd, o.entry_type_cd) as entry_type_cd -- 记账类型代码
    ,nvl(n.prft_mode_cd, o.prft_mode_cd) as prft_mode_cd -- 收益模式代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.exp_flg, o.exp_flg) as exp_flg -- 到期标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_acct_id is null
                and o.lp_id is null
            ) or (
                o.acct_fname <> n.acct_fname
                or o.acct_abbr <> n.acct_abbr
                or o.acct_type_cd <> n.acct_type_cd
                or o.entry_type_cd <> n.entry_type_cd
                or o.prft_mode_cd <> n.prft_mode_cd
                or o.valid_flg <> n.valid_flg
                or o.exp_flg <> n.exp_flg
                or o.remark <> n.remark
            ) or (
                 case when (
                           n.prod_acct_id is null
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
                n.prod_acct_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_acct_famsf1_tm n
    full join ${iml_schema}.prd_am_acct_famsf1_bk o
        on
            o.prod_acct_id = n.prod_acct_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_am_acct truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_am_acct exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_am_acct_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_am_acct drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_acct_famsf1_tm purge;
drop table ${iml_schema}.prd_am_acct_famsf1_ex purge;
drop table ${iml_schema}.prd_am_acct_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_acct', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);