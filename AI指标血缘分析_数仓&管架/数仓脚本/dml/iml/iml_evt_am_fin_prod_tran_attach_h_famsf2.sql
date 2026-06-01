/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_am_fin_prod_tran_attach_h_famsf2
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
alter table ${iml_schema}.evt_am_fin_prod_tran_attach_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_attach_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_attach_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_attach_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_am_fin_prod_tran_attach_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_trd_product_deal_add-
insert into ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104035'||P1.TRADE_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRADE_ID -- 交易编号
    ,P1.PENALTY_INTAMT -- 罚息金额
    ,CASE WHEN TRIM(P1.CUSTOM_CASH_TYPE) IS NULL THEN '-'
     WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL 
     ELSE '@'||P1.CUSTOM_CASH_TYPE END -- 自定义现金流类型代码
    ,decode(P1.PUR_CFM_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.PUR_CFM_DATE) -- 预计申购确认日
    ,decode(P1.RED_CFM_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.RED_CFM_DATE) -- 预计赎回到账日
    ,P1.REG_DATE -- 权益登记日
    ,decode(P1.BONUS_CFM_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.BONUS_CFM_DATE) -- 预计分红日
    ,P1.CREATE_USER -- 创建人名称
    ,P1.CREATE_DEPT -- 创建部门
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_USER -- 更新人名称
    ,P1.UPDATE_TIME -- 更新时间
    ,P1.RED_PROFIT -- 赎回收益
    ,P1.RED_COST -- 赎回成本
    ,P1.REG_DATE_AMT -- 权益登记日金额
    ,P1.MP_FINPROD_ID -- 金融产品编号
    ,to_char(P1.MP_BRANCH) -- 分支序号
    ,P1.ASSET_RECOMMAND_ORG -- 资产推荐方编号
    ,P1.EXP_CON_VALUE -- 预计转股价值
    ,P1.DEPOSIT_AMT -- 保证金金额
    ,P1.TERMINATE_RATE -- 提前终止利率
    ,P1.PORTFOLIO_ID -- 投资组合编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_trd_product_deal_add' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_trd_product_deal_add p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSTOM_CASH_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_TRD_PRODUCT_DEAL_ADD'
        AND R1.SRC_FIELD_EN_NAME= 'CUSTOM_CASH_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_AM_FIN_PROD_TRAN_ATTACH_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUSTM_CASHFLOW_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm 
  	                                group by 
  	                                        evt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.pnlt_amt, o.pnlt_amt) as pnlt_amt -- 罚息金额
    ,nvl(n.custm_cashflow_type_cd, o.custm_cashflow_type_cd) as custm_cashflow_type_cd -- 自定义现金流类型代码
    ,nvl(n.expect_purch_cfm_day, o.expect_purch_cfm_day) as expect_purch_cfm_day -- 预计申购确认日
    ,nvl(n.expect_redem_arriv_dt, o.expect_redem_arriv_dt) as expect_redem_arriv_dt -- 预计赎回到账日
    ,nvl(n.eqty_rgst_day, o.eqty_rgst_day) as eqty_rgst_day -- 权益登记日
    ,nvl(n.expect_divd_day, o.expect_divd_day) as expect_divd_day -- 预计分红日
    ,nvl(n.creator_name, o.creator_name) as creator_name -- 创建人名称
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.updater_name, o.updater_name) as updater_name -- 更新人名称
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.redem_prft, o.redem_prft) as redem_prft -- 赎回收益
    ,nvl(n.redem_cost, o.redem_cost) as redem_cost -- 赎回成本
    ,nvl(n.eqty_rgst_day_amt, o.eqty_rgst_day_amt) as eqty_rgst_day_amt -- 权益登记日金额
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.asset_refer_id, o.asset_refer_id) as asset_refer_id -- 资产推荐方编号
    ,nvl(n.expect_turn_stock_val, o.expect_turn_stock_val) as expect_turn_stock_val -- 预计转股价值
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.adv_termnt_int_rat, o.adv_termnt_int_rat) as adv_termnt_int_rat -- 提前终止利率
    ,nvl(n.inv_port_id, o.inv_port_id) as inv_port_id -- 投资组合编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm n
    full join (select * from ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_id <> n.tran_id
        or o.pnlt_amt <> n.pnlt_amt
        or o.custm_cashflow_type_cd <> n.custm_cashflow_type_cd
        or o.expect_purch_cfm_day <> n.expect_purch_cfm_day
        or o.expect_redem_arriv_dt <> n.expect_redem_arriv_dt
        or o.eqty_rgst_day <> n.eqty_rgst_day
        or o.expect_divd_day <> n.expect_divd_day
        or o.creator_name <> n.creator_name
        or o.create_dept <> n.create_dept
        or o.create_tm <> n.create_tm
        or o.updater_name <> n.updater_name
        or o.update_tm <> n.update_tm
        or o.redem_prft <> n.redem_prft
        or o.redem_cost <> n.redem_cost
        or o.eqty_rgst_day_amt <> n.eqty_rgst_day_amt
        or o.fin_prod_id <> n.fin_prod_id
        or o.brch_seq_num <> n.brch_seq_num
        or o.asset_refer_id <> n.asset_refer_id
        or o.expect_turn_stock_val <> n.expect_turn_stock_val
        or o.margin_amt <> n.margin_amt
        or o.adv_termnt_int_rat <> n.adv_termnt_int_rat
        or o.inv_port_id <> n.inv_port_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_id -- 交易编号
    ,pnlt_amt -- 罚息金额
    ,custm_cashflow_type_cd -- 自定义现金流类型代码
    ,expect_purch_cfm_day -- 预计申购确认日
    ,expect_redem_arriv_dt -- 预计赎回到账日
    ,eqty_rgst_day -- 权益登记日
    ,expect_divd_day -- 预计分红日
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,create_tm -- 创建时间
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,redem_prft -- 赎回收益
    ,redem_cost -- 赎回成本
    ,eqty_rgst_day_amt -- 权益登记日金额
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,asset_refer_id -- 资产推荐方编号
    ,expect_turn_stock_val -- 预计转股价值
    ,margin_amt -- 保证金金额
    ,adv_termnt_int_rat -- 提前终止利率
    ,inv_port_id -- 投资组合编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.tran_id -- 交易编号
    ,o.pnlt_amt -- 罚息金额
    ,o.custm_cashflow_type_cd -- 自定义现金流类型代码
    ,o.expect_purch_cfm_day -- 预计申购确认日
    ,o.expect_redem_arriv_dt -- 预计赎回到账日
    ,o.eqty_rgst_day -- 权益登记日
    ,o.expect_divd_day -- 预计分红日
    ,o.creator_name -- 创建人名称
    ,o.create_dept -- 创建部门
    ,o.create_tm -- 创建时间
    ,o.updater_name -- 更新人名称
    ,o.update_tm -- 更新时间
    ,o.redem_prft -- 赎回收益
    ,o.redem_cost -- 赎回成本
    ,o.eqty_rgst_day_amt -- 权益登记日金额
    ,o.fin_prod_id -- 金融产品编号
    ,o.brch_seq_num -- 分支序号
    ,o.asset_refer_id -- 资产推荐方编号
    ,o.expect_turn_stock_val -- 预计转股价值
    ,o.margin_amt -- 保证金金额
    ,o.adv_termnt_int_rat -- 提前终止利率
    ,o.inv_port_id -- 投资组合编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_bk o
    left join ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_am_fin_prod_tran_attach_h;
alter table ${iml_schema}.evt_am_fin_prod_tran_attach_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_am_fin_prod_tran_attach_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl;
alter table ${iml_schema}.evt_am_fin_prod_tran_attach_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_am_fin_prod_tran_attach_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_tm purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_op purge;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_am_fin_prod_tran_attach_h', partname => 'p_famsf2_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
