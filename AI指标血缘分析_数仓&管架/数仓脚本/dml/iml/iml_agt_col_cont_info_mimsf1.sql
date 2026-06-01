/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_col_cont_info_mimsf1
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
drop table ${iml_schema}.agt_col_cont_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_cont_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_col_cont_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_col_cont_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_col_cont_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_cont_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_cont_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,rg_cd -- 地区代码
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,cust_mgr_id -- 客户经理编号
    ,crdt_breed_id -- 授信品种编号
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,guar_curr_cd -- 担保币种代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,setup_dt -- 建立日期
    ,chg_dt -- 更改日期
    ,distrd_amt -- 已发放金额
    ,level5_cls_cd -- 五级分类代码
    ,off_bs_bal -- 表外余额
    ,in_bs_bal -- 表内余额
    ,over_int_amt -- 欠息金额
    ,payoff_status_cd -- 结清状态代码
    ,loan_rating_cd -- 贷款评级代码
    ,reply_id -- 批复编号
    ,strip_line_cd -- 条线代码
    ,crdt_cont_id -- 授信合同编号
    ,crdt_appl_id -- 授信申请编号
    ,paper_cont_id -- 纸质合同编号
    ,data_src_cd -- 数据来源代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_cont_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_col_cont_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_col_cont_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_cc_contractinfo-
insert into ${iml_schema}.agt_col_cont_info_mimsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,rg_cd -- 地区代码
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,cust_mgr_id -- 客户经理编号
    ,crdt_breed_id -- 授信品种编号
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,guar_curr_cd -- 担保币种代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,setup_dt -- 建立日期
    ,chg_dt -- 更改日期
    ,distrd_amt -- 已发放金额
    ,level5_cls_cd -- 五级分类代码
    ,off_bs_bal -- 表外余额
    ,in_bs_bal -- 表内余额
    ,over_int_amt -- 欠息金额
    ,payoff_status_cd -- 结清状态代码
    ,loan_rating_cd -- 贷款评级代码
    ,reply_id -- 批复编号
    ,strip_line_cd -- 条线代码
    ,crdt_cont_id -- 授信合同编号
    ,crdt_appl_id -- 授信申请编号
    ,paper_cont_id -- 纸质合同编号
    ,data_src_cd -- 数据来源代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    case when trim(p1.datasourceflag) = '2' and trim(p1.contractno) is not null then '222102'||trim(p1.contractno)
     when trim(p1.datasourceflag) = '3' and trim(p1.contractno) is not null  then '222301'||trim(p1.contractno)
     when trim(p1.datasourceflag) in ('5','6') and trim(p1.contractno) is not null then '231020'||trim(p1.contractno)
     else trim(p1.contractno)
end -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNO -- 合同编号
    ,NVL(TRIM(P2.CORECUSTID),NVL(P1.custid,' ')) -- 客户编号
    ,P1.REGIONCODE -- 地区代码
    ,P1.ORGID -- 机构编号
    ,P1.MFORGID -- 入账机构编号
    ,P1.CUSTMGR -- 客户经理编号
    ,P1.CREDITTYPE -- 授信品种编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.loandirect END -- 贷款投向行业代码
    ,nvl(trim(p1.CURRENCY),'CNY') -- 担保币种代码
    ,P1.AMT -- 合同金额
    ,P1.BALANCE -- 合同余额
    ,P1.COVERAGERATE -- 保证金比例
    ,P1.ASSUREMONEY -- 保证金金额
    ,${iml_schema}.dateformat_min(P1.OCCURDATE) -- 生效日期
    ,${iml_schema}.dateformat_min(P1.DUEDATE) -- 到期日期
    ,nvl(P1.GUARTYPE,'-')  -- 担保方式代码
    ,nvl(P1.MAINGUARTYPE,'-') -- 主担保方式代码
    ,${iml_schema}.dateformat_min(P1.CREATEDATE) -- 建立日期
    ,${iml_schema}.dateformat_min(P1.UPDATEDATE) -- 更改日期
    ,P1.PAYAMT -- 已发放金额
    ,nvl(trim(p1.fiveclass),'99') -- 五级分类代码
    ,P1.BALANCEOUT -- 表外余额
    ,P1.BALANCEIN -- 表内余额
    ,P1.BALANCE13 -- 欠息金额
    ,NVL(TRIM(P1.SQUARESTATE),'-') -- 结清状态代码
    ,DECODE(P1.TENCLASS,' ','99','60','99',P1.TENCLASS) -- 贷款评级代码
    ,P1.REQNO -- 批复编号
    ,NVL(TRIM(P1.BARSIGN),'0') -- 条线代码
    ,P1.CREDITAGGREEMENT -- 授信合同编号
    ,P1.APPLYCODE -- 授信申请编号
    ,P1.TXTCONTRACTNO -- 纸质合同编号
    ,nvl(trim(p1.datasourceflag),'-') -- 数据来源代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_cc_contractinfo' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_cc_contractinfo p1
    left join ${iol_schema}.mims_ci_custinfo p2 on P1.custid = P2.CUSTID
