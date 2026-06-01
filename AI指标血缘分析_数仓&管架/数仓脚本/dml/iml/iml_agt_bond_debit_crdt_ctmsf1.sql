/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bond_debit_crdt_ctmsf1
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
drop table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bond_debit_crdt add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bond_debit_crdt modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bond_debit_crdt partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,inpwn_bond_id_comb -- 质押债券编号组合
    ,underly_bond_id -- 标的债券编号
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,inpwn_bond_denom_comb -- 质押债券面额组合
    ,tran_tm -- 交易时间
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
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,dealer_id -- 交易员编号
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,debit_crdt_fee_rat -- 借贷费率
    ,debit_crdt_days -- 借贷天数
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bond_debit_crdt
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bond_debit_crdt partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_payment_wtrade_lend-
insert into ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,inpwn_bond_id_comb -- 质押债券编号组合
    ,underly_bond_id -- 标的债券编号
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,inpwn_bond_denom_comb -- 质押债券面额组合
    ,tran_tm -- 交易时间
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
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,dealer_id -- 交易员编号
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,debit_crdt_fee_rat -- 借贷费率
    ,debit_crdt_days -- 借贷天数
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225105'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_TABLENAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,P1.BONDSCODE -- 质押债券编号组合
    ,P1.LENDBONDSCODE -- 标的债券编号
    ,nvl(trim(p3.PRODUCT_CODE),' ') -- 标准产品编号
    ,P1.SERIAL_NUMBER -- 交易编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 首期交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.VALUE_DATE) -- 首期交割日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 到期交割日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUYORSELL END -- 交易方向代码
    ,P1.FACE_AMOUNT -- 质押债券面额组合
    ,P1.TRADE_TIME -- 交易时间
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
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE END -- 首期结算方式代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE2 END -- 到期结算方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DAY_COUNT END -- 计息基准代码
    ,P1.DEALER -- 交易员编号
    ,P1.REF_NUMBER -- 成交编号
    ,P1.CFETS_FROM -- CFETS交易标志
    ,P1.TRADE_RATE -- 借贷费率
    ,P1.LEND_DAYS -- 借贷天数
    ,P1.WTRADE_LEND_ID_GRAND -- 原业务编号
    ,P1.LASTMODIFIED_PAY -- 收付确认修改时间
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,P1.DN_DEALER -- 本币交易员名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_wtrade_lend' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend p1
  left join  ${iol_schema}.ctms_v_lt_wtrade_lend p4
	  on p1.deal_id = p4.wtrade_lend_id
    and p4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and p4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join (select max(balance_id) as max_balance_id ,buztype,assettype,keepfolder_id,majorassetcode,minorassetcode 
    from ${iol_schema}.ctms_tbs_v_new_balance  group by buztype,assettype,keepfolder_id,majorassetcode,minorassetcode) t 
    on p4.wtrade_lend_id_grand = substr(t.minorassetcode,4) 
    and t.ASSETTYPE ='债券借贷'
    left join ${iol_schema}.ctms_tbs_v_new_balance p3 
    on t.max_balance_id = p3.balance_id
    AND p3.START_DT <= TO_DATE('${batch_date}','yyyymmdd')
    and p3.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_cptys p2 
    on P1.CPTYS_ID = P2.KEY_SRC 
    AND p2.START_DT <= TO_DATE('${batch_date}','yyyymmdd')
    and p2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUYORSELL = R1.SRC_CODE_VAL
   AND R1.SORC_SYS_CD= 'CTMS'
   AND R1.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_WTRADE_LEND'
   AND R1.SRC_FIELD_EN_NAME= 'BUYORSELL'
   AND R1.TARGET_TAB_EN_NAME= 'AGT_BOND_DEBIT_CRDT'
   AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLE_TYPE = R3.SRC_CODE_VAL
   AND R3.SORC_SYS_CD= 'CTMS'
   AND R3.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_WTRADE_LEND'
   AND R3.SRC_FIELD_EN_NAME= 'SETTLE_TYPE'
   AND R3.TARGET_TAB_EN_NAME= 'AGT_BOND_DEBIT_CRDT'
   AND R3.TARGET_TAB_FIELD_EN_NAME= 'FST_STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SETTLE_TYPE2 = R4.SRC_CODE_VAL
   AND R4.SORC_SYS_CD= 'CTMS'
   AND R4.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_WTRADE_LEND'
   AND R4.SRC_FIELD_EN_NAME= 'SETTLE_TYPE2'
   AND R4.TARGET_TAB_EN_NAME= 'AGT_BOND_DEBIT_CRDT'
   AND R4.TARGET_TAB_FIELD_EN_NAME= 'EXP_STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DAY_COUNT = R2.SRC_CODE_VAL
   AND R2.SORC_SYS_CD= 'CTMS'
   AND R2.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_WTRADE_LEND'
   AND R2.SRC_FIELD_EN_NAME= 'DAY_COUNT'
   AND R2.TARGET_TAB_EN_NAME= 'AGT_BOND_DEBIT_CRDT'
   AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_bond_debit_crdt_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,inpwn_bond_id_comb -- 质押债券编号组合
    ,underly_bond_id -- 标的债券编号
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,fst_tran_dt -- 首期交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,tran_dir_cd -- 交易方向代码
    ,inpwn_bond_denom_comb -- 质押债券面额组合
    ,tran_tm -- 交易时间
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
    ,fst_stl_way_cd -- 首期结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,dealer_id -- 交易员编号
    ,bag_id -- 成交编号
    ,cfets_tran_flg -- CFETS交易标志
    ,debit_crdt_fee_rat -- 借贷费率
    ,debit_crdt_days -- 借贷天数
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
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
    ,nvl(n.inpwn_bond_id_comb, o.inpwn_bond_id_comb) as inpwn_bond_id_comb -- 质押债券编号组合
    ,nvl(n.underly_bond_id, o.underly_bond_id) as underly_bond_id -- 标的债券编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.fst_tran_dt, o.fst_tran_dt) as fst_tran_dt -- 首期交易日期
    ,nvl(n.fst_dlvy_dt, o.fst_dlvy_dt) as fst_dlvy_dt -- 首期交割日期
    ,nvl(n.exp_dlvy_dt, o.exp_dlvy_dt) as exp_dlvy_dt -- 到期交割日期
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.inpwn_bond_denom_comb, o.inpwn_bond_denom_comb) as inpwn_bond_denom_comb -- 质押债券面额组合
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
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
    ,nvl(n.fst_stl_way_cd, o.fst_stl_way_cd) as fst_stl_way_cd -- 首期结算方式代码
    ,nvl(n.exp_stl_way_cd, o.exp_stl_way_cd) as exp_stl_way_cd -- 到期结算方式代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(n.bag_id, o.bag_id) as bag_id -- 成交编号
    ,nvl(n.cfets_tran_flg, o.cfets_tran_flg) as cfets_tran_flg -- CFETS交易标志
    ,nvl(n.debit_crdt_fee_rat, o.debit_crdt_fee_rat) as debit_crdt_fee_rat -- 借贷费率
    ,nvl(n.debit_crdt_days, o.debit_crdt_days) as debit_crdt_days -- 借贷天数
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.acpt_pay_cfm_modif_tm, o.acpt_pay_cfm_modif_tm) as acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.dc_dealer_name, o.dc_dealer_name) as dc_dealer_name -- 本币交易员名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.bus_table_name <> n.bus_table_name
                or o.dept_id <> n.dept_id
                or o.inpwn_bond_id_comb <> n.inpwn_bond_id_comb
                or o.underly_bond_id <> n.underly_bond_id
                or o.std_prod_id <> n.std_prod_id
                or o.tran_id <> n.tran_id
                or o.fst_tran_dt <> n.fst_tran_dt
                or o.fst_dlvy_dt <> n.fst_dlvy_dt
                or o.exp_dlvy_dt <> n.exp_dlvy_dt
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.inpwn_bond_denom_comb <> n.inpwn_bond_denom_comb
                or o.tran_tm <> n.tran_tm
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
                or o.fst_stl_way_cd <> n.fst_stl_way_cd
                or o.exp_stl_way_cd <> n.exp_stl_way_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.dealer_id <> n.dealer_id
                or o.bag_id <> n.bag_id
                or o.cfets_tran_flg <> n.cfets_tran_flg
                or o.debit_crdt_fee_rat <> n.debit_crdt_fee_rat
                or o.debit_crdt_days <> n.debit_crdt_days
                or o.init_bus_id <> n.init_bus_id
                or o.acpt_pay_cfm_modif_tm <> n.acpt_pay_cfm_modif_tm
                or o.tran_status_cd <> n.tran_status_cd
                or o.dc_dealer_name <> n.dc_dealer_name
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
from ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm n
    full join ${iml_schema}.agt_bond_debit_crdt_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bond_debit_crdt truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bond_debit_crdt exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bond_debit_crdt drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bond_debit_crdt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_ex purge;
drop table ${iml_schema}.agt_bond_debit_crdt_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bond_debit_crdt', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);