/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_inv_info_mimsf1
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
drop table ${iml_schema}.ast_col_inv_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_inv_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_inv_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_inv_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_inv_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_inv_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_inv_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,inv_type_descb -- 存货类型描述
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,measure_corp_cd -- 计量单位代码
    ,qtty -- 数量
    ,apprv_price -- 核定价格
    ,supv_corp_supv_flg -- 监管公司监管标志
    ,supv_corp_name -- 监管公司名称
    ,supv_corp_orgnz_cd -- 监管公司组织机构代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,other_comnt -- 其他说明
    ,other_measure_corp -- 其他计量单位
    ,curr_cd -- 币种代码
    ,mtg_rgst_b_id -- 抵押登记书编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_inv_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_inv_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_inv_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_inventory-
insert into ${iml_schema}.ast_col_inv_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,inv_type_descb -- 存货类型描述
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,measure_corp_cd -- 计量单位代码
    ,qtty -- 数量
    ,apprv_price -- 核定价格
    ,supv_corp_supv_flg -- 监管公司监管标志
    ,supv_corp_name -- 监管公司名称
    ,supv_corp_orgnz_cd -- 监管公司组织机构代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,other_comnt -- 其他说明
    ,other_measure_corp -- 其他计量单位
    ,curr_cd -- 币种代码
    ,mtg_rgst_b_id -- 抵押登记书编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.REGION -- 存货类型描述
    ,NVL(TRIM(P1.PROVINCE),'000000') -- 所在省代码
    ,NVL(TRIM(P1.CITY),'000000') -- 所在市代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.UNIT END -- 计量单位代码
    ,P1.AMOUNT -- 数量
    ,P1.TOTALVALUE -- 核定价格
    ,NVL(TRIM(P1.ISREG),'-') -- 监管公司监管标志
    ,P1.REGULATORY -- 监管公司名称
    ,P1.REGULATORYCODE -- 监管公司组织机构代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENDDATE) -- 协议失效日期
    ,P1.REMARK -- 其他说明
    ,P1.OTHERREMARK -- 其他计量单位
    ,NVL(TRIM(P1.TDCURRENCY),'CNY') -- 币种代码
    ,P1.GUARINFONO -- 抵押登记书编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_inventory' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_inventory p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.UNIT = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_INVENTORY'
        AND R1.SRC_FIELD_EN_NAME= 'UNIT'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_INV_INFO'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_inv_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_inv_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,inv_type_descb -- 存货类型描述
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,measure_corp_cd -- 计量单位代码
    ,qtty -- 数量
    ,apprv_price -- 核定价格
    ,supv_corp_supv_flg -- 监管公司监管标志
    ,supv_corp_name -- 监管公司名称
    ,supv_corp_orgnz_cd -- 监管公司组织机构代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,other_comnt -- 其他说明
    ,other_measure_corp -- 其他计量单位
    ,curr_cd -- 币种代码
    ,mtg_rgst_b_id -- 抵押登记书编号
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
    ,nvl(n.inv_type_descb, o.inv_type_descb) as inv_type_descb -- 存货类型描述
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.measure_corp_cd, o.measure_corp_cd) as measure_corp_cd -- 计量单位代码
    ,nvl(n.qtty, o.qtty) as qtty -- 数量
    ,nvl(n.apprv_price, o.apprv_price) as apprv_price -- 核定价格
    ,nvl(n.supv_corp_supv_flg, o.supv_corp_supv_flg) as supv_corp_supv_flg -- 监管公司监管标志
    ,nvl(n.supv_corp_name, o.supv_corp_name) as supv_corp_name -- 监管公司名称
    ,nvl(n.supv_corp_orgnz_cd, o.supv_corp_orgnz_cd) as supv_corp_orgnz_cd -- 监管公司组织机构代码
    ,nvl(n.agt_effect_dt, o.agt_effect_dt) as agt_effect_dt -- 协议生效日期
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.other_measure_corp, o.other_measure_corp) as other_measure_corp -- 其他计量单位
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.mtg_rgst_b_id, o.mtg_rgst_b_id) as mtg_rgst_b_id -- 抵押登记书编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.inv_type_descb <> n.inv_type_descb
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.measure_corp_cd <> n.measure_corp_cd
                or o.qtty <> n.qtty
                or o.apprv_price <> n.apprv_price
                or o.supv_corp_supv_flg <> n.supv_corp_supv_flg
                or o.supv_corp_name <> n.supv_corp_name
                or o.supv_corp_orgnz_cd <> n.supv_corp_orgnz_cd
                or o.agt_effect_dt <> n.agt_effect_dt
                or o.agt_invalid_dt <> n.agt_invalid_dt
                or o.other_comnt <> n.other_comnt
                or o.other_measure_corp <> n.other_measure_corp
                or o.curr_cd <> n.curr_cd
                or o.mtg_rgst_b_id <> n.mtg_rgst_b_id
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
from ${iml_schema}.ast_col_inv_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_inv_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_inv_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_inv_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_inv_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_inv_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_inv_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_inv_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_inv_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_inv_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_inv_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);