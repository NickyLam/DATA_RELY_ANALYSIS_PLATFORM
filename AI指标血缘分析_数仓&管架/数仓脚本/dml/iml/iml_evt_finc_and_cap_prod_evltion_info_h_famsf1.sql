/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_and_cap_prod_evltion_info_h_famsf1
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
alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_famsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h partition for ('famsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm purge;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op purge;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h partition for ('famsf1')
where 0=1
;

create table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h partition for ('famsf1') where 0=1;

create table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h partition for ('famsf1') where 0=1;

-- 3.1 get new data into table
-- fams_ptl_sec_valution-
insert into ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201014'||P1.CDATE||P1.PORTFOLIO_ID||P1.FINPROD_ID||P1.INV_AIM||P1.SEC_ACCT_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CDATE -- 跑批日期
    ,P1.PORTFOLIO_ID -- 组合产品代码描述
    ,P1.FINPROD_ID -- 金融产品代码描述
    ,CASE WHEN P2.TARGET_CD_VAL IS NOT NULL THEN P2.TARGET_CD_VAL ELSE '@'||P1.INV_AIM END -- 投资目的代码
    ,P1.CCY -- 币种代码
    ,P1.SHARE_AMT -- 资产数量
    ,P1.TDY_FLOAT_INGPL -- 公允价值变动
    ,P1.DSC_COST_AMT -- 摊销总成本
    ,P1.DSC_CLEAN_PRICE -- 摊销成本净价
    ,P1.TDY_INTINCEXP -- 当日应计利息
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_TIME -- 更新时间
    ,P1.ACT_D_YIELD -- 摊销实际日利率
    ,P1.SEC_ACCT_ID -- 证券账户编号
    ,P1.DELAY_PAY_AMT -- 逾期资产待清算资金
    ,P1.END_DAYS_1 -- 剩余期限
    ,P1.END_DAYS_2 -- 剩余存续期限
    ,P1.INT_RATE -- 计提利率
    ,P1.TDY_DSCLOSS_ADD_B -- 当日价差收入
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_ptl_sec_valution' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_ptl_sec_valution p1
    left join ${iml_schema}.ref_pub_cd_map p2 on  P1.INV_AIM = P2.SRC_CODE_VAL
        AND P2.SORC_SYS_CD= 'FAMS'
        AND P2.SRC_TAB_EN_NAME= 'FAMS_PTL_SEC_VALUTION'
        AND P2.SRC_FIELD_EN_NAME= 'INV_AIM'
        AND P2.TARGET_TAB_EN_NAME= 'EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H'
        AND P2.TARGET_TAB_FIELD_EN_NAME= 'INVEST_AIM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm 
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
        into ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
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
    ,nvl(n.batch_dt, o.batch_dt) as batch_dt -- 跑批日期
    ,nvl(n.comb_prod_cd_descb, o.comb_prod_cd_descb) as comb_prod_cd_descb -- 组合产品代码描述
    ,nvl(n.fin_prod_cd_descb, o.fin_prod_cd_descb) as fin_prod_cd_descb -- 金融产品代码描述
    ,nvl(n.invest_aim_cd, o.invest_aim_cd) as invest_aim_cd -- 投资目的代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.asset_qtty, o.asset_qtty) as asset_qtty -- 资产数量
    ,nvl(n.evha_val_chag, o.evha_val_chag) as evha_val_chag -- 公允价值变动
    ,nvl(n.amort_tot_cost, o.amort_tot_cost) as amort_tot_cost -- 摊销总成本
    ,nvl(n.amort_cost_net_price, o.amort_cost_net_price) as amort_cost_net_price -- 摊销成本净价
    ,nvl(n.td_acru_int, o.td_acru_int) as td_acru_int -- 当日应计利息
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.amort_actl_day_int_rat, o.amort_actl_day_int_rat) as amort_actl_day_int_rat -- 摊销实际日利率
    ,nvl(n.secu_acct_id, o.secu_acct_id) as secu_acct_id -- 证券账户编号
    ,nvl(n.ovdue_asset_prep_clear_cap, o.ovdue_asset_prep_clear_cap) as ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.surp_surviv_tenor, o.surp_surviv_tenor) as surp_surviv_tenor -- 剩余存续期限
    ,nvl(n.provi_int_rat, o.provi_int_rat) as provi_int_rat -- 计提利率
    ,nvl(n.td_spd_inco, o.td_spd_inco) as td_spd_inco -- 当日价差收入
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
from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm n
    full join (select * from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.batch_dt <> n.batch_dt
        or o.comb_prod_cd_descb <> n.comb_prod_cd_descb
        or o.fin_prod_cd_descb <> n.fin_prod_cd_descb
        or o.invest_aim_cd <> n.invest_aim_cd
        or o.curr_cd <> n.curr_cd
        or o.asset_qtty <> n.asset_qtty
        or o.evha_val_chag <> n.evha_val_chag
        or o.amort_tot_cost <> n.amort_tot_cost
        or o.amort_cost_net_price <> n.amort_cost_net_price
        or o.td_acru_int <> n.td_acru_int
        or o.create_tm <> n.create_tm
        or o.update_tm <> n.update_tm
        or o.amort_actl_day_int_rat <> n.amort_actl_day_int_rat
        or o.secu_acct_id <> n.secu_acct_id
        or o.ovdue_asset_prep_clear_cap <> n.ovdue_asset_prep_clear_cap
        or o.surp_tenor <> n.surp_tenor
        or o.surp_surviv_tenor <> n.surp_surviv_tenor
        or o.provi_int_rat <> n.provi_int_rat
        or o.td_spd_inco <> n.td_spd_inco
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 跑批日期
    ,comb_prod_cd_descb -- 组合产品代码描述
    ,fin_prod_cd_descb -- 金融产品代码描述
    ,invest_aim_cd -- 投资目的代码
    ,curr_cd -- 币种代码
    ,asset_qtty -- 资产数量
    ,evha_val_chag -- 公允价值变动
    ,amort_tot_cost -- 摊销总成本
    ,amort_cost_net_price -- 摊销成本净价
    ,td_acru_int -- 当日应计利息
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,amort_actl_day_int_rat -- 摊销实际日利率
    ,secu_acct_id -- 证券账户编号
    ,ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,surp_tenor -- 剩余期限
    ,surp_surviv_tenor -- 剩余存续期限
    ,provi_int_rat -- 计提利率
    ,td_spd_inco -- 当日价差收入
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
    ,o.batch_dt -- 跑批日期
    ,o.comb_prod_cd_descb -- 组合产品代码描述
    ,o.fin_prod_cd_descb -- 金融产品代码描述
    ,o.invest_aim_cd -- 投资目的代码
    ,o.curr_cd -- 币种代码
    ,o.asset_qtty -- 资产数量
    ,o.evha_val_chag -- 公允价值变动
    ,o.amort_tot_cost -- 摊销总成本
    ,o.amort_cost_net_price -- 摊销成本净价
    ,o.td_acru_int -- 当日应计利息
    ,o.create_tm -- 创建时间
    ,o.update_tm -- 更新时间
    ,o.amort_actl_day_int_rat -- 摊销实际日利率
    ,o.secu_acct_id -- 证券账户编号
    ,o.ovdue_asset_prep_clear_cap -- 逾期资产待清算资金
    ,o.surp_tenor -- 剩余期限
    ,o.surp_surviv_tenor -- 剩余存续期限
    ,o.provi_int_rat -- 计提利率
    ,o.td_spd_inco -- 当日价差收入
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_bk o
    left join ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl d
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
--truncate table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h;
--alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h truncate partition for ('famsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_finc_and_cap_prod_evltion_info_h') 
               and substr(subpartition_name,1,8)=upper('p_famsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h modify partition p_famsf1 
add subpartition p_famsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl;
alter table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h exchange subpartition p_famsf1_20991231 with table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_tm purge;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_op purge;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h_famsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_and_cap_prod_evltion_info_h', partname => 'p_famsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
