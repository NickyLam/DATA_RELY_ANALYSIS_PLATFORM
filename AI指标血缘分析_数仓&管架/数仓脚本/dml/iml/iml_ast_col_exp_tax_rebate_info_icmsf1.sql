/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_exp_tax_rebate_info_icmsf1
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
drop table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_exp_tax_rebate_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_exp_tax_rebate_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_exp_tax_rebate_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,exp_tax_rebate_amt -- 出口退税金额
    ,debt_fulfil_begin_dt -- 债务履行起始日期
    ,debt_fulfil_exp_dt -- 债务履行到期日期
    ,spec_acct_id -- 专用账户编号
    ,spec_acct_name -- 专用账户名称
    ,acct_owner_name -- 账户所有人名称
    ,cus_decl_id -- 报关单编号
    ,aging -- 账龄
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_exp_tax_rebate_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_exp_tax_rebate_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_asset_receivable_exportrebates-
insert into ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,exp_tax_rebate_amt -- 出口退税金额
    ,debt_fulfil_begin_dt -- 债务履行起始日期
    ,debt_fulfil_exp_dt -- 债务履行到期日期
    ,spec_acct_id -- 专用账户编号
    ,spec_acct_name -- 专用账户名称
    ,acct_owner_name -- 账户所有人名称
    ,cus_decl_id -- 报关单编号
    ,aging -- 账龄
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,P1.EXPORTMONEY -- 出口退税金额
    ,P1.STARTDATE -- 债务履行起始日期
    ,P1.DUEDATE -- 债务履行到期日期
    ,P1.ACCOUNT -- 专用账户编号
    ,P1.ACCOUNTNAME -- 专用账户名称
    ,P1.ACCOUNTOWNER -- 账户所有人名称
    ,P1.CUSTOMNO -- 报关单编号
    ,P1.USEDTIME -- 账龄
    ,nvl(trim(P1.ISPRODUCE),'-') -- 债权产生标志
    ,P1.REMARK -- 其他说明
    ,nvl(trim(P1.ISRELATION2),'-') -- 关系标志
    ,nvl(trim(P1.TDCURRENCY),'CNY') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_receivable_exportrebates' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_receivable_exportrebates p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,exp_tax_rebate_amt -- 出口退税金额
    ,debt_fulfil_begin_dt -- 债务履行起始日期
    ,debt_fulfil_exp_dt -- 债务履行到期日期
    ,spec_acct_id -- 专用账户编号
    ,spec_acct_name -- 专用账户名称
    ,acct_owner_name -- 账户所有人名称
    ,cus_decl_id -- 报关单编号
    ,aging -- 账龄
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
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
    ,nvl(n.exp_tax_rebate_amt, o.exp_tax_rebate_amt) as exp_tax_rebate_amt -- 出口退税金额
    ,nvl(n.debt_fulfil_begin_dt, o.debt_fulfil_begin_dt) as debt_fulfil_begin_dt -- 债务履行起始日期
    ,nvl(n.debt_fulfil_exp_dt, o.debt_fulfil_exp_dt) as debt_fulfil_exp_dt -- 债务履行到期日期
    ,nvl(n.spec_acct_id, o.spec_acct_id) as spec_acct_id -- 专用账户编号
    ,nvl(n.spec_acct_name, o.spec_acct_name) as spec_acct_name -- 专用账户名称
    ,nvl(n.acct_owner_name, o.acct_owner_name) as acct_owner_name -- 账户所有人名称
    ,nvl(n.cus_decl_id, o.cus_decl_id) as cus_decl_id -- 报关单编号
    ,nvl(n.aging, o.aging) as aging -- 账龄
    ,nvl(n.cred_rht_prod_flg, o.cred_rht_prod_flg) as cred_rht_prod_flg -- 债权产生标志
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.rela_flg, o.rela_flg) as rela_flg -- 关系标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.exp_tax_rebate_amt <> n.exp_tax_rebate_amt
                or o.debt_fulfil_begin_dt <> n.debt_fulfil_begin_dt
                or o.debt_fulfil_exp_dt <> n.debt_fulfil_exp_dt
                or o.spec_acct_id <> n.spec_acct_id
                or o.spec_acct_name <> n.spec_acct_name
                or o.acct_owner_name <> n.acct_owner_name
                or o.cus_decl_id <> n.cus_decl_id
                or o.aging <> n.aging
                or o.cred_rht_prod_flg <> n.cred_rht_prod_flg
                or o.other_comnt <> n.other_comnt
                or o.rela_flg <> n.rela_flg
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
from ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_exp_tax_rebate_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_exp_tax_rebate_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_exp_tax_rebate_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_exp_tax_rebate_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_exp_tax_rebate_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_exp_tax_rebate_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);