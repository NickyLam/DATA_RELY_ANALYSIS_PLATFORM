/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fx_fitran_ctmsf1
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
drop table ${iml_schema}.agt_fx_fitran_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_fitran_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_fx_fitran add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_fx_fitran modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fx_fitran_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fx_fitran partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fx_fitran_ctmsf1_tm
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
    ,fitran_dt -- 头寸调拨日期
    ,cannib_type_cd -- 调拨类型代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,bag_flow_num -- 成交流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,tran_dir_cd -- 交易方向代码
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
    ,inv_port_status_cd -- 投资组合状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,amt_type_cd -- 金额类型代码
    ,stl_status_cd -- 结算状态代码
    ,r_bk_acct_id -- 划出行账户编号
    ,p_bk_acct_id -- 划入行账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fx_fitran
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_fx_fitran_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_fx_fitran partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_fbs_v_fit_deal-
insert into ${iml_schema}.agt_fx_fitran_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,fitran_dt -- 头寸调拨日期
    ,cannib_type_cd -- 调拨类型代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,bag_flow_num -- 成交流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,tran_dir_cd -- 交易方向代码
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
    ,inv_port_status_cd -- 投资组合状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,amt_type_cd -- 金额类型代码
    ,stl_status_cd -- 结算状态代码
    ,r_bk_acct_id -- 划出行账户编号
    ,p_bk_acct_id -- 划入行账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224102'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DEAL_SQNO -- 业务编号
    ,P1.CUS_NUMBER -- 部门编号
    ,P1.BRANCH_NUMBER -- 机构编号
    ,P1.BUSINESS_DATE -- 录入日期
    ,P1.DEAL_DATE -- 交易日期
    ,P1.TRNSFR_DATE -- 头寸调拨日期
    ,P1.TRNSFR_TYPE -- 调拨类型代码
    ,P1.CRNCY_CODE -- 币种代码
    ,P1.FIRST_AMNT -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||to_char(P1.TRADE_PURPOSE) END -- 交易目的代码
    ,P1.COUNTER_PARTY_ID -- 交易对手编号
    ,P1.COUNTER_PARTY_SCNAME -- 交易对手名称
    ,P1.PDD_DEAL_SQNO -- 成交流水号
    ,P1.DEAL_STATUS -- 成交单状态代码
    ,P1.DEAL_DIR -- 交易方向代码
    ,P1.CLIENT_DEAL_SQNO -- 成交编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TRADE_TYPE END -- 交易模式代码
    ,P1.DEAL_SOURCE -- 交易来源代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.DEAL_MARKET END -- 交易场所代码
    ,P1.SETTLE_TYPE -- 清算方式代码
    ,TO_CHAR(P1.DEAL_LINK_SQNO) -- 关联交易编号
    ,P1.PORTFOLIO_SQNO -- 投组交易编号
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,P1.PORTFOLIO_TYPE -- 投组类型名称
    ,P1.PORTFOLIO_STATUS -- 投资组合状态代码
    ,P1.PORTFOLIO_LINK_SQNO -- 投组关联交易编号
    ,P1.AMNT_TYPE -- 金额类型代码
    ,P1.STLMNT_STTS -- 结算状态代码
    ,P1.FROM_ACCOUNT_INFR_SRNO -- 划出行账户编号
    ,P1.TO_ACCOUNT_INFR_SRNO -- 划入行账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_fit_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_fit_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on to_char(P1.TRADE_PURPOSE) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_FBS_V_FIT_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_PURPOSE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FX_FITRAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_AIM_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRADE_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_FBS_V_FIT_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'TRADE_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_FX_FITRAN'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DEAL_MARKET = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_FBS_V_FIT_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'DEAL_MARKET'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FX_FITRAN'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SITE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fx_fitran_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_fx_fitran_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,fitran_dt -- 头寸调拨日期
    ,cannib_type_cd -- 调拨类型代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,bag_flow_num -- 成交流水号
    ,ctr_nt_status_cd -- 成交单状态代码
    ,tran_dir_cd -- 交易方向代码
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
    ,inv_port_status_cd -- 投资组合状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,amt_type_cd -- 金额类型代码
    ,stl_status_cd -- 结算状态代码
    ,r_bk_acct_id -- 划出行账户编号
    ,p_bk_acct_id -- 划入行账户编号
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
    ,nvl(n.fitran_dt, o.fitran_dt) as fitran_dt -- 头寸调拨日期
    ,nvl(n.cannib_type_cd, o.cannib_type_cd) as cannib_type_cd -- 调拨类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_aim_cd, o.tran_aim_cd) as tran_aim_cd -- 交易目的代码
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.bag_flow_num, o.bag_flow_num) as bag_flow_num -- 成交流水号
    ,nvl(n.ctr_nt_status_cd, o.ctr_nt_status_cd) as ctr_nt_status_cd -- 成交单状态代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
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
    ,nvl(n.inv_port_status_cd, o.inv_port_status_cd) as inv_port_status_cd -- 投资组合状态代码
    ,nvl(n.portf_rela_tran_id, o.portf_rela_tran_id) as portf_rela_tran_id -- 投组关联交易编号
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.stl_status_cd, o.stl_status_cd) as stl_status_cd -- 结算状态代码
    ,nvl(n.r_bk_acct_id, o.r_bk_acct_id) as r_bk_acct_id -- 划出行账户编号
    ,nvl(n.p_bk_acct_id, o.p_bk_acct_id) as p_bk_acct_id -- 划入行账户编号
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
                or o.fitran_dt <> n.fitran_dt
                or o.cannib_type_cd <> n.cannib_type_cd
                or o.curr_cd <> n.curr_cd
                or o.tran_amt <> n.tran_amt
                or o.tran_aim_cd <> n.tran_aim_cd
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_name <> n.cntpty_name
                or o.bag_flow_num <> n.bag_flow_num
                or o.ctr_nt_status_cd <> n.ctr_nt_status_cd
                or o.tran_dir_cd <> n.tran_dir_cd
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
                or o.inv_port_status_cd <> n.inv_port_status_cd
                or o.portf_rela_tran_id <> n.portf_rela_tran_id
                or o.amt_type_cd <> n.amt_type_cd
                or o.stl_status_cd <> n.stl_status_cd
                or o.r_bk_acct_id <> n.r_bk_acct_id
                or o.p_bk_acct_id <> n.p_bk_acct_id
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
from ${iml_schema}.agt_fx_fitran_ctmsf1_tm n
    full join ${iml_schema}.agt_fx_fitran_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fx_fitran truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_fx_fitran exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_fx_fitran_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_fx_fitran drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fx_fitran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_fx_fitran_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_fitran_ctmsf1_ex purge;
drop table ${iml_schema}.agt_fx_fitran_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fx_fitran', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);