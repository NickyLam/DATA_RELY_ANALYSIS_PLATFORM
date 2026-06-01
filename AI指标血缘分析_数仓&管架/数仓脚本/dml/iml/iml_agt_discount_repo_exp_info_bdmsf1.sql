/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_discount_repo_exp_info_bdmsf1
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
drop table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_discount_repo_exp_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_discount_repo_exp_info modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_discount_repo_exp_info partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm
compress ${option_switch} for query high
as
select
    repo_exp_id -- 回购到期编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,bus_dt -- 业务日期
    ,batch_id -- 批次编号
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_discount_repo_exp_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_discount_repo_exp_info partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_cpes_quote_due-
insert into ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm(
    repo_exp_id -- 回购到期编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,bus_dt -- 业务日期
    ,batch_id -- 批次编号
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 回购到期编号
    ,'9999' -- 法人编号
    ,P1.CONTRACT_NO -- 合同编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BUSI_DATE) -- 业务日期
    ,P1.ORG_CPES_QUOTE_CONTRACT_ID -- 批次编号
    ,P1.PRODUCT_NO -- 产品编号
    ,NVL(TRIM(P1.BUSI_TYPE),'BT00') -- 业务类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,P1.BUSI_BRANCH_NO -- 业务机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,NVL(TRIM(P1.SETTLE_STATUS),'-') -- 清算状态代码
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_quote_due' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_quote_due p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_DIRECT= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_DUE'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISCOUNT_REPO_EXP_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_DUE'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISCOUNT_REPO_EXP_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm 
  	                                group by 
  	                                        repo_exp_id
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
insert /*+ append */ into ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_ex(
    repo_exp_id -- 回购到期编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,bus_dt -- 业务日期
    ,batch_id -- 批次编号
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,entry_status_cd -- 记账状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.repo_exp_id, o.repo_exp_id) as repo_exp_id -- 回购到期编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.bus_dt, o.bus_dt) as bus_dt -- 业务日期
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.bus_org_id, o.bus_org_id) as bus_org_id -- 业务机构编号
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.clear_status_cd, o.clear_status_cd) as clear_status_cd -- 清算状态代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.repo_exp_id is null
                and o.lp_id is null
            ) or (
                o.cont_id <> n.cont_id
                or o.bus_dt <> n.bus_dt
                or o.batch_id <> n.batch_id
                or o.prod_id <> n.prod_id
                or o.bus_type_cd <> n.bus_type_cd
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.bus_org_id <> n.bus_org_id
                or o.entry_status_cd <> n.entry_status_cd
                or o.clear_status_cd <> n.clear_status_cd
                or o.final_modif_tm <> n.final_modif_tm
            ) or (
                 case when (
                           n.repo_exp_id is null
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
                n.repo_exp_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm n
    full join ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_bk o
        on
            o.repo_exp_id = n.repo_exp_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_discount_repo_exp_info truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_discount_repo_exp_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_discount_repo_exp_info drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_discount_repo_exp_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_ex purge;
drop table ${iml_schema}.agt_discount_repo_exp_info_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_discount_repo_exp_info', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);