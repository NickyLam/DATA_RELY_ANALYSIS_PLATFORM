/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_fund_info_mimsf1
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
drop table ${iml_schema}.ast_col_fund_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_fund_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_fund_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_fund_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_fund_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_fund_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_fund_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,fund_cd -- 基金代码
    ,acct_id -- 账户编号
    ,issuer_name -- 发行人名称
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,fund_name -- 基金名称
    ,fund_type_cd -- 基金类型代码
    ,brkevn_flg -- 保本标志
    ,tranbl_flg -- 可转让标志
    ,invest_underly_cd -- 投资标的代码
    ,public_quot_flg -- 公开报价标志
    ,inpwn_lot -- 质押份额
    ,corp_nv -- 单位净值
    ,inpwn_tot_val -- 质押总价值
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,descb -- 描述
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_fund_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_fund_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_fund_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_fundinformation-1
insert into ${iml_schema}.ast_col_fund_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,fund_cd -- 基金代码
    ,acct_id -- 账户编号
    ,issuer_name -- 发行人名称
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,fund_name -- 基金名称
    ,fund_type_cd -- 基金类型代码
    ,brkevn_flg -- 保本标志
    ,tranbl_flg -- 可转让标志
    ,invest_underly_cd -- 投资标的代码
    ,public_quot_flg -- 公开报价标志
    ,inpwn_lot -- 质押份额
    ,corp_nv -- 单位净值
    ,inpwn_tot_val -- 质押总价值
    ,issuer_brwer_flg -- 发行人为借款人标志
    ,descb -- 描述
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.FUNDCODE -- 基金代码
    ,P1.ACCOUNT -- 账户编号
    ,P1.ISSUERNAME -- 发行人名称
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 起始日期
    ,${iml_schema}.dateformat_max(P1.ENDDATE) -- 截止日期
    ,P1.FUNDNAME -- 基金名称
    ,nvl(trim(P1.FUNDTYPE),'-') -- 基金类型代码
    ,nvl(trim(P1.ISCP),'-') -- 保本标志
    ,nvl(trim(P1.ISTRANSFER),'-') -- 可转让标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INVEST END -- 投资标的代码
    ,nvl(trim(P1.ISPUBLICOFFER),'-') -- 公开报价标志
    ,P1.IMPAWNNUM -- 质押份额
    ,P1.NETVALUE -- 单位净值
    ,P1.TOTALVALUE -- 质押总价值
    ,nvl(trim(P1.ISBORROWER),'-') -- 发行人为借款人标志
    ,P1.REMARK -- 描述
    ,nvl(trim(P1.TDCURRENCY),'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_fundinformation' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_fundinformation p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INVEST= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_FUNDINFORMATION'
        AND R1.SRC_FIELD_EN_NAME= 'INVEST'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_FUND_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INVEST_UNDERLY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_fund_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_fund_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,fund_cd -- 基金代码
    ,acct_id -- 账户编号
    ,issuer_name -- 发行人名称
    ,begin_dt -- 起始日期
    ,closing_dt -- 截止日期
    ,fund_name -- 基金名称
    ,fund_type_cd -- 基金类型代码
    ,brkevn_flg -- 保本标志
    ,tranbl_flg -- 可转让标志
    ,invest_underly_cd -- 投资标的代码
    ,public_quot_flg -- 公开报价标志
    ,inpwn_lot -- 质押份额
    ,corp_nv -- 单位净值
    ,inpwn_tot_val -- 质押总价值
    ,issuer_brwer_flg -- 发行人为借款人标志
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
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.closing_dt, o.closing_dt) as closing_dt -- 截止日期
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 基金名称
    ,nvl(n.fund_type_cd, o.fund_type_cd) as fund_type_cd -- 基金类型代码
    ,nvl(n.brkevn_flg, o.brkevn_flg) as brkevn_flg -- 保本标志
    ,nvl(n.tranbl_flg, o.tranbl_flg) as tranbl_flg -- 可转让标志
    ,nvl(n.invest_underly_cd, o.invest_underly_cd) as invest_underly_cd -- 投资标的代码
    ,nvl(n.public_quot_flg, o.public_quot_flg) as public_quot_flg -- 公开报价标志
    ,nvl(n.inpwn_lot, o.inpwn_lot) as inpwn_lot -- 质押份额
    ,nvl(n.corp_nv, o.corp_nv) as corp_nv -- 单位净值
    ,nvl(n.inpwn_tot_val, o.inpwn_tot_val) as inpwn_tot_val -- 质押总价值
    ,nvl(n.issuer_brwer_flg, o.issuer_brwer_flg) as issuer_brwer_flg -- 发行人为借款人标志
    ,nvl(n.descb, o.descb) as descb -- 描述
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.fund_cd <> n.fund_cd
                or o.acct_id <> n.acct_id
                or o.issuer_name <> n.issuer_name
                or o.begin_dt <> n.begin_dt
                or o.closing_dt <> n.closing_dt
                or o.fund_name <> n.fund_name
                or o.fund_type_cd <> n.fund_type_cd
                or o.brkevn_flg <> n.brkevn_flg
                or o.tranbl_flg <> n.tranbl_flg
                or o.invest_underly_cd <> n.invest_underly_cd
                or o.public_quot_flg <> n.public_quot_flg
                or o.inpwn_lot <> n.inpwn_lot
                or o.corp_nv <> n.corp_nv
                or o.inpwn_tot_val <> n.inpwn_tot_val
                or o.issuer_brwer_flg <> n.issuer_brwer_flg
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
from ${iml_schema}.ast_col_fund_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_fund_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_fund_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_fund_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_fund_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_fund_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_fund_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_fund_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_fund_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_fund_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_fund_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);