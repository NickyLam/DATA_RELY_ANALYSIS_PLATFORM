/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cap_ib_lend_ctmsf1
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
drop table ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm purge;
drop table ${iml_schema}.agt_cap_ib_lend_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_cap_ib_lend add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_cap_ib_lend modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cap_ib_lend_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cap_ib_lend partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,ib_lend_int_rat -- 拆借利率
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,acru_int -- 应计利息
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,ib_lend_days -- 拆借天数
    ,init_bus_id -- 原业务编号
    ,tran_cate_cd -- 交易类别代码
    ,repo_id -- 回购编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_ib_lend
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_cap_ib_lend_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_cap_ib_lend partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_payment_iamdeals-
insert into ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,ib_lend_int_rat -- 拆借利率
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,acru_int -- 应计利息
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,ib_lend_days -- 拆借天数
    ,init_bus_id -- 原业务编号
    ,tran_cate_cd -- 交易类别代码
    ,repo_id -- 回购编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224101'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_TABLENAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,P1.SERIAL_NUMBER -- 交易编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 首期交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.VALUE_DATE) -- 首期交割日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 到期交割日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUYORSELL END -- 交易方向代码
    ,P1.REPO_RATE -- 拆借利率
    ,P1.AMOUNT -- 首期结算金额
    ,P1.MATURITY_AMOUNT -- 到期结算金额
    ,P1.FEE -- 首期费用
    ,P1.TAX_AMT -- 首期税金
    ,P1.BROKER_AMT -- 首期佣金
    ,P1.INTEREST -- 应计利息
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,P1.KEEPFOLDER_SHORTNAME -- 账簿名称
    ,P1.CPTYS_SHORT_NAME -- 交易对手名称
    ,P2.CPTYS_ID -- 交易对手编号
    ,P1.DEALER_ID -- 交易员编号
    ,P1.DEALER_NAME -- 交易员名称
    ,P1.REF_NUMBER -- 成交编号
    ,P1.CFETS_FROM -- CFETS交易标志
    ,P1.REPO_DAYS -- 拆借天数
    ,TO_CHAR(P1.IAMDEALS_ID_GRAND) -- 原业务编号
    ,P1.COUNTERPARTY_TYPE -- 交易类别代码
    ,P1.REPO_ID -- 回购编号
    ,P1.LASTMODIFIED_PAY -- 收付确认修改时间
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_iamdeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_iamdeals p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUYORSELL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_IAMDEALS'
        AND R1.SRC_FIELD_EN_NAME= 'BUYORSELL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CAP_IB_LEND'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iol_schema}.ctms_tbs_vs_cptys p2 on P1.CPTYS_ID = P2.KEY_SRC AND p2.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and p2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_cap_ib_lend_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,ib_lend_int_rat -- 拆借利率
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,acru_int -- 应计利息
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,ib_lend_days -- 拆借天数
    ,init_bus_id -- 原业务编号
    ,tran_cate_cd -- 交易类别代码
    ,repo_id -- 回购编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
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
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.fst_tran_dt, o.fst_tran_dt) as fst_tran_dt -- 首期交易日期
    ,nvl(n.fst_dlvy_dt, o.fst_dlvy_dt) as fst_dlvy_dt -- 首期交割日期
    ,nvl(n.exp_dlvy_dt, o.exp_dlvy_dt) as exp_dlvy_dt -- 到期交割日期
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.ib_lend_int_rat, o.ib_lend_int_rat) as ib_lend_int_rat -- 拆借利率
    ,nvl(n.fst_stl_amt, o.fst_stl_amt) as fst_stl_amt -- 首期结算金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.fst_fee, o.fst_fee) as fst_fee -- 首期费用
    ,nvl(n.fst_tax, o.fst_tax) as fst_tax -- 首期税金
    ,nvl(n.fst_comm, o.fst_comm) as fst_comm -- 首期佣金
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.acct_b_name, o.acct_b_name) as acct_b_name -- 账簿名称
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.bag_id, o.bag_id) as bag_id -- 成交编号
    ,nvl(n.cfets_tran_flg, o.cfets_tran_flg) as cfets_tran_flg -- CFETS交易标志
    ,nvl(n.ib_lend_days, o.ib_lend_days) as ib_lend_days -- 拆借天数
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.tran_cate_cd, o.tran_cate_cd) as tran_cate_cd -- 交易类别代码
    ,nvl(n.repo_id, o.repo_id) as repo_id -- 回购编号
    ,nvl(n.acpt_pay_cfm_modif_tm, o.acpt_pay_cfm_modif_tm) as acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.bus_table_name <> n.bus_table_name
                or o.dept_id <> n.dept_id
                or o.tran_id <> n.tran_id
                or o.fst_tran_dt <> n.fst_tran_dt
                or o.fst_dlvy_dt <> n.fst_dlvy_dt
                or o.exp_dlvy_dt <> n.exp_dlvy_dt
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.ib_lend_int_rat <> n.ib_lend_int_rat
                or o.fst_stl_amt <> n.fst_stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.fst_fee <> n.fst_fee
                or o.fst_tax <> n.fst_tax
                or o.fst_comm <> n.fst_comm
                or o.acru_int <> n.acru_int
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.acct_b_id <> n.acct_b_id
                or o.acct_b_name <> n.acct_b_name
                or o.cntpty_name <> n.cntpty_name
                or o.cntpty_id <> n.cntpty_id
                or o.dealer_id <> n.dealer_id
                or o.dealer_name <> n.dealer_name
                or o.bag_id <> n.bag_id
                or o.cfets_tran_flg <> n.cfets_tran_flg
                or o.ib_lend_days <> n.ib_lend_days
                or o.init_bus_id <> n.init_bus_id
                or o.tran_cate_cd <> n.tran_cate_cd
                or o.repo_id <> n.repo_id
                or o.acpt_pay_cfm_modif_tm <> n.acpt_pay_cfm_modif_tm
                or o.tran_status_cd <> n.tran_status_cd
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
from ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm n
    full join ${iml_schema}.agt_cap_ib_lend_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cap_ib_lend truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_cap_ib_lend exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_cap_ib_lend_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_cap_ib_lend drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cap_ib_lend to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_cap_ib_lend_ctmsf1_tm purge;
drop table ${iml_schema}.agt_cap_ib_lend_ctmsf1_ex purge;
drop table ${iml_schema}.agt_cap_ib_lend_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cap_ib_lend', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);