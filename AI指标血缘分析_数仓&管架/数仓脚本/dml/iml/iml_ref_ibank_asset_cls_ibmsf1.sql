/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ibank_asset_cls_ibmsf1
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
drop table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_ibank_asset_cls add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_ibank_asset_cls modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ibank_asset_cls partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm
compress ${option_switch} for query high
as
select
    prod_cls_id -- 产品分类编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,prod_cls_name -- 产品分类名称
    ,prod_type_id -- 产品类型编号
    ,prod_type_name -- 产品类型名称
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_asset_cls
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_ibank_asset_cls partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_p_class-
insert into ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm(
    prod_cls_id -- 产品分类编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,prod_cls_name -- 产品分类名称
    ,prod_type_id -- 产品类型编号
    ,prod_type_name -- 产品类型名称
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 产品分类编号
    ,'9999' -- 法人编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.P_CLASS -- 产品分类名称
    ,P1.P_TYPE -- 产品类型编号
    ,P1.P_TYPE_NAME -- 产品类型名称
    ,P1.P_CLASS_CODE -- 标准产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_p_class' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_p_class p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm 
  	                                group by 
  	                                        prod_cls_id
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
insert /*+ append */ into ${iml_schema}.ref_ibank_asset_cls_ibmsf1_ex(
    prod_cls_id -- 产品分类编号
    ,lp_id -- 法人编号
    ,asset_type_id -- 资产类型编号
    ,prod_cls_name -- 产品分类名称
    ,prod_type_id -- 产品类型编号
    ,prod_type_name -- 产品类型名称
    ,std_prod_id -- 标准产品编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_cls_id, o.prod_cls_id) as prod_cls_id -- 产品分类编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.prod_cls_name, o.prod_cls_name) as prod_cls_name -- 产品分类名称
    ,nvl(n.prod_type_id, o.prod_type_id) as prod_type_id -- 产品类型编号
    ,nvl(n.prod_type_name, o.prod_type_name) as prod_type_name -- 产品类型名称
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_cls_id is null
                and o.lp_id is null
            ) or (
                o.asset_type_id <> n.asset_type_id
                or o.prod_cls_name <> n.prod_cls_name
                or o.prod_type_id <> n.prod_type_id
                or o.prod_type_name <> n.prod_type_name
                or o.std_prod_id <> n.std_prod_id
            ) or (
                 case when (
                           n.prod_cls_id is null
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
                n.prod_cls_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm n
    full join ${iml_schema}.ref_ibank_asset_cls_ibmsf1_bk o
        on
            o.prod_cls_id = n.prod_cls_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_ibank_asset_cls truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_ibank_asset_cls exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_ibank_asset_cls drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ibank_asset_cls to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_ex purge;
drop table ${iml_schema}.ref_ibank_asset_cls_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ibank_asset_cls', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);