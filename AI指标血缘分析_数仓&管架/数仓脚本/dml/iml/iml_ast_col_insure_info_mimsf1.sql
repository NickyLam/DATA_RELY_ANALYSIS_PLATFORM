/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_insure_info_mimsf1
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
drop table ${iml_schema}.ast_col_insure_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_insure_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_insure_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_insure_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_insure_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_insure_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,insure_seq_num -- 保险序号
    ,insure_pl_id -- 保险单编号
    ,insu_comp_name -- 保险公司名称
    ,insu_comp_orgnz_cd -- 保险公司组织机构代码
    ,full_amt_insure_flg -- 全额投保标志
    ,insure_insud_amt -- 保险承保金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人姓名
    ,secd_ctfer_name -- 第二核保人姓名
    ,operr_id -- 操作员编号
    ,insure_status_cd -- 保险状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_insure_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_insure_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_insurance-
insert into ${iml_schema}.ast_col_insure_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,insure_seq_num -- 保险序号
    ,insure_pl_id -- 保险单编号
    ,insu_comp_name -- 保险公司名称
    ,insu_comp_orgnz_cd -- 保险公司组织机构代码
    ,full_amt_insure_flg -- 全额投保标志
    ,insure_insud_amt -- 保险承保金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人姓名
    ,secd_ctfer_name -- 第二核保人姓名
    ,operr_id -- 操作员编号
    ,insure_status_cd -- 保险状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.INCODE -- 保险序号
    ,P1.INNO -- 保险单编号
    ,P1.INSURNAME -- 保险公司名称
    ,P1.INSURCODE -- 保险公司组织机构代码
    ,P1.ISFULLGUAR -- 全额投保标志
    ,P1.INSUMN -- 保险承保金额
    ,${iml_schema}.dateformat_min(P1.STDATE) -- 起始日期
    ,${iml_schema}.dateformat_max(P1.EDDATE) -- 到期日期
    ,${iml_schema}.dateformat_max(P1.EFDATE) -- 核保日期
    ,P1.UNDERWRITERS1 -- 第一核保人姓名
    ,P1.UNDERWRITERS2 -- 第二核保人姓名
    ,P1.OPERATORID -- 操作员编号
    ,nvl(TRIM(P1.STATE),'0') -- 保险状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_insurance' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_insurance p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_insure_info_mimsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                                        ,insure_seq_num
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
insert /*+ append */ into ${iml_schema}.ast_col_insure_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,insure_seq_num -- 保险序号
    ,insure_pl_id -- 保险单编号
    ,insu_comp_name -- 保险公司名称
    ,insu_comp_orgnz_cd -- 保险公司组织机构代码
    ,full_amt_insure_flg -- 全额投保标志
    ,insure_insud_amt -- 保险承保金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人姓名
    ,secd_ctfer_name -- 第二核保人姓名
    ,operr_id -- 操作员编号
    ,insure_status_cd -- 保险状态代码
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
    ,nvl(n.insure_seq_num, o.insure_seq_num) as insure_seq_num -- 保险序号
    ,nvl(n.insure_pl_id, o.insure_pl_id) as insure_pl_id -- 保险单编号
    ,nvl(n.insu_comp_name, o.insu_comp_name) as insu_comp_name -- 保险公司名称
    ,nvl(n.insu_comp_orgnz_cd, o.insu_comp_orgnz_cd) as insu_comp_orgnz_cd -- 保险公司组织机构代码
    ,nvl(n.full_amt_insure_flg, o.full_amt_insure_flg) as full_amt_insure_flg -- 全额投保标志
    ,nvl(n.insure_insud_amt, o.insure_insud_amt) as insure_insud_amt -- 保险承保金额
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.check_guar_dt, o.check_guar_dt) as check_guar_dt -- 核保日期
    ,nvl(n.fst_ctfer_name, o.fst_ctfer_name) as fst_ctfer_name -- 第一核保人姓名
    ,nvl(n.secd_ctfer_name, o.secd_ctfer_name) as secd_ctfer_name -- 第二核保人姓名
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.insure_status_cd, o.insure_status_cd) as insure_status_cd -- 保险状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
                and o.insure_seq_num is null
            ) or (
                o.insure_pl_id <> n.insure_pl_id
                or o.insu_comp_name <> n.insu_comp_name
                or o.insu_comp_orgnz_cd <> n.insu_comp_orgnz_cd
                or o.full_amt_insure_flg <> n.full_amt_insure_flg
                or o.insure_insud_amt <> n.insure_insud_amt
                or o.begin_dt <> n.begin_dt
                or o.exp_dt <> n.exp_dt
                or o.check_guar_dt <> n.check_guar_dt
                or o.fst_ctfer_name <> n.fst_ctfer_name
                or o.secd_ctfer_name <> n.secd_ctfer_name
                or o.operr_id <> n.operr_id
                or o.insure_status_cd <> n.insure_status_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                           and n.insure_seq_num is null
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
                and n.insure_seq_num is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_insure_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.insure_seq_num = n.insure_seq_num
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_insure_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_insure_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_insure_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_insure_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_insure_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_insure_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_insure_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_insure_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);