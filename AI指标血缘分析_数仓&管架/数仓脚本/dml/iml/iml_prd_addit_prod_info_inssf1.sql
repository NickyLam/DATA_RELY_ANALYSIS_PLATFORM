/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_addit_prod_info_inssf1
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
drop table ${iml_schema}.prd_addit_prod_info_inssf1_tm purge;
drop table ${iml_schema}.prd_addit_prod_info_inssf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_addit_prod_info add partition p_inssf1 values ('inssf1')(
        subpartition p_inssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_addit_prod_info modify partition p_inssf1
    add subpartition p_inssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_addit_prod_info_inssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_addit_prod_info partition for ('inssf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_addit_prod_info_inssf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,main_prod_id -- 主险产品编号
    ,addit_prod_name -- 附加险产品名称
    ,insu_comp_addit_prod_id -- 保险公司附加险产品编号
    ,permium_calc_corp_type_cd -- 保费计算单位类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_addit_prod_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_addit_prod_info_inssf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_addit_prod_info partition for ('inssf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbinsureadd-1
insert into ${iml_schema}.prd_addit_prod_info_inssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,main_prod_id -- 主险产品编号
    ,addit_prod_name -- 附加险产品名称
    ,insu_comp_addit_prod_id -- 保险公司附加险产品编号
    ,permium_calc_corp_type_cd -- 保费计算单位类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRD_ADD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 主险产品编号
    ,P1.PRD_ADD_NAME -- 附加险产品名称
    ,P1.ADD_CODE -- 保险公司附加险产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.FEE_UNIT END -- 保费计算单位类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbinsureadd' -- 源表名称
    ,'inssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbinsureadd p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.FEE_UNIT= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBINSUREADD'
        AND R1.SRC_FIELD_EN_NAME= 'FEE_UNIT'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_ADDIT_PROD_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PERMIUM_CALC_CORP_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_addit_prod_info_inssf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,ta_cd
  	                                        ,main_prod_id
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
insert /*+ append */ into ${iml_schema}.prd_addit_prod_info_inssf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,main_prod_id -- 主险产品编号
    ,addit_prod_name -- 附加险产品名称
    ,insu_comp_addit_prod_id -- 保险公司附加险产品编号
    ,permium_calc_corp_type_cd -- 保费计算单位类型代码
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
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.main_prod_id, o.main_prod_id) as main_prod_id -- 主险产品编号
    ,nvl(n.addit_prod_name, o.addit_prod_name) as addit_prod_name -- 附加险产品名称
    ,nvl(n.insu_comp_addit_prod_id, o.insu_comp_addit_prod_id) as insu_comp_addit_prod_id -- 保险公司附加险产品编号
    ,nvl(n.permium_calc_corp_type_cd, o.permium_calc_corp_type_cd) as permium_calc_corp_type_cd -- 保费计算单位类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.ta_cd is null
                and o.main_prod_id is null
            ) or (
                o.addit_prod_name <> n.addit_prod_name
                or o.insu_comp_addit_prod_id <> n.insu_comp_addit_prod_id
                or o.permium_calc_corp_type_cd <> n.permium_calc_corp_type_cd
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.ta_cd is null
                           and n.main_prod_id is null
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
                and n.ta_cd is null
                and n.main_prod_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_addit_prod_info_inssf1_tm n
    full join ${iml_schema}.prd_addit_prod_info_inssf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.ta_cd = n.ta_cd
            and o.main_prod_id = n.main_prod_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_addit_prod_info truncate partition for ('inssf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_addit_prod_info exchange subpartition p_inssf1_${batch_date} with table ${iml_schema}.prd_addit_prod_info_inssf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_addit_prod_info drop subpartition p_inssf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_addit_prod_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_addit_prod_info_inssf1_tm purge;
drop table ${iml_schema}.prd_addit_prod_info_inssf1_ex purge;
drop table ${iml_schema}.prd_addit_prod_info_inssf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_addit_prod_info', partname => 'p_inssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);