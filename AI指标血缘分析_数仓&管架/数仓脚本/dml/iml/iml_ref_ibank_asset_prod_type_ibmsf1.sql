/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ibank_asset_prod_type_ibmsf1
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
drop table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_ibank_asset_prod_type add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_ibank_asset_prod_type modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ibank_asset_prod_type partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm
compress ${option_switch} for query high
as
select
    prod_type_cd -- 产品类型代码
    ,lp_id -- 法人编号
    ,asset_type_cd -- 资产类型代码
    ,prod_type_name -- 产品类型名称
    ,auto_ird_flg -- 自动息差标志
    ,delay_exp_flg -- 延迟到期标志
    ,amort_way_cd -- 摊销方式代码
    ,amort_way_name -- 摊销方式名称
    ,evltion_flg -- 估值标志
    ,evltion_type_cd -- 估值类型代码
    ,drawdown_flg -- 支取标志
    ,provi_flg -- 计提标志
    ,col_int_flg -- 收息标志
    ,auto_ovdue_flg -- 自动逾期标志
    ,on_acct_id -- 挂账账户编号
    ,on_acct_name -- 挂账账户名
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_asset_prod_type
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_ibank_asset_prod_type partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_p_type-
insert into ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm(
    prod_type_cd -- 产品类型代码
    ,lp_id -- 法人编号
    ,asset_type_cd -- 资产类型代码
    ,prod_type_name -- 产品类型名称
    ,auto_ird_flg -- 自动息差标志
    ,delay_exp_flg -- 延迟到期标志
    ,amort_way_cd -- 摊销方式代码
    ,amort_way_name -- 摊销方式名称
    ,evltion_flg -- 估值标志
    ,evltion_type_cd -- 估值类型代码
    ,drawdown_flg -- 支取标志
    ,provi_flg -- 计提标志
    ,col_int_flg -- 收息标志
    ,auto_ovdue_flg -- 自动逾期标志
    ,on_acct_id -- 挂账账户编号
    ,on_acct_name -- 挂账账户名
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.P_TYPE -- 产品类型代码
    ,'9999' -- 法人编号
    ,P1.A_TYPE -- 资产类型代码
    ,P1.P_TYPE_NAME -- 产品类型名称
    ,P1.IS_AUTO_PRFT -- 自动息差标志
    ,P1.IS_ALLOW_DELAY -- 延迟到期标志
    ,P1.AMORT_METHOD -- 摊销方式代码
    ,P1.AMORT_METHOD_NAME -- 摊销方式名称
    ,P1.IS_TPRICE -- 估值标志
    ,P1.FV_TYPE -- 估值类型代码
    ,P1.IS_ALLOW_WITHDRAW -- 支取标志
    ,P1.IS_ALLOW_ACCRUE -- 计提标志
    ,P1.IS_ALLOW_RECEIVEAI -- 收息标志
    ,P1.IS_AUTO_OVERDUE -- 自动逾期标志
    ,P1.PENDING_ACCOUNT -- 挂账账户编号
    ,P1.PENDING_ACCOUNT_NAME -- 挂账账户名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_p_type' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_p_type p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm 
  	                                group by 
  	                                        prod_type_cd
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
insert /*+ append */ into ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_ex(
    prod_type_cd -- 产品类型代码
    ,lp_id -- 法人编号
    ,asset_type_cd -- 资产类型代码
    ,prod_type_name -- 产品类型名称
    ,auto_ird_flg -- 自动息差标志
    ,delay_exp_flg -- 延迟到期标志
    ,amort_way_cd -- 摊销方式代码
    ,amort_way_name -- 摊销方式名称
    ,evltion_flg -- 估值标志
    ,evltion_type_cd -- 估值类型代码
    ,drawdown_flg -- 支取标志
    ,provi_flg -- 计提标志
    ,col_int_flg -- 收息标志
    ,auto_ovdue_flg -- 自动逾期标志
    ,on_acct_id -- 挂账账户编号
    ,on_acct_name -- 挂账账户名
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.prod_type_name, o.prod_type_name) as prod_type_name -- 产品类型名称
    ,nvl(n.auto_ird_flg, o.auto_ird_flg) as auto_ird_flg -- 自动息差标志
    ,nvl(n.delay_exp_flg, o.delay_exp_flg) as delay_exp_flg -- 延迟到期标志
    ,nvl(n.amort_way_cd, o.amort_way_cd) as amort_way_cd -- 摊销方式代码
    ,nvl(n.amort_way_name, o.amort_way_name) as amort_way_name -- 摊销方式名称
    ,nvl(n.evltion_flg, o.evltion_flg) as evltion_flg -- 估值标志
    ,nvl(n.evltion_type_cd, o.evltion_type_cd) as evltion_type_cd -- 估值类型代码
    ,nvl(n.drawdown_flg, o.drawdown_flg) as drawdown_flg -- 支取标志
    ,nvl(n.provi_flg, o.provi_flg) as provi_flg -- 计提标志
    ,nvl(n.col_int_flg, o.col_int_flg) as col_int_flg -- 收息标志
    ,nvl(n.auto_ovdue_flg, o.auto_ovdue_flg) as auto_ovdue_flg -- 自动逾期标志
    ,nvl(n.on_acct_id, o.on_acct_id) as on_acct_id -- 挂账账户编号
    ,nvl(n.on_acct_name, o.on_acct_name) as on_acct_name -- 挂账账户名
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_type_cd is null
                and o.lp_id is null
            ) or (
                o.asset_type_cd <> n.asset_type_cd
                or o.prod_type_name <> n.prod_type_name
                or o.auto_ird_flg <> n.auto_ird_flg
                or o.delay_exp_flg <> n.delay_exp_flg
                or o.amort_way_cd <> n.amort_way_cd
                or o.amort_way_name <> n.amort_way_name
                or o.evltion_flg <> n.evltion_flg
                or o.evltion_type_cd <> n.evltion_type_cd
                or o.drawdown_flg <> n.drawdown_flg
                or o.provi_flg <> n.provi_flg
                or o.col_int_flg <> n.col_int_flg
                or o.auto_ovdue_flg <> n.auto_ovdue_flg
                or o.on_acct_id <> n.on_acct_id
                or o.on_acct_name <> n.on_acct_name
            ) or (
                 case when (
                           n.prod_type_cd is null
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
                n.prod_type_cd is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm n
    full join ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_bk o
        on
            o.prod_type_cd = n.prod_type_cd
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_ibank_asset_prod_type truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_ibank_asset_prod_type exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_ibank_asset_prod_type drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ibank_asset_prod_type to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_ex purge;
drop table ${iml_schema}.ref_ibank_asset_prod_type_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ibank_asset_prod_type', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);