/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_non_share_right_info_icmsf1
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
drop table ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_non_share_right_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_non_share_right_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_non_share_right_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_non_share_right_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_non_share_right_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,pledge_share_corp_name -- 出质股权公司名称
    ,pledge_share_local_corp_cd -- 出质股权所在公司代码
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,hold_shares_qtty -- 持股数量
    ,pledge_right_tot_right_ratio -- 出质股权所占总股权比例
    ,pledge_right_cnt -- 出质股权数
    ,per_share_mk_pri -- 每股市价
    ,prev_share_divd_amt -- 上年度每股分红金额
    ,per_share_idtfy_val -- 每股认定价值
    ,inpwn_tot_val -- 质押总价值
    ,per_share_net_asset -- 每股净资产
    ,warning_line -- 警戒线
    ,close_pos_line -- 平仓线
    ,net_asset_tot -- 净资产总额
    ,descb -- 描述
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_non_share_right_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_non_share_right_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_non_share_right_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_asset_finance_nlistedstock-
insert into ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,pledge_share_corp_name -- 出质股权公司名称
    ,pledge_share_local_corp_cd -- 出质股权所在公司代码
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,hold_shares_qtty -- 持股数量
    ,pledge_right_tot_right_ratio -- 出质股权所占总股权比例
    ,pledge_right_cnt -- 出质股权数
    ,per_share_mk_pri -- 每股市价
    ,prev_share_divd_amt -- 上年度每股分红金额
    ,per_share_idtfy_val -- 每股认定价值
    ,inpwn_tot_val -- 质押总价值
    ,per_share_net_asset -- 每股净资产
    ,warning_line -- 警戒线
    ,close_pos_line -- 平仓线
    ,net_asset_tot -- 净资产总额
    ,descb -- 描述
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,P1.COMPANYNAME -- 出质股权公司名称
    ,P1.STOCKCODE -- 出质股权所在公司代码
    ,nvl(trim(P1.ISBORROWER),'-') -- 发行人为借款人标志
    ,P1.SHAREAMOUNT -- 持股数量
    ,P1.RATIO -- 出质股权所占总股权比例
    ,P1.STOCKAMOUNT -- 出质股权数
    ,P1.PERSHAREMARKETPRICE -- 每股市价
    ,P1.PROFITMONEY -- 上年度每股分红金额
    ,P1.PERIDENTYSHARE -- 每股认定价值
    ,P1.TOTALVALUE -- 质押总价值
    ,P1.PERSHAREVALUE -- 每股净资产
    ,P1.WARNINGLINE -- 警戒线
    ,P1.LIQUIDATELINE -- 平仓线
    ,P1.SHARETOTALVALUE -- 净资产总额
    ,P1.REMARK -- 描述
    ,nvl(trim(P1.TDCURRENCY),'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_finance_nlistedstock' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_finance_nlistedstock p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_non_share_right_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,pledge_share_corp_name -- 出质股权公司名称
    ,pledge_share_local_corp_cd -- 出质股权所在公司代码
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,hold_shares_qtty -- 持股数量
    ,pledge_right_tot_right_ratio -- 出质股权所占总股权比例
    ,pledge_right_cnt -- 出质股权数
    ,per_share_mk_pri -- 每股市价
    ,prev_share_divd_amt -- 上年度每股分红金额
    ,per_share_idtfy_val -- 每股认定价值
    ,inpwn_tot_val -- 质押总价值
    ,per_share_net_asset -- 每股净资产
    ,warning_line -- 警戒线
    ,close_pos_line -- 平仓线
    ,net_asset_tot -- 净资产总额
    ,descb -- 描述
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
    ,nvl(n.pledge_share_corp_name, o.pledge_share_corp_name) as pledge_share_corp_name -- 出质股权公司名称
    ,nvl(n.pledge_share_local_corp_cd, o.pledge_share_local_corp_cd) as pledge_share_local_corp_cd -- 出质股权所在公司代码
    ,nvl(n.issuer_brwer_flg, o.issuer_brwer_flg) as issuer_brwer_flg -- 发行人为借款人标志
    ,nvl(n.hold_shares_qtty, o.hold_shares_qtty) as hold_shares_qtty -- 持股数量
    ,nvl(n.pledge_right_tot_right_ratio, o.pledge_right_tot_right_ratio) as pledge_right_tot_right_ratio -- 出质股权所占总股权比例
    ,nvl(n.pledge_right_cnt, o.pledge_right_cnt) as pledge_right_cnt -- 出质股权数
    ,nvl(n.per_share_mk_pri, o.per_share_mk_pri) as per_share_mk_pri -- 每股市价
    ,nvl(n.prev_share_divd_amt, o.prev_share_divd_amt) as prev_share_divd_amt -- 上年度每股分红金额
    ,nvl(n.per_share_idtfy_val, o.per_share_idtfy_val) as per_share_idtfy_val -- 每股认定价值
    ,nvl(n.inpwn_tot_val, o.inpwn_tot_val) as inpwn_tot_val -- 质押总价值
    ,nvl(n.per_share_net_asset, o.per_share_net_asset) as per_share_net_asset -- 每股净资产
    ,nvl(n.warning_line, o.warning_line) as warning_line -- 警戒线
    ,nvl(n.close_pos_line, o.close_pos_line) as close_pos_line -- 平仓线
    ,nvl(n.net_asset_tot, o.net_asset_tot) as net_asset_tot -- 净资产总额
    ,nvl(n.descb, o.descb) as descb -- 描述
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.pledge_share_corp_name <> n.pledge_share_corp_name
                or o.pledge_share_local_corp_cd <> n.pledge_share_local_corp_cd
                or o.issuer_brwer_flg <> n.issuer_brwer_flg
                or o.hold_shares_qtty <> n.hold_shares_qtty
                or o.pledge_right_tot_right_ratio <> n.pledge_right_tot_right_ratio
                or o.pledge_right_cnt <> n.pledge_right_cnt
                or o.per_share_mk_pri <> n.per_share_mk_pri
                or o.prev_share_divd_amt <> n.prev_share_divd_amt
                or o.per_share_idtfy_val <> n.per_share_idtfy_val
                or o.inpwn_tot_val <> n.inpwn_tot_val
                or o.per_share_net_asset <> n.per_share_net_asset
                or o.warning_line <> n.warning_line
                or o.close_pos_line <> n.close_pos_line
                or o.net_asset_tot <> n.net_asset_tot
                or o.descb <> n.descb
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
from ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_non_share_right_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_non_share_right_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_non_share_right_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_non_share_right_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_non_share_right_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_non_share_right_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_non_share_right_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_non_share_right_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_non_share_right_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_non_share_right_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);