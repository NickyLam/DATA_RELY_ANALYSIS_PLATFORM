/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_nv_type_acct_pos_famsf1
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
drop table ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm purge;
drop table ${iml_schema}.prd_nv_type_acct_pos_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_nv_type_acct_pos add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_nv_type_acct_pos modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_nv_type_acct_pos_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_nv_type_acct_pos partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,pos_dt -- 头寸日期
    ,pos_type_cd -- 头寸类型代码
    ,paid_in_capital -- 实收资本
    ,td_asset_nv -- 当日资产净值
    ,td_pl_gain -- 当日损益平准金
    ,td_unrliz_gain -- 当日未实现利得平准金
    ,fee_bf_asset_val -- 费前资产价值
    ,fee_post_asset_val -- 费后资产价值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_nv_type_acct_pos
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_nv_type_acct_pos_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_nv_type_acct_pos partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_bok_prd_position_n-
insert into ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm(
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,pos_dt -- 头寸日期
    ,pos_type_cd -- 头寸类型代码
    ,paid_in_capital -- 实收资本
    ,td_asset_nv -- 当日资产净值
    ,td_pl_gain -- 当日损益平准金
    ,td_unrliz_gain -- 当日未实现利得平准金
    ,fee_bf_asset_val -- 费前资产价值
    ,fee_post_asset_val -- 费后资产价值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ACCOUNTID -- 产品账户编号
    ,'9999' -- 法人编号
    ,P1.DRAWDATE -- 头寸日期
    ,P1.PTYPE -- 头寸类型代码
    ,P1.PRINAMT -- 实收资本
    ,P1.TDYASSETAMOUNT -- 当日资产净值
    ,P1.TDYPLGAIN -- 当日损益平准金
    ,P1.TDYPAPERGAIN -- 当日未实现利得平准金
    ,P1.TDYBFAMOUNT -- 费前资产价值
    ,P1.TDYNONFEEAMOUNT -- 费后资产价值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_prd_position_n' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_prd_position_n p1
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm 
  	                                group by 
  	                                        prod_acct_id
  	                                        ,lp_id
  	                                        ,pos_dt
  	                                        ,pos_type_cd
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
insert /*+ append */ into ${iml_schema}.prd_nv_type_acct_pos_famsf1_ex(
    prod_acct_id -- 产品账户编号
    ,lp_id -- 法人编号
    ,pos_dt -- 头寸日期
    ,pos_type_cd -- 头寸类型代码
    ,paid_in_capital -- 实收资本
    ,td_asset_nv -- 当日资产净值
    ,td_pl_gain -- 当日损益平准金
    ,td_unrliz_gain -- 当日未实现利得平准金
    ,fee_bf_asset_val -- 费前资产价值
    ,fee_post_asset_val -- 费后资产价值
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
    ,nvl(n.pos_dt, o.pos_dt) as pos_dt -- 头寸日期
    ,nvl(n.pos_type_cd, o.pos_type_cd) as pos_type_cd -- 头寸类型代码
    ,nvl(n.paid_in_capital, o.paid_in_capital) as paid_in_capital -- 实收资本
    ,nvl(n.td_asset_nv, o.td_asset_nv) as td_asset_nv -- 当日资产净值
    ,nvl(n.td_pl_gain, o.td_pl_gain) as td_pl_gain -- 当日损益平准金
    ,nvl(n.td_unrliz_gain, o.td_unrliz_gain) as td_unrliz_gain -- 当日未实现利得平准金
    ,nvl(n.fee_bf_asset_val, o.fee_bf_asset_val) as fee_bf_asset_val -- 费前资产价值
    ,nvl(n.fee_post_asset_val, o.fee_post_asset_val) as fee_post_asset_val -- 费后资产价值
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_acct_id is null
                and o.lp_id is null
                and o.pos_dt is null
                and o.pos_type_cd is null
            ) or (
                o.paid_in_capital <> n.paid_in_capital
                or o.td_asset_nv <> n.td_asset_nv
                or o.td_pl_gain <> n.td_pl_gain
                or o.td_unrliz_gain <> n.td_unrliz_gain
                or o.fee_bf_asset_val <> n.fee_bf_asset_val
                or o.fee_post_asset_val <> n.fee_post_asset_val
            ) or (
                 case when (
                           n.prod_acct_id is null
                           and n.lp_id is null
                           and n.pos_dt is null
                           and n.pos_type_cd is null
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
                and n.pos_dt is null
                and n.pos_type_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm n
    full join ${iml_schema}.prd_nv_type_acct_pos_famsf1_bk o
        on
            o.prod_acct_id = n.prod_acct_id
            and o.lp_id = n.lp_id
            and o.pos_dt = n.pos_dt
            and o.pos_type_cd = n.pos_type_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_nv_type_acct_pos truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_nv_type_acct_pos exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_nv_type_acct_pos_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_nv_type_acct_pos drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_nv_type_acct_pos to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_nv_type_acct_pos_famsf1_tm purge;
drop table ${iml_schema}.prd_nv_type_acct_pos_famsf1_ex purge;
drop table ${iml_schema}.prd_nv_type_acct_pos_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_nv_type_acct_pos', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);