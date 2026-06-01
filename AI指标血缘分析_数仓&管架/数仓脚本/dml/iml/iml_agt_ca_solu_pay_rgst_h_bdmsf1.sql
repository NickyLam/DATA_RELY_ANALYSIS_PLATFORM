/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ca_solu_pay_rgst_h_bdmsf1
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
alter table ${iml_schema}.agt_ca_solu_pay_rgst_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ca_solu_pay_rgst_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ca_solu_pay_rgst_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ca_solu_pay_rgst_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ca_solu_pay_rgst_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_sp_draft_info-1
insert into ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_tm(
    solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 解付编号
    ,'9999' -- 法人编号
    ,'101004'||P1.DRAFT_NUMBER -- 凭证编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.REMITTER_NAME -- 出票人名称
    ,P1.REMITTER_ACCOUNT -- 出票人账户编号
    ,P1.REMITTER_BANK_ID -- 出票人开户行行号
    ,P1.REMITTER_BANK_NAME -- 出票人开户行名称
    ,P1.ACCEPTOR_BANK_ID -- 承兑人开户行行号
    ,P1.ACCEPTOR_BANK_NAME -- 承兑人开户行名称
    ,P1.FACE_AMOUNT -- 票面金额
    ,${iml_schema}.DATEFORMAT_MAX(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 到期日
    ,P1.PAYEE_ACCOUNT -- 收款人账户编号
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_BANK_ID -- 收款人开户行行号
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.STATUS -- 登记状态代码
    ,NVL(P2.brh_no,' ') -- 机构编号
    ,P1.ACCOUNT_FLAG -- 记账标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.JIE_FU_DATE) -- 登记日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCOUNT_DATE) -- 记账日期
    ,P1.JIE_FU_TIME -- 登记时间
    ,P1.ACCEPT_FLAG -- 承兑登记标志
    ,P1.DISCOUNT_FLAG -- 贴现登记标志
    ,P1.SETTLE_FLAG -- 结清标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_sp_draft_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_sp_draft_info p1
    left join ${iol_schema}.bdms_branch_info p2 on P1.BRANCH_ID=P2.ID AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl(
            solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op(
            solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.solu_pay_id, o.solu_pay_id) as solu_pay_id -- 解付编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_acct_id, o.drawer_acct_id) as drawer_acct_id -- 出票人账户编号
    ,nvl(n.drawer_open_bank_no, o.drawer_open_bank_no) as drawer_open_bank_no -- 出票人开户行行号
    ,nvl(n.drawer_open_bank_name, o.drawer_open_bank_name) as drawer_open_bank_name -- 出票人开户行名称
    ,nvl(n.accptor_open_bank_no, o.accptor_open_bank_no) as accptor_open_bank_no -- 承兑人开户行行号
    ,nvl(n.accptor_open_bank_name, o.accptor_open_bank_name) as accptor_open_bank_name -- 承兑人开户行名称
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 出票日期
    ,nvl(n.exp_day, o.exp_day) as exp_day -- 到期日
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.rgst_status_cd, o.rgst_status_cd) as rgst_status_cd -- 登记状态代码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.entry_flg, o.entry_flg) as entry_flg -- 记账标志
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.rgst_tm, o.rgst_tm) as rgst_tm -- 登记时间
    ,nvl(n.acpt_rgst_flg, o.acpt_rgst_flg) as acpt_rgst_flg -- 承兑登记标志
    ,nvl(n.discnt_rgst_flg, o.discnt_rgst_flg) as discnt_rgst_flg -- 贴现登记标志
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,case when
            n.solu_pay_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.solu_pay_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.solu_pay_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.solu_pay_id = n.solu_pay_id
            and o.lp_id = n.lp_id
where (
        o.solu_pay_id is null
        and o.lp_id is null
    )
    or (
        n.solu_pay_id is null
        and n.lp_id is null
    )
    or (
        o.vouch_id <> n.vouch_id
        or o.bill_num <> n.bill_num
        or o.drawer_name <> n.drawer_name
        or o.drawer_acct_id <> n.drawer_acct_id
        or o.drawer_open_bank_no <> n.drawer_open_bank_no
        or o.drawer_open_bank_name <> n.drawer_open_bank_name
        or o.accptor_open_bank_no <> n.accptor_open_bank_no
        or o.accptor_open_bank_name <> n.accptor_open_bank_name
        or o.fac_val_amt <> n.fac_val_amt
        or o.draw_dt <> n.draw_dt
        or o.exp_day <> n.exp_day
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_name <> n.recver_name
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.rgst_status_cd <> n.rgst_status_cd
        or o.org_id <> n.org_id
        or o.entry_flg <> n.entry_flg
        or o.rgst_dt <> n.rgst_dt
        or o.entry_dt <> n.entry_dt
        or o.rgst_tm <> n.rgst_tm
        or o.acpt_rgst_flg <> n.acpt_rgst_flg
        or o.discnt_rgst_flg <> n.discnt_rgst_flg
        or o.payoff_flg <> n.payoff_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl(
            solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op(
            solu_pay_id -- 解付编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,bill_num -- 票据号码
    ,drawer_name -- 出票人名称
    ,drawer_acct_id -- 出票人账户编号
    ,drawer_open_bank_no -- 出票人开户行行号
    ,drawer_open_bank_name -- 出票人开户行名称
    ,accptor_open_bank_no -- 承兑人开户行行号
    ,accptor_open_bank_name -- 承兑人开户行名称
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_day -- 到期日
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,rgst_status_cd -- 登记状态代码
    ,org_id -- 机构编号
    ,entry_flg -- 记账标志
    ,rgst_dt -- 登记日期
    ,entry_dt -- 记账日期
    ,rgst_tm -- 登记时间
    ,acpt_rgst_flg -- 承兑登记标志
    ,discnt_rgst_flg -- 贴现登记标志
    ,payoff_flg -- 结清标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.solu_pay_id -- 解付编号
    ,o.lp_id -- 法人编号
    ,o.vouch_id -- 凭证编号
    ,o.bill_num -- 票据号码
    ,o.drawer_name -- 出票人名称
    ,o.drawer_acct_id -- 出票人账户编号
    ,o.drawer_open_bank_no -- 出票人开户行行号
    ,o.drawer_open_bank_name -- 出票人开户行名称
    ,o.accptor_open_bank_no -- 承兑人开户行行号
    ,o.accptor_open_bank_name -- 承兑人开户行名称
    ,o.fac_val_amt -- 票面金额
    ,o.draw_dt -- 出票日期
    ,o.exp_day -- 到期日
    ,o.recver_acct_id -- 收款人账户编号
    ,o.recver_name -- 收款人名称
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.rgst_status_cd -- 登记状态代码
    ,o.org_id -- 机构编号
    ,o.entry_flg -- 记账标志
    ,o.rgst_dt -- 登记日期
    ,o.entry_dt -- 记账日期
    ,o.rgst_tm -- 登记时间
    ,o.acpt_rgst_flg -- 承兑登记标志
    ,o.discnt_rgst_flg -- 贴现登记标志
    ,o.payoff_flg -- 结清标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_bk o
    left join ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op n
        on
            o.solu_pay_id = n.solu_pay_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl d
        on
            o.solu_pay_id = d.solu_pay_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ca_solu_pay_rgst_h;
alter table ${iml_schema}.agt_ca_solu_pay_rgst_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ca_solu_pay_rgst_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl;
alter table ${iml_schema}.agt_ca_solu_pay_rgst_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ca_solu_pay_rgst_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ca_solu_pay_rgst_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ca_solu_pay_rgst_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
