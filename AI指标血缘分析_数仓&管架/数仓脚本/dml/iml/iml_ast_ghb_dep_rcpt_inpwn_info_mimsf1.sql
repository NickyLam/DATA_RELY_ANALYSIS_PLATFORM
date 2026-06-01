/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_ghb_dep_rcpt_inpwn_info_mimsf1
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
alter table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op purge;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_ownerdeposit-
insert into ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.CERTIFICATECODE -- 存单凭证号
    ,P1.STOPPAYMENTMONEY -- 可用金额
    ,P1.ACCOUNT -- 客户账号编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENDDATE) -- 到期日期
    ,P1.MONEY -- 账户余额
    ,P1.CHILDACCOUNT -- 客户子账户号
    ,P1.STOPPAYACCOUNT -- 止付通知书编号
    ,NVL(TRIM(P1.TDCURRENCY),'-') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DUEDATE END -- 存期代码
    ,P1.RATE -- 利率
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_ownerdeposit' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_ownerdeposit p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DUEDATE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_OWNERDEPOSIT'
        AND R1.SRC_FIELD_EN_NAME= 'DUEDATE'
        AND R1.TARGET_TAB_EN_NAME= 'AST_GHB_DEP_RCPT_INPWN_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DEP_TERM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dep_rcpt_vouch_num, o.dep_rcpt_vouch_num) as dep_rcpt_vouch_num -- 存单凭证号
    ,nvl(n.aval_amt, o.aval_amt) as aval_amt -- 可用金额
    ,nvl(n.cust_acct_num_id, o.cust_acct_num_id) as cust_acct_num_id -- 客户账号编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.acct_bal, o.acct_bal) as acct_bal -- 账户余额
    ,nvl(n.cust_sub_acct_num, o.cust_sub_acct_num) as cust_sub_acct_num -- 客户子账户号
    ,nvl(n.stop_pay_advise_id, o.stop_pay_advise_id) as stop_pay_advise_id -- 止付通知书编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.dep_term_cd, o.dep_term_cd) as dep_term_cd -- 存期代码
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
where (
        o.asset_id is null
        and o.lp_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
    )
    or (
        o.dep_rcpt_vouch_num <> n.dep_rcpt_vouch_num
        or o.aval_amt <> n.aval_amt
        or o.cust_acct_num_id <> n.cust_acct_num_id
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.acct_bal <> n.acct_bal
        or o.cust_sub_acct_num <> n.cust_sub_acct_num
        or o.stop_pay_advise_id <> n.stop_pay_advise_id
        or o.curr_cd <> n.curr_cd
        or o.dep_term_cd <> n.dep_term_cd
        or o.int_rat <> n.int_rat
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,dep_rcpt_vouch_num -- 存单凭证号
    ,aval_amt -- 可用金额
    ,cust_acct_num_id -- 客户账号编号
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,acct_bal -- 账户余额
    ,cust_sub_acct_num -- 客户子账户号
    ,stop_pay_advise_id -- 止付通知书编号
    ,curr_cd -- 币种代码
    ,dep_term_cd -- 存期代码
    ,int_rat -- 利率
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.dep_rcpt_vouch_num -- 存单凭证号
    ,o.aval_amt -- 可用金额
    ,o.cust_acct_num_id -- 客户账号编号
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.acct_bal -- 账户余额
    ,o.cust_sub_acct_num -- 客户子账户号
    ,o.stop_pay_advise_id -- 止付通知书编号
    ,o.curr_cd -- 币种代码
    ,o.dep_term_cd -- 存期代码
    ,o.int_rat -- 利率
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_bk o
    left join ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info;
alter table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl;
alter table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_op purge;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_ghb_dep_rcpt_inpwn_info_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_ghb_dep_rcpt_inpwn_info', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
