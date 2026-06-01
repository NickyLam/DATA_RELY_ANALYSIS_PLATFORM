/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_type_def_mimsf1
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
drop table ${iml_schema}.ast_col_type_def_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_type_def_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_type_def add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_type_def modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_type_def_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_type_def partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_type_def_mimsf1_tm
compress ${option_switch} for query high
as
select
    col_type_cd -- 押品类型代码
    ,col_type_name -- 押品类型名称
    ,up_level_node_type_cd -- 上层节点类型代码
    ,lev -- 级别
    ,base_cate_flg -- 基础类别标志
    ,spcl_info_type_cd -- 专项信息类型代码
    ,keyw_a -- 关键字段A
    ,effect_way_cd -- 生效方式代码
    ,col_descb -- 押品描述
    ,status_descb -- 状态描述
    ,admit_cls -- 准入分类
    ,modif_dt -- 修改日期
    ,modif_org_id -- 修改机构编号
    ,data_type_cd -- 数据类型代码
    ,guar_admit_cls_cd -- 担保准入分类代码
    ,modif_emply_id -- 修改员工编号
    ,reval_freq_cd -- 重估频率代码
    ,higt_pm_rat -- 最高抵质押率
    ,keyw_b -- 关键字段B
    ,gen_cd -- 大类代码
    ,manu_idtfy_flg -- 人工认定标志
    ,tshold -- 阀值
    ,strip_line_cd -- 条线代码
    ,ab_divd_cd -- AB类划分代码
    ,keyw_comb_use_flg -- 关键字段结合使用标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_type_def
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_type_def_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_type_def partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_guarwarrantsinfo-
insert into ${iml_schema}.ast_col_type_def_mimsf1_tm(
    col_type_cd -- 押品类型代码
    ,col_type_name -- 押品类型名称
    ,up_level_node_type_cd -- 上层节点类型代码
    ,lev -- 级别
    ,base_cate_flg -- 基础类别标志
    ,spcl_info_type_cd -- 专项信息类型代码
    ,keyw_a -- 关键字段A
    ,effect_way_cd -- 生效方式代码
    ,col_descb -- 押品描述
    ,status_descb -- 状态描述
    ,admit_cls -- 准入分类
    ,modif_dt -- 修改日期
    ,modif_org_id -- 修改机构编号
    ,data_type_cd -- 数据类型代码
    ,guar_admit_cls_cd -- 担保准入分类代码
    ,modif_emply_id -- 修改员工编号
    ,reval_freq_cd -- 重估频率代码
    ,higt_pm_rat -- 最高抵质押率
    ,keyw_b -- 关键字段B
    ,gen_cd -- 大类代码
    ,manu_idtfy_flg -- 人工认定标志
    ,tshold -- 阀值
    ,strip_line_cd -- 条线代码
    ,ab_divd_cd -- AB类划分代码
    ,keyw_comb_use_flg -- 关键字段结合使用标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GUARTYPE -- 押品类型代码
    ,P1.GUARNAME -- 押品类型名称
    ,NVL(TRIM(P1.UPGUARTYPE),'-') -- 上层节点类型代码
    ,P1.LEVELCODE -- 级别
    ,P1.ISLEAF -- 基础类别标志
    ,NVL(TRIM(P1.TNAME),'-') -- 专项信息类型代码
    ,P1.KEYCOLUMN -- 关键字段A
    ,NVL(TRIM(P1.EFFECTTYPE),'00') -- 生效方式代码
    ,P1.GUARANTEEACCEXPLAIN -- 押品描述
    ,P1.STATE -- 状态描述
    ,P1.ALLENTERYSTATUS -- 准入分类
    ,${iml_schema}.dateformat_max(P1.MOTIME) -- 修改日期
    ,P1.DEPTCODE -- 修改机构编号
    ,NVL(TRIM(P1.DATATYPE),'-') -- 数据类型代码
    ,P1.GUARANTEETYPE -- 担保准入分类代码
    ,P1.MODIFIER -- 修改员工编号
    ,NVL(TRIM(P1.EVALFREQUENCY),'-') -- 重估频率代码
    ,P1.HIGHESTGUARRATE -- 最高抵质押率
    ,P1.KEYCOLUMN1 -- 关键字段B
    ,NVL(TRIM(P1.GENERA),'0') -- 大类代码
    ,P1.ISNEEDPEOPLECHECK -- 人工认定标志
    ,P1.FZ -- 阀值
    ,P1.BARSIGN -- 条线代码
    ,NVL(TRIM(P1.ABTYPE),'-') -- AB类划分代码
    ,P1.ISUNION -- 关键字段结合使用标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_guarwarrantsinfo' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_guarwarrantsinfo p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_type_def_mimsf1_tm 
  	                                group by 
  	                                        col_type_cd
  	                                        ,strip_line_cd
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
insert /*+ append */ into ${iml_schema}.ast_col_type_def_mimsf1_ex(
    col_type_cd -- 押品类型代码
    ,col_type_name -- 押品类型名称
    ,up_level_node_type_cd -- 上层节点类型代码
    ,lev -- 级别
    ,base_cate_flg -- 基础类别标志
    ,spcl_info_type_cd -- 专项信息类型代码
    ,keyw_a -- 关键字段A
    ,effect_way_cd -- 生效方式代码
    ,col_descb -- 押品描述
    ,status_descb -- 状态描述
    ,admit_cls -- 准入分类
    ,modif_dt -- 修改日期
    ,modif_org_id -- 修改机构编号
    ,data_type_cd -- 数据类型代码
    ,guar_admit_cls_cd -- 担保准入分类代码
    ,modif_emply_id -- 修改员工编号
    ,reval_freq_cd -- 重估频率代码
    ,higt_pm_rat -- 最高抵质押率
    ,keyw_b -- 关键字段B
    ,gen_cd -- 大类代码
    ,manu_idtfy_flg -- 人工认定标志
    ,tshold -- 阀值
    ,strip_line_cd -- 条线代码
    ,ab_divd_cd -- AB类划分代码
    ,keyw_comb_use_flg -- 关键字段结合使用标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.col_type_cd, o.col_type_cd) as col_type_cd -- 押品类型代码
    ,nvl(n.col_type_name, o.col_type_name) as col_type_name -- 押品类型名称
    ,nvl(n.up_level_node_type_cd, o.up_level_node_type_cd) as up_level_node_type_cd -- 上层节点类型代码
    ,nvl(n.lev, o.lev) as lev -- 级别
    ,nvl(n.base_cate_flg, o.base_cate_flg) as base_cate_flg -- 基础类别标志
    ,nvl(n.spcl_info_type_cd, o.spcl_info_type_cd) as spcl_info_type_cd -- 专项信息类型代码
    ,nvl(n.keyw_a, o.keyw_a) as keyw_a -- 关键字段A
    ,nvl(n.effect_way_cd, o.effect_way_cd) as effect_way_cd -- 生效方式代码
    ,nvl(n.col_descb, o.col_descb) as col_descb -- 押品描述
    ,nvl(n.status_descb, o.status_descb) as status_descb -- 状态描述
    ,nvl(n.admit_cls, o.admit_cls) as admit_cls -- 准入分类
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 修改日期
    ,nvl(n.modif_org_id, o.modif_org_id) as modif_org_id -- 修改机构编号
    ,nvl(n.data_type_cd, o.data_type_cd) as data_type_cd -- 数据类型代码
    ,nvl(n.guar_admit_cls_cd, o.guar_admit_cls_cd) as guar_admit_cls_cd -- 担保准入分类代码
    ,nvl(n.modif_emply_id, o.modif_emply_id) as modif_emply_id -- 修改员工编号
    ,nvl(n.reval_freq_cd, o.reval_freq_cd) as reval_freq_cd -- 重估频率代码
    ,nvl(n.higt_pm_rat, o.higt_pm_rat) as higt_pm_rat -- 最高抵质押率
    ,nvl(n.keyw_b, o.keyw_b) as keyw_b -- 关键字段B
    ,nvl(n.gen_cd, o.gen_cd) as gen_cd -- 大类代码
    ,nvl(n.manu_idtfy_flg, o.manu_idtfy_flg) as manu_idtfy_flg -- 人工认定标志
    ,nvl(n.tshold, o.tshold) as tshold -- 阀值
    ,nvl(n.strip_line_cd, o.strip_line_cd) as strip_line_cd -- 条线代码
    ,nvl(n.ab_divd_cd, o.ab_divd_cd) as ab_divd_cd -- AB类划分代码
    ,nvl(n.keyw_comb_use_flg, o.keyw_comb_use_flg) as keyw_comb_use_flg -- 关键字段结合使用标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.col_type_cd is null
                and o.strip_line_cd is null
            ) or (
                o.col_type_name <> n.col_type_name
                or o.up_level_node_type_cd <> n.up_level_node_type_cd
                or o.lev <> n.lev
                or o.base_cate_flg <> n.base_cate_flg
                or o.spcl_info_type_cd <> n.spcl_info_type_cd
                or o.keyw_a <> n.keyw_a
                or o.effect_way_cd <> n.effect_way_cd
                or o.col_descb <> n.col_descb
                or o.status_descb <> n.status_descb
                or o.admit_cls <> n.admit_cls
                or o.modif_dt <> n.modif_dt
                or o.modif_org_id <> n.modif_org_id
                or o.data_type_cd <> n.data_type_cd
                or o.guar_admit_cls_cd <> n.guar_admit_cls_cd
                or o.modif_emply_id <> n.modif_emply_id
                or o.reval_freq_cd <> n.reval_freq_cd
                or o.higt_pm_rat <> n.higt_pm_rat
                or o.keyw_b <> n.keyw_b
                or o.gen_cd <> n.gen_cd
                or o.manu_idtfy_flg <> n.manu_idtfy_flg
                or o.tshold <> n.tshold
                or o.ab_divd_cd <> n.ab_divd_cd
                or o.keyw_comb_use_flg <> n.keyw_comb_use_flg
            ) or (
                 case when (
                           n.col_type_cd is null
                           and n.strip_line_cd is null
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
                n.col_type_cd is null
                and n.strip_line_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_type_def_mimsf1_tm n
    full join ${iml_schema}.ast_col_type_def_mimsf1_bk o
        on
            o.col_type_cd = n.col_type_cd
            and o.strip_line_cd = n.strip_line_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_type_def truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_type_def exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_type_def_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_type_def drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_type_def to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_type_def_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_type_def_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_type_def_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_type_def', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);