and P2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.loandirect = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_CC_CONTRACTINFO'
        AND R1.SRC_FIELD_EN_NAME= 'loandirect'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_COL_CONT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_DIR_INDUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_col_cont_info_mimsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_col_cont_info_mimsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,rg_cd -- 地区代码
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,cust_mgr_id -- 客户经理编号
    ,crdt_breed_id -- 授信品种编号
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,guar_curr_cd -- 担保币种代码
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,setup_dt -- 建立日期
    ,chg_dt -- 更改日期
    ,distrd_amt -- 已发放金额
    ,level5_cls_cd -- 五级分类代码
    ,off_bs_bal -- 表外余额
    ,in_bs_bal -- 表内余额
    ,over_int_amt -- 欠息金额
    ,payoff_status_cd -- 结清状态代码
    ,loan_rating_cd -- 贷款评级代码
    ,reply_id -- 批复编号
    ,strip_line_cd -- 条线代码
    ,crdt_cont_id -- 授信合同编号
    ,crdt_appl_id -- 授信申请编号
    ,paper_cont_id -- 纸质合同编号
    ,data_src_cd -- 数据来源代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 地区代码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.crdt_breed_id, o.crdt_breed_id) as crdt_breed_id -- 授信品种编号
    ,nvl(n.loan_dir_indus_cd, o.loan_dir_indus_cd) as loan_dir_indus_cd -- 贷款投向行业代码
    ,nvl(n.guar_curr_cd, o.guar_curr_cd) as guar_curr_cd -- 担保币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.cont_bal, o.cont_bal) as cont_bal -- 合同余额
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.setup_dt, o.setup_dt) as setup_dt -- 建立日期
    ,nvl(n.chg_dt, o.chg_dt) as chg_dt -- 更改日期
    ,nvl(n.distrd_amt, o.distrd_amt) as distrd_amt -- 已发放金额
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.off_bs_bal, o.off_bs_bal) as off_bs_bal -- 表外余额
    ,nvl(n.in_bs_bal, o.in_bs_bal) as in_bs_bal -- 表内余额
    ,nvl(n.over_int_amt, o.over_int_amt) as over_int_amt -- 欠息金额
    ,nvl(n.payoff_status_cd, o.payoff_status_cd) as payoff_status_cd -- 结清状态代码
    ,nvl(n.loan_rating_cd, o.loan_rating_cd) as loan_rating_cd -- 贷款评级代码
    ,nvl(n.reply_id, o.reply_id) as reply_id -- 批复编号
    ,nvl(n.strip_line_cd, o.strip_line_cd) as strip_line_cd -- 条线代码
    ,nvl(n.crdt_cont_id, o.crdt_cont_id) as crdt_cont_id -- 授信合同编号
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.paper_cont_id, o.paper_cont_id) as paper_cont_id -- 纸质合同编号
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.cont_id <> n.cont_id
                or o.cust_id <> n.cust_id
                or o.rg_cd <> n.rg_cd
                or o.org_id <> n.org_id
                or o.enter_acct_org_id <> n.enter_acct_org_id
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.crdt_breed_id <> n.crdt_breed_id
                or o.loan_dir_indus_cd <> n.loan_dir_indus_cd
                or o.guar_curr_cd <> n.guar_curr_cd
                or o.cont_amt <> n.cont_amt
                or o.cont_bal <> n.cont_bal
                or o.margin_ratio <> n.margin_ratio
                or o.margin_amt <> n.margin_amt
                or o.effect_dt <> n.effect_dt
                or o.exp_dt <> n.exp_dt
                or o.guar_way_cd <> n.guar_way_cd
                or o.main_guar_way_cd <> n.main_guar_way_cd
                or o.setup_dt <> n.setup_dt
                or o.chg_dt <> n.chg_dt
                or o.distrd_amt <> n.distrd_amt
                or o.level5_cls_cd <> n.level5_cls_cd
                or o.off_bs_bal <> n.off_bs_bal
                or o.in_bs_bal <> n.in_bs_bal
                or o.over_int_amt <> n.over_int_amt
                or o.payoff_status_cd <> n.payoff_status_cd
                or o.loan_rating_cd <> n.loan_rating_cd
                or o.reply_id <> n.reply_id
                or o.strip_line_cd <> n.strip_line_cd
                or o.crdt_cont_id <> n.crdt_cont_id
                or o.crdt_appl_id <> n.crdt_appl_id
                or o.paper_cont_id <> n.paper_cont_id
                or o.data_src_cd <> n.data_src_cd
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_cont_info_mimsf1_tm n
    full join ${iml_schema}.agt_col_cont_info_mimsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_col_cont_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_col_cont_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.agt_col_cont_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_col_cont_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_col_cont_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_col_cont_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_cont_info_mimsf1_ex purge;
drop table ${iml_schema}.agt_col_cont_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_col_cont_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);