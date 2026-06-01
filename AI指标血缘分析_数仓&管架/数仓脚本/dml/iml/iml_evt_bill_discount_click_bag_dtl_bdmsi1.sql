/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_discount_click_bag_dtl_bdmsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_bill_discount_click_bag_dtl add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_dtl partition for ('bdmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_ser_num -- 明细序列号
    ,batch_ser_num -- 批次序列号
    ,bill_ser_num -- 票据序列号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 转贴现金额
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,final_modif_tm -- 最后修改时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bag_flg -- 成交标志
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_dtl partition for ('bdmsi1')
where 0=1
;

create table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_dtl partition for ('bdmsi1') where 0=1;

create table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_dtl partition for ('bdmsi1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_click_deal_details-
insert into ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_ser_num -- 明细序列号
    ,batch_ser_num -- 批次序列号
    ,bill_ser_num -- 票据序列号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 转贴现金额
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,final_modif_tm -- 最后修改时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bag_flg -- 成交标志
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105005'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,p1.id -- 明细序列号
    ,p1.contract_id -- 批次序列号
    ,p1.dpc_draft_id -- 票据序列号
    ,p1.draft_number -- 票据编号
    ,P1.draft_amount -- 票面金额
    ,${iml_schema}.DATEFORMAT_MAX2(p1.maturity_date) -- 票据到期日期
    ,${iml_schema}.DATEFORMAT_MAX2(p1.real_due_date) -- 实际到期日期
    ,P1.tenor_days -- 剩余期限
    ,P1.pay_interest -- 应付利息
    ,P1.settle_amt -- 转贴现金额
    ,case when R1.target_cd_val is not null then R1.target_cd_val else '@'||p1.account_status end -- 记账状态代码
    ,NVL(TRIM(p1.valid_flag),'-') -- 有效标志
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.last_upd_time) -- 最后修改时间
    ,nvl(trim(p1.credit_type),'000') -- 信用主体类型代码
    ,p1.credit_branch -- 信用主体编号
    ,NVL(TRIM(p1.is_approve),'-') -- 成交标志
    ,p1.deal_id -- 成交单序列号
    ,p1.dealed_no -- 成交单编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||nvl(P2.FIRSTSOURCE,' ') END  -- 首次买入来源代码 
    ,nvl(trim(P2.FIRSTSOURCECUSTNO),' ') -- 首次交易对手客户编号
    ,nvl(trim(P2.FIRSTCUSTNAME),' ') -- 首次交易对手名称
    ,nvl(trim(P2.FRISTBANKNO),' ') -- 首次交易对手联行号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_click_deal_details' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_click_deal_details p1
    left join ${iol_schema}.bdms_view_buy_firstsource_info p2 
     on p1.draft_number = p2.draftnumber and p1.CD_RANGE = p2.CDRANGE
     and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNT_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_DETAILS'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
     left join ${iml_schema}.ref_pub_cd_map r3 on nvl(P2.FIRSTSOURCE,' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_VIEW_BUY_FIRSTSOURCE_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'FIRSTSOURCE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FIR_BUY_SRC_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND substr(trim(P1.last_upd_time),1,8)='${batch_date}'
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm 
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_ser_num -- 明细序列号
    ,batch_ser_num -- 批次序列号
    ,bill_ser_num -- 票据序列号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 转贴现金额
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,final_modif_tm -- 最后修改时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bag_flg -- 成交标志
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.dtl_ser_num -- 明细序列号
    ,n.batch_ser_num -- 批次序列号
    ,n.bill_ser_num -- 票据序列号
    ,n.bill_id -- 票据编号
    ,n.fac_val_amt -- 票面金额
    ,n.bill_exp_dt -- 票据到期日期
    ,n.actl_exp_dt -- 实际到期日期
    ,n.surp_tenor -- 剩余期限
    ,n.int_paybl -- 应付利息
    ,n.stl_amt -- 转贴现金额
    ,n.entry_status_cd -- 记账状态代码
    ,n.valid_flg -- 有效标志
    ,n.final_modif_tm -- 最后修改时间
    ,n.crdt_main_type_cd -- 信用主体类型代码
    ,n.crdt_main_id -- 信用主体编号
    ,n.bag_flg -- 成交标志
    ,n.ctr_nt_ser_num -- 成交单序列号
    ,n.ctr_nt_id -- 成交单编号
    ,n.fir_buy_src_cd -- 首次买入来源代码
    ,n.fir_cntpty_cust_id -- 首次交易对手客户编号
    ,n.fir_cntpty_name -- 首次交易对手名称
    ,n.fir_cntpty_ibank_no -- 首次交易对手联行号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'bdmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm n
    left join ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.dtl_ser_num <> n.dtl_ser_num
        or o.batch_ser_num <> n.batch_ser_num
        or o.bill_ser_num <> n.bill_ser_num
        or o.bill_id <> n.bill_id
        or o.fac_val_amt <> n.fac_val_amt
        or o.bill_exp_dt <> n.bill_exp_dt
        or o.actl_exp_dt <> n.actl_exp_dt
        or o.surp_tenor <> n.surp_tenor
        or o.int_paybl <> n.int_paybl
        or o.stl_amt <> n.stl_amt
        or o.entry_status_cd <> n.entry_status_cd
        or o.valid_flg <> n.valid_flg
        or o.final_modif_tm <> n.final_modif_tm
        or o.crdt_main_type_cd <> n.crdt_main_type_cd
        or o.crdt_main_id <> n.crdt_main_id
        or o.bag_flg <> n.bag_flg
        or o.ctr_nt_ser_num <> n.ctr_nt_ser_num
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.fir_buy_src_cd <> n.fir_buy_src_cd
        or o.fir_cntpty_cust_id <> n.fir_cntpty_cust_id
        or o.fir_cntpty_name <> n.fir_cntpty_name
        or o.fir_cntpty_ibank_no <> n.fir_cntpty_ibank_no
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_ser_num -- 明细序列号
    ,batch_ser_num -- 批次序列号
    ,bill_ser_num -- 票据序列号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 转贴现金额
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,final_modif_tm -- 最后修改时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bag_flg -- 成交标志
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_ser_num -- 明细序列号
    ,batch_ser_num -- 批次序列号
    ,bill_ser_num -- 票据序列号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 转贴现金额
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,final_modif_tm -- 最后修改时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bag_flg -- 成交标志
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
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
    ,o.dtl_ser_num -- 明细序列号
    ,o.batch_ser_num -- 批次序列号
    ,o.bill_ser_num -- 票据序列号
    ,o.bill_id -- 票据编号
    ,o.fac_val_amt -- 票面金额
    ,o.bill_exp_dt -- 票据到期日期
    ,o.actl_exp_dt -- 实际到期日期
    ,o.surp_tenor -- 剩余期限
    ,o.int_paybl -- 应付利息
    ,o.stl_amt -- 转贴现金额
    ,o.entry_status_cd -- 记账状态代码
    ,o.valid_flg -- 有效标志
    ,o.final_modif_tm -- 最后修改时间
    ,o.crdt_main_type_cd -- 信用主体类型代码
    ,o.crdt_main_id -- 信用主体编号
    ,o.bag_flg -- 成交标志
    ,o.ctr_nt_ser_num -- 成交单序列号
    ,o.ctr_nt_id -- 成交单编号
    ,o.fir_buy_src_cd -- 首次买入来源代码
    ,o.fir_cntpty_cust_id -- 首次交易对手客户编号
    ,o.fir_cntpty_name -- 首次交易对手名称
    ,o.fir_cntpty_ibank_no -- 首次交易对手联行号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_bk o
    left join ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_bill_discount_click_bag_dtl') 
               and substr(subpartition_name,1,8)=upper('p_bdmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bill_discount_click_bag_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bill_discount_click_bag_dtl modify partition p_bdmsi1 
add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_bill_discount_click_bag_dtl exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_cl;
alter table ${iml_schema}.evt_bill_discount_click_bag_dtl exchange subpartition p_bdmsi1_20991231 with table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_discount_click_bag_dtl to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl_bdmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_discount_click_bag_dtl', partname => 'p_bdmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
