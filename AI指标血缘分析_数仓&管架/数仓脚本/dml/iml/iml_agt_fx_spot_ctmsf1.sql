/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fx_spot_ctmsf1
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
drop table ${iml_schema}.agt_fx_spot_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_spot_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_fx_spot add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_fx_spot modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fx_spot_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fx_spot partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fx_spot_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,curr_pairs_id -- 货币对编号
    ,bag_exch_rat -- 成交汇率
    ,brch_exch_rat -- 分行汇率
    ,cost_exch_rat -- 成本汇率
    ,fst_curr_cd -- 第一币种代码
    ,secd_curr_cd -- 第二货币代码
    ,fst_curr_tran_amt -- 第一币种交易金额
    ,secd_curr_tran_amt -- 第二币种交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,tran_splt_type_cd -- 交易拆分类型代码
    ,tran_dir_cd -- 交易方向代码
    ,tran_flow_num -- 交易流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,clear_org_cd -- 清算机构代码
    ,modif_rela_flow_num -- 交易修改关联流水号
    ,dealer_acct_num -- 交易员账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fx_spot
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_fx_spot_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_fx_spot partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_fbs_v_spot_deal-
insert into ${iml_schema}.agt_fx_spot_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,curr_pairs_id -- 货币对编号
    ,bag_exch_rat -- 成交汇率
    ,brch_exch_rat -- 分行汇率
    ,cost_exch_rat -- 成本汇率
    ,fst_curr_cd -- 第一币种代码
    ,secd_curr_cd -- 第二货币代码
    ,fst_curr_tran_amt -- 第一币种交易金额
    ,secd_curr_tran_amt -- 第二币种交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,tran_splt_type_cd -- 交易拆分类型代码
    ,tran_dir_cd -- 交易方向代码
    ,tran_flow_num -- 交易流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,clear_org_cd -- 清算机构代码
    ,modif_rela_flow_num -- 交易修改关联流水号
    ,dealer_acct_num -- 交易员账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224104'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DEAL_SQNO -- 业务编号
    ,P1.CUS_NUMBER -- 部门编号
    ,P1.BRANCH_NUMBER -- 机构编号
    ,P1.BUSINESS_DATE -- 录入日期
    ,P1.DEAL_DATE -- 交易日期
    ,P1.VALUE_DATE -- 起息日期
    ,P1.CRNCY_PAIR_ID -- 货币对编号
    ,P1.SPOT_RATE -- 成交汇率
    ,P1.CHILD_RATE -- 分行汇率
    ,P1.COST_RATE -- 成本汇率
    ,P1.FIRST_CRNCY -- 第一币种代码
    ,P1.SECOND_CRNCY -- 第二货币代码
    ,P1.FIRST_AMNT -- 第一币种交易金额
    ,P1.SECOND_AMNT -- 第二币种交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||to_char(P1.TRADE_PURPOSE) END -- 交易目的代码
    ,P1.COUNTER_PARTY_ID -- 交易对手编号
    ,P1.COUNTER_PARTY_SCNAME -- 交易对手简称
    ,P1.SPLIT_TYPE -- 交易拆分类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||to_char(P1.DEAL_DIR) END -- 交易方向代码
    ,P1.PDD_DEAL_SQNO -- 交易流水号
    ,P1.DEAL_STATUS -- 成交单状态代码
    ,P1.CLIENT_DEAL_SQNO -- 成交编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_TYPE END -- 交易模式代码
    ,P1.DEAL_SOURCE -- 交易来源代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DEAL_MARKET END -- 交易场所代码
    ,P1.SETTLE_TYPE -- 清算方式代码
    ,TO_CHAR(P1.DEAL_LINK_SQNO) -- 关联交易编号
    ,P1.PORTFOLIO_SQNO -- 投组交易编号
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,P1.PORTFOLIO_TYPE -- 投组类型名称
    ,P1.PORTFOLIO_STATUS -- 投组状态代码
    ,P1.PORTFOLIO_LINK_SQNO -- 投组关联交易编号
    ,P1.CLEAR_DEP -- 清算机构代码
    ,TO_CHAR(P1.DEAL_LINK_SQNO) -- 交易修改关联流水号
    ,P1.DEALER -- 交易员账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_spot_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_spot_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on to_char(P1.TRADE_PURPOSE) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_FBS_V_SPOT_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_PURPOSE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FX_SPOT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_AIM_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on to_char(P1.DEAL_DIR) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_FBS_V_SPOT_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'DEAL_DIR'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_FX_SPOT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_FBS_V_SPOT_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FX_SPOT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DEAL_MARKET = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'CTMS'
        AND R4.SRC_TAB_EN_NAME= 'CTMS_FBS_V_SPOT_DEAL'
        AND R4.SRC_FIELD_EN_NAME= 'DEAL_MARKET'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_FX_SPOT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SITE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fx_spot_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_fx_spot_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,curr_pairs_id -- 货币对编号
    ,bag_exch_rat -- 成交汇率
    ,brch_exch_rat -- 分行汇率
    ,cost_exch_rat -- 成本汇率
    ,fst_curr_cd -- 第一币种代码
    ,secd_curr_cd -- 第二货币代码
    ,fst_curr_tran_amt -- 第一币种交易金额
    ,secd_curr_tran_amt -- 第二币种交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,tran_splt_type_cd -- 交易拆分类型代码
    ,tran_dir_cd -- 交易方向代码
    ,tran_flow_num -- 交易流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,clear_org_cd -- 清算机构代码
    ,modif_rela_flow_num -- 交易修改关联流水号
    ,dealer_acct_num -- 交易员账号
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
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.curr_pairs_id, o.curr_pairs_id) as curr_pairs_id -- 货币对编号
    ,nvl(n.bag_exch_rat, o.bag_exch_rat) as bag_exch_rat -- 成交汇率
    ,nvl(n.brch_exch_rat, o.brch_exch_rat) as brch_exch_rat -- 分行汇率
    ,nvl(n.cost_exch_rat, o.cost_exch_rat) as cost_exch_rat -- 成本汇率
    ,nvl(n.fst_curr_cd, o.fst_curr_cd) as fst_curr_cd -- 第一币种代码
    ,nvl(n.secd_curr_cd, o.secd_curr_cd) as secd_curr_cd -- 第二货币代码
    ,nvl(n.fst_curr_tran_amt, o.fst_curr_tran_amt) as fst_curr_tran_amt -- 第一币种交易金额
    ,nvl(n.secd_curr_tran_amt, o.secd_curr_tran_amt) as secd_curr_tran_amt -- 第二币种交易金额
    ,nvl(n.tran_aim_cd, o.tran_aim_cd) as tran_aim_cd -- 交易目的代码
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_abbr, o.cntpty_abbr) as cntpty_abbr -- 交易对手简称
    ,nvl(n.tran_splt_type_cd, o.tran_splt_type_cd) as tran_splt_type_cd -- 交易拆分类型代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.ctr_nt_status_cd, o.ctr_nt_status_cd) as ctr_nt_status_cd -- 成交单状态代码
    ,nvl(n.bag_id, o.bag_id) as bag_id -- 成交编号
    ,nvl(n.tran_mode_cd, o.tran_mode_cd) as tran_mode_cd -- 交易模式代码
    ,nvl(n.tran_src_cd, o.tran_src_cd) as tran_src_cd -- 交易来源代码
    ,nvl(n.tran_site_cd, o.tran_site_cd) as tran_site_cd -- 交易场所代码
    ,nvl(n.clear_way_cd, o.clear_way_cd) as clear_way_cd -- 清算方式代码
    ,nvl(n.rela_tran_id, o.rela_tran_id) as rela_tran_id -- 关联交易编号
    ,nvl(n.portf_tran_id, o.portf_tran_id) as portf_tran_id -- 投组交易编号
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.portf_type_name, o.portf_type_name) as portf_type_name -- 投组类型名称
    ,nvl(n.portf_status_cd, o.portf_status_cd) as portf_status_cd -- 投组状态代码
    ,nvl(n.portf_rela_tran_id, o.portf_rela_tran_id) as portf_rela_tran_id -- 投组关联交易编号
    ,nvl(n.clear_org_cd, o.clear_org_cd) as clear_org_cd -- 清算机构代码
    ,nvl(n.modif_rela_flow_num, o.modif_rela_flow_num) as modif_rela_flow_num -- 交易修改关联流水号
    ,nvl(n.dealer_acct_num, o.dealer_acct_num) as dealer_acct_num -- 交易员账号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.dept_id <> n.dept_id
                or o.org_id <> n.org_id
                or o.input_dt <> n.input_dt
                or o.tran_dt <> n.tran_dt
                or o.value_dt <> n.value_dt
                or o.curr_pairs_id <> n.curr_pairs_id
                or o.bag_exch_rat <> n.bag_exch_rat
                or o.brch_exch_rat <> n.brch_exch_rat
                or o.cost_exch_rat <> n.cost_exch_rat
                or o.fst_curr_cd <> n.fst_curr_cd
                or o.secd_curr_cd <> n.secd_curr_cd
                or o.fst_curr_tran_amt <> n.fst_curr_tran_amt
                or o.secd_curr_tran_amt <> n.secd_curr_tran_amt
                or o.tran_aim_cd <> n.tran_aim_cd
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_abbr <> n.cntpty_abbr
                or o.tran_splt_type_cd <> n.tran_splt_type_cd
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.tran_flow_num <> n.tran_flow_num
                or o.ctr_nt_status_cd <> n.ctr_nt_status_cd
                or o.bag_id <> n.bag_id
                or o.tran_mode_cd <> n.tran_mode_cd
                or o.tran_src_cd <> n.tran_src_cd
                or o.tran_site_cd <> n.tran_site_cd
                or o.clear_way_cd <> n.clear_way_cd
                or o.rela_tran_id <> n.rela_tran_id
                or o.portf_tran_id <> n.portf_tran_id
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.portf_type_name <> n.portf_type_name
                or o.portf_status_cd <> n.portf_status_cd
                or o.portf_rela_tran_id <> n.portf_rela_tran_id
                or o.clear_org_cd <> n.clear_org_cd
                or o.modif_rela_flow_num <> n.modif_rela_flow_num
                or o.dealer_acct_num <> n.dealer_acct_num
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
from ${iml_schema}.agt_fx_spot_ctmsf1_tm n
    full join ${iml_schema}.agt_fx_spot_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fx_spot truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_fx_spot exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_fx_spot_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_fx_spot drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fx_spot to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_fx_spot_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_spot_ctmsf1_ex purge;
drop table ${iml_schema}.agt_fx_spot_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fx_spot', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);