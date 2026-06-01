/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ifs_prod_ifcsf1
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
drop table ${iml_schema}.prd_ifs_prod_ifcsf1_tm purge;
drop table ${iml_schema}.prd_ifs_prod_ifcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ifs_prod add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ifs_prod modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ifs_prod_ifcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ifs_prod partition for ('ifcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ifs_prod_ifcsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,sav_type_cd -- 储种代码
    ,dep_term_cd -- 存期代码
    ,pric_accting_code -- 本金会计核算码
    ,int_paybl_accting_code -- 应付利息会计核算码
    ,int_expns_accting_code -- 利息支出会计核算码
    ,accti_org_id -- 核算机构编号
    ,exec_int_rat_cate_cd -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd -- 逾期利率类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ifs_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ifs_prod_ifcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ifs_prod partition for ('ifcsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifcs_prod_info-
insert into ${iml_schema}.prd_ifs_prod_ifcsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,sav_type_cd -- 储种代码
    ,dep_term_cd -- 存期代码
    ,pric_accting_code -- 本金会计核算码
    ,int_paybl_accting_code -- 应付利息会计核算码
    ,int_expns_accting_code -- 利息支出会计核算码
    ,accti_org_id -- 核算机构编号
    ,exec_int_rat_cate_cd -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd -- 逾期利率类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.CURR_CD -- 币种代码
    ,P1.SAV_TYPE_CD -- 储种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DEP_TERM_CD END -- 存期代码
    ,P1.ACCTING_CODE -- 本金会计核算码
    ,P1.INT_PAYBL_ACCTING_CODE -- 应付利息会计核算码
    ,P1.INT_EXPNS_ACCTING_CODE -- 利息支出会计核算码
    ,P1.ACCTI_ORG -- 核算机构编号
    ,P1.EXEC_INT_RAT_CD -- 执行利率类别代码
    ,P1.PA_EXT_INT_RAT_CD -- 部提利率类别代码
    ,P1.OVDUE_INT_RAT_CD -- 逾期利率类别代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_prod_info' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_prod_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DEP_TERM_CD = R1.SRC_CODE_VAL 
 AND R1.SORC_SYS_CD= 'IFCS'
 AND R1.SRC_TAB_EN_NAME= 'IFCS_PROD_INFO'
 AND R1.SRC_FIELD_EN_NAME= 'DEP_TERM_CD'
 AND R1.TARGET_TAB_EN_NAME= 'PRD_IFS_PROD'
 AND R1.TARGET_TAB_FIELD_EN_NAME= 'DEP_TERM_CD'
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ifs_prod_ifcsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_ifs_prod_ifcsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,sav_type_cd -- 储种代码
    ,dep_term_cd -- 存期代码
    ,pric_accting_code -- 本金会计核算码
    ,int_paybl_accting_code -- 应付利息会计核算码
    ,int_expns_accting_code -- 利息支出会计核算码
    ,accti_org_id -- 核算机构编号
    ,exec_int_rat_cate_cd -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd -- 逾期利率类别代码
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
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sav_type_cd, o.sav_type_cd) as sav_type_cd -- 储种代码
    ,nvl(n.dep_term_cd, o.dep_term_cd) as dep_term_cd -- 存期代码
    ,nvl(n.pric_accting_code, o.pric_accting_code) as pric_accting_code -- 本金会计核算码
    ,nvl(n.int_paybl_accting_code, o.int_paybl_accting_code) as int_paybl_accting_code -- 应付利息会计核算码
    ,nvl(n.int_expns_accting_code, o.int_expns_accting_code) as int_expns_accting_code -- 利息支出会计核算码
    ,nvl(n.accti_org_id, o.accti_org_id) as accti_org_id -- 核算机构编号
    ,nvl(n.exec_int_rat_cate_cd, o.exec_int_rat_cate_cd) as exec_int_rat_cate_cd -- 执行利率类别代码
    ,nvl(n.pa_ext_int_rat_cate_cd, o.pa_ext_int_rat_cate_cd) as pa_ext_int_rat_cate_cd -- 部提利率类别代码
    ,nvl(n.ovdue_int_rat_cate_cd, o.ovdue_int_rat_cate_cd) as ovdue_int_rat_cate_cd -- 逾期利率类别代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.curr_cd <> n.curr_cd
                or o.sav_type_cd <> n.sav_type_cd
                or o.dep_term_cd <> n.dep_term_cd
                or o.pric_accting_code <> n.pric_accting_code
                or o.int_paybl_accting_code <> n.int_paybl_accting_code
                or o.int_expns_accting_code <> n.int_expns_accting_code
                or o.accti_org_id <> n.accti_org_id
                or o.exec_int_rat_cate_cd <> n.exec_int_rat_cate_cd
                or o.pa_ext_int_rat_cate_cd <> n.pa_ext_int_rat_cate_cd
                or o.ovdue_int_rat_cate_cd <> n.ovdue_int_rat_cate_cd
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
from ${iml_schema}.prd_ifs_prod_ifcsf1_tm n
    full join ${iml_schema}.prd_ifs_prod_ifcsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ifs_prod truncate partition for ('ifcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ifs_prod exchange subpartition p_ifcsf1_${batch_date} with table ${iml_schema}.prd_ifs_prod_ifcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ifs_prod drop subpartition p_ifcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ifs_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ifs_prod_ifcsf1_tm purge;
drop table ${iml_schema}.prd_ifs_prod_ifcsf1_ex purge;
drop table ${iml_schema}.prd_ifs_prod_ifcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ifs_prod', partname => 'p_ifcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);