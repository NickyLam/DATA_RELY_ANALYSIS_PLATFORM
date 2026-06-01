/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_bond_ext_rating_ibmsf1
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
drop table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ibank_bond_ext_rating add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ibank_bond_ext_rating modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_bond_ext_rating partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,crdt_rating_cd -- 信用评级代码
    ,rating_org_name -- 评级机构名称
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rating_type_cd -- 评级类型代码
    ,seq_num -- 序号
    ,rating_outl -- 评级展望
    ,rating_chg_dir_cd -- 评级变动方向代码
    ,input_dt -- 录入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_ext_rating
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ibank_bond_ext_rating partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_tbnd_ext_rating-1
insert into ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,crdt_rating_cd -- 信用评级代码
    ,rating_org_name -- 评级机构名称
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rating_type_cd -- 评级类型代码
    ,seq_num -- 序号
    ,rating_outl -- 评级展望
    ,rating_chg_dir_cd -- 评级变动方向代码
    ,input_dt -- 录入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,P1.S_GRADE -- 信用评级代码
    ,P1.RATING_INSTITUTION -- 评级机构名称
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX2(NULL) -- 失效日期
    ,P1.RATING_TYPE -- 评级类型代码
    ,' ' -- 序号
    ,' ' -- 评级展望
    ,' ' -- 评级变动方向代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 录入日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tinstrument_inst_grade' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tinstrument_inst_grade p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
  	                                        ,lp_id
  	                                        ,rating_org_name
  	                                        ,effect_dt
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
insert /*+ append */ into ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_ex(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,crdt_rating_cd -- 信用评级代码
    ,rating_org_name -- 评级机构名称
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,rating_type_cd -- 评级类型代码
    ,seq_num -- 序号
    ,rating_outl -- 评级展望
    ,rating_chg_dir_cd -- 评级变动方向代码
    ,input_dt -- 录入日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.crdt_rating_cd, o.crdt_rating_cd) as crdt_rating_cd -- 信用评级代码
    ,nvl(n.rating_org_name, o.rating_org_name) as rating_org_name -- 评级机构名称
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.rating_type_cd, o.rating_type_cd) as rating_type_cd -- 评级类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.rating_outl, o.rating_outl) as rating_outl -- 评级展望
    ,nvl(n.rating_chg_dir_cd, o.rating_chg_dir_cd) as rating_chg_dir_cd -- 评级变动方向代码
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.fin_instm_id is null
                and o.asset_type_id is null
                and o.market_type_id is null
                and o.lp_id is null
                and o.rating_org_name is null
                and o.effect_dt is null
            ) or (
                o.crdt_rating_cd <> n.crdt_rating_cd
                or o.invalid_dt <> n.invalid_dt
                or o.rating_type_cd <> n.rating_type_cd
                or o.seq_num <> n.seq_num
                or o.rating_outl <> n.rating_outl
                or o.rating_chg_dir_cd <> n.rating_chg_dir_cd
                or o.input_dt <> n.input_dt
            ) or (
                 case when (
                           n.fin_instm_id is null
                           and n.asset_type_id is null
                           and n.market_type_id is null
                           and n.lp_id is null
                           and n.rating_org_name is null
                           and n.effect_dt is null
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
                n.fin_instm_id is null
                and n.asset_type_id is null
                and n.market_type_id is null
                and n.lp_id is null
                and n.rating_org_name is null
                and n.effect_dt is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm n
    full join ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_bk o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.rating_org_name = n.rating_org_name
            and o.effect_dt = n.effect_dt
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ibank_bond_ext_rating truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ibank_bond_ext_rating exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ibank_bond_ext_rating drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_bond_ext_rating to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_ex purge;
drop table ${iml_schema}.prd_ibank_bond_ext_rating_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_bond_ext_rating', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);