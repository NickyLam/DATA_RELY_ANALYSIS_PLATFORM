/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_product_famsf2
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
drop table ${iml_schema}.prd_product_famsf2_tm purge;
drop table ${iml_schema}.prd_product_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_product add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_product modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_product_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_product partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_product_famsf2_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,self_own_prod_flg -- 自有产品标志
    ,sellbl_prod_flg -- 可售产品标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_product
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_product_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_product partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_fin_product-1
insert into ${iml_schema}.prd_product_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,self_own_prod_flg -- 自有产品标志
    ,sellbl_prod_flg -- 可售产品标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223002'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.FINPROD_ABBR -- 产品名称
    ,P1.FINPROD_NAME -- 产品描述
    ,'223002' -- 产品类型代码
    ,'-' -- 自有产品标志
    ,'-' -- 可售产品标志
    ,${iml_schema}.DATEFORMAT_MIN(null) -- 产品生效日期
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 产品失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.FINPROD_TYPE2 in ('F16','F24','F26')
;
commit;

-- fams_fin_product-2
insert into ${iml_schema}.prd_product_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,self_own_prod_flg -- 自有产品标志
    ,sellbl_prod_flg -- 可售产品标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223003'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.FINPROD_ABBR -- 产品名称
    ,P1.FINPROD_NAME -- 产品描述
    ,'223003' -- 产品类型代码
    ,'-' -- 自有产品标志
    ,'-' -- 可售产品标志
    ,${iml_schema}.DATEFORMAT_MIN(null) -- 产品生效日期
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 产品失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.FINPROD_TYPE2 not in ('F16','F24','F26')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_product_famsf2_tm 
  	                                group by 
  	                                        prod_id
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
insert /*+ append */ into ${iml_schema}.prd_product_famsf2_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,self_own_prod_flg -- 自有产品标志
    ,sellbl_prod_flg -- 可售产品标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_descb, o.prod_descb) as prod_descb -- 产品描述
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.self_own_prod_flg, o.self_own_prod_flg) as self_own_prod_flg -- 自有产品标志
    ,nvl(n.sellbl_prod_flg, o.sellbl_prod_flg) as sellbl_prod_flg -- 可售产品标志
    ,nvl(n.prod_effect_dt, o.prod_effect_dt) as prod_effect_dt -- 产品生效日期
    ,nvl(n.prod_invalid_dt, o.prod_invalid_dt) as prod_invalid_dt -- 产品失效日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.prod_name <> n.prod_name
                or o.prod_descb <> n.prod_descb
                or o.prod_type_cd <> n.prod_type_cd
                or o.self_own_prod_flg <> n.self_own_prod_flg
                or o.sellbl_prod_flg <> n.sellbl_prod_flg
                or o.prod_effect_dt <> n.prod_effect_dt
                or o.prod_invalid_dt <> n.prod_invalid_dt
            ) or (
                 case when (
                           n.prod_id is null
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
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_product_famsf2_tm n
    full join ${iml_schema}.prd_product_famsf2_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_product truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_product exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.prd_product_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_product drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_product to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_product_famsf2_tm purge;
drop table ${iml_schema}.prd_product_famsf2_ex purge;
drop table ${iml_schema}.prd_product_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_product', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);