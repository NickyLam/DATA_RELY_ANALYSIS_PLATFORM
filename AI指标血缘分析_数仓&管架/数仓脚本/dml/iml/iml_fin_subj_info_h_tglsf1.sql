/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_subj_info_h_tglsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.fin_subj_info_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_subj_info_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_subj_info_h partition for ('tglsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_subj_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_subj_info_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_subj_info_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.fin_subj_info_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_subj_info_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.fin_subj_info_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_subj_info_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_com_item-1
insert into ${iml_schema}.fin_subj_info_h_tglsf1_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.STACID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.ITEMCD -- 科目编号
    ,P1.SPRRCD -- 上级科目编号
    ,P1.ITEMNA -- 科目名称
    ,P1.ITEMLV -- 科目等级代码
    ,P1.ITEMTP -- 科目类型代码
    ,P1.ITEMPR -- 科目属性代码
    ,P1.DETLTG -- 末级科目标志
    ,P1.ITEMDN -- 科目余额方向代码
    ,P1.USEDTP -- 科目状态代码
    ,P1.CONFIN -- 受限科目标志
    ,P1.POMDTG -- 透支标志
    ,P1.MNTYTG -- 货币性项目代码
    ,P1.INACTP -- 建账类型代码
    ,P1.ITEMCL -- 科目归属代码
    ,decode(trim(P1.IOFLAG),'I','1','O','2','0') -- 表内标志
    ,P1.HDOPMD -- 手工开户受理模式代码
    ,${iml_schema}.dateformat_max2(P1.BEGNDT) -- 启用日期
    ,${iml_schema}.dateformat_max2(P1.OVERDT) -- 停用日期
    ,P1.USESYS -- 科目使用系统代码
    ,decode(P1.HAPPEN,'DC','B',NVL(TRIM(P1.HAPPEN),'-')) -- 科目发生额方向代码
    ,P1.SEPATG -- 价税分离代码
    ,nvl(trim(P1.WARNING),'-') -- 科目余额浮动预警标志
    ,${iml_schema}.dateformat_max2(P1.COUNBE) -- 柜面手工记账开始日期
    ,${iml_schema}.dateformat_max2(P1.COUNOV) -- 柜面手工记账结束日期
    ,${iml_schema}.dateformat_max2(P1.CHECKBE) -- 核算中台手工记账开始日期
    ,${iml_schema}.dateformat_max2(P1.CHECKOV) -- 核算中台手工记账结束日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_com_item' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_com_item p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_subj_info_h_tglsf1_tm 
  	                                group by 
  	                                        sob_id
  	                                        ,lp_id
  	                                        ,subj_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_subj_info_h_tglsf1_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_subj_info_h_tglsf1_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.super_subj_id, o.super_subj_id) as super_subj_id -- 上级科目编号
    ,nvl(n.subj_name, o.subj_name) as subj_name -- 科目名称
    ,nvl(n.subj_level_cd, o.subj_level_cd) as subj_level_cd -- 科目等级代码
    ,nvl(n.subj_type_cd, o.subj_type_cd) as subj_type_cd -- 科目类型代码
    ,nvl(n.subj_attr_cd, o.subj_attr_cd) as subj_attr_cd -- 科目属性代码
    ,nvl(n.end_level_subj_flg, o.end_level_subj_flg) as end_level_subj_flg -- 末级科目标志
    ,nvl(n.subj_bal_dir_cd, o.subj_bal_dir_cd) as subj_bal_dir_cd -- 科目余额方向代码
    ,nvl(n.subj_status_cd, o.subj_status_cd) as subj_status_cd -- 科目状态代码
    ,nvl(n.lmt_subj_flg, o.lmt_subj_flg) as lmt_subj_flg -- 受限科目标志
    ,nvl(n.allow_od_flg, o.allow_od_flg) as allow_od_flg -- 透支标志
    ,nvl(n.curr_char_proj_cd, o.curr_char_proj_cd) as curr_char_proj_cd -- 货币性项目代码
    ,nvl(n.setup_acct_type_cd, o.setup_acct_type_cd) as setup_acct_type_cd -- 建账类型代码
    ,nvl(n.subj_belong_cd, o.subj_belong_cd) as subj_belong_cd -- 科目归属代码
    ,nvl(n.in_bs_flg, o.in_bs_flg) as in_bs_flg -- 表内标志
    ,nvl(n.manual_open_acct_proc_mode_cd, o.manual_open_acct_proc_mode_cd) as manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,nvl(n.start_use_dt, o.start_use_dt) as start_use_dt -- 启用日期
    ,nvl(n.stop_use_dt, o.stop_use_dt) as stop_use_dt -- 停用日期
    ,nvl(n.subj_use_sys_cd, o.subj_use_sys_cd) as subj_use_sys_cd -- 科目使用系统代码
    ,nvl(n.subj_amt_dir_cd, o.subj_amt_dir_cd) as subj_amt_dir_cd -- 科目发生额方向代码
    ,nvl(n.price_tax_sept_cd, o.price_tax_sept_cd) as price_tax_sept_cd -- 价税分离代码
    ,nvl(n.subj_bal_float_warn_flg, o.subj_bal_float_warn_flg) as subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,nvl(n.cnter_manual_entry_start_dt, o.cnter_manual_entry_start_dt) as cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,nvl(n.cnter_manual_entry_end_dt, o.cnter_manual_entry_end_dt) as cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,nvl(n.accti_midgrod_manual_entry_start_dt, o.accti_midgrod_manual_entry_start_dt) as accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,nvl(n.accti_midgrod_manual_entry_end_dt, o.accti_midgrod_manual_entry_end_dt) as accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
            and n.subj_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_subj_info_h_tglsf1_tm n
    full join (select * from ${iml_schema}.fin_subj_info_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.subj_id = n.subj_id
where (
        o.sob_id is null
        and o.lp_id is null
        and o.subj_id is null
    )
    or (
        n.sob_id is null
        and n.lp_id is null
        and n.subj_id is null
    )
    or (
        o.super_subj_id <> n.super_subj_id
        or o.subj_name <> n.subj_name
        or o.subj_level_cd <> n.subj_level_cd
        or o.subj_type_cd <> n.subj_type_cd
        or o.subj_attr_cd <> n.subj_attr_cd
        or o.end_level_subj_flg <> n.end_level_subj_flg
        or o.subj_bal_dir_cd <> n.subj_bal_dir_cd
        or o.subj_status_cd <> n.subj_status_cd
        or o.lmt_subj_flg <> n.lmt_subj_flg
        or o.allow_od_flg <> n.allow_od_flg
        or o.curr_char_proj_cd <> n.curr_char_proj_cd
        or o.setup_acct_type_cd <> n.setup_acct_type_cd
        or o.subj_belong_cd <> n.subj_belong_cd
        or o.in_bs_flg <> n.in_bs_flg
        or o.manual_open_acct_proc_mode_cd <> n.manual_open_acct_proc_mode_cd
        or o.start_use_dt <> n.start_use_dt
        or o.stop_use_dt <> n.stop_use_dt
        or o.subj_use_sys_cd <> n.subj_use_sys_cd
        or o.subj_amt_dir_cd <> n.subj_amt_dir_cd
        or o.price_tax_sept_cd <> n.price_tax_sept_cd
        or o.subj_bal_float_warn_flg <> n.subj_bal_float_warn_flg
        or o.cnter_manual_entry_start_dt <> n.cnter_manual_entry_start_dt
        or o.cnter_manual_entry_end_dt <> n.cnter_manual_entry_end_dt
        or o.accti_midgrod_manual_entry_start_dt <> n.accti_midgrod_manual_entry_start_dt
        or o.accti_midgrod_manual_entry_end_dt <> n.accti_midgrod_manual_entry_end_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_subj_info_h_tglsf1_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_subj_info_h_tglsf1_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_name -- 科目名称
    ,subj_level_cd -- 科目等级代码
    ,subj_type_cd -- 科目类型代码
    ,subj_attr_cd -- 科目属性代码
    ,end_level_subj_flg -- 末级科目标志
    ,subj_bal_dir_cd -- 科目余额方向代码
    ,subj_status_cd -- 科目状态代码
    ,lmt_subj_flg -- 受限科目标志
    ,allow_od_flg -- 透支标志
    ,curr_char_proj_cd -- 货币性项目代码
    ,setup_acct_type_cd -- 建账类型代码
    ,subj_belong_cd -- 科目归属代码
    ,in_bs_flg -- 表内标志
    ,manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,start_use_dt -- 启用日期
    ,stop_use_dt -- 停用日期
    ,subj_use_sys_cd -- 科目使用系统代码
    ,subj_amt_dir_cd -- 科目发生额方向代码
    ,price_tax_sept_cd -- 价税分离代码
    ,subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sob_id -- 账套编号
    ,o.lp_id -- 法人编号
    ,o.subj_id -- 科目编号
    ,o.super_subj_id -- 上级科目编号
    ,o.subj_name -- 科目名称
    ,o.subj_level_cd -- 科目等级代码
    ,o.subj_type_cd -- 科目类型代码
    ,o.subj_attr_cd -- 科目属性代码
    ,o.end_level_subj_flg -- 末级科目标志
    ,o.subj_bal_dir_cd -- 科目余额方向代码
    ,o.subj_status_cd -- 科目状态代码
    ,o.lmt_subj_flg -- 受限科目标志
    ,o.allow_od_flg -- 透支标志
    ,o.curr_char_proj_cd -- 货币性项目代码
    ,o.setup_acct_type_cd -- 建账类型代码
    ,o.subj_belong_cd -- 科目归属代码
    ,o.in_bs_flg -- 表内标志
    ,o.manual_open_acct_proc_mode_cd -- 手工开户受理模式代码
    ,o.start_use_dt -- 启用日期
    ,o.stop_use_dt -- 停用日期
    ,o.subj_use_sys_cd -- 科目使用系统代码
    ,o.subj_amt_dir_cd -- 科目发生额方向代码
    ,o.price_tax_sept_cd -- 价税分离代码
    ,o.subj_bal_float_warn_flg -- 科目余额浮动预警标志
    ,o.cnter_manual_entry_start_dt -- 柜面手工记账开始日期
    ,o.cnter_manual_entry_end_dt -- 柜面手工记账结束日期
    ,o.accti_midgrod_manual_entry_start_dt -- 核算中台手工记账开始日期
    ,o.accti_midgrod_manual_entry_end_dt -- 核算中台手工记账结束日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_subj_info_h_tglsf1_bk o
    left join ${iml_schema}.fin_subj_info_h_tglsf1_op n
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.subj_id = n.subj_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_subj_info_h_tglsf1_cl d
        on
            o.sob_id = d.sob_id
            and o.lp_id = d.lp_id
            and o.subj_id = d.subj_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_subj_info_h;
alter table ${iml_schema}.fin_subj_info_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.fin_subj_info_h exchange subpartition p_tglsf1_19000101 with table ${iml_schema}.fin_subj_info_h_tglsf1_cl;
alter table ${iml_schema}.fin_subj_info_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.fin_subj_info_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_subj_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_subj_info_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_subj_info_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
