/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_other_mtg_info_mimsf1
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
drop table ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_other_mtg_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_other_mtg_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_other_mtg_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_other_mtg_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_other_mtg_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_qtty -- 押品数量
    ,measure_corp_cd -- 计量单位代码
    ,col_val -- 押品价值
    ,col_store_addr -- 押品存放地址
    ,prop_get_dt -- 所有权取得日期
    ,col_ori_price_val -- 押品原价值
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_other_mtg_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_other_mtg_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_other_mtg_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_otherguaranty-
insert into ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_qtty -- 押品数量
    ,measure_corp_cd -- 计量单位代码
    ,col_val -- 押品价值
    ,col_store_addr -- 押品存放地址
    ,prop_get_dt -- 所有权取得日期
    ,col_ori_price_val -- 押品原价值
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.GUARNAME -- 押品名称
    ,P1.AMOUNT -- 押品数量
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.UNIT END -- 计量单位代码
    ,P1.GUARUNITPRICE -- 押品价值
    ,P1.GUARADDRESS -- 押品存放地址
    ,${iml_schema}.DATEFORMAT_MIN(P1.GAINDATE) -- 所有权取得日期
    ,P1.VALUE -- 押品原价值
    ,P1.REMARK -- 其他说明
    ,nvl(P1.TDCURRENCY,'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_otherguaranty' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_otherguaranty p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.UNIT= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_OTHERGUARANTY'
        AND R1.SRC_FIELD_EN_NAME= 'UNIT'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_OTHER_MTG_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'MEASURE_CORP_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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
insert /*+ append */ into ${iml_schema}.ast_col_other_mtg_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_qtty -- 押品数量
    ,measure_corp_cd -- 计量单位代码
    ,col_val -- 押品价值
    ,col_store_addr -- 押品存放地址
    ,prop_get_dt -- 所有权取得日期
    ,col_ori_price_val -- 押品原价值
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.col_name, o.col_name) as col_name -- 押品名称
    ,nvl(n.col_qtty, o.col_qtty) as col_qtty -- 押品数量
    ,nvl(n.measure_corp_cd, o.measure_corp_cd) as measure_corp_cd -- 计量单位代码
    ,nvl(n.col_val, o.col_val) as col_val -- 押品价值
    ,nvl(n.col_store_addr, o.col_store_addr) as col_store_addr -- 押品存放地址
    ,nvl(n.prop_get_dt, o.prop_get_dt) as prop_get_dt -- 所有权取得日期
    ,nvl(n.col_ori_price_val, o.col_ori_price_val) as col_ori_price_val -- 押品原价值
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.col_name <> n.col_name
                or o.col_qtty <> n.col_qtty
                or o.measure_corp_cd <> n.measure_corp_cd
                or o.col_val <> n.col_val
                or o.col_store_addr <> n.col_store_addr
                or o.prop_get_dt <> n.prop_get_dt
                or o.col_ori_price_val <> n.col_ori_price_val
                or o.other_comnt <> n.other_comnt
                or o.curr_cd <> n.curr_cd
            ) or (
                 case when (
                           n.asset_id is null
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
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_other_mtg_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_other_mtg_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_other_mtg_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_other_mtg_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_other_mtg_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_other_mtg_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_other_mtg_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_other_mtg_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_other_mtg_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_other_mtg_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);