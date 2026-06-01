/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_margin_icmsf1
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
drop table ${iml_schema}.ast_col_margin_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_margin_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_margin add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_margin modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_margin_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_margin partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_margin_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_acct_num -- 押品账号
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,acct_bal -- 账户余额
    ,margin_flow_id -- 保证金流水编号
    ,is_cmplt_froz_flg -- 是否完成冻结标志
    ,margin_froz_amt -- 保证金冻结金额
    ,remark -- 备注
    ,sub_acct_id -- 子账户编号
    ,open_acct_org -- 开户机构
    ,aval_bal -- 可用余额
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_margin
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_margin_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_margin partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_asset_finance_bail-
insert into ${iml_schema}.ast_col_margin_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_acct_num -- 押品账号
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,acct_bal -- 账户余额
    ,margin_flow_id -- 保证金流水编号
    ,is_cmplt_froz_flg -- 是否完成冻结标志
    ,margin_froz_amt -- 保证金冻结金额
    ,remark -- 备注
    ,sub_acct_id -- 子账户编号
    ,open_acct_org -- 开户机构
    ,aval_bal -- 可用余额
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,P1.ACCOUNT -- 押品账号
    ,${iml_schema}.dateformat_min(null) -- 起始日期
    ,${iml_schema}.dateformat_max(null) -- 截止日期
    ,0 -- 账户余额
    ,P1.BAILSEQNO -- 保证金流水编号
    ,'-' -- 是否完成冻结标志
    ,P1.FREEZEMONEY -- 保证金冻结金额
    ,' ' -- 备注
    ,P1.CHILDACCOUNT -- 子账户编号
    ,P1.OPENDEPT -- 开户机构
    ,0 -- 可用余额
    ,nvl(trim(P1.TDCURRENCY),'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_finance_bail' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_finance_bail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_margin_icmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_margin_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_acct_num -- 押品账号
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,acct_bal -- 账户余额
    ,margin_flow_id -- 保证金流水编号
    ,is_cmplt_froz_flg -- 是否完成冻结标志
    ,margin_froz_amt -- 保证金冻结金额
    ,remark -- 备注
    ,sub_acct_id -- 子账户编号
    ,open_acct_org -- 开户机构
    ,aval_bal -- 可用余额
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
    ,nvl(n.col_acct_num, o.col_acct_num) as col_acct_num -- 押品账号
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.closing_dt, o.closing_dt) as closing_dt -- 截止日期
    ,nvl(n.acct_bal, o.acct_bal) as acct_bal -- 账户余额
    ,nvl(n.margin_flow_id, o.margin_flow_id) as margin_flow_id -- 保证金流水编号
    ,nvl(n.is_cmplt_froz_flg, o.is_cmplt_froz_flg) as is_cmplt_froz_flg -- 是否完成冻结标志
    ,nvl(n.margin_froz_amt, o.margin_froz_amt) as margin_froz_amt -- 保证金冻结金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.sub_acct_id, o.sub_acct_id) as sub_acct_id -- 子账户编号
    ,nvl(n.open_acct_org, o.open_acct_org) as open_acct_org -- 开户机构
    ,nvl(n.aval_bal, o.aval_bal) as aval_bal -- 可用余额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.col_acct_num <> n.col_acct_num
                or o.begin_dt <> n.begin_dt
                or o.closing_dt <> n.closing_dt
                or o.acct_bal <> n.acct_bal
                or o.margin_flow_id <> n.margin_flow_id
                or o.is_cmplt_froz_flg <> n.is_cmplt_froz_flg
                or o.margin_froz_amt <> n.margin_froz_amt
                or o.remark <> n.remark
                or o.sub_acct_id <> n.sub_acct_id
                or o.open_acct_org <> n.open_acct_org
                or o.aval_bal <> n.aval_bal
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
from ${iml_schema}.ast_col_margin_icmsf1_tm n
    full join ${iml_schema}.ast_col_margin_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_margin truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_margin exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_margin_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_margin drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_margin to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_margin_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_margin_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_margin_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_margin', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);