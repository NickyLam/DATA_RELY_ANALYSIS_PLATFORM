/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_prft_weight_info_icmsf1
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
drop table ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_prft_weight_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_prft_weight_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_prft_weight_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_prft_weight_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_prft_weight_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,prft_weight_gover_doc_id -- 收益权政府批文编号
    ,prft_weight_gover_doc_name -- 收益权政府批文名称
    ,eqty_cert_id -- 权益证书编号
    ,eqty_owner_name -- 权益所有人名称
    ,eqty_start_dt -- 权益开始日期
    ,eqty_exp_dt -- 权益到期日期
    ,other_comnt -- 其他说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_prft_weight_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_prft_weight_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_prft_weight_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_asset_finance_profit-
insert into ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,prft_weight_gover_doc_id -- 收益权政府批文编号
    ,prft_weight_gover_doc_name -- 收益权政府批文名称
    ,eqty_cert_id -- 权益证书编号
    ,eqty_owner_name -- 权益所有人名称
    ,eqty_start_dt -- 权益开始日期
    ,eqty_exp_dt -- 权益到期日期
    ,other_comnt -- 其他说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,P1.INAPPDOCNO -- 收益权政府批文编号
    ,P1.INAPPDOCNUM -- 收益权政府批文名称
    ,P1.OWNERNO -- 权益证书编号
    ,P1.OWNERNAME -- 权益所有人名称
    ,P1.STARTDATE -- 权益开始日期
    ,P1.DUEDATE -- 权益到期日期
    ,P1.REMARK -- 其他说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_finance_profit' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_finance_profit p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_prft_weight_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,prft_weight_gover_doc_id -- 收益权政府批文编号
    ,prft_weight_gover_doc_name -- 收益权政府批文名称
    ,eqty_cert_id -- 权益证书编号
    ,eqty_owner_name -- 权益所有人名称
    ,eqty_start_dt -- 权益开始日期
    ,eqty_exp_dt -- 权益到期日期
    ,other_comnt -- 其他说明
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
    ,nvl(n.prft_weight_gover_doc_id, o.prft_weight_gover_doc_id) as prft_weight_gover_doc_id -- 收益权政府批文编号
    ,nvl(n.prft_weight_gover_doc_name, o.prft_weight_gover_doc_name) as prft_weight_gover_doc_name -- 收益权政府批文名称
    ,nvl(n.eqty_cert_id, o.eqty_cert_id) as eqty_cert_id -- 权益证书编号
    ,nvl(n.eqty_owner_name, o.eqty_owner_name) as eqty_owner_name -- 权益所有人名称
    ,nvl(n.eqty_start_dt, o.eqty_start_dt) as eqty_start_dt -- 权益开始日期
    ,nvl(n.eqty_exp_dt, o.eqty_exp_dt) as eqty_exp_dt -- 权益到期日期
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.prft_weight_gover_doc_id <> n.prft_weight_gover_doc_id
                or o.prft_weight_gover_doc_name <> n.prft_weight_gover_doc_name
                or o.eqty_cert_id <> n.eqty_cert_id
                or o.eqty_owner_name <> n.eqty_owner_name
                or o.eqty_start_dt <> n.eqty_start_dt
                or o.eqty_exp_dt <> n.eqty_exp_dt
                or o.other_comnt <> n.other_comnt
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
from ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_prft_weight_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_prft_weight_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_prft_weight_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_prft_weight_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_prft_weight_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_prft_weight_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_prft_weight_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_prft_weight_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_prft_weight_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_prft_weight_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);