/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ibank_acctnt_type_cd_ibmsf1
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
drop table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_ibank_acctnt_type_cd add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_ibank_acctnt_type_cd modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ibank_acctnt_type_cd partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm
compress ${option_switch} for query high
as
select
    cls_id -- 分类编号
    ,cls_name -- 分类名称
    ,tran_cost_accti_method_cd -- 交易成本核算方法代码
    ,hold_cost_method_cd -- 持有成本方法代码
    ,evltion_method_cd -- 估值方法代码
    ,provi_method_cd -- 计提方法代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,i9_cls_cd -- I9分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_acctnt_type_cd
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_ibank_acctnt_type_cd partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_acctg_account_type-
insert into ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm(
    cls_id -- 分类编号
    ,cls_name -- 分类名称
    ,tran_cost_accti_method_cd -- 交易成本核算方法代码
    ,hold_cost_method_cd -- 持有成本方法代码
    ,evltion_method_cd -- 估值方法代码
    ,provi_method_cd -- 计提方法代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,i9_cls_cd -- I9分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TYPEID -- 分类编号
    ,P1.TYPENAME -- 分类名称
    ,P1.TRADECOSTMETHOD -- 交易成本核算方法代码
    ,P1.HOLDCOSTMETHOD -- 持有成本方法代码
    ,P1.FVMETHOD -- 估值方法代码
    ,P1.AIMETHOD -- 计提方法代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.I9_CLASS) END -- 资产三分类代码
    ,P1.I9_CLASS_M -- I9分类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_acctg_account_type' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_acctg_account_type p1
    left join ${iml_schema}.ref_pub_cd_map r1 on to_char(P1.I9_CLASS) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_ACCTG_ACCOUNT_TYPE'
        AND R1.SRC_FIELD_EN_NAME= 'I9_CLASS'
        AND R1.TARGET_TAB_EN_NAME= 'REF_IBANK_ACCTNT_TYPE_CD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ASSET_THD_CLS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm 
  	                                group by 
  	                                        cls_id
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
insert /*+ append */ into ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_ex(
    cls_id -- 分类编号
    ,cls_name -- 分类名称
    ,tran_cost_accti_method_cd -- 交易成本核算方法代码
    ,hold_cost_method_cd -- 持有成本方法代码
    ,evltion_method_cd -- 估值方法代码
    ,provi_method_cd -- 计提方法代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,i9_cls_cd -- I9分类代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.cls_id, o.cls_id) as cls_id -- 分类编号
    ,nvl(n.cls_name, o.cls_name) as cls_name -- 分类名称
    ,nvl(n.tran_cost_accti_method_cd, o.tran_cost_accti_method_cd) as tran_cost_accti_method_cd -- 交易成本核算方法代码
    ,nvl(n.hold_cost_method_cd, o.hold_cost_method_cd) as hold_cost_method_cd -- 持有成本方法代码
    ,nvl(n.evltion_method_cd, o.evltion_method_cd) as evltion_method_cd -- 估值方法代码
    ,nvl(n.provi_method_cd, o.provi_method_cd) as provi_method_cd -- 计提方法代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.i9_cls_cd, o.i9_cls_cd) as i9_cls_cd -- I9分类代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.cls_id is null
            ) or (
                o.cls_name <> n.cls_name
                or o.tran_cost_accti_method_cd <> n.tran_cost_accti_method_cd
                or o.hold_cost_method_cd <> n.hold_cost_method_cd
                or o.evltion_method_cd <> n.evltion_method_cd
                or o.provi_method_cd <> n.provi_method_cd
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.i9_cls_cd <> n.i9_cls_cd
            ) or (
                 case when (
                           n.cls_id is null
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
                n.cls_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm n
    full join ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_bk o
        on
            o.cls_id = n.cls_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_ibank_acctnt_type_cd truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_ibank_acctnt_type_cd exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_ibank_acctnt_type_cd drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ibank_acctnt_type_cd to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_tm purge;
drop table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_ex purge;
drop table ${iml_schema}.ref_ibank_acctnt_type_cd_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ibank_acctnt_type_cd', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